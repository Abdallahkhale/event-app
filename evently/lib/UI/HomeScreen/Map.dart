import 'package:evently/Core/manager/app_manger.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class MapPagState extends StatefulWidget {
  const MapPagState({super.key});

  @override
  State<MapPagState> createState() => __MapPagStateState();
}


class __MapPagStateState extends State<MapPagState> {
  late AppProvider appProvider;
  var  location= Location();
  LocationData? locationData;

  void getCurrentLocation(LocationData locationData) {
    appProvider.getCurrentLocation(locationData);
  }
  
  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_)  {
      appProvider.getlocation();
     
    });
  }
  
  @override
  Widget build(BuildContext context) {

    return Consumer<AppProvider>(builder: (context, provider, child) {
      return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () {
            location.getLocation().then((locationData) {
              this.locationData = locationData;
            });
            appProvider.getCurrentLocation(locationData!);
          },
          child: const Icon(Icons.gps_fixed , color: Colors.white),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: 
              GoogleMap(
                markers: provider.markers,
                mapType: MapType.normal,

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