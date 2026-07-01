import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/datasources/quran_local_datasource.dart';
import '../../../data/local/local_storage_service.dart';
import '../../../data/models/surah.dart';
import '../../../data/models/surah_index_entry.dart';

/// مزود مصدر بيانات القرآن (Singleton طوال عمر التطبيق).
final quranDataSourceProvider = Provider<QuranLocalDataSource>((ref) {
  return QuranLocalDataSource();
});

/// مزود خدمة التخزين المحلي - يُهيَّأ مرة واحدة عند بدء التطبيق في main().
final localStorageProvider = Provider<LocalStorageService>((ref) {
  throw UnimplementedError(
    'يجب تهيئة localStorageProvider في main() عبر overrideWithValue بعد '
    'await LocalStorageService.getInstance()',
  );
});

/// فهرس السور الـ114 (بيانات وصفية).
final surahIndexProvider = FutureProvider<List<SurahIndexEntry>>((ref) async {
  final ds = ref.watch(quranDataSourceProvider);
  return ds.loadSurahIndex();
});

/// نص كلمة البحث الحالية في شاشة قائمة السور.
final surahSearchQueryProvider = StateProvider<String>((ref) => '');

/// نتائج فهرس السور مصفّاة حسب كلمة البحث.
final filteredSurahIndexProvider = Provider<AsyncValue<List<SurahIndexEntry>>>((ref) {
  final query = ref.watch(surahSearchQueryProvider);
  final indexAsync = ref.watch(surahIndexProvider);
  return indexAsync.whenData((list) {
    if (query.trim().isEmpty) return list;
    final q = query.trim().toLowerCase();
    return list
        .where((s) =>
            s.name.contains(query.trim()) ||
            s.englishName.toLowerCase().contains(q) ||
            s.number.toString() == query.trim())
        .toList();
  });
});

/// تحميل سورة كاملة (مع الآيات) برقمها - يُعاد استخدامه عبر family حسب الرقم.
final surahDetailProvider =
    FutureProvider.family<Surah?, int>((ref, surahNumber) async {
  final ds = ref.watch(quranDataSourceProvider);
  return ds.loadSurah(surahNumber);
});

/// حجم الخط الحالي لعرض الآيات (قابل للتكبير/التصغير من شاشة القراءة).
final quranFontScaleProvider =
    StateNotifierProvider<FontScaleNotifier, double>((ref) {
  final storage = ref.watch(localStorageProvider);
  return FontScaleNotifier(storage);
});

class FontScaleNotifier extends StateNotifier<double> {
  FontScaleNotifier(this._storage) : super(_storage.fontScale);
  final LocalStorageService _storage;

  static const double _min = 0.75;
  static const double _max = 2.0;
  static const double _step = 0.1;

  void increase() {
    state = (state + _step).clamp(_min, _max);
    _storage.setFontScale(state);
  }

  void decrease() {
    state = (state - _step).clamp(_min, _max);
    _storage.setFontScale(state);
  }
}

/// مجموعة مفاتيح الآيات المفضّلة "surah:ayah".
final favoriteAyahsProvider =
    StateNotifierProvider<FavoriteAyahsNotifier, Set<String>>((ref) {
  final storage = ref.watch(localStorageProvider);
  return FavoriteAyahsNotifier(storage);
});

class FavoriteAyahsNotifier extends StateNotifier<Set<String>> {
  FavoriteAyahsNotifier(this._storage) : super(_storage.favoriteAyahKeys);
  final LocalStorageService _storage;

  Future<void> toggle(String key) async {
    await _storage.toggleFavoriteAyah(key);
    state = _storage.favoriteAyahKeys;
  }

  bool isFavorite(String key) => state.contains(key);
}

/// مجموعة مفاتيح العلامات المرجعية "surah:ayah".
final bookmarksProvider =
    StateNotifierProvider<BookmarksNotifier, Set<String>>((ref) {
  final storage = ref.watch(localStorageProvider);
  return BookmarksNotifier(storage);
});

class BookmarksNotifier extends StateNotifier<Set<String>> {
  BookmarksNotifier(this._storage) : super(_storage.bookmarkKeys);
  final LocalStorageService _storage;

  Future<void> toggle(String key) async {
    await _storage.toggleBookmark(key);
    state = _storage.bookmarkKeys;
  }
}

/// مصدر التفسير الافتراضي المختار في الإعدادات.
final tafsirSourceProvider =
    StateNotifierProvider<TafsirSourceNotifier, String>((ref) {
  final storage = ref.watch(localStorageProvider);
  return TafsirSourceNotifier(storage);
});

class TafsirSourceNotifier extends StateNotifier<String> {
  TafsirSourceNotifier(this._storage) : super(_storage.tafsirSource);
  final LocalStorageService _storage;

  Future<void> select(String value) async {
    state = value;
    await _storage.setTafsirSource(value);
  }
}

/// الوضع الليلي.
final darkModeProvider =
    StateNotifierProvider<DarkModeNotifier, bool>((ref) {
  final storage = ref.watch(localStorageProvider);
  return DarkModeNotifier(storage);
});

class DarkModeNotifier extends StateNotifier<bool> {
  DarkModeNotifier(this._storage) : super(_storage.isDarkMode);
  final LocalStorageService _storage;

  Future<void> toggle() async {
    state = !state;
    await _storage.setDarkMode(state);
  }
}
