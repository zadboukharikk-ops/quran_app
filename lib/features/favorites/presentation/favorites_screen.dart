import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/responsive.dart';
import '../../../data/models/ayah.dart';
import '../../quran/presentation/surah_detail_screen.dart';
import '../../quran/providers/quran_providers.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteKeys = ref.watch(favoriteAyahsProvider);
    final indexAsync = ref.watch(surahIndexProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('المفضلة')),
      body: SafeArea(
        child: ReadableWidth(
          child: favoriteKeys.isEmpty
              ? const Center(child: Text('لا توجد آيات في المفضلة بعد'))
              : indexAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, st) => Center(child: Text('خطأ: $e')),
                  data: (index) {
                    final refs = favoriteKeys.map(AyahRef.fromKey).toList()
                      ..sort((a, b) => a.surahNumber != b.surahNumber
                          ? a.surahNumber.compareTo(b.surahNumber)
                          : a.ayahNumber.compareTo(b.ayahNumber));

                    return ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: refs.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, i) {
                        final ref_ = refs[i];
                        final surahEntry = index.firstWhere(
                          (s) => s.number == ref_.surahNumber,
                          orElse: () => index.first,
                        );
                        return Card(
                          child: ListTile(
                            leading: const Icon(Icons.favorite_rounded, color: Colors.redAccent),
                            title: Text('سورة ${surahEntry.name}'),
                            subtitle: Text('الآية رقم ${ref_.ayahNumber}'),
                            trailing: const Icon(Icons.chevron_left),
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => SurahDetailScreen(
                                  surahNumber: ref_.surahNumber,
                                  surahName: surahEntry.name,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
      ),
    );
  }
}
