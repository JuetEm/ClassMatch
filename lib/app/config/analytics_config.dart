import 'package:amplitude_flutter/amplitude.dart';

// ignore: camel_case_types
class Analytics_config {
  static Amplitude analytics = Amplitude.getInstance();

  Future<void> init() async {
    // Initialize SDK
    analytics.init('4a0b6470dd736bad54a484e3cec8b03f');
    //Enable automatically log start and end session events
    analytics.trackingSessionEvents(true);
  }
}
