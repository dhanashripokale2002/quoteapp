// lib/screens/quotes_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/category_model.dart';
import '../providers/language_provider.dart';
import '../providers/quotes_provider.dart';
import '../widgets/loading_skeleton.dart';
import '../widgets/quote_card.dart';

class QuotesScreen extends StatefulWidget {
  final CategoryModel category;
  const QuotesScreen({super.key, required this.category});

  @override
  State<QuotesScreen> createState() => _QuotesScreenState();
}

class _QuotesScreenState extends State<QuotesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuotesProvider>().loadQuotes(widget.category);
    });
  }

  @override
  Widget build(BuildContext context) {
    final langCode = context.watch<LanguageProvider>().languageCode;
    final catName = langCode == 'hi'
        ? widget.category.nameHindi
        : widget.category.name;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Gradient SliverAppBar
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                catName,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18, color: Colors.white),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: widget.category.gradient,
                  ),
                ),
                child: Center(
                  child: Text(widget.category.emoji, style: const TextStyle(fontSize: 60)),
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                onPressed: () => context.read<QuotesProvider>().loadQuotes(widget.category, forceRefresh: true),
              ),
            ],
          ),

          // Quote list
          Consumer<QuotesProvider>(
            builder: (context, provider, _) {
              final state = provider.getLoadState(widget.category.id);
              final quotes = provider.getQuotes(widget.category.id);
              final error = provider.getError(widget.category.id);

              if (state == LoadState.loading && quotes.isEmpty) {
                return const SliverFillRemaining(child: LoadingSkeleton());
              }

              if (state == LoadState.error && quotes.isEmpty) {
                return SliverFillRemaining(
                  child: _ErrorView(
                    message: error ?? 'Something went wrong',
                    onRetry: () => provider.loadQuotes(widget.category, forceRefresh: true),
                  ),
                );
              }

              if (quotes.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('🤔', style: TextStyle(fontSize: 48)),
                        const SizedBox(height: 16),
                        Text('No quotes found', style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey)),
                      ],
                    ),
                  ),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) => _AnimatedItem(
                    index: i,
                    child: QuoteCard(
                      quote: quotes[i],
                      index: i,
                      category: widget.category,
                      showCategory: false,
                    ),
                  ),
                  childCount: quotes.length,
                ),
              );
            },
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 30)),
        ],
      ),
    );
  }
}

class _AnimatedItem extends StatefulWidget {
  final Widget child;
  final int index;
  const _AnimatedItem({required this.child, required this.index});

  @override
  State<_AnimatedItem> createState() => _AnimatedItemState();
}

class _AnimatedItemState extends State<_AnimatedItem> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _fade = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _slide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    Future.delayed(Duration(milliseconds: widget.index * 80), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _fade, child: SlideTransition(position: _slide, child: widget.child));
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('😕', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 15, color: Colors.grey)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
