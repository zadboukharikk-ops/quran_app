import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/surah.dart';
import '../models/surah_index_entry.dart';

/// طبقة الوصول لبيانات القرآن الكريم من ملفات JSON محلية داخل assets/data.
///
/// ملاحظة معمارية: هذه الطبقة تنفّذ واجهة بسيطة بحيث يسهل لاحقًا استبدالها
/// بمصدر آخر (قاعدة بيانات SQLite مضمّنة، أو API عن بعد) دون تغيير طبقات
/// العرض (Presentation) التي تعتمد فقط على هذه الدوال.
class QuranLocalDataSource {
  List<SurahIndexEntry>? _indexCache;
  final Map<int, Surah> _surahCache = {};

  /// تحميل فهرس كل السور الـ114 (بيانات وصفية بدون نص الآيات - تحميل سريع).
  Future<List<SurahIndexEntry>> loadSurahIndex() async {
    if (_indexCache != null) return _indexCache!;
    final raw = await rootBundle.loadString('assets/data/surah_index.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final list = (json['surahs'] as List)
        .map((e) => SurahIndexEntry.fromJson(e as Map<String, dynamic>))
        .toList();
    _indexCache = list;
    return list;
  }

  /// تحميل سورة كاملة (بما فيها نص الآيات) برقمها.
  ///
  /// ملاحظة هامة: النسخة الحالية تحتوي على عيّنة صغيرة فقط من السور
  /// (quran_sample.json) لأغراض العرض التجريبي. لعرض نص كامل وصحيح لجميع
  /// السور الـ114، يجب استبدال/دمج ملف البيانات بمصدر قرآني موثّق ومُدقَّق
  /// (مثل مشروع Tanzil.net) قبل إطلاق التطبيق للمستخدمين.
  Future<Surah?> loadSurah(int number) async {
    if (_surahCache.containsKey(number)) return _surahCache[number];

    final raw = await rootBundle.loadString('assets/data/quran_sample.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final list = (json['surahs'] as List)
        .map((e) => Surah.fromJson(e as Map<String, dynamic>))
        .toList();

    for (final s in list) {
      _surahCache[s.number] = s;
    }

    return _surahCache[number];
  }

  /// بحث بسيط عن سورة بالاسم (عربي أو لاتيني) ضمن الفهرس.
  Future<List<SurahIndexEntry>> searchSurahs(String query) async {
    final index = await loadSurahIndex();
    final q = query.trim();
    if (q.isEmpty) return index;
    return index
        .where((s) =>
            s.name.contains(q) ||
            s.englishName.toLowerCase().contains(q.toLowerCase()) ||
            s.number.toString() == q)
        .toList();
  }

  /// بحث عن كلمة داخل نص الآيات المتاحة حاليًا في العيّنة المحمّلة.
  /// (سيعمل بشكل كامل على كل القرآن فور توفير ملف بيانات كامل).
  Future<List<MapEntry<Surah, List<int>>>> searchInAyahs(String query) async {
    if (query.trim().isEmpty) return [];
    final raw = await rootBundle.loadString('assets/data/quran_sample.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final list = (json['surahs'] as List)
        .map((e) => Surah.fromJson(e as Map<String, dynamic>))
        .toList();

    final results = <MapEntry<Surah, List<int>>>[];
    for (final surah in list) {
      final matchingAyahNumbers = <int>[];
      for (final ayah in surah.ayahs) {
        if (ayah.text.contains(query.trim())) {
          matchingAyahNumbers.add(ayah.numberInSurah);
        }
      }
      if (matchingAyahNumbers.isNotEmpty) {
        results.add(MapEntry(surah, matchingAyahNumbers));
      }
    }
    return results;
  }
}
