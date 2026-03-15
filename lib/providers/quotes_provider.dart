// lib/providers/quotes_provider.dart
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../models/quote_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

enum LoadState { idle, loading, success, error }

class QuotesProvider extends ChangeNotifier {
  final ApiService _api;
  final StorageService _storage;

  QuotesProvider(this._api, this._storage);

  // ── State ──────────────────────────────────────────────────────────────────
  final Map<String, List<QuoteModel>> _categoryQuotes = {};
  final Map<String, LoadState> _loadStates = {};
  final Map<String, String?> _errors = {};

  QuoteModel? _dailyQuote;
  LoadState _dailyQuoteState = LoadState.idle;

  List<QuoteModel> _searchResults = [];
  LoadState _searchState = LoadState.idle;
  String _searchQuery = '';

  // ── Getters ────────────────────────────────────────────────────────────────
  List<QuoteModel> getQuotes(String categoryId) =>
      _categoryQuotes[categoryId] ?? [];

  LoadState getLoadState(String categoryId) =>
      _loadStates[categoryId] ?? LoadState.idle;

  String? getError(String categoryId) => _errors[categoryId];

  QuoteModel? get dailyQuote => _dailyQuote;
  LoadState get dailyQuoteState => _dailyQuoteState;

  List<QuoteModel> get searchResults => List.unmodifiable(_searchResults);
  LoadState get searchState => _searchState;
  String get searchQuery => _searchQuery;

  // ── Load category quotes ───────────────────────────────────────────────────
  Future<void> loadQuotes(CategoryModel category, {bool forceRefresh = false}) async {
    final id = category.id;

    // If already loaded and no force refresh, skip
    if (!forceRefresh &&
        _loadStates[id] == LoadState.success &&
        (_categoryQuotes[id]?.isNotEmpty ?? false)) {
      return;
    }

    _setLoadState(id, LoadState.loading);

    try {
      // Try cache first (unless force refresh)
      if (!forceRefresh) {
        final cached = _storage.getCachedQuotes(id);
        if (cached != null && cached.isNotEmpty) {
          _categoryQuotes[id] = cached;
          _setLoadState(id, LoadState.success);
          // Refresh in background without blocking UI
          _refreshInBackground(category);
          return;
        }
      }

      // Fetch from API
      final quotes = await _api.fetchQuotesByCategory(
        category: id,
        apiTag: category.apiTag,
      );

      _categoryQuotes[id] = quotes;
      _setLoadState(id, LoadState.success);

      // Cache the results
      if (quotes.isNotEmpty) {
        await _storage.cacheQuotes(id, quotes);
      }
    } catch (e, stack) {
      dev.log('Error loading quotes for $id', error: e, stackTrace: stack, name: 'QuotesProvider');
      _errors[id] = 'Failed to load quotes. Check your connection.';
      _setLoadState(id, LoadState.error);
    }
  }

  /// Silently refresh quotes in the background
  Future<void> _refreshInBackground(CategoryModel category) async {
    try {
      final quotes = await _api.fetchQuotesByCategory(
        category: category.id,
        apiTag: category.apiTag,
      );
      if (quotes.isNotEmpty) {
        _categoryQuotes[category.id] = quotes;
        await _storage.cacheQuotes(category.id, quotes);
        notifyListeners();
      }
    } catch (_) {
      // Silent fail — we already have cached data
    }
  }

  // ── Daily quote ────────────────────────────────────────────────────────────
  Future<void> loadDailyQuote() async {
    // Check if already loaded
    if (_dailyQuote != null) return;

    // Check cache (same day)
    final cached = _storage.getCachedDailyQuote();
    if (cached != null) {
      _dailyQuote = cached;
      _dailyQuoteState = LoadState.success;
      notifyListeners();
      return;
    }

    _dailyQuoteState = LoadState.loading;
    notifyListeners();

    try {
      final quote = await _api.fetchDailyQuote();
      if (quote != null) {
        _dailyQuote = quote;
        await _storage.cacheDailyQuote(quote);
        _dailyQuoteState = LoadState.success;
      } else {
        _dailyQuoteState = LoadState.error;
      }
    } catch (e) {
      dev.log('Daily quote error: $e', name: 'QuotesProvider');
      _dailyQuoteState = LoadState.error;
    }

    notifyListeners();
  }

  // ── Search ─────────────────────────────────────────────────────────────────
  Future<void> search(String query) async {
    _searchQuery = query;

    if (query.trim().isEmpty) {
      _searchResults = [];
      _searchState = LoadState.idle;
      notifyListeners();
      return;
    }

    _searchState = LoadState.loading;
    notifyListeners();

    try {
      _searchResults = await _api.searchQuotes(query);
      _searchState = LoadState.success;
    } catch (e) {
      _searchState = LoadState.error;
      _searchResults = [];
    }

    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    _searchResults = [];
    _searchState = LoadState.idle;
    notifyListeners();
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  void _setLoadState(String id, LoadState state) {
    _loadStates[id] = state;
    notifyListeners();
  }

  /// Update favorite status of a quote inside category lists
  void updateFavoriteStatus(String quoteId, bool isFavorite) {
    for (final key in _categoryQuotes.keys) {
      final idx = _categoryQuotes[key]!.indexWhere((q) => q.id == quoteId);
      if (idx != -1) {
        _categoryQuotes[key]![idx] = _categoryQuotes[key]![idx].copyWith(isFavorite: isFavorite);
      }
    }
    notifyListeners();
  }
}
