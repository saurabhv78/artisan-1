import Flutter
import UIKit
import FirebaseCore
import FirebaseMessaging
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate, MessagingDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      // Firebase Init
      FirebaseApp.configure()
      Messaging.messaging().delegate = self

      // Notification Setup
      UNUserNotificationCenter.current().delegate = self
      application.registerForRemoteNotifications()

      GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }


  // FCM Token
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("📩 FCM Token: \(fcmToken ?? "")")
  }

  // APNs Token
  override func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    Messaging.messaging().apnsToken = deviceToken
    print("📲 APNs Token: \(deviceToken.map { String(format: "%02.2hhx", $0) }.joined())")
  }
}
