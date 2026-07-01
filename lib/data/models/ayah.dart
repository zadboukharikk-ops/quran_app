class Ayah {
  final int numberInSurah;
  final String text;
  final int? page; // رقم الصفحة في المصحف
  final int? juz; // رقم الجزء
  final int? hizb; // رقم الحزب
  final int? ruboAlHizb; // الربع

  const Ayah({
    required this.numberInSurah,
    required this.text,
    this.page,
    this.juz,
    this.hizb,
    this.ruboAlHizb,
  });

  factory Ayah.fromJson(Map<String, dynamic> json) {
    return Ayah(
      numberInSurah: json['numberInSurah'] as int,
      text: json['text'] as String,
      page: json['page'] as int?,
      juz: json['juz'] as int?,
      hizb: json['hizb'] as int?,
      ruboAlHizb: json['ruboAlHizb'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'numberInSurah': numberInSurah,
        'text': text,
        if (page != null) 'page': page,
        if (juz != null) 'juz': juz,
        if (hizb != null) 'hizb': hizb,
        if (ruboAlHizb != null) 'ruboAlHizb': ruboAlHizb,
      };
}

/// مرجع فريد للآية (رقم السورة + رقم الآية) يُستخدم في المفضلة والعلامات المرجعية.
class AyahRef {
  final int surahNumber;
  final int ayahNumber;
  const AyahRef(this.surahNumber, this.ayahNumber);

  String get key => '$surahNumber:$ayahNumber';

  factory AyahRef.fromKey(String key) {
    final parts = key.split(':');
    return AyahRef(int.parse(parts[0]), int.parse(parts[1]));
  }

  @override
  bool operator ==(Object other) =>
      other is AyahRef &&
      other.surahNumber == surahNumber &&
      other.ayahNumber == ayahNumber;

  @override
  int get hashCode => Object.hash(surahNumber, ayahNumber);
}
