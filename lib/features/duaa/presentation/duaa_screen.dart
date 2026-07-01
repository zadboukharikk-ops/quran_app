import 'package:flutter/material.dart';
import '../../../shared/widgets/placeholder_screen.dart';

class DuaaScreen extends StatelessWidget {
  const DuaaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'الأدعية',
      icon: Icons.volunteer_activism_rounded,
      description: 'مجموعة أدعية القرآن والسنة وأدعية الأنبياء والأدعية المتنوعة.',
      items: ['أدعية القرآن', 'أدعية السنة', 'أدعية الأنبياء', 'أدعية متنوعة'],
    );
  }
}
