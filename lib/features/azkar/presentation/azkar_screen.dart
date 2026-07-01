import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/placeholder_screen.dart';

class AzkarScreen extends StatelessWidget {
  const AzkarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'الأذكار',
      icon: Icons.spa_rounded,
      description: 'أذكار الصباح والمساء وغيرها، مع عداد تلقائي وتذكير يومي.',
      items: AppConstants.azkarCategories,
    );
  }
}
