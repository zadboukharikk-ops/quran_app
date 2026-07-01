import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/responsive.dart';
import '../../../data/models/surah.dart';
import '../../../data/models/surah_index_entry.dart';
import '../providers/quran_providers.dart';
import 'surah_detail_screen.dart';

class SurahListScreen extends ConsumerWidget {
  const SurahListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filtered = ref.watch(filteredSurahIndexProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('القرآن الكريم'),
      ),
      body: SafeArea(
        child: ReadableWidth(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: TextField(
                  textAlign: TextAlign.right,
                  decoration: const InputDecoration(
                    hintText: 'ابحث باسم السورة أو رقمها...',
                    prefixIcon: Icon(Icons.search_rounded),
                  ),
                  onChanged: (v) =>
                      ref.read(surahSearchQueryProvider.notifier).state = v,
                ),
              ),
              Expanded(
                child: filtered.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, st) => Center(child: Text('حدث خطأ في تحميل الفهرس: $e')),
                  data: (list) {
                    if (list.isEmpty) {
                      return const Center(child: Text('لا توجد نتائج مطابقة'));
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: list.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, i) => _SurahTile(entry: list[i]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SurahTile extends StatelessWidget {
  const _SurahTile({required this.entry});
  final SurahIndexEntry entry;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isMakkah = entry.revelationPlace == RevelationPlace.makkah;

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: CircleAvatar(
          backgroundColor: scheme.primaryContainer,
          child: Text(
            '${entry.number}',
            style: TextStyle(
              color: scheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
        title: Text(
          'سورة ${entry.name}',
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
        ),
        subtitle: Text(
          '${entry.ayahCount} آية  •  ${isMakkah ? "مكية" : "مدنية"}',
        ),
        trailing: Icon(
          isMakkah ? Icons.wb_sunny_rounded : Icons.mosque_rounded,
          color: scheme.primary.withValues(alpha: 0.6),
          size: 20,
        ),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => SurahDetailScreen(
              surahNumber: entry.number,
              surahName: entry.name,
            ),
          ),
        ),
      ),
    );
  }
}
