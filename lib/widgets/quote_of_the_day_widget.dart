// lib/widgets/quote_of_the_day_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/quote_model.dart';
import '../providers/language_provider.dart';
import '../providers/quotes_provider.dart';

class QuoteOfTheDayWidget extends StatelessWidget {
  const QuoteOfTheDayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<QuotesProvider>(
      builder: (context, provider, _) {
        if (provider.dailyQuoteState == LoadState.loading) {
          return _DailyQuoteSkeleton();
        }
        if (provider.dailyQuote == null) return const SizedBox.shrink();
        return _DailyQuoteCard(quote: provider.dailyQuote!);
      },
    );
  }
}

class _DailyQuoteCard extends StatelessWidget {
  final QuoteModel quote;
  const _DailyQuoteCard({required this.quote});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().languageCode;
    final text = quote.getLocalizedText(lang);
    final author = quote.getLocalizedAuthor(lang);
    final label = lang == 'hi' ? 'आज का विचार ✨' : 'Quote of the Day ✨';

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6C63FF), Color(0xFF9C59D1), Color(0xFFFF6584)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative blobs
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            bottom: -40,
            left: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.poppins(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Row(
                      children: [
                        _SmallActionBtn(
                          icon: Icons.copy_rounded,
                          onTap: () async {
                            await Clipboard.setData(ClipboardData(
                              text: '"$text" — $author',
                            ));
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Copied!'),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: const Color(0xFF6C63FF),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(width: 8),
                        _SmallActionBtn(
                          icon: Icons.share_rounded,
                          onTap: () => Share.share(
                            '"$text"\n\n— $author\n\nShared via QuoteNest',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Quote mark
                Text(
                  '\u201C',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 44,
                    color: Colors.white.withOpacity(0.4),
                    height: 0.6,
                  ),
                ),
                const SizedBox(height: 8),

                // Text
                Text(
                  text,
                  style: GoogleFonts.merriweather(
                    color: Colors.white,
                    fontSize: lang == 'hi' ? 14 : 15,
                    height: 1.6,
                  ),
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 14),

                // Author
                Row(
                  children: [
                    Container(width: 24, height: 2, color: Colors.white60),
                    const SizedBox(width: 8),
                    Text(
                      author,
                      style: GoogleFonts.poppins(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallActionBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _SmallActionBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 16, color: Colors.white),
      ),
    );
  }
}

class _DailyQuoteSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      height: 160,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
