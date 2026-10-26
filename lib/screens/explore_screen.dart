
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/book.dart';
import '../providers/book_provider.dart';
import '../widgets/book_card.dart';
import 'book_detail_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController =
      TextEditingController();

  static const Color navy = Color(0xFF173B57);
  static const Color blue = Color(0xFF3D7EAB);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchBooks() {
    FocusScope.of(context).unfocus();

    context.read<BookProvider>().searchBooks(
          _searchController.text,
        );
  }

  void _navigateToDetail(Book book) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => BookDetailScreen(book: book),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F9FC),
        title: const Text(
          'Explore Books',
          style: TextStyle(
            color: navy,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Temukan bacaan berikutnya.',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: navy,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Cari berdasarkan judul buku atau nama penulis.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF718096),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0C173B57),
                          blurRadius: 18,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (_) => _searchBooks(),
                      decoration: InputDecoration(
                        hintText: 'Contoh: Harry Potter',
                        hintStyle: const TextStyle(
                          color: Color(0xFF9AA9B8),
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: blue,
                        ),
                        suffixIcon: IconButton(
                          tooltip: 'Search books',
                          onPressed: _searchBooks,
                          icon: const Icon(
                            Icons.arrow_forward_rounded,
                            color: blue,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 18,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: const BorderSide(
                            color: Color(0xFFE3EBF3),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: const BorderSide(
                            color: blue,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Expanded(
                    child: _buildResults(provider),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResults(BookProvider provider) {
    switch (provider.status) {
      case BookStatus.initial:
        return _emptyState(
          icon: Icons.auto_stories_rounded,
          title: 'Dunia buku menantimu',
          description:
              'Masukkan judul buku atau nama penulis '
              'untuk mulai menjelajah.',
        );

      case BookStatus.loading:
        return const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: blue),
              SizedBox(height: 18),
              Text('Sedang mencari buku...'),
            ],
          ),
        );

      case BookStatus.error:
        return _emptyState(
          icon: Icons.cloud_off_rounded,
          title: 'Buku belum bisa dimuat',
          description: provider.errorMessage ??
              'Periksa koneksi internet, lalu coba kembali.',
          buttonLabel: 'Coba Lagi',
          onPressed: _searchBooks,
        );

      case BookStatus.success:
        if (provider.books.isEmpty) {
          return _emptyState(
            icon: Icons.search_off_rounded,
            title: 'Buku tidak ditemukan',
            description:
                'Coba kata kunci lain, misalnya judul '
                'atau nama penulis yang berbeda.',
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final books = provider.books;

            if (constraints.maxWidth >= 650) {
              return GridView.builder(
                padding: const EdgeInsets.only(bottom: 12),
                gridDelegate:
                    const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 460,
                  mainAxisExtent: 160,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 2,
                ),
                itemCount: books.length,
                itemBuilder: (context, index) {
                  final book = books[index];

                  return BookCard(
                    book: book,
                    onTap: () => _navigateToDetail(book),
                  );
                },
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 12),
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];

                return BookCard(
                  book: book,
                  onTap: () => _navigateToDetail(book),
                );
              },
            );
          },
        );
    }
  }

  Widget _emptyState({
    required IconData icon,
    required String title,
    required String description,
    String? buttonLabel,
    VoidCallback? onPressed,
  }) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: const Color(0xFFE4EFF8),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Icon(
                icon,
                size: 43,
                color: blue,
              ),
            ),
            const SizedBox(height: 22),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: navy,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 9),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF718096),
                height: 1.6,
              ),
            ),
            if (buttonLabel != null && onPressed != null) ...[
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: onPressed,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(buttonLabel),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
