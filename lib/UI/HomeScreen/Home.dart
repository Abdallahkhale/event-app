import 'package:evently/Core/Assets/Color/Colors.dart';
import 'package:evently/Core/Assets/Theme/Theme.dart';
import 'package:evently/Core/Custom/Custom_Card.dart';
import 'package:evently/Core/Custom/Custom_tabs.dart';
import 'package:evently/Core/manager/app_manger.dart';
import 'package:evently/Core/models/categorical_data.dart';
import 'package:evently/Core/settingProvider.dart';
import 'package:evently/Core/utils/firebase_Auth_utils.dart';
import 'package:evently/Core/utils/firebase_firestores_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<CategoricalData> categoricals;
  late AppProvider appProvider;
  String? userLocation;

  @override
  void initState() {
    super.initState();
    categoricals = [];
    _getUserLocation();
  }

  // Method to get user's current location
  void _getUserLocation() async {
    try {
      // Get the AppProvider instance
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      
      // Get the user location
      String location = await appProvider.gettheuserlocation();
      
      setState(() {
        userLocation = location;
      });
    } catch (e) {
      print('Error getting user location: $e');
      setState(() {
        userLocation = 'Location unavailable';
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    categoricals = [
      CategoricalData(name: local_all, icon: Icons.explore_outlined, id: 'All'),
      CategoricalData(name: local_sport, icon: Icons.sports_soccer_outlined, id: 'Sports'),
      CategoricalData(name: local_Birthday, icon: Icons.cake_outlined, id: 'Birthday'),
      CategoricalData(name: local_Meeting, icon: Icons.meeting_room_outlined, id: 'Meeting'),
      CategoricalData(name: local_Gaming, icon: Icons.videogame_asset_outlined, id: 'Gaming'),
      CategoricalData(name: local_Eating, icon: Icons.fastfood_outlined, id: 'Eating'),
      CategoricalData(name: local_Hoilday, icon: Icons.beach_access_outlined, id: 'Holiday'),
      CategoricalData(name: local_WorkShop, icon: Icons.work_outline, id: 'WorkShop'),
      CategoricalData(name: local_BookClub, icon: Icons.book_outlined, id: 'BookClub'),
    ];
  }

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var App = AppLocalizations.of(context)!;
    var provider = Provider.of<Settingprovider>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          height: MediaQuery.of(context).size.height * 0.26,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40)
            ),
            color: Colors.blue,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        App.welcome_back,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                      ),
                      FutureBuilder<String?>(
                        future: FirebaseFirestoreUtils.getUsernameFromFirestore(
                          FirebaseAuthUtils.getCurrentUserid().toString()
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Text(
                              'Loading...',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                            );
                          } else if (snapshot.hasError) {
                            return Text(
                              'Error loading username',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                            );
                          } else if (snapshot.hasData && snapshot.data != null) {
                            return Text(
                              snapshot.data!,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                            );
                          } else {
                            return Text(
                              FirebaseAuthUtils.getUsername().toString(),
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                            );
                          }
                        },
                      ),
                      // Updated location display
                      Row(
                        children: [
                          Icon(Icons.place_outlined, color: Colors.white),
                          SizedBox(width: 4),
                          userLocation == null
                              ? SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : Text(
                                  userLocation!,
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white),
                                ),
                        ],
                      )
                    ]
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          provider.isdDarkMode 
                            ? provider.tosettheme(themeDataclass.lightTheme) 
                            : provider.tosettheme(themeDataclass.darkTheme);
                        },
                        child: const Icon(
                          Icons.wb_sunny_outlined,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 12),
                      InkWell(
                        onTap: () {
                          provider.setLanguage(provider.language == 'en' ? 'ar' : 'en');
                        },
                        child: Container(
                          padding: EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: ColorsApp.bluelight,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Text(provider.language.toUpperCase()),
                        ),
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(height: 8),
              DefaultTabController(
                length: categoricals.length,
                child: TabBar(
                  onTap: (index) {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  dividerColor: Colors.transparent,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                  indicator: BoxDecoration(),
                  tabAlignment: TabAlignment.start,
                  isScrollable: true,
                  tabs: categoricals.map((cat) => Tab(
                    child: CustomTabs(
                      cat: cat,
                      isSelected: selectedIndex == categoricals.indexOf(cat),
                    )
                  )).toList(),
                )
              )
            ],
          )
        ),
        SizedBox(height: 10),
        StreamBuilder(
          stream: FirebaseFirestoreUtils.getStreamEvents(categoricals[selectedIndex].id),
          builder: (content, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(color: ColorsApp.bluelight));
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            List events = snapshot.data?.docs.map((doc) => doc.data()).toList() ?? [];
            return Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return CustomCard(
                    data: events[index],
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 12),
                itemCount: events.length,
              )
            );
          }
        ),
      ],
    );
  }

  get local_sport => AppLocalizations.of(context)!.sports;
  get local_Birthday => AppLocalizations.of(context)!.birthday;
  get local_WorkShop => AppLocalizations.of(context)!.workshop;
  get local_Meeting => AppLocalizations.of(context)!.meeting;
  get local_all => AppLocalizations.of(context)!.all;
  get local_Hoilday => AppLocalizations.of(context)!.hoilday;
  get local_Gaming => AppLocalizations.of(context)!.gaming;
  get local_Eating => AppLocalizations.of(context)!.eating;
  get local_BookClub => AppLocalizations.of(context)!.bookClub;
}