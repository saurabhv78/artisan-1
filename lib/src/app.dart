import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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
    // You can add custom logic here if needed
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    print('$runtimeType Popped route: ${route.settings.name}');
    // You can add custom logic here if needed
  }
  
}
