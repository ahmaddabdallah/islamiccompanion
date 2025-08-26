import 'package:flutter/material.dart';
import '../presentation/settings/settings.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/dhikr_counter/dhikr_counter.dart';
import '../presentation/home_dashboard/home_dashboard.dart';
import '../presentation/prayer_times/prayer_times.dart';
import '../presentation/hadith_collection/hadith_collection.dart';
import '../presentation/islamic_calendar/islamic_calendar.dart';
import '../presentation/quran_reader/quran_reader.dart';
import '../presentation/qibla_compass/qibla_compass.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String settings = '/settings';
  static const String splash = '/splash-screen';
  static const String dhikrCounter = '/dhikr-counter';
  static const String homeDashboard = '/home-dashboard';
  static const String prayerTimes = '/prayer-times';
  static const String hadithCollection = '/hadith-collection';
  static const String islamicCalendar = '/islamic-calendar';
  static const String quranReader = '/quran-reader';
  static const String qiblaCompass = '/qibla-compass';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    settings: (context) => const Settings(),
    splash: (context) => const SplashScreen(),
    dhikrCounter: (context) => const DhikrCounter(),
    homeDashboard: (context) => const HomeDashboard(),
    prayerTimes: (context) => const PrayerTimes(),
    hadithCollection: (context) => const HadithCollection(),
    islamicCalendar: (context) => const IslamicCalendar(),
    quranReader: (context) => const QuranReader(),
    qiblaCompass: (context) => const QiblaCompass(),
    // TODO: Add your other routes here
  };
}
