// lib/screens/search_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/quotes_provider.dart';
import '../widgets/loading_skeleton.dart';
import '../widgets/quote_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    // Clear search results when leaving
    context.read<QuotesProvider>().clearSearch();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<QuotesProvider>().search(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          onChanged: _onSearchChanged,
          decoration: InputDecoration(
            hintText: 'Search quotes or authors...',
            hintStyle: GoogleFonts.poppins(
              fontSize: 15,
              color: Colors.grey,
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
          style: GoogleFonts.poppins(fontSize: 15),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Consumer<QuotesProvider>(
            builder: (_, provider, __) {
              if (provider.searchQuery.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.clear_rounded),
                onPressed: () {
                  _controller.clear();
                  provider.clearSearch();
                },
              );
            },
          ),
        ],
      ),
      body: Consumer<QuotesProvider>(
        builder: (context, provider, _) {
          // Idle — show suggestions
          if (provider.searchState == LoadState.idle) {
            return _SearchSuggestions(
              onSuggestionTap: (term) {
                _controller.text = term;
                _controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: _controller.text.length),
                );
                provider.search(term);
              },
            );
          }

          // Loading
          if (provider.searchState == LoadState.loading) {
            return const LoadingSkeleton();
          }

          // No results
          if (provider.searchResults.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🔍', style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 16),
                  Text(
                    'No quotes found for\n"${provider.searchQuery}"',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.grey,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            );
          }

          // Results
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                child: Text(
                  '${provider.searchResults.length} result${provider.searchResults.length == 1 ? '' : 's'} for "${provider.searchQuery}"',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 30),
                  itemCount: provider.searchResults.length,
                  itemBuilder: (_, index) => QuoteCard(
                    quote: provider.searchResults[index],
                    index: index,
                    showCategory: true,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SearchSuggestions extends StatelessWidget {
  final ValueChanged<String> onSuggestionTap;

  const _SearchSuggestions({required this.onSuggestionTap});

  static const List<String> _suggestions = [
    'Motivation', 'Success', 'Life', 'Love', 'Happiness',
    'Courage', 'Wisdom', 'Friendship', 'Marcus Aurelius',
    'Einstein', 'Churchill', 'Mandela',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Popular Searches',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _suggestions.map((term) {
              return GestureDetector(
                onTap: () => onSuggestionTap(term),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    term,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
