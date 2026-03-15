// lib/screens/quote_detail_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../models/category_model.dart';
import '../models/quote_model.dart';
import '../providers/favorites_provider.dart';
import '../providers/language_provider.dart';

class QuoteDetailScreen extends StatelessWidget {
  final QuoteModel quote;
  final CategoryModel? category;
  final List<Color> gradient;

  const QuoteDetailScreen({
    super.key,
    required this.quote,
    this.category,
    this.gradient = const [Color(0xFF6C63FF), Color(0xFF9C59D1)],
  });

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().languageCode;
    final favProvider = context.watch<FavoritesProvider>();
    final isFav = favProvider.isFavorite(quote.id);

    final text = quote.getLocalizedText(lang);
    final author = quote.getLocalizedAuthor(lang);
    final screenshotController = ScreenshotController();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 18),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Screenshot(
        controller: screenshotController,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradient,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Category tag
                  if (category != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${category!.emoji}  ${lang == 'hi' ? category!.nameHindi : category!.name}',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  const SizedBox(height: 32),

                  // Giant quote mark
                  Text(
                    '\u201C',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 96,
                      color: Colors.white.withOpacity(0.3),
                      height: 0.5,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Quote text
                  Text(
                    text,
                    style: GoogleFonts.merriweather(
                      color: Colors.white,
                      fontSize: lang == 'hi' ? 20 : 22,
                      height: 1.7,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Author
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 3,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        author,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 60),

                  // Action buttons row
                  _ActionButtonsRow(
                    quote: quote,
                    text: text,
                    author: author,
                    isFavorite: isFav,
                    gradient: gradient,
                    onFavorite: () => favProvider.toggleFavorite(quote),
                    screenshotController: screenshotController,
                  ),

                  const SizedBox(height: 20),
                  // App watermark
                  Center(
                    child: Text(
                      'QuoteNest',
                      style: GoogleFonts.poppins(
                        color: Colors.white.withOpacity(0.3),
                        fontSize: 12,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionButtonsRow extends StatelessWidget {
  final QuoteModel quote;
  final String text;
  final String author;
  final bool isFavorite;
  final List<Color> gradient;
  final VoidCallback onFavorite;
  final ScreenshotController screenshotController;

  const _ActionButtonsRow({
    required this.quote,
    required this.text,
    required this.author,
    required this.isFavorite,
    required this.gradient,
    required this.onFavorite,
    required this.screenshotController,
  });

  Future<void> _copyToClipboard(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: '"$text" — $author'));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Copied to clipboard!'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: gradient.first,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  Future<void> _shareQuote() async {
    await Share.share(
      '"$text"\n\n— $author\n\nShared via QuoteNest',
      subject: 'Beautiful quote from QuoteNest',
    );
  }

  Future<void> _downloadImage(BuildContext context) async {
    try {
      final imageBytes = await screenshotController.capture(pixelRatio: 3.0);
      if (imageBytes == null) return;

      final dir = await getTemporaryDirectory();
      final file = await File('${dir.path}/quotenest_${quote.id}.png')
          .writeAsBytes(imageBytes);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: '"$text" — $author',
        subject: 'Quote by $author',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not export image')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _BigActionButton(
          icon: isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          label: isFavorite ? 'Saved' : 'Save',
          color: Colors.red.shade300,
          onTap: onFavorite,
          isActive: isFavorite,
        ),
        const SizedBox(width: 16),
        _BigActionButton(
          icon: Icons.copy_rounded,
          label: 'Copy',
          color: Colors.white,
          onTap: () => _copyToClipboard(context),
        ),
        const SizedBox(width: 16),
        _BigActionButton(
          icon: Icons.share_rounded,
          label: 'Share',
          color: Colors.white,
          onTap: _shareQuote,
        ),
        const SizedBox(width: 16),
        _BigActionButton(
          icon: Icons.download_rounded,
          label: 'Save Image',
          color: Colors.white,
          onTap: () => _downloadImage(context),
        ),
      ],
    );
  }
}

class _BigActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool isActive;

  const _BigActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: isActive
                  ? Colors.white.withOpacity(0.9)
                  : Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isActive ? Colors.red : color,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.8),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
