import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/utils/responsive.dart';
import '../../../data/models/ayah.dart';
import '../providers/quran_providers.dart';

class SurahDetailScreen extends ConsumerWidget {
  const SurahDetailScreen({
    super.key,
    required this.surahNumber,
    required this.surahName,
  });

  final int surahNumber;
  final String surahName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surahAsync = ref.watch(surahDetailProvider(surahNumber));
    final fontScale = ref.watch(quranFontScaleProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('سورة $surahName'),
        actions: [
          IconButton(
            tooltip: 'تصغير الخط',
            icon: const Icon(Icons.text_decrease_rounded),
            onPressed: () => ref.read(quranFontScaleProvider.notifier).decrease(),
          ),
          IconButton(
            tooltip: 'تكبير الخط',
            icon: const Icon(Icons.text_increase_rounded),
            onPressed: () => ref.read(quranFontScaleProvider.notifier).increase(),
          ),
        ],
      ),
      body: SafeArea(
        child: surahAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(child: Text('تعذّر تحميل السورة: $e')),
          data: (surah) {
            if (surah == null) {
              return _NotAvailableYet(surahName: surahName);
            }
            return ReadableWidth(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: surah.ayahs.length,
                itemBuilder: (context, i) {
                  final ayah = surah.ayahs[i];
                  return _AyahCard(
                    surahNumber: surahNumber,
                    ayah: ayah,
                    fontScale: fontScale,
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

/// تُعرض عندما لا يكون نص السورة متوفرًا بعد في ملف البيانات (لأن النسخة
/// الحالية تحتوي على عيّنة صغيرة فقط). راجع ملاحظة QuranLocalDataSource.
class _NotAvailableYet extends StatelessWidget {
  const _NotAvailableYet({required this.surahName});
  final String surahName;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.menu_book_outlined,
                size: 48, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 16),
            Text(
              'نص سورة "$surahName" غير مضمَّن في بيانات العيّنة الحالية.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'أضِف نص القرآن الكامل والموثّق (مثلًا من مشروع Tanzil.net) إلى '
              'assets/data/quran_sample.json ليظهر هنا تلقائيًا.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _AyahCard extends ConsumerWidget {
  const _AyahCard({
    required this.surahNumber,
    required this.ayah,
    required this.fontScale,
  });

  final int surahNumber;
  final Ayah ayah;
  final double fontScale;

  String get _key => AyahRef(surahNumber, ayah.numberInSurah).key;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoriteAyahsProvider);
    final bookmarks = ref.watch(bookmarksProvider);
    final isFav = favorites.contains(_key);
    final isBookmarked = bookmarks.contains(_key);
    final scheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: scheme.secondaryContainer,
                  child: Text(
                    '${ayah.numberInSurah}',
                    style: TextStyle(fontSize: 11, color: scheme.onSecondaryContainer),
                  ),
                ),
                const Spacer(),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  tooltip: 'نسخ',
                  icon: const Icon(Icons.copy_rounded, size: 20),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: ayah.text));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم نسخ الآية')),
                    );
                  },
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  tooltip: 'مشاركة',
                  icon: const Icon(Icons.share_rounded, size: 20),
                  onPressed: () => SharePlus.instance.share(
                    ShareParams(text: '${ayah.text}\n\n[$surahNumber:${ayah.numberInSurah}]'),
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  tooltip: isBookmarked ? 'إزالة العلامة المرجعية' : 'إضافة علامة مرجعية',
                  icon: Icon(
                    isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                    size: 20,
                  ),
                  onPressed: () =>
                      ref.read(bookmarksProvider.notifier).toggle(_key),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  tooltip: isFav ? 'إزالة من المفضلة' : 'إضافة للمفضلة',
                  icon: Icon(
                    isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    size: 20,
                    color: isFav ? Colors.redAccent : null,
                  ),
                  onPressed: () =>
                      ref.read(favoriteAyahsProvider.notifier).toggle(_key),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              ayah.text,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontSize: 22 * fontScale,
                height: 2.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
