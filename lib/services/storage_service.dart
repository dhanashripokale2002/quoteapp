// lib/services/storage_service.dart
import 'dart:convert';
import 'dart:developer' as dev;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quote_model.dart';
import '../utils/constants.dart';

class StorageService {
  late Box<String> _settingsBox;
  final Map<String, List<QuoteModel>> _quotesCache = {};

  // ── Init ──────────────────────────────────────────────────────────────────
  Future<void> init() async {
    await Hive.initFlutter();

    // Register adapter if not already registered
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(QuoteModelAdapter());
    }

    _settingsBox = await Hive.openBox<String>(AppConstants.settingsBox);
    await Hive.openBox<String>(AppConstants.favoritesBox);
    await Hive.openBox<String>(AppConstants.quotesBox);
  }

  // ── Theme ─────────────────────────────────────────────────────────────────
  bool get isDarkMode {
    return _settingsBox.get(AppConstants.themeKey, defaultValue: 'false') == 'true';
  }

  Future<void> saveThemeMode(bool isDark) async {
    await _settingsBox.put(AppConstants.themeKey, isDark.toString());
  }

  // ── Language ──────────────────────────────────────────────────────────────
  String get languageCode {
    return _settingsBox.get(AppConstants.languageKey, defaultValue: 'en') ?? 'en';
  }

  Future<void> saveLanguageCode(String code) async {
    await _settingsBox.put(AppConstants.languageKey, code);
  }

  // ── Favorites ─────────────────────────────────────────────────────────────
  List<QuoteModel> getFavorites() {
    final box = Hive.box<String>(AppConstants.favoritesBox);
    final favorites = <QuoteModel>[];
    for (final key in box.keys) {
      try {
        final jsonStr = box.get(key.toString());
        if (jsonStr != null) {
          final map = jsonDecode(jsonStr) as Map<String, dynamic>;
          favorites.add(QuoteModel.fromJson({...map, 'isFavorite': true}));
        }
      } catch (e) {
        dev.log('Error reading favorite $key: $e', name: 'StorageService');
      }
    }
    return favorites;
  }

  Future<void> saveFavorite(QuoteModel quote) async {
    final box = Hive.box<String>(AppConstants.favoritesBox);
    await box.put(quote.id, jsonEncode(quote.copyWith(isFavorite: true).toJson()));
  }

  Future<void> removeFavorite(String quoteId) async {
    final box = Hive.box<String>(AppConstants.favoritesBox);
    await box.delete(quoteId);
  }

  bool isFavorite(String quoteId) {
    final box = Hive.box<String>(AppConstants.favoritesBox);
    return box.containsKey(quoteId);
  }

  // ── Quotes cache ──────────────────────────────────────────────────────────
  List<QuoteModel>? getCachedQuotes(String category) {
    // Check in-memory first
    if (_quotesCache.containsKey(category)) {
      return _quotesCache[category];
    }

    // Check Hive
    final box = Hive.box<String>(AppConstants.quotesBox);
    final jsonStr = box.get(category);
    if (jsonStr == null) return null;

    try {
      final list = jsonDecode(jsonStr) as List<dynamic>;
      final quotes = list.map((q) => QuoteModel.fromJson(q as Map<String, dynamic>)).toList();
      _quotesCache[category] = quotes;
      return quotes;
    } catch (e) {
      dev.log('Cache read error for $category: $e', name: 'StorageService');
      return null;
    }
  }

  Future<void> cacheQuotes(String category, List<QuoteModel> quotes) async {
    _quotesCache[category] = quotes;
    final box = Hive.box<String>(AppConstants.quotesBox);
    final jsonStr = jsonEncode(quotes.map((q) => q.toJson()).toList());
    await box.put(category, jsonStr);
  }

  // ── Daily quote ───────────────────────────────────────────────────────────
  QuoteModel? getCachedDailyQuote() {
    final box = Hive.box<String>(AppConstants.settingsBox);
    final savedDate = box.get(AppConstants.dailyQuoteDateKey);
    final today = DateTime.now().toIso8601String().substring(0, 10);

    if (savedDate != today) return null; // Date changed, get new quote

    final jsonStr = box.get(AppConstants.dailyQuoteKey);
    if (jsonStr == null) return null;

    try {
      return QuoteModel.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> cacheDailyQuote(QuoteModel quote) async {
    final box = Hive.box<String>(AppConstants.settingsBox);
    final today = DateTime.now().toIso8601String().substring(0, 10);
    await box.put(AppConstants.dailyQuoteDateKey, today);
    await box.put(AppConstants.dailyQuoteKey, jsonEncode(quote.toJson()));
  }
}
