import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  static final StreamController<Position> _locationStreamController =
      StreamController<Position>.broadcast();

  static Stream<Position> get stream => _locationStreamController.stream;

  /// Initialize location service
  /// Call this inside main() before runApp()
  static Future<void> initialize() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint("❌ Location services are disabled.");
    }

    await _requestPermissions();

    // Listen to location updates
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // meters
      ),
    ).listen((position) {
      debugPrint("📍 Location update: ${position.latitude}, ${position.longitude}");
      _locationStreamController.add(position);
    });
  }

  /// Request location permissions
  static Future<bool> _requestPermissions() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint(
          "🚫 Location permission permanently denied. Open settings to enable.");
      return false;
    }

    if (permission == LocationPermission.whileInUse) {
      debugPrint("ℹ️ Only foreground location allowed");
    }

    if (permission == LocationPermission.always) {
      debugPrint("✅ Background location permission granted");
    }

    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  /// Get one-time location
  static Future<Position?> getCurrentLocation() async {
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      debugPrint("❌ Error getting location: $e");
      return null;
    }
  }

  /// Start listening to location updates manually (optional)
  static StreamSubscription<Position> startListening() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 5,
      ),
    ).listen((position) {
      debugPrint("📍 Live Location: ${position.latitude}, ${position.longitude}");
      _locationStreamController.add(position);
    });
  }

  /// Stop a particular subscription
  static void stopListening(StreamSubscription subscription) {
    subscription.cancel();
  }

  /// Background task handler (similar to Firebase background handler)
  /// Must be a top-level function
  @pragma('vm:entry-point')
  static Future<void> backgroundLocationHandler() async {
    debugPrint("🌙 Background Location Handler Triggered");

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    debugPrint("🌙 Background position: ${position.latitude}, ${position.longitude}");
    // TODO: Send to server if needed
  }

  /// Dispose when app closes
  static void dispose() {
    _locationStreamController.close();
  }
}
