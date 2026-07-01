import 'ayah.dart';

enum RevelationPlace { makkah, madinah }

class Surah {
  final int number; // رقم السورة 1-114
  final String name; // الاسم بالعربية
  final String englishName;
  final RevelationPlace revelationPlace;
  final List<Ayah> ayahs;

  const Surah({
    required this.number,
    required this.name,
    required this.englishName,
    required this.revelationPlace,
    required this.ayahs,
  });

  int get ayahCount => ayahs.length;

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      number: json['number'] as int,
      name: json['name'] as String,
      englishName: json['englishName'] as String? ?? '',
      revelationPlace: (json['revelationType'] as String?) == 'Madinah'
          ? RevelationPlace.madinah
          : RevelationPlace.makkah,
      ayahs: (json['ayahs'] as List)
          .map((a) => Ayah.fromJson(a as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'number': number,
        'name': name,
        'englishName': englishName,
        'revelationType':
            revelationPlace == RevelationPlace.madinah ? 'Madinah' : 'Makkah',
        'ayahs': ayahs.map((a) => a.toJson()).toList(),
      };
}
