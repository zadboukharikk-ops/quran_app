import 'package:flutter/material.dart';
import '../../../shared/widgets/placeholder_screen.dart';

class NamesScreen extends StatelessWidget {
  const NamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'أسماء الله الحسنى',
      icon: Icons.auto_awesome_rounded,
      description: 'الأسماء الحسنى التسعة والتسعون مع شرح كل اسم، وبحث ومفضلة.',
    );
  }
}
