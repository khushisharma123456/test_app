import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  
  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    
    await _notifications.initialize(initializationSettings);
  }
  
  static Future<void> scheduleShoppingReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'shopping_reminders',
          'Shopping Reminders',
          channelDescription: 'Reminders for shopping lists',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
  
  static Future<void> showLocationReminder({
    required String storeName,
    required String items,
  }) async {
    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      'Near $storeName!',
      'Don\'t forget to shop for: $items',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'location_reminders',
          'Location Reminders',
          channelDescription: 'Reminders when near stores',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }
  
  static Future<void> cancelReminder(int id) async {
    await _notifications.cancel(id);
  }
}
