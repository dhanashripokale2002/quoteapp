// lib/models/category_model.dart
import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String name;
  final String nameHindi;
  final String apiTag;      // Tag used with the Quotable API
  final IconData icon;
  final List<Color> gradient;
  final String emoji;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.nameHindi,
    required this.apiTag,
    required this.icon,
    required this.gradient,
    required this.emoji,
  });
}

/// All app categories with their associated API tags and visuals
const List<CategoryModel> kCategories = [
  CategoryModel(
    id: 'motivation',
    name: 'Motivation',
    nameHindi: 'प्रेरणा',
    apiTag: 'motivational',
    icon: Icons.local_fire_department_rounded,
    emoji: '🔥',
    gradient: [Color(0xFFFF6B35), Color(0xFFFF8E53)],
  ),
  CategoryModel(
    id: 'success',
    name: 'Success',
    nameHindi: 'सफलता',
    apiTag: 'success',
    icon: Icons.emoji_events_rounded,
    emoji: '🏆',
    gradient: [Color(0xFFFFD700), Color(0xFFFFA500)],
  ),
  CategoryModel(
    id: 'life',
    name: 'Life',
    nameHindi: 'जीवन',
    apiTag: 'life',
    icon: Icons.spa_rounded,
    emoji: '🌿',
    gradient: [Color(0xFF4CAF50), Color(0xFF087F23)],
  ),
  CategoryModel(
    id: 'love',
    name: 'Love',
    nameHindi: 'प्यार',
    apiTag: 'love',
    icon: Icons.favorite_rounded,
    emoji: '❤️',
    gradient: [Color(0xFFE91E63), Color(0xFF9C27B0)],
  ),
  CategoryModel(
    id: 'friendship',
    name: 'Friends',
    nameHindi: 'दोस्ती',
    apiTag: 'friendship',
    icon: Icons.group_rounded,
    emoji: '👫',
    gradient: [Color(0xFF2196F3), Color(0xFF00BCD4)],
  ),
  CategoryModel(
    id: 'relationship',
    name: 'Relationship',
    nameHindi: 'रिश्ता',
    apiTag: 'humor',
    icon: Icons.people_rounded,
    emoji: '💑',
    gradient: [Color(0xFF9C27B0), Color(0xFF673AB7)],
  ),
  CategoryModel(
    id: 'mother',
    name: 'Mother',
    nameHindi: 'माँ',
    apiTag: 'family',
    icon: Icons.woman_rounded,
    emoji: '👩',
    gradient: [Color(0xFFFF4081), Color(0xFFF50057)],
  ),
  CategoryModel(
    id: 'father',
    name: 'Father',
    nameHindi: 'पिता',
    apiTag: 'wisdom',
    icon: Icons.man_rounded,
    emoji: '👨',
    gradient: [Color(0xFF0D47A1), Color(0xFF1565C0)],
  ),
  CategoryModel(
    id: 'attitude',
    name: 'Attitude',
    nameHindi: 'रवैया',
    apiTag: 'inspirational',
    icon: Icons.bolt_rounded,
    emoji: '⚡',
    gradient: [Color(0xFF212121), Color(0xFF424242)],
  ),
];
