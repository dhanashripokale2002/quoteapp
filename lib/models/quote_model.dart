// lib/models/quote_model.dart
import 'package:hive/hive.dart';

part 'quote_model.g.dart';

@HiveType(typeId: 0)
class QuoteModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String text;

  @HiveField(2)
  final String textHindi;

  @HiveField(3)
  final String author;

  @HiveField(4)
  final String authorHindi;

  @HiveField(5)
  final String category;

  @HiveField(6)
  bool isFavorite;

  @HiveField(7)
  final DateTime? createdAt;

  QuoteModel({
    required this.id,
    required this.text,
    this.textHindi = '',
    required this.author,
    this.authorHindi = '',
    required this.category,
    this.isFavorite = false,
    this.createdAt,
  });

  /// Factory constructor from Quotable API JSON
  factory QuoteModel.fromApiJson(Map<String, dynamic> json, String category) {
    return QuoteModel(
      id: json['_id'] ?? json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      text: json['content'] ?? json['q'] ?? json['quote'] ?? '',
      author: json['author'] ?? json['a'] ?? 'Unknown',
      category: category,
      createdAt: DateTime.now(),
    );
  }

  /// Factory constructor from local JSON (for static data)
  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      id: json['id'] ?? '',
      text: json['text'] ?? '',
      textHindi: json['textHindi'] ?? '',
      author: json['author'] ?? 'Unknown',
      authorHindi: json['authorHindi'] ?? '',
      category: json['category'] ?? '',
      isFavorite: json['isFavorite'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'textHindi': textHindi,
      'author': author,
      'authorHindi': authorHindi,
      'category': category,
      'isFavorite': isFavorite,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  QuoteModel copyWith({
    String? id,
    String? text,
    String? textHindi,
    String? author,
    String? authorHindi,
    String? category,
    bool? isFavorite,
    DateTime? createdAt,
  }) {
    return QuoteModel(
      id: id ?? this.id,
      text: text ?? this.text,
      textHindi: textHindi ?? this.textHindi,
      author: author ?? this.author,
      authorHindi: authorHindi ?? this.authorHindi,
      category: category ?? this.category,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Returns localized text based on language code
  String getLocalizedText(String languageCode) {
    if (languageCode == 'hi' && textHindi.isNotEmpty) {
      return textHindi;
    }
    return text;
  }

  /// Returns localized author name
  String getLocalizedAuthor(String languageCode) {
    if (languageCode == 'hi' && authorHindi.isNotEmpty) {
      return authorHindi;
    }
    return author;
  }
}
