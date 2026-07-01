import 'package:flutter/material.dart';

/// نقاط التحول (Breakpoints) لجعل التصميم متجاوبًا على كل الأجهزة:
/// - موبايل: أقل من 600
/// - تابلت: من 600 إلى 1024
/// - سطح مكتب / ويب واسع: أكبر من 1024
class Responsive {
  Responsive._();

  static const double mobileMax = 600;
  static const double tabletMax = 1024;

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < mobileMax;

  static bool isTablet(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return w >= mobileMax && w < tabletMax;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= tabletMax;

  /// عدد أعمدة الشبكة حسب حجم الشاشة، لاستخدامه في GridView للصفحة الرئيسية
  /// ولوحة السور وغيرها.
  static int gridColumns(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w >= 1400) return 6;
    if (w >= tabletMax) return 5;
    if (w >= mobileMax) return 3;
    if (w >= 380) return 2;
    return 2;
  }

  /// أقصى عرض للمحتوى في الشاشات الواسعة حتى لا يتمدد النص بشكل غير مريح للقراءة.
  static double contentMaxWidth(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w >= tabletMax) return 900;
    return w;
  }

  /// هل يجب عرض قائمة جانبية دائمة (NavigationRail) بدل الـ Drawer المنبثق؟
  static bool useSideRail(BuildContext context) => isDesktop(context);
}

/// غلاف يحصر المحتوى في عرض مقروء مريح على الشاشات الواسعة (سطح المكتب/الويب)
/// مع توسيطه أفقيًا، مع الحفاظ على العرض الكامل على الموبايل.
class ReadableWidth extends StatelessWidget {
  const ReadableWidth({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: Responsive.contentMaxWidth(context)),
        child: child,
      ),
    );
  }
}
