import 'package:evently/Core/manager/app_manger.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class Chooseeventlocation extends StatefulWidget {
  const Chooseeventlocation({super.key});

  @override
  State<Chooseeventlocation> createState() => _ChooseeventlocationState();
}

class _ChooseeventlocationState extends State<Chooseeventlocation> {
  late AppProvider appProvider;
  var  location= Location();
  LocationData? locationData;
  void getCurrentLocation(LocationData locationData) {
    appProvider.getCurrentLocation(locationData);
  }
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_)  {
      appProvider.getlocation();
     
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Consumer<AppProvider>(builder: (context, provider, child) {
      return Scaffold(
        
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
           width: MediaQuery.of(context).size.width ,
              height: MediaQuery.of(context).size.height * 0.1,
          child: FloatingActionButton(
            
            backgroundColor: Colors.blue,
            onPressed: () {
            
            },
            child: const Text('Tap on loction to select', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
        
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: 
              GoogleMap(
                markers: provider.markers,
                mapType: MapType.normal,
                onTap: (latLng) {
                  provider.setnewlocation(latLng);
                  
                  setState(() {
                    
                  });
                
                  Navigator.pop(context);

                },
                onMapCreated: (GoogleMapController controller) {
                  provider.mapController = controller;
                },
                initialCameraPosition: provider.cameraPosition,
              )
            ),
          ],
        )
      );
    });
  }
}