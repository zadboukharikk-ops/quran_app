import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/placeholder_screen.dart';

class HadithScreen extends StatelessWidget {
  const HadithScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'الأحاديث النبوية',
      icon: Icons.format_quote_rounded,
      description: 'تصفح كتب الحديث الشريف مع خاصية البحث والنسخ والمشاركة والمفضلة.',
      items: AppConstants.hadithBooks,
    );
  }
}
