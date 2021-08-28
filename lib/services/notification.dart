import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:terature/model/task.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final _notification = FlutterLocalNotificationsPlugin();

  static Future initialize() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("ic_launcher");

    IOSInitializationSettings iosInitializationSettings =
        IOSInitializationSettings();

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: androidInitializationSettings,
            iOS: iosInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future _notificationDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        'channel description',
        importance: Importance.high,
      ),
      iOS: IOSNotificationDetails(),
    );
  }

  static Future showNotification(
      int id, String title, String body, String payload) async {
    return _notification.show(id, title, body, await _notificationDetails(),
        payload: payload);
  }

  static void showScheduleNotification(Task task, String payload) async {
    if (DateTime.parse(task.tanggalDeadline).isAfter(DateTime.now())) {
      return _notification.zonedSchedule(
          task.id,
          'terature',
          'task ${task.judul} akan segera melewati waktu tenggat. Segera selesaikan task mu',
          tz.TZDateTime.from(DateTime.parse(task.tanggalDeadline), tz.local),
          await _notificationDetails(),
          payload: payload,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          androidAllowWhileIdle: true);
    }
  }

  static Future cancelAllNotifications() async {
    return await _notification.cancelAll();
  }

  static Future setNotificationFromAllUsersTask(List<Task> task) async {
    task.forEach((element) async {
      print('set notifikasi ${element.judul}');
      if (DateTime.parse(element.tanggalDeadline).isAfter(DateTime.now())) {
        print('set notifikasi ${element.judul} berhasil');
        await _notification.zonedSchedule(
          element.id,
          'terature',
          'task ${element.judul} akan segera melewati waktu tenggat. Segera selesaikan task mu',
          tz.TZDateTime.from(DateTime.parse(element.tanggalDeadline), tz.local),
          await _notificationDetails(),
          payload: 'terature',
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          androidAllowWhileIdle: true,
        );
      }
    });
  }

  static Future cancelNotificationById(int id) async {
    await _notification.cancel(id);
  }
}
