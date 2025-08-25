import 'package:evently/Core/Assets/Color/Colors.dart';
import 'package:evently/Core/settingProvider.dart';
import 'package:evently/UI/HomeScreen/Home.dart';
import 'package:evently/UI/HomeScreen/Love.dart';
import 'package:evently/UI/HomeScreen/Map.dart';
import 'package:evently/UI/HomeScreen/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int currentIndex = 0;
  final List<Widget> pages = [
    const HomePage(),
    const MapPagState(),
    const LovePagState(),
    const ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<Settingprovider>(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:  GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/createEvent');
            
        },
        child:  CircleAvatar(
          radius: 30,
          backgroundColor: Colors.white,
          child: CircleAvatar(
            radius: 24,
            backgroundColor: provider.isdDarkMode? ColorsApp.blueDark :  Colors.blue,
            child: Icon(
              color: Colors.white,
              Icons.add,
              size: 30,
            ),
          ),
          
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        backgroundColor:provider.isdDarkMode?ColorsApp.blueDark: Colors.blue,
        
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        selectedFontSize: 14,
        selectedIconTheme: const IconThemeData(color: Colors.white ),
        

        items:  [
          BottomNavigationBarItem(
            icon:const Icon( Icons.home_outlined),
            activeIcon:const Icon(Icons.home),
            label: AppLocalizations.of(context)!.home,
          ),
          BottomNavigationBarItem(
            icon:const Icon(Icons.place_outlined),
            activeIcon:const Icon(Icons.place),
            label: AppLocalizations.of(context)!.map,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite_border),
            activeIcon:const Icon(Icons.favorite),
            label: AppLocalizations.of(context)!.favorite,
          ),
          BottomNavigationBarItem(
            icon:const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
            label: AppLocalizations.of(context)!.profile,
          ),
        ],
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      body: pages[currentIndex],
    );
  }
}