import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart';

class AppProvider extends ChangeNotifier{

  var location = loc.Location();
  String messagepermission = '';
  late GoogleMapController mapController;
  Set<Marker> markers = {};
  LatLng? selectedLocation;

  
  // New properties for address handling
  String? _selectedAddress;
  bool _isLoadingAddress = false;
  double? latitude;
  double? longitude;
  
  // Getters for address
  String? get selectedAddress => _selectedAddress;
  bool get isLoadingAddress => _isLoadingAddress;
  double? get getLatitude => latitude;
  double? get getLongitude => longitude;

  CameraPosition cameraPosition = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Future<void> getlocation() async {
    messagepermission = 'Checking location permission...';
    notifyListeners();
    bool locationpremissionGranted = await _getlocationPermission(); 
    if(locationpremissionGranted) {
      messagepermission = 'Location permission granted';
      notifyListeners();
    } else {
      messagepermission = 'Location permission denied';
      notifyListeners();
    }
    bool serviceEnabled = await _locationServiceEnabled();
    if(serviceEnabled) {
      messagepermission = 'Location service is enabled';
      notifyListeners();
    } else {
      messagepermission = 'Location service is disabled';
      notifyListeners();
    }
    LocationData? locationData = await location.getLocation();
    getCurrentLocation(locationData);
    //setlocationlisner(locationData);
    
    notifyListeners();
  }

  Future<bool> _getlocationPermission() async {
    PermissionStatus permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
    }
    if (permissionStatus == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }
  
  Future<bool> _locationServiceEnabled() async{
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }
    return serviceEnabled;
  }

  void getCurrentLocation(LocationData locationData) async {
    cameraPosition = CameraPosition(
      target: LatLng(locationData.latitude ?? 0.0, locationData.longitude ?? 0.0),
      zoom: 17.0,
    );
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition),
    );
    markers = {
      Marker(
        markerId: const MarkerId('current_location'),
        position: LatLng(locationData.latitude ?? 0.0, locationData.longitude ?? 0.0),
      ),
    };
    latitude = locationData.latitude;
    longitude = locationData.longitude;
    
    // Get address for current location
    selectedLocation = LatLng(locationData.latitude ?? 0.0, locationData.longitude ?? 0.0);
    await getAddressFromLocation(selectedLocation!);
    
    notifyListeners();
  }

  void setlocationlisner(LocationData currentLocation) {
    location.changeSettings(
      accuracy: LocationAccuracy.high,
      interval: 1000,
    );
    location.onLocationChanged.listen((currentLocation) {
      getCurrentLocation(currentLocation);
    });
  }

  void setnewlocation(LatLng latLng) {
    markers = {
      Marker(
        markerId: MarkerId('current_location'),
        position: latLng,
      ),
    };
    selectedLocation = latLng;
    
    // Get address for the new location
    getAddressFromLocation(latLng);
    
    notifyListeners();
  }

  // New method to get address from coordinates
  Future<void> getAddressFromLocation(LatLng location) async {
    
    _isLoadingAddress = true;
    _selectedAddress = null; // Clear previous address
    notifyListeners();
    
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude, 
        location.longitude
      );
      
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        
        List<String> addressParts = [];
        
        // Add street information
        // if (place.street != null && place.street!.isNotEmpty) {
        //   addressParts.add(place.street!);
        // }
        
        // Add city/locality
        // if (place.locality != null && place.locality!.isNotEmpty) {
        //   addressParts.add(place.locality!);
        // } else if (place.subLocality != null && place.subLocality!.isNotEmpty) {
        //   addressParts.add(place.subLocality!);
        // }
        
      //  Add state/administrative area
        
        // Add country
        if (place.country != null && place.country!.isNotEmpty) {
          addressParts.add(place.country!);
        }
        if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) {
          addressParts.add(place.administrativeArea!.split(' ').first.trim());
        }
        
        _selectedAddress = addressParts.isNotEmpty 
            ? addressParts.join(', ') 
            : 'Address not found';
      } else {
        _selectedAddress = "Address not found";
      }
    } catch (e) {
      _selectedAddress = "Error getting address";
      print('Error getting address: $e');
    } finally {
      _isLoadingAddress = false;
      notifyListeners();
    }
  }

  // Method to get detailed address components
  Future<Map<String, String>> getDetailedAddress(LatLng location) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude, 
        location.longitude
      );
      
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        
        return {
          'country': place.country ?? '',
        'administrativeArea': place.administrativeArea ?? '', // State
        //  'name': place.name ?? '',
        };
      }
      
      return {};
    } catch (e) {
      print('Error getting detailed address: $e');
      return {};
    }
  }

  // Method to clear address when needed
  void clearAddress() {
    _selectedAddress = null;
    _isLoadingAddress = false;
    notifyListeners();
  }



 Future<String> gettheuserlocation() async {
    try {
      LocationData locationData = await location.getLocation();
      getCurrentLocation(locationData);
      return getDetailedAddress(LatLng(locationData.latitude ?? 0.0, locationData.longitude ?? 0.0)).then((address) {
        String addressStringstate = address['administrativeArea'] ?? '';
        String addressStringcountry = address['country'] ?? '';

        return addressStringcountry +  ', '+addressStringstate.split(' ').first.trim() ;
      });
    } catch (e) {
      print('Error getting location: $e');
      return 'Error getting location';
    }
  }
}