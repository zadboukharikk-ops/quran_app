import 'package:flutter/material.dart';
import '../../../shared/widgets/placeholder_screen.dart';

class QiblaScreen extends StatelessWidget {
  const QiblaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'اتجاه القبلة',
      icon: Icons.explore_rounded,
      description: 'بوصلة دقيقة تعتمد على flutter_compass وGPS لتحديد اتجاه القبلة. '
          'ملاحظة: بوصلة الهاتف تتطلب جهازًا فعليًا (لا تعمل داخل المحاكي عادة).',
    );
  }
}
