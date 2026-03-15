# 📖 QuoteNest

> **Wisdom in Every Word** — A beautiful, production-ready Flutter quotes app

[![Flutter](https://img.shields.io/badge/Flutter-3.10+-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

## ✨ Features

| Feature | Description |
|---|---|
| 📂 **9 Categories** | Motivation, Success, Life, Love, Friends, Relationship, Mother, Father, Attitude |
| 🌐 **Live API Quotes** | Fetches from [Quotable API](https://api.quotable.io) with offline caching |
| 🌏 **Multi-Language** | English & Hindi with persistent preference |
| ❤️ **Favorites** | Save, view, and swipe-to-remove favorites |
| 🔍 **Search** | Debounced live search by quote text or author |
| 📅 **Quote of the Day** | New inspirational quote every day |
| 📤 **Share** | Share to WhatsApp, Instagram, or any app |
| 📋 **Copy** | One-tap copy to clipboard |
| 🖼️ **Download Image** | Export quote as shareable image |
| 🌙 **Dark Mode** | Full dark/light theme with persistence |
| ✨ **Animations** | Staggered card entries, scale press effects |
| 💅 **Material 3** | Modern Google Material You design |

---

## 🏗️ Architecture

```
lib/
├── main.dart                    # App entry point, providers setup
├── models/
│   ├── quote_model.dart         # Quote data model + Hive adapter
│   ├── quote_model.g.dart       # Generated Hive TypeAdapter
│   └── category_model.dart      # Category definitions
├── providers/
│   ├── quotes_provider.dart     # Quotes state + API + caching
│   ├── favorites_provider.dart  # Favorites CRUD state
│   ├── theme_provider.dart      # Theme toggling
│   └── language_provider.dart   # Language switching
├── screens/
│   ├── splash_screen.dart       # Animated splash
│   ├── home_screen.dart         # Category grid + daily quote
│   ├── quotes_screen.dart       # Quotes list for a category
│   ├── favorites_screen.dart    # Saved quotes with swipe-to-delete
│   ├── search_screen.dart       # Live search with suggestions
│   ├── settings_screen.dart     # Theme, language, about
│   └── quote_detail_screen.dart # Full-screen quote view
├── services/
│   ├── api_service.dart         # Quotable API integration
│   └── storage_service.dart     # Hive + SharedPreferences wrapper
├── widgets/
│   ├── category_card.dart       # Gradient category card
│   ├── quote_card.dart          # Quote card with actions
│   ├── quote_of_the_day_widget.dart  # Daily quote banner
│   └── loading_skeleton.dart    # Shimmer loading UI
└── utils/
    ├── app_theme.dart           # Light & dark ThemeData
    └── constants.dart           # Keys, API URLs, fallback quotes
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK ≥ 3.10.0
- Dart SDK ≥ 3.0.0
- Android Studio / VS Code

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/yourusername/quotenest.git
cd quotenest

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run
```

### Build for Release

```bash
# Android APK
flutter build apk --release

# Android App Bundle (Play Store)
flutter build appbundle --release

# iOS
flutter build ios --release
```

---

## 📦 Dependencies

| Package | Purpose |
|---|---|
| `provider ^6.1.2` | State management |
| `http ^1.2.0` | API calls |
| `hive ^2.2.3` + `hive_flutter ^1.1.0` | Local storage |
| `shared_preferences ^2.2.3` | Settings persistence |
| `google_fonts ^6.2.1` | Poppins, Merriweather, Playfair Display |
| `shimmer ^3.0.0` | Skeleton loading UI |
| `share_plus ^7.2.2` | Native share sheet |
| `screenshot ^2.3.0` | Quote image export |
| `path_provider ^2.1.2` | Temp directory for image export |
| `permission_handler ^11.3.0` | Storage permissions |

---

## 🌐 API

This app uses the free [Quotable API](https://api.quotable.io):

```
GET https://api.quotable.io/quotes?tags=motivational&limit=20
GET https://api.quotable.io/quotes/random
GET https://api.quotable.io/quotes?query=courage
```

**Offline support:** All fetched quotes are cached in Hive. Falls back to 30+ built-in quotes when offline.

---

## 🎨 Design System

- **Primary:** `#6C63FF` (Purple)
- **Accent:** `#FF6584` (Pink)  
- **Typography:** Poppins (UI), Merriweather (quotes), Playfair Display (decorative)
- **Card gradients:** 9 hand-picked gradient pairs
- **Border radius:** 20–24px rounded cards

---

## 📱 Screenshots

| Splash | Home | Quotes | Favorites |
|--------|------|--------|-----------|
| Animated gradient | Category grid | Gradient cards | Swipe to remove |

| Search | Settings | Dark Mode |
|--------|----------|-----------|
| Live suggestions | Theme + Language | Full dark support |

---

## 🔮 Roadmap

- [ ] Push notifications for daily quote
- [ ] Widget for home screen (Android/iOS)
- [ ] More languages (Spanish, French, Arabic)
- [ ] Custom quote creation
- [ ] Quote collections / folders
- [ ] iCloud / Google Drive sync

---

## 📄 License

MIT License — free to use and modify.

---

Made with ❤️ using Flutter
