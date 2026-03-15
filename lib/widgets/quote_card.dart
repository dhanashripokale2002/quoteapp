// lib/widgets/quote_card.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import '../models/category_model.dart';
import '../models/quote_model.dart';
import '../providers/favorites_provider.dart';
import '../providers/language_provider.dart';

const List<List<Color>> _kCardGradients = [
  [Color(0xFF6C63FF), Color(0xFF9C59D1)],
  [Color(0xFFFF6B35), Color(0xFFFF8E53)],
  [Color(0xFF0D47A1), Color(0xFF1565C0)],
  [Color(0xFF2E7D32), Color(0xFF43A047)],
  [Color(0xFFAD1457), Color(0xFFE91E63)],
  [Color(0xFF4527A0), Color(0xFF7B1FA2)],
  [Color(0xFF00695C), Color(0xFF00897B)],
  [Color(0xFFBF360C), Color(0xFFE64A19)],
  [Color(0xFF1A237E), Color(0xFF283593)],
];

class QuoteCard extends StatelessWidget {
  final QuoteModel quote;
  final int index;
  final CategoryModel? category;
  final bool showCategory;

  const QuoteCard({
    super.key,
    required this.quote,
    required this.index,
    this.category,
    this.showCategory = true,
  });

  List<Color> get _gradient => _kCardGradients[index % _kCardGradients.length];

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().languageCode;
    final favProvider = context.watch<FavoritesProvider>();
    final isFav = favProvider.isFavorite(quote.id);
    final text = quote.getLocalizedText(lang);
    final author = quote.getLocalizedAuthor(lang);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _gradient,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _gradient.first.withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -20, right: -20,
            child: Container(
              width: 100, height: 100,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.08)),
            ),
          ),
          Positioned(
            bottom: -30, left: -30,
            child: Container(
              width: 120, height: 120,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.06)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showCategory && category != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      '${category!.emoji}  ${lang == 'hi' ? category!.nameHindi : category!.name}',
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 14),
                ],
                Text(
                  '\u201C',
                  style: GoogleFonts.playfairDisplay(fontSize: 56, color: Colors.white.withOpacity(0.5), height: 0.6),
                ),
                const SizedBox(height: 8),
                Text(
                  text,
                  style: GoogleFonts.merriweather(
                    color: Colors.white,
                    fontSize: lang == 'hi' ? 15 : 16,
                    fontWeight: FontWeight.w400,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(width: 32, height: 2, color: Colors.white.withOpacity(0.6)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        author,
                        style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.9), fontSize: 13, fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _ActionRow(
                  quote: quote, text: text, author: author,
                  isFavorite: isFav, gradient: _gradient,
                  onFavorite: () => favProvider.toggleFavorite(quote),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final QuoteModel quote;
  final String text;
  final String author;
  final bool isFavorite;
  final List<Color> gradient;
  final VoidCallback onFavorite;

  const _ActionRow({
    required this.quote, required this.text, required this.author,
    required this.isFavorite, required this.gradient, required this.onFavorite,
  });

  Future<void> _share() async {
    await Share.share('"$text"\n\n— $author\n\nShared via QuoteNest');
  }

  Future<void> _copy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: '"$text" — $author'));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Quote copied!'),
        backgroundColor: gradient.first,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
    }
  }

  Future<void> _download(BuildContext context) async {
    final ctrl = ScreenshotController();
    try {
      final bytes = await ctrl.captureFromWidget(
        _ExportWidget(text: text, author: author, gradient: gradient),
        pixelRatio: 3.0,
      );
      final dir = await getTemporaryDirectory();
      final file = await File('${dir.path}/quote_${quote.id}.png').writeAsBytes(bytes);
      await Share.shareXFiles([XFile(file.path)], text: '"$text" — $author');
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not export image')));
      }
    }
  }

  Widget _btn({required IconData icon, required VoidCallback onTap, bool active = false}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 38, height: 38,
        decoration: BoxDecoration(
          color: active ? Colors.white.withOpacity(0.9) : Colors.white.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: active ? Colors.red : Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      _btn(icon: isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded, onTap: onFavorite, active: isFavorite),
      const SizedBox(width: 10),
      _btn(icon: Icons.copy_rounded, onTap: () => _copy(context)),
      const SizedBox(width: 10),
      _btn(icon: Icons.share_rounded, onTap: _share),
      const SizedBox(width: 10),
      _btn(icon: Icons.download_rounded, onTap: () => _download(context)),
    ]);
  }
}

class _ExportWidget extends StatelessWidget {
  final String text;
  final String author;
  final List<Color> gradient;
  const _ExportWidget({required this.text, required this.author, required this.gradient});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: gradient),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('\u201C', style: GoogleFonts.playfairDisplay(fontSize: 80, color: Colors.white.withOpacity(0.5), height: 0.6)),
            const SizedBox(height: 16),
            Text(text, style: GoogleFonts.merriweather(color: Colors.white, fontSize: 22, height: 1.6)),
            const SizedBox(height: 24),
            Row(children: [
              Container(width: 40, height: 2, color: Colors.white70),
              const SizedBox(width: 12),
              Text(author, style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.9), fontSize: 16, fontWeight: FontWeight.w600)),
            ]),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: Text('QuoteNest', style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.4), fontSize: 12, letterSpacing: 1.5)),
            ),
          ],
        ),
      ),
    );
  }
}
