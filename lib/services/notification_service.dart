import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  /// Call this in `main()` before runApp()
  static Future<void> initialize() async {
    // Request permissions (iOS)
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Local notification initialization
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        _handleNotificationTap(response.payload);
      },
    );

    // Background FCM handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Print FCM token
    final token = await _messaging.getToken();
    debugPrint('🔑 FCM Token: $token');

    // Foreground messages
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint('📥 Foreground message received');
      _handleMessage(message, isFromBackground: false);
    });

    // App opened from background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint('📲 Notification opened from background');
      _handleNotificationTap(jsonEncode(message.data));
    });

    // App launched from terminated
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint('🧊 App launched from terminated via notification');
      _handleNotificationTap(jsonEncode(initialMessage.data));
    }
  }

  /// Handle incoming FCM message (foreground or background)
  static Future<void> _handleMessage(RemoteMessage message, {bool isFromBackground = false}) async {
    final notification = message.notification;
    final data = message.data;

    // ✅ Prevent duplicate notification if Firebase already displays it (background/terminated)
    if (isFromBackground && message.notification != null && data.isEmpty) {
      debugPrint('⚠️ Skipping duplicate background notification');
      return;
    }

    final title = notification?.title ?? data['title'] ?? 'No Title';
    final body = notification?.body ?? data['body'] ?? 'No Body';
    final imageUrl = notification?.android?.imageUrl ??
        notification?.apple?.imageUrl ??
        data['image'];

    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      await _showImageNotification(id: id, title: title, body: body, imageUrl: imageUrl, data: data);
    } else {
      await _showTextNotification(id: id, title: title, body: body, data: data);
    }
  }

  /// Show notification with text only
  static Future<void> _showTextNotification({
    required int id,
    required String title,
    required String body,
    Map? data,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'channel_id',
      'Channel Name',
      channelDescription: 'Your channel description',
      importance: Importance.max,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      id,
      title,
      body,
      notificationDetails,
      payload: jsonEncode(data ?? {}),
    );
  }

  /// Show notification with image
  static Future<void> _showImageNotification({
    required int id,
    required String title,
    required String body,
    required String imageUrl,
    Map? data,
  }) async {
    try {
      final largeIconPath = await _downloadAndSaveFile(imageUrl, 'largeIcon');
      final bigPicturePath = await _downloadAndSaveFile(imageUrl, 'bigPicture');

      final bigPictureStyle = BigPictureStyleInformation(
        FilePathAndroidBitmap(bigPicturePath),
        largeIcon: FilePathAndroidBitmap(largeIconPath),
        contentTitle: title,
        summaryText: body,
      );

      final androidDetails = AndroidNotificationDetails(
        'channel_id',
        'Channel Name',
        channelDescription: 'Your channel description',
        styleInformation: bigPictureStyle,
        importance: Importance.max,
        priority: Priority.high,
      );

      final notificationDetails = NotificationDetails(android: androidDetails);

      await _localNotifications.show(
        id,
        title,
        body,
        notificationDetails,
        payload: jsonEncode(data ?? {}),
      );
    } catch (e) {
      debugPrint('🛑 Error showing image notification: $e');
      await _showTextNotification(id: id, title: title, body: body, data: data);
    }
  }

  /// Download image from URL
  static Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';
    final response = await http.get(Uri.parse(url));
    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  /// Handle notification tap (from foreground, background, or terminated)
  static void _handleNotificationTap(String? payload) {
    if (payload == null) return;

    final data = jsonDecode(payload);
    debugPrint('🔔 Notification tapped with data: $data');

    // TODO: Add logic to navigate to specific screen based on `data`
  }
}

/// 🔁 Background message handler (must be top-level and marked with pragma)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('🌙 Handling background message: ${message.messageId}');
  await NotificationService._handleMessage(message, isFromBackground: true);
}
