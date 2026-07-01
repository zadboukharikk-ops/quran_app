import 'package:flutter/material.dart';
import '../../core/utils/responsive.dart';

/// شاشة عامة تُستخدم كنقطة انطلاق لأي قسم لم يُطوَّر بعمقه الكامل بعد
/// (مثل الأحاديث، الأذكار، الأدعية...). تحافظ على نفس بنية التنقل
/// والتصميم العام حتى تُستبدل تدريجيًا بمحتوى كل قسم الفعلي.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({
    super.key,
    required this.title,
    required this.icon,
    this.items = const [],
    this.description,
  });

  final String title;
  final IconData icon;
  final List<String> items;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: ReadableWidth(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: scheme.primaryContainer.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(icon, size: 34, color: scheme.primary),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        description ??
                            'هذا القسم جاهز من ناحية البنية والتنقل، وسيُستكمل '
                                'بالمحتوى الكامل والوظائف التفصيلية.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
              if (items.isNotEmpty) ...[
                const SizedBox(height: 20),
                Text('الأقسام المتوفرة:',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                ...items.map(
                  (item) => Card(
                    child: ListTile(
                      leading: Icon(icon, color: scheme.primary),
                      title: Text(item),
                      trailing: const Icon(Icons.chevron_left),
                      onTap: () {},
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
