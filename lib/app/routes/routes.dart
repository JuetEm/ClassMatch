import 'package:classmatch/app/landing/landing.dart';
import 'package:classmatch/app/ui/alarm_guide.dart';
import 'package:classmatch/app/ui/alarmlist.dart';
import 'package:classmatch/app/ui/favarea_select.dart';
import 'package:classmatch/app/ui/login.dart';
import 'package:classmatch/app/ui/onboarding.dart';
import 'package:classmatch/app/ui/openchat_guide.dart';
import 'package:classmatch/app/ui/service_over.dart';
import 'package:classmatch/app/ui/use_guide.dart';
import 'package:flutter/widgets.dart';

class Routes {
  Routes._();

  static const String login = '/login';
  static const String arlamList = '/alarmList';
  static const String onboarding = '/onBoarding';
  static const String favareaSelect = '/favareaSelect';
  static const String useGuide = '/useGuide';
  static const String alarmGuide = '/alarmGuide';
  static const String openchatGuide = '/openchatGuide';
  static const String serviceOver = '/serviceOver';
  static const String landing = '/landing';

  static final routes = <String, WidgetBuilder>{
    login: (BuildContext context) => const LoginPage(),
    arlamList: (BuildContext context) => const ArlamListPage(),
    onboarding: (BuildContext context) => const OnboardingPage(),
    favareaSelect: (BuildContext context) => const FavareaSelectPage(),
    useGuide: (BuildContext context) => const UseGuidePage(),
    alarmGuide: (BuildContext context) => const AlarmGuidePage(),
    openchatGuide: (BuildContext context) => const OpenchatGuidePage(),
    serviceOver: (BuildContext context) => const ServiceOverPage(),
    landing: (BuildContext context) => const LandingPage(),
  };
}
