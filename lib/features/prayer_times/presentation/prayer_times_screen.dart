import 'package:flutter/material.dart';
import '../../../shared/widgets/placeholder_screen.dart';

class PrayerTimesScreen extends StatelessWidget {
  const PrayerTimesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'مواقيت الصلاة',
      icon: Icons.access_time_filled_rounded,
      description: 'تحديد الموقع تلقائيًا (حزمة geolocator مُضافة في pubspec.yaml) '
          'لحساب أوقات الصلوات الخمس والشروق والثلث الأخير من الليل، مع تنبيهات '
          'وصوت أذان قابل للاختيار.',
      items: ['الفجر', 'الشروق', 'الظهر', 'العصر', 'المغرب', 'العشاء', 'الثلث الأخير'],
    );
  }
}
