import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import '../../../core/utils/responsive.dart';

/// التقويم الهجري - يعتمد على حزمة hijri للتحويل بين التاريخين.
class HijriCalendarScreen extends StatelessWidget {
  const HijriCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final hijri = HijriCalendar.now();
    final gregorian = DateTime.now();

    return Scaffold(
      appBar: AppBar(title: const Text('التقويم الهجري')),
      body: SafeArea(
        child: ReadableWidth(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text('التاريخ الهجري', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Text(
                          '${hijri.hDay} ${hijri.longMonthName} ${hijri.hYear} هـ',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text('التاريخ الميلادي', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Text(
                          '${gregorian.day}/${gregorian.month}/${gregorian.year} م',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
