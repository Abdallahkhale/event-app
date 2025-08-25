import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently/Core/models/event_data.dart';
import 'package:evently/Core/utils/firebase_Auth_utils.dart';

abstract class FirebaseFirestoreUtils {
  
  static CollectionReference<EventData> _getCollectionsReference(){
    return FirebaseFirestore.instance
       //.collection(EventData.collectionName)
       .collection(FirebaseAuthUtils.getCurrentUserid() ?? 'default_user')
        .withConverter<EventData>(
          fromFirestore: (snapshot, _) => EventData.formFirestore(snapshot.data()!),
          toFirestore: (value, _) => value.toFirestore(),
        );
  }

 

  static Future<bool> createEvent(EventData event) async {
    try {
      var collection = _getCollectionsReference();
      var docRef = collection.doc();
      event.id = docRef.id;
      
      await docRef.set(event);
      return true;
    } catch (e) {
      print('Error creating event: $e'); 
      return false;
    } 
  }

  static Future<List<EventData>> getEvents() async {
    try {
      final collection = _getCollectionsReference();
      final querySnapshot = await collection.get();
      
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error getting events: $e');
      return [];
    }
  }

   static Stream<QuerySnapshot<EventData>> getStreamEvents(String  categoricalImgID) { {
    if (categoricalImgID == 'All') {
      return _getCollectionsReference().snapshots();
      }
      final collection = _getCollectionsReference().
      where(
        'categoricalImgID',
          isEqualTo:categoricalImgID,
      );
      return collection.snapshots();
   }
   }
  static Future<bool> updateEvent(EventData event) async {
    try {
      var collection = _getCollectionsReference();
      if (event.id == null) return false;
      
      await collection.doc(event.id).update(event.toFirestore());
      return true;
    } catch (e) {
      print('Error updating event: $e');
      return false;
    }
  }

  static Stream<QuerySnapshot<EventData>> getStreamEventsLove() { {
    
      final collection = _getCollectionsReference().
      where(
        'isFavorite',
          isEqualTo:true,
      );
      return collection.snapshots();
   }
   }
  static Future<bool> deleteEvent(String id) async {
    try {
      var collection = _getCollectionsReference();
      await collection.doc(id).delete();
      return true;
    } catch (e) {
      print('Error deleting event: $e');
      return false;
    }
  }

    static Stream<DocumentSnapshot<EventData>> getStreamEventsid(String eventId) {

    return _getCollectionsReference().doc(eventId).snapshots();
}
// New method to save username to Firestore
  static Future<void> saveUsernameToFirestore({
    required String uid,
    required String username,
  }) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'username': username,
    });
  }
  static Future<String?> getUsernameFromFirestore(String uid) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>?;
        return data?['username'] as String?;
      }
    } catch (e) {
      // Log the error using a logging framework
      print('Error getting username: $e');
    }
    return null;
  }


  

}