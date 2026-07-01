import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/responsive.dart';
import '../../quran/providers/quran_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(darkModeProvider);
    final fontScale = ref.watch(quranFontScaleProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: SafeArea(
        child: ReadableWidth(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _SectionTitle('المظهر'),
              Card(
                child: SwitchListTile(
                  title: const Text('الوضع الليلي'),
                  secondary: const Icon(Icons.dark_mode_rounded),
                  value: isDark,
                  onChanged: (_) => ref.read(darkModeProvider.notifier).toggle(),
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.text_fields_rounded),
                      const SizedBox(width: 12),
                      const Expanded(child: Text('حجم خط القرآن')),
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline_rounded),
                        onPressed: () =>
                            ref.read(quranFontScaleProvider.notifier).decrease(),
                      ),
                      Text('${(fontScale * 100).round()}%'),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline_rounded),
                        onPressed: () =>
                            ref.read(quranFontScaleProvider.notifier).increase(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _SectionTitle('التفسير الافتراضي'),
              Card(
                child: Column(
                  children: AppConstants.tafsirSources
                      .map((t) => RadioListTile<String>(
                            title: Text(t),
                            value: t,
                            groupValue: ref.watch(tafsirSourceProvider),
                            onChanged: (v) {
                              if (v != null) {
                                ref.read(tafsirSourceProvider.notifier).select(v);
                              }
                            },
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(height: 20),
              _SectionTitle('عام'),
              Card(
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('الإشعارات'),
                      secondary: const Icon(Icons.notifications_rounded),
                      value: true,
                      onChanged: (_) {},
                    ),
                    SwitchListTile(
                      title: const Text('الاهتزاز'),
                      secondary: const Icon(Icons.vibration_rounded),
                      value: true,
                      onChanged: (_) {},
                    ),
                    ListTile(
                      leading: const Icon(Icons.backup_rounded),
                      title: const Text('النسخ الاحتياطي للبيانات'),
                      trailing: const Icon(Icons.chevron_left),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 8),
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .titleSmall
            ?.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
      ),
    );
  }
}
