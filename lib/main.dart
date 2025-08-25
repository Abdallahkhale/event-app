import 'package:evently/Core/Assets/Theme/Theme.dart';
import 'package:evently/Core/Service/sharedprefernced.dart';
import 'package:evently/Core/manager/app_manger.dart';
import 'package:evently/Core/models/event_data.dart';
import 'package:evently/Core/settingProvider.dart';
import 'package:evently/Core/utils/fcm_utils.dart';
import 'package:evently/UI/Auth/login.dart';
import 'package:evently/UI/Auth/signup.dart';
import 'package:evently/UI/ChooseEventLocation/ChooseEventLocation.dart';
import 'package:evently/UI/HomeScreen/Home.dart';
import 'package:evently/UI/HomeScreen/HomeScreen.dart';
import 'package:evently/UI/HomeScreen/Love.dart';
import 'package:evently/UI/HomeScreen/Map.dart';
import 'package:evently/UI/HomeScreen/createEvent.dart';
import 'package:evently/UI/HomeScreen/profile.dart';
import 'package:evently/UI/Onboarding/onboarding.dart';
import 'package:evently/UI/Onboarding/onboardingScreen.dart';
import 'package:evently/UI/Splash/Splash.dart';
import 'package:evently/UI/editEvent/eventDetails.dart';
import 'package:evently/UI/editEvent/eventEdit.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await localStorage.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FcmService fcmService = FcmService();
  await fcmService.initialize();
  await fcmService.initializeTimezone();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  
  runApp(

    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Settingprovider()),
        ChangeNotifierProvider(create: (context) => AppProvider()), 
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<Settingprovider>(context);
    return  MaterialApp(
      debugShowCheckedModeBanner: false,

      themeMode: provider.isdDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: themeDataclass.lightTheme,
      darkTheme: themeDataclass.darkTheme,
      
      
      
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(provider.language),

      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const Onboardingscreen(),
        '/onboarding2': (context) => const Onboarding(),
        '/login': (context) => const Login(), 
        '/signup': (context) => const Signup(),
        '/homescreen': (context) => const Homescreen(),
        '/home': (context) => const HomePage(),
        '/profile': (context) => const ProfilePage(),
        '/love': (context) => const LovePagState(),
        '/map': (context) => const MapPagState(),
        '/createEvent': (context) => const Createevent(),
        '/eventDetails': (context) => eventDetails(
          data: ModalRoute.of(context)!.settings.arguments as EventData),

        '/editEvent': (context) => Eventedit(
          data: ModalRoute.of(context)!.settings.arguments as EventData),

        'profilePage': (context) => const ProfilePage(),
        'chooseEventLocation': (context) => const Chooseeventlocation(),

        
      },
     
    );
  }
  
}