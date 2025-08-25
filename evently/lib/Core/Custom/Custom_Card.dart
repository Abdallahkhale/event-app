import 'package:evently/Core/Assets/Color/Colors.dart';
import 'package:evently/Core/Assets/Images/Imagespath.dart';
import 'package:evently/Core/models/event_data.dart';
import 'package:evently/Core/utils/fcm_utils.dart';
import 'package:evently/Core/utils/firebase_firestores_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomCard extends StatefulWidget {
   CustomCard({super.key,  required this.data});
  EventData data;

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  FcmService fcmService = FcmService();
  @override
  void initState() {
    
    super.initState();
    DateTime eventDate = widget.data.eventDate; // Event date
    DateTime notificationTime = eventDate.subtract(const Duration(hours: 12));
    fcmService.scheduleEventReminder(notificationTime, widget.data.enentTitle);
  }

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/eventDetails', arguments: widget.data);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
          height: 210,
          width: double.infinity,
          decoration:  BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            image: DecorationImage(
              image: AssetImage(widget.data.categoricalImg),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(2),
              height: 55,
              width: 50,
              decoration: BoxDecoration(
              color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text( DateFormat('dd MMM').format(widget.data.eventDate)  ,
              textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: ColorsApp.blue,
                    fontWeight: FontWeight.w700
                      )),
            )
            ,
            Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              color: ColorsApp.bluelight,
              ),
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Expanded(child:   Text(widget.data.enentTitle, 
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                )
                  )),
                  InkWell(
                    onTap: () {
                      widget.data.isFavorite = !widget.data.isFavorite;
                      FirebaseFirestoreUtils.updateEvent(widget.data);
                      setState(() {
                      });
                    },
                    child: widget.data.isFavorite? const Icon(Icons.favorite , color: ColorsApp.blue,): const Icon(Icons.favorite_border_outlined),
                    
                    )
                ],
              ),
            )
          
          
          ],
          
          ),
       
      ),
    );
  }
}