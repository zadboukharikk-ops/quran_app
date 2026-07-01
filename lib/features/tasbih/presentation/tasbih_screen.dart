import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/responsive.dart';
import '../../../data/local/local_storage_service.dart';
import '../../quran/providers/quran_providers.dart';

final _tasbihCountProvider = StateProvider<int>((ref) {
  return ref.watch(localStorageProvider).tasbihCount;
});

final _tasbihPhraseProvider = StateProvider<String>((ref) => 'سبحان الله');

const _phrases = ['سبحان الله', 'الحمد لله', 'الله أكبر', 'لا إله إلا الله', 'أستغفر الله'];

class TasbihScreen extends ConsumerWidget {
  const TasbihScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storage = ref.watch(localStorageProvider);
    final count = ref.watch(_tasbihCountProvider);
    final phrase = ref.watch(_tasbihPhraseProvider);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('التسبيح الإلكتروني'),
        actions: [
          IconButton(
            tooltip: 'إعادة التعيين',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              storage.resetTasbih();
              ref.read(_tasbihCountProvider.notifier).state = 0;
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ReadableWidth(
          child: Column(
            children: [
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                alignment: WrapAlignment.center,
                children: _phrases
                    .map((p) => ChoiceChip(
                          label: Text(p),
                          selected: phrase == p,
                          onSelected: (_) =>
                              ref.read(_tasbihPhraseProvider.notifier).state = p,
                        ))
                    .toList(),
              ),
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      storage.incrementTasbih();
                      ref.read(_tasbihCountProvider.notifier).state = storage.tasbihCount;
                    },
                    child: Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: scheme.primaryContainer,
                        boxShadow: [
                          BoxShadow(
                            color: scheme.primary.withValues(alpha: 0.25),
                            blurRadius: 30,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$count',
                            style: TextStyle(
                              fontSize: 56,
                              fontWeight: FontWeight.bold,
                              color: scheme.onPrimaryContainer,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(phrase, style: TextStyle(color: scheme.onPrimaryContainer)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'اضغط على الدائرة للتسبيح  •  الإجمالي التراكمي: ${storage.tasbihTotal}',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
