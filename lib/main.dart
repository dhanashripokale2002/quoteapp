// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/language_provider.dart';
import 'providers/quotes_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/splash_screen.dart';
import 'services/api_service.dart';
import 'services/storage_service.dart';
import 'utils/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait orientation for a consistent experience
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set transparent status bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Init local storage
  final storage = StorageService();
  await storage.init();

  // Init API service
  final api = ApiService();

  runApp(QuoteNestApp(storage: storage, api: api));
}

class QuoteNestApp extends StatelessWidget {
  final StorageService storage;
  final ApiService api;

  const QuoteNestApp({super.key, required this.storage, required this.api});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Theme
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(storage),
        ),
        // Language
        ChangeNotifierProvider(
          create: (_) => LanguageProvider(storage),
        ),
        // Favorites
        ChangeNotifierProvider(
          create: (_) => FavoritesProvider(storage),
        ),
        // Quotes (depends on api + storage)
        ChangeNotifierProvider(
          create: (_) => QuotesProvider(api, storage),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'QuoteNest',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
