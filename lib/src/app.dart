// import 'dart:developer';

// import 'package:auto_route/auto_route.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// import '../services/notification_service.dart';
// import 'constants/colors.dart';
// import 'routing/router.dart';
// import 'utils/color_utils.dart';

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _AppState();
// }

// class _AppState extends State<MyApp> {
//   late final AppRouter _appRouter;

//   @override
//   void initState() {
//     super.initState();
//     _appRouter = AppRouter();
//     NotificationService.initialize();
//   }

//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//     ]);
//     SystemChrome.setSystemUIOverlayStyle(
//       const SystemUiOverlayStyle(
//         statusBarIconBrightness: Brightness.dark,
//         statusBarColor: Colors.transparent,
//       ),
//     );
//     return MaterialApp.router(
//       debugShowCheckedModeBanner: false,
//       title: 'Artisan',
//       theme: ThemeData(
//         colorScheme: const ColorScheme.light(primary: primaryColor),
//         brightness: Brightness.light,
//         primarySwatch: ColorUtils.generateMaterialColor(primaryColor),
//         scaffoldBackgroundColor: Colors.white,
//       ),
//       routerConfig: _appRouter.config(
//         navigatorObservers: () => [
//           MyAutoRouteObserver(),
//         ],
//       ),
//     );
//   }
// }

// class MyAutoRouteObserver extends AutoRouterObserver {
//   @override
//   void didPush(Route route, Route? previousRoute) {
//     super.didPush(route, previousRoute);
//     print('$runtimeType Pushed route: ${route.settings.name}');
//     // You can add custom logic here if needed
//   }

//   @override
//   void didPop(Route route, Route? previousRoute) {
//     super.didPop(route, previousRoute);
//     print('$runtimeType Popped route: ${route.settings.name}');
//     // You can add custom logic here if needed
//   }
// }
import 'dart:developer';
import 'package:Artisan/services/location_service.dart';
import 'package:auto_route/auto_route.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../services/notification_service.dart';
import 'constants/colors.dart';
import 'routing/router.dart';
import 'utils/color_utils.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _AppState();
}

class _AppState extends State<MyApp> {
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _appRouter = AppRouter();
    setState(() {
      NotificationService.initialize();
      LocationService.initialize();
    });
    // 👈 Enable location on app start
  }

  // /// ✅ Handles location permission, service check, and logs location
  // Future<void> _enableLocation() async {
  //   try {
  //     // Check location permission
  //     LocationPermission permission = await Geolocator.checkPermission();

  //     if (permission == LocationPermission.denied) {
  //       permission = await Geolocator.requestPermission();
  //     }

  //     if (permission == LocationPermission.deniedForever) {
  //       // Open app settings using permission_handler
  //       await openAppSettings();
  //       return;
  //     }

  //     // Check if location service (GPS) is enabled
  //     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //     if (!serviceEnabled) {
  //       await Geolocator.openLocationSettings();
  //       return;
  //     }

  //     // Get the current user position
  //     Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high,
  //     );

  //     log('✅ User Location: ${position.latitude}, ${position.longitude}');
  //   } catch (e) {
  //     log('❌ Error getting location: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // Lock app to portrait mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Set status bar style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
      ),
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Artisan',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(primary: primaryColor),
        brightness: Brightness.light,
        primarySwatch: ColorUtils.generateMaterialColor(primaryColor),
        scaffoldBackgroundColor: Colors.white,
      ),
      routerConfig: _appRouter.config(
        navigatorObservers: () => [
          MyAutoRouteObserver(),
        ],
      ),
    );
  }
}

class MyAutoRouteObserver extends AutoRouterObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    print('$runtimeType Pushed route: ${route.settings.name}');
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    print('$runtimeType Popped route: ${route.settings.name}');
  }
}
