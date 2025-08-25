import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class FcmService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid
    );
    
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse
    );
  }

  void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
    }
  }

  Future<void> createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // Channel ID
      'High Importance Notifications', // Channel name
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
      playSound: true,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> initialize() async {
    try {
      // Initialize local notifications first
      await initializeLocalNotifications();
      
      // Create notification channel
      await createNotificationChannel();

      // Request permissions
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      print('User granted permission: ${settings.authorizationStatus}');

      // Get FCM token
      String? token = await messaging.getToken();
      print("FCM Token: $token");

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Received foreground message: ${message.messageId}');
        printmessage(message);
      });

      // Handle background messages
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      // Handle notification taps when app is in background or terminated
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('Message clicked!');
        handleNotificationClick(message);
      });

      // Handle notification tap when app is terminated
      RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
      if (initialMessage != null) {
        print('App opened from terminated state via notification');
        handleNotificationClick(initialMessage);
      }

    } catch (e) {
      print('Error initializing FCM: $e');
    }
  }

  // Handle notification clicks
  void handleNotificationClick(RemoteMessage message) {
    print('Notification clicked: ${message.data}');
    // Add your navigation logic here
    // For example: Navigator.pushNamed(context, '/specific_page');
  }

  void printmessage(RemoteMessage message) async {
    try {
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        print('Title: ${message.notification!.title}');
        print('Body: ${message.notification!.body}');
      }

      // Create notification details with proper icon configuration
      const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        'high_importance_channel', // Must match the channel ID created above
        'High Importance Notifications',
        channelDescription: 'This channel is used for important notifications.',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        icon: '@mipmap/ic_launcher', // This fixes the NullPointerException
        largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        styleInformation: BigTextStyleInformation(''), // For long text
        playSound: true,
        enableVibration: true,
        showWhen: true,
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
      );

      // Use unique notification ID based on timestamp
      int notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      await flutterLocalNotificationsPlugin.show(
        notificationId,
        message.notification?.title ?? 'New Notification',
        message.notification?.body ?? 'You have a new message',
        notificationDetails,
        payload: message.data.toString(), // Pass data as payload
      );

      print('Notification shown successfully with ID: $notificationId');
    } catch (e) {
      print('Error showing notification: $e');
    }
  }

  // Background message handler - must be top-level function
  static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print('Handling a background message: ${message.messageId}');
    print('Background message data: ${message.data}');
    
    if (message.notification != null) {
      print('Background message notification: ${message.notification!.title}');
    }
    
    // You can also show local notifications in background
    // but you'll need to initialize the plugin again
  }

  // Method to subscribe to topics
  Future<void> subscribeToTopic(String topic) async {
    try {
      await messaging.subscribeToTopic(topic);
      print('Subscribed to topic: $topic');
    } catch (e) {
      print('Error subscribing to topic $topic: $e');
    }
  }

  // Method to unsubscribe from topics
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await messaging.unsubscribeFromTopic(topic);
      print('Unsubscribed from topic: $topic');
    } catch (e) {
      print('Error unsubscribing from topic $topic: $e');
    }
  }

  // Method to get current FCM token
  Future<String?> getFCMToken() async {
    try {
      String? token = await messaging.getToken();
      return token;
    } catch (e) {
      print('Error getting FCM token: $e');
      return null;
    }
  }

  // Method to delete FCM token
  Future<void> deleteFCMToken() async {
    try {
      await messaging.deleteToken();
      print('FCM token deleted');
    } catch (e) {
      print('Error deleting FCM token: $e');
    }
  }


Future<void> initializeTimezone() async {
  tz.initializeTimeZones();
}

Future<void> scheduleEventReminder(DateTime eventDateTime, String eventTitle) async {
  try {
    // Initialize timezone if not done
    await initializeTimezone();
   
    
    // Calculate 12 hours before event
    DateTime reminderTime = eventDateTime.subtract(Duration(hours: 12));

    
    // Check if reminder time is in the future
    if (reminderTime.isBefore(DateTime.now())) {
      print('Reminder time is in the past, not scheduling');
      //print('Event date: $eventDateTime, Reminder time: $reminderTime');
      return;
    }
    print('--------Event date: $eventDateTime, Reminder time: $reminderTime');
    
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'event_reminder_channel',
      'Event Reminders',
      channelDescription: 'Notifications for upcoming events',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      playSound: true,
      enableVibration: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    // Use event date as unique ID (or generate unique ID)
    int notificationId = eventDateTime.millisecondsSinceEpoch ~/ 1000;
    
    await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      'Event Reminder',
      'Your event "$eventTitle" starts in 12 hours!',
      tz.TZDateTime.from(reminderTime, tz.local),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
    
    print('Event reminder scheduled for: $reminderTime');
  } catch (e) {
    print('Error scheduling event reminder: $e');
  }
}

// Optional: Cancel specific notification
Future<void> cancelEventReminder(DateTime eventDateTime) async {
  try {
    int notificationId = eventDateTime.millisecondsSinceEpoch ~/ 1000;
    await flutterLocalNotificationsPlugin.cancel(notificationId);
    print('Event reminder cancelled');
  } catch (e) {
    print('Error cancelling event reminder: $e');
  }
}
}

// Background message handler must be top-level function
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
  print('Background message data: ${message.data}');
  
  if (message.notification != null) {
    print('Background message notification: ${message.notification!.title}');
  }
}