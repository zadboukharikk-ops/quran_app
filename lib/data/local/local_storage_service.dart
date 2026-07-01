import 'package:shared_preferences/shared_preferences.dart';

/// غلاف بسيط فوق SharedPreferences يعزل بقية التطبيق عن تفاصيل التخزين،
/// بحيث يسهل استبداله لاحقًا بـ SQLite أو Hive دون تعديل الشاشات.
class LocalStorageService {
  LocalStorageService._(this._prefs);
  final SharedPreferences _prefs;

  static LocalStorageService? _instance;

  static Future<LocalStorageService> getInstance() async {
    if (_instance != null) return _instance!;
    final prefs = await SharedPreferences.getInstance();
    _instance = LocalStorageService._(prefs);
    return _instance!;
  }

  // ---------- الإعدادات العامة ----------
  static const _kDarkMode = 'settings.darkMode';
  static const _kFontScale = 'settings.fontScale';
  static const _kTafsirSource = 'settings.tafsirSource';
  static const _kLastReadKey = 'quran.lastRead'; // "surah:ayah"

  bool get isDarkMode => _prefs.getBool(_kDarkMode) ?? false;
  Future<void> setDarkMode(bool value) => _prefs.setBool(_kDarkMode, value);

  double get fontScale => _prefs.getDouble(_kFontScale) ?? 1.0;
  Future<void> setFontScale(double value) =>
      _prefs.setDouble(_kFontScale, value);

  String get tafsirSource => _prefs.getString(_kTafsirSource) ?? 'تفسير السعدي';
  Future<void> setTafsirSource(String value) =>
      _prefs.setString(_kTafsirSource, value);

  String? get lastReadKey => _prefs.getString(_kLastReadKey);
  Future<void> setLastRead(int surah, int ayah) =>
      _prefs.setString(_kLastReadKey, '$surah:$ayah');

  // ---------- المفضلة (آيات) ----------
  static const _kFavAyahs = 'favorites.ayahs'; // قائمة "surah:ayah"

  Set<String> get favoriteAyahKeys =>
      (_prefs.getStringList(_kFavAyahs) ?? const []).toSet();

  Future<void> toggleFavoriteAyah(String key) async {
    final current = favoriteAyahKeys;
    if (current.contains(key)) {
      current.remove(key);
    } else {
      current.add(key);
    }
    await _prefs.setStringList(_kFavAyahs, current.toList());
  }

  // ---------- العلامات المرجعية (Bookmarks) ----------
  static const _kBookmarks = 'bookmarks.ayahs';

  Set<String> get bookmarkKeys =>
      (_prefs.getStringList(_kBookmarks) ?? const []).toSet();

  Future<void> toggleBookmark(String key) async {
    final current = bookmarkKeys;
    if (current.contains(key)) {
      current.remove(key);
    } else {
      current.add(key);
    }
    await _prefs.setStringList(_kBookmarks, current.toList());
  }

  // ---------- عداد المسبحة الإلكترونية ----------
  static const _kTasbihCount = 'tasbih.count';
  static const _kTasbihTotal = 'tasbih.total'; // إحصائية إجمالية تراكمية

  int get tasbihCount => _prefs.getInt(_kTasbihCount) ?? 0;
  int get tasbihTotal => _prefs.getInt(_kTasbihTotal) ?? 0;

  Future<void> incrementTasbih() async {
    await _prefs.setInt(_kTasbihCount, tasbihCount + 1);
    await _prefs.setInt(_kTasbihTotal, tasbihTotal + 1);
  }

  Future<void> resetTasbih() => _prefs.setInt(_kTasbihCount, 0);
}
