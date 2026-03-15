// lib/providers/language_provider.dart
import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class LanguageProvider extends ChangeNotifier {
  final StorageService _storage;
  late String _languageCode;

  LanguageProvider(this._storage) {
    _languageCode = _storage.languageCode;
  }

  String get languageCode => _languageCode;
  bool get isHindi => _languageCode == 'hi';

  String get languageName => _languageCode == 'hi' ? 'हिंदी' : 'English';

  Locale get locale => Locale(_languageCode);

  Future<void> setLanguage(String code) async {
    if (_languageCode == code) return;
    _languageCode = code;
    await _storage.saveLanguageCode(code);
    notifyListeners();
  }
}
