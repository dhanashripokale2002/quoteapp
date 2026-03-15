// lib/providers/favorites_provider.dart
import 'package:flutter/material.dart';
import '../models/quote_model.dart';
import '../services/storage_service.dart';

class FavoritesProvider extends ChangeNotifier {
  final StorageService _storage;
  late List<QuoteModel> _favorites;

  FavoritesProvider(this._storage) {
    _favorites = _storage.getFavorites();
  }

  List<QuoteModel> get favorites => List.unmodifiable(_favorites);

  bool isFavorite(String quoteId) => _storage.isFavorite(quoteId);

  Future<void> toggleFavorite(QuoteModel quote) async {
    if (_storage.isFavorite(quote.id)) {
      await _storage.removeFavorite(quote.id);
      _favorites.removeWhere((q) => q.id == quote.id);
    } else {
      await _storage.saveFavorite(quote);
      _favorites.add(quote.copyWith(isFavorite: true));
    }
    notifyListeners();
  }

  Future<void> removeFavorite(String quoteId) async {
    await _storage.removeFavorite(quoteId);
    _favorites.removeWhere((q) => q.id == quoteId);
    notifyListeners();
  }

  void reload() {
    _favorites = _storage.getFavorites();
    notifyListeners();
  }
}
