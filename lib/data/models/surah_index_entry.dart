import 'surah.dart';

/// مُدخل في فهرس السور: بيانات وصفية فقط (بدون نص الآيات) تُستخدم في شاشة
/// قائمة السور بحيث تُحمَّل بسرعة وبدون استهلاك ذاكرة كبير.
class SurahIndexEntry {
  final int number;
  final String name;
  final String englishName;
  final RevelationPlace revelationPlace;
  final int ayahCount;

  const SurahIndexEntry({
    required this.number,
    required this.name,
    required this.englishName,
    required this.revelationPlace,
    required this.ayahCount,
  });

  factory SurahIndexEntry.fromJson(Map<String, dynamic> json) {
    return SurahIndexEntry(
      number: json['number'] as int,
      name: json['name'] as String,
      englishName: json['englishName'] as String? ?? '',
      revelationPlace: (json['revelationType'] as String?) == 'Madinah'
          ? RevelationPlace.madinah
          : RevelationPlace.makkah,
      ayahCount: json['ayahCount'] as int,
    );
  }
}
