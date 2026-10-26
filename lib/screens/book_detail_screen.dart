
import 'package:flutter/material.dart';

import '../models/book.dart';

class BookDetailScreen extends StatelessWidget {
  const BookDetailScreen({
    super.key,
    required this.book,
  });

  final Book book;

  static const Color navy = Color(0xFF173B57);
  static const Color blue = Color(0xFF3D7EAB);
  static const Color background = Color(0xFFF6F9FC);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        leading: IconButton(
          tooltip: 'Back',
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text(
          'Book Details',
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
            constraints: const BoxConstraints(maxWidth: 900),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth >= 650;

                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFE1EFFB),
                              Color(0xFFF0F6FC),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(26),
                          border: Border.all(
                            color: const Color(0xFFDCEAF7),
                          ),
                        ),
                        child: wide
                            ? Row(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  _buildCover(),
                                  const SizedBox(width: 28),
                                  Expanded(
                                    child: _buildBookInformation(
                                      context,
                                      theme,
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  _buildCover(),
                                  const SizedBox(height: 24),
                                  _buildBookInformation(
                                    context,
                                    theme,
                                  ),
                                ],
                              ),
                      ),
                      const SizedBox(height: 26),
                      Text(
                        'Book information',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: navy,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: const Color(0xFFE5EDF5),
                          ),
                        ),
                        child: Column(
                          children: [
                            _InfoTile(
                              icon: Icons.person_outline_rounded,
                              label: 'Author',
                              value: book.authorText,
                            ),
                            const Divider(
                              height: 1,
                              indent: 18,
                              endIndent: 18,
                              color: Color(0xFFEDF1F5),
                            ),
                            _InfoTile(
                              icon: Icons.calendar_today_outlined,
                              label: 'First publication',
                              value: book.firstPublishYear?.toString() ??
                                  'Not available',
                            ),
                            const Divider(
                              height: 1,
                              indent: 18,
                              endIndent: 18,
                              color: Color(0xFFEDF1F5),
                            ),
                            _InfoTile(
                              icon: Icons.menu_book_rounded,
                              label: 'Book ID',
                              value: book.id.isEmpty
                                  ? 'Not available'
                                  : book.id,
                            ),
                            if (book.editionKey != null) ...[
                              const Divider(
                                height: 1,
                                indent: 18,
                                endIndent: 18,
                                color: Color(0xFFEDF1F5),
                              ),
                              _InfoTile(
                                icon: Icons.library_books_outlined,
                                label: 'Edition key',
                                value: book.editionKey!,
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back_rounded,
                          ),
                          label: const Text('Kembali ke Explore'),
                          style: FilledButton.styleFrom(
                            backgroundColor: navy,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 17,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCover() {
    return Container(
      width: 190,
      height: 270,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x18173B57),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: book.coverUrl == null
            ? _coverPlaceholder()
            : Image.network(
                book.coverUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _coverPlaceholder(),
              ),
      ),
    );
  }

  Widget _coverPlaceholder() {
    return Container(
      color: const Color(0xFFE4EFF8),
      child: const Center(
        child: Icon(
          Icons.auto_stories_rounded,
          size: 70,
          color: blue,
        ),
      ),
    );
  }

  Widget _buildBookInformation(
    BuildContext context,
    ThemeData theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Text(
            'BOOK DETAILS',
            style: TextStyle(
              color: blue,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          book.title,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: navy,
            fontWeight: FontWeight.w900,
            height: 1.2,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          book.authorText,
          style: theme.textTheme.titleMedium?.copyWith(
            color: const Color(0xFF58738B),
          ),
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 13,
            vertical: 9,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFDCEEFF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.calendar_month_rounded,
                color: blue,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                book.firstPublishYear?.toString() ??
                    'Year unavailable',
                style: const TextStyle(
                  color: navy,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'Informasi buku ini diperoleh dari Open Library.',
          style: TextStyle(
            color: Color(0xFF718096),
            fontSize: 13,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 16,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F2FB),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF3D7EAB),
              size: 21,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF718096),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 5),
                SelectableText(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF173B57),
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
