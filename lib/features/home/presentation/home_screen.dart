import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/responsive.dart';
import '../../../features/quran/providers/quran_providers.dart';
import '../../../shared/widgets/feature_card.dart';
import '../../../shared/widgets/placeholder_screen.dart';
import '../../about/presentation/about_screen.dart';
import '../../azkar/presentation/azkar_screen.dart';
import '../../duaa/presentation/duaa_screen.dart';
import '../../favorites/presentation/favorites_screen.dart';
import '../../hadith/presentation/hadith_screen.dart';
import '../../hijri_calendar/presentation/hijri_calendar_screen.dart';
import '../../names/presentation/names_screen.dart';
import '../../prayer_times/presentation/prayer_times_screen.dart';
import '../../qibla/presentation/qibla_screen.dart';
import '../../quran/presentation/surah_list_screen.dart';
import '../../settings/presentation/settings_screen.dart';
import '../../tasbih/presentation/tasbih_screen.dart';

class _HomeItem {
  final String label;
  final IconData icon;
  final WidgetBuilder builder;
  const _HomeItem(this.label, this.icon, this.builder);
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  List<_HomeItem> _items(BuildContext context) => [
        _HomeItem('القرآن الكريم', Icons.menu_book_rounded,
            (_) => const SurahListScreen()),
        _HomeItem('الأحاديث النبوية', Icons.format_quote_rounded,
            (_) => const HadithScreen()),
        _HomeItem(
            'الأذكار', Icons.spa_rounded, (_) => const AzkarScreen()),
        _HomeItem(
            'الأدعية', Icons.volunteer_activism_rounded, (_) => const DuaaScreen()),
        _HomeItem('التسبيح الإلكتروني', Icons.touch_app_rounded,
            (_) => const TasbihScreen()),
        _HomeItem('مواقيت الصلاة', Icons.access_time_filled_rounded,
            (_) => const PrayerTimesScreen()),
        _HomeItem(
            'القبلة', Icons.explore_rounded, (_) => const QiblaScreen()),
        _HomeItem('أسماء الله الحسنى', Icons.auto_awesome_rounded,
            (_) => const NamesScreen()),
        _HomeItem('التقويم الهجري', Icons.calendar_month_rounded,
            (_) => const HijriCalendarScreen()),
        _HomeItem(
            'المناسبات الإسلامية',
            Icons.event_rounded,
            (_) => const PlaceholderScreen(
                  title: 'المناسبات الإسلامية',
                  icon: Icons.event_rounded,
                  items: [
                    'رمضان',
                    'عيد الفطر',
                    'عيد الأضحى',
                    'عاشوراء',
                    'ليلة القدر',
                    'رأس السنة الهجرية',
                    'المولد النبوي',
                  ],
                )),
        _HomeItem('المفضلة', Icons.favorite_rounded,
            (_) => const FavoritesScreen()),
        _HomeItem(
            'الإعدادات', Icons.settings_rounded, (_) => const SettingsScreen()),
        _HomeItem('حول التطبيق', Icons.info_rounded,
            (_) => const AboutScreen()),
      ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(darkModeProvider);
    final items = _items(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          IconButton(
            tooltip: isDark ? 'الوضع الفاتح' : 'الوضع الليلي',
            onPressed: () => ref.read(darkModeProvider.notifier).toggle(),
            icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: ReadableWidth(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              itemCount: items.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: Responsive.gridColumns(context),
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.95,
              ),
              itemBuilder: (context, index) {
                final item = items[index];
                return FeatureCard(
                  icon: item.icon,
                  label: item.label,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: item.builder),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
