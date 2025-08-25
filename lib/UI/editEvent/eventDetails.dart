import 'package:evently/Core/Assets/Color/Colors.dart';
import 'package:evently/Core/models/event_data.dart';
import 'package:evently/Core/settingProvider.dart';
import 'package:evently/Core/utils/firebase_firestores_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:evently/gen_l10n/app_localizations.dart';

class eventDetails extends StatefulWidget {
  eventDetails({super.key, required this.data});
  EventData data;
  
  @override
  State<eventDetails> createState() => _EditeventState();
}

class _EditeventState extends State<eventDetails> {



  @override
  Widget build(BuildContext context) {
   var App = AppLocalizations.of(context)!;
    var provider = Provider.of<Settingprovider>(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/editEvent', arguments: widget.data);
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () async {
              bool deleted = await FirebaseFirestoreUtils.deleteEvent(widget.data.id!);
              if (deleted) {
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to delete event')),
                );
              }
            },
            icon: const Icon(Icons.delete, color: Colors.red),
          ),
        ],
        iconTheme: const IconThemeData(color: ColorsApp.blue),
        title:  Text(App.event_details, style: TextStyle(color: ColorsApp.blue)),
        backgroundColor:provider.isdDarkMode ? ColorsApp.blueDark:ColorsApp.bluelight,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: const EdgeInsets.all(16),
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage(widget.data.categoricalImg),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Text(
                widget.data.enentTitle,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: ColorsApp.blue,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                margin: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: ColorsApp.blue, width: 2),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: ColorsApp.blue,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: ColorsApp.blue, width: 2),
                      ),
                      child: const Icon(Icons.calendar_today, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('dd MMMM yyyy').format(widget.data.eventDate),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: ColorsApp.blue,
                          ),
                        ),
                        Text(
                          widget.data.eventTime,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: ColorsApp.blue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                margin: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: ColorsApp.blue, width: 2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: ColorsApp.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.my_location_rounded, color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.data.location ,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: ColorsApp.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.arrow_forward_ios_outlined, color: Colors.grey, size: 16),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                height: 200,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: ColorsApp.blue, width: 2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: GoogleMap(
                    scrollGesturesEnabled: false,
                    zoomControlsEnabled: true,
                    zoomGesturesEnabled: false,
                      mapType: MapType.normal,
                  
                      initialCameraPosition: CameraPosition(
                        target: LatLng(widget.data.latitude, widget.data.longitude),
                        zoom: 14.4746),
                    ),
                ),
              )
              ,
              const SizedBox(height: 16),
               Text(App.description,
               style: TextStyle(
                color: provider.isdDarkMode ? Colors.white : Colors.black,
                
               ),
               ),
              const SizedBox(height: 8),
              Text(widget.data.eventDescription,
              style: TextStyle(
                color: provider.isdDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.normal,
               ),),
            ],
          ),
        ),
      ),
    );
  }
}