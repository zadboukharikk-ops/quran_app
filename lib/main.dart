import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'data/local/local_storage_service.dart';
import 'features/home/presentation/home_screen.dart';
import 'features/quran/providers/quran_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة خدمة التخزين المحلي مرة واحدة قبل تشغيل التطبيق، ثم حقنها في
  // Riverpod عبر override بحيث تكون متاحة كمزود عادي (localStorageProvider)
  // في كل أنحاء الشجرة دون الحاجة لـ async في كل شاشة.
  final storage = await LocalStorageService.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        localStorageProvider.overrideWithValue(storage),
      ],
      child: const QuranApp(),
    ),
  );
}

class QuranApp extends ConsumerWidget {
  const QuranApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(darkModeProvider);

    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      // دعم اللغة العربية واتجاه RTL في كل أنحاء التطبيق.
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      builder: (context, child) {
        // فرض اتجاه RTL على كامل التطبيق بغض النظر عن اللغة الافتراضية للنظام.
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const HomeScreen(),
    );
  }
}
