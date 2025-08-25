import 'package:evently/Core/Assets/Color/Colors.dart';
import 'package:evently/Core/Custom/Custom_Card.dart';
import 'package:evently/Core/Custom/Customtextform.dart';
import 'package:evently/Core/models/event_data.dart';
import 'package:evently/Core/utils/firebase_firestores_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LovePagState extends StatefulWidget {
  const LovePagState({super.key});

  @override
  State<LovePagState> createState() => __LovePagStateState();
}


class __LovePagStateState extends State<LovePagState> {

  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {}); 
    });
  }

  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var App = AppLocalizations.of(context)!;
    return   Column(
      children: [
        Padding(

          padding: const EdgeInsets.only(top: 50, left: 16, right: 16),
          child: Customtextform(
            prefixIcon: Icons.search,
            labelText: App.search_event,
            controller: searchController,
            
            
          
            
          ),
        ),
        

        StreamBuilder(stream: FirebaseFirestoreUtils.getStreamEventsLove(),
          
              builder: (content ,snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Center(child: CircularProgressIndicator(color: ColorsApp.bluelight,));}
                  if(snapshot.hasError){
                    return Center(child: Text('Error: ${snapshot.error}'));}
          
              List<EventData> events = snapshot.data?.docs.map((doc) => doc.data()).toList() ?? [];
              List<EventData> eventsbname =searchbyName(searchController.text,events);
              return Expanded(child: ListView.separated(
                itemBuilder: (context, index){
                  return CustomCard(
                    data: eventsbname[index],
                  );
                }
             , separatorBuilder:(context , index)=> SizedBox(height: 12,), 
              itemCount: eventsbname.length,)
              );
              }
              
              
              
        ),
      ],
    );
  }

  List<EventData> searchbyName(String query , List<EventData> events) {
    if (query.isEmpty) {
      return events;
    }
    
    return events.where((event) {
      return event.enentTitle.toLowerCase().contains(query.toLowerCase());
    }).toList();
   
  }
}