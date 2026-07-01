# تطبيق القرآن الكريم

تطبيق إسلامي متكامل مبني بـ Flutter (Clean Architecture + Riverpod)، يعمل من
قاعدة كود واحدة على: **Android, iOS, iPadOS, Windows, macOS, Linux, Web**.

---

## ⚠️ اقرأ هذا أولًا

هذا المشروع **هيكل احترافي جاهز للبناء عليه**، وليس تطبيقًا نهائيًا جاهزًا
للنشر في المتاجر. تحديدًا:

1. **نص القرآن الكريم غير مكتمل.** الملف `assets/data/quran_sample.json`
   يحتوي على سورتين فقط (الفاتحة والإخلاص) كعيّنة للتجربة، تفاديًا لخطر
   الأخطاء الإملائية التي قد تنتج عن كتابة 6236 آية يدويًا دون تدقيق. فهرس
   أسماء السور الـ114 وعدد آيات كل سورة (`assets/data/surah_index.json`)
   **مكتمل ومُتحقَّق منه** (تم التأكد أن مجموع الآيات = 6236، وهو الرقم
   القياسي المعروف). **قبل الاستخدام الفعلي:** استبدل/أكمل ملف نص الآيات
   بمصدر قرآني موثّق ومُدقَّق مثل [Tanzil.net](https://tanzil.net/download/)
   (متوفر بصيغة JSON/XML جاهزة)، ويُفضّل مراجعته من جهة مختصة قبل النشر.

2. **الأقسام التالية بها بنية تنقّل وتصميم كامل لكنها بحاجة لمحتوى فعلي:**
   الأحاديث النبوية، الأذكار، الأدعية، أسماء الله الحسنى، المناسبات
   الإسلامية. كل شاشة مبنية بحيث يسهل حقن بيانات JSON فيها بنفس نمط وحدة
   القرآن (`QuranLocalDataSource` كمرجع نمطي).

3. **مواقيت الصلاة والقبلة:** الحزم اللازمة (`geolocator`, `flutter_compass`)
   مُضافة في `pubspec.yaml`، لكن منطق حساب المواقيت الفلكي وربط البوصلة
   بالواجهة لم يُنفَّذ بعد (شاشات مؤقتة/Placeholder جاهزة للتوسعة).

4. **التقويم الهجري:** يعمل فعليًا (يعرض التاريخ الهجري الحالي محوّلاً من
   الميلادي عبر حزمة `hijri`).

5. **الصوتيات (الاستماع للقرآن):** غير مُنفَّذة في هذه النسخة (تحتاج مصدر
   ملفات صوتية للقراء السبعة المذكورين + مشغل صوت مثل `just_audio`).

---

## البنية المعمارية

```
lib/
  core/                     ثوابت، ثيم، أدوات مساعدة (تصميم متجاوب)
  data/
    models/                 نماذج البيانات (Surah, Ayah...)
    datasources/            مصادر البيانات (محلي حاليًا، قابل للاستبدال بـ API)
    local/                  التخزين المحلي (SharedPreferences)
  features/
    <feature_name>/
      presentation/         الشاشات والـ Widgets
      providers/            Riverpod providers (state management)
  shared/widgets/           عناصر واجهة قابلة لإعادة الاستخدام عبر الميزات
```

هذا الفصل بين الطبقات (Clean Architecture) يعني أن استبدال مصدر البيانات
(مثلاً من ملفات JSON محلية إلى قاعدة SQLite أو API) لا يتطلب تعديل أي شاشة —
فقط تعديل داخل `data/datasources/`.

---

## التشغيل محليًا

يتطلب هذا المشروع بيئة **Flutter SDK** (لم يتم تثبيتها أو اختبار المشروع في
البيئة التي كُتب فيها هذا الكود، لذا يُرجى تشغيل `flutter analyze` و
`flutter pub get` أول مرة والتحقق من عدم وجود أخطاء إصدارات قبل المتابعة).

```bash
# 1) تثبيت الاعتماديات
flutter pub get

# 2) تشغيل على المحاكي/الجهاز المتصل
flutter run
```

## البناء لكل منصة

```bash
# Android (APK)
flutter build apk --release

# Android (App Bundle - للنشر على Google Play)
flutter build appbundle --release

# iOS (يتطلب macOS + Xcode)
flutter build ios --release

# Web
flutter build web --release

# Windows (يتطلب تفعيل: flutter config --enable-windows-desktop)
flutter build windows --release

# macOS (يتطلب macOS + تفعيل: flutter config --enable-macos-desktop)
flutter build macos --release

# Linux (يتطلب تفعيل: flutter config --enable-linux-desktop)
flutter build linux --release
```

> ملاحظة: لدعم iOS/macOS/Windows/Linux كمنصات مستهدفة داخل المشروع، قد
> تحتاج أول مرة لتشغيل `flutter create .` داخل مجلد المشروع لتوليد مجلدات
> المنصات الأصلية (`ios/`, `macos/`, `windows/`, `linux/`, `android/`,
> `web/`) التي لم تُولَّد هنا لأن بيئة الكتابة الحالية لا تملك Flutter SDK.

---

## خطوات الإكمال المقترحة (بالأولوية)

1. **دمج نص القرآن الكامل** من مصدر موثّق (Tanzil.net) في
   `assets/data/quran_sample.json`، مع الإبقاء على نفس البنية (`Surah.fromJson`).
2. **تفعيل مشغل الصوت** لتلاوات القراء السبعة (حزمة `just_audio` +
   `just_audio_background` للتشغيل بالخلفية).
3. **بناء منطق مواقيت الصلاة** الفلكي (يمكن استخدام حزمة `adhan_dart` أو
   `adhan` الجاهزة لحساب الأوقات من الإحداثيات).
4. **ربط `flutter_compass`** بواجهة `QiblaScreen` لحساب زاوية القبلة الفعلية
   من موقع المستخدم (إحداثيات الكعبة: 21.4225° شمالاً، 39.8262° شرقًا).
5. **إضافة محتوى:** الأحاديث، الأذكار، الأدعية، أسماء الله الحسنى — بنفس نمط
   `QuranLocalDataSource` (ملفات JSON في `assets/data/`).
6. **إشعارات يومية** (آية + حديث + ذكر) عبر `flutter_local_notifications`.
7. **الويدجت للشاشة الرئيسية** يتطلب تطويرًا أصليًا منفصلًا لكل منصة
   (Android App Widget / iOS WidgetKit)، خارج نطاق كود Flutter المشترك.

---

## المطوّر

زيد — © جميع الحقوق محفوظة.
