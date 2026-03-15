// lib/services/api_service.dart
import 'dart:convert';
import 'dart:developer' as dev;
import 'package:http/http.dart' as http;
import '../models/quote_model.dart';
import '../utils/constants.dart';

class ApiService {
  static const Duration _timeout = Duration(seconds: 15);
  static const Map<String, String> _headers = {'Accept': 'application/json'};

  // ── Fetch quotes by category tag ───────────────────────────────────────────
  Future<List<QuoteModel>> fetchQuotesByCategory({
    required String category,
    required String apiTag,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      // Primary source: Quotable API
      final quotes = await _fetchFromQuotable(
        tag: apiTag,
        category: category,
        page: page,
        limit: limit,
      );
      if (quotes.isNotEmpty) return quotes;

      // Fallback to local data
      return _getFallbackQuotes(category);
    } catch (e) {
      dev.log('API Error: $e', name: 'ApiService');
      return _getFallbackQuotes(category);
    }
  }

  // ── Quotable API ───────────────────────────────────────────────────────────
  Future<List<QuoteModel>> _fetchFromQuotable({
    required String tag,
    required String category,
    required int page,
    required int limit,
  }) async {
    final uri = Uri.parse(
      '${AppConstants.quotableBaseUrl}/quotes'
      '?tags=$tag&page=$page&limit=$limit&sortBy=dateAdded&order=desc',
    );

    final response = await http
        .get(uri, headers: _headers)
        .timeout(_timeout);

    if (response.statusCode != 200) {
      throw Exception('Quotable API returned ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final results = json['results'] as List<dynamic>? ?? [];

    return results
        .map((q) => QuoteModel.fromApiJson(q as Map<String, dynamic>, category))
        .toList();
  }

  // ── Daily quote ────────────────────────────────────────────────────────────
  Future<QuoteModel?> fetchDailyQuote() async {
    try {
      final uri = Uri.parse('${AppConstants.quotableBaseUrl}/quotes/random?minLength=50&maxLength=150');
      final response = await http.get(uri, headers: _headers).timeout(_timeout);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return QuoteModel.fromApiJson(json, 'life');
      }
    } catch (e) {
      dev.log('Daily quote fetch error: $e', name: 'ApiService');
    }

    // Fallback
    final fallbacks = _getFallbackQuotes('motivation');
    if (fallbacks.isNotEmpty) {
      fallbacks.shuffle();
      return fallbacks.first;
    }
    return null;
  }

  // ── Search quotes ──────────────────────────────────────────────────────────
  Future<List<QuoteModel>> searchQuotes(String query) async {
    if (query.trim().isEmpty) return [];

    try {
      final uri = Uri.parse(
        '${AppConstants.quotableBaseUrl}/quotes?query=${Uri.encodeComponent(query)}&limit=20',
      );
      final response = await http.get(uri, headers: _headers).timeout(_timeout);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final results = json['results'] as List<dynamic>? ?? [];
        return results
            .map((q) => QuoteModel.fromApiJson(q as Map<String, dynamic>, 'search'))
            .toList();
      }
    } catch (e) {
      dev.log('Search error: $e', name: 'ApiService');
    }

    // Fallback: local search
    return AppConstants.fallbackQuotes
        .where((q) =>
            q['text'].toString().toLowerCase().contains(query.toLowerCase()) ||
            q['author'].toString().toLowerCase().contains(query.toLowerCase()))
        .map((q) => QuoteModel.fromJson(q))
        .toList();
  }

  // ── Local fallback data ────────────────────────────────────────────────────
  List<QuoteModel> _getFallbackQuotes(String category) {
    return AppConstants.fallbackQuotes
        .where((q) => q['category'] == category)
        .map((q) => QuoteModel.fromJson(q))
        .toList();
  }
}
