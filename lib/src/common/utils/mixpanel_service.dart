import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class MixpanelService {
  static Mixpanel? _mixpanel;

  static Future<void> init() async {
    _mixpanel ??= await Mixpanel.init(
      "54000df262b8002db343419e0f3cfac3", // Replace with your actual Mixpanel token
      trackAutomaticEvents: true,
    );
  }

  static void track(String event, {Map<String, dynamic>? properties}) {
    _mixpanel?.track(event, properties: properties);
  }

  static void identify(String userId) {
    _mixpanel?.identify(userId);
  }

  static void setUserProperties(Map<String, dynamic> properties) {
    properties.forEach((key, value) {
      _mixpanel?.getPeople().set(key, value);
    });
  }
}
