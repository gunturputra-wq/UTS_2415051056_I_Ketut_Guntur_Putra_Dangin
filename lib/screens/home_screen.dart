
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.onExploreTap,
  });

  final VoidCallback onExploreTap;

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
        titleSpacing: 20,
        title: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFDCECF8),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.auto_stories_rounded,
                color: blue,
                size: 26,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'BookNest',
              style: TextStyle(
                color: navy,
                fontSize: 23,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.7,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Search books',
            onPressed: onExploreTap,
            icon: const Icon(Icons.search_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth >= 650;

                return ListView(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    16,
                    20,
                    28,
                  ),
                  children: [
                    _buildHero(context, wide),
                    const SizedBox(height: 30),
                    Text(
                      'Jelajahi dunia buku',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: navy,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Temukan bacaan yang cocok untukmu.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF718096),
                      ),
                    ),
                    const SizedBox(height: 18),
                    if (wide)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _FeatureCard(
                              icon: Icons.search_rounded,
                              title: 'Cari Buku',
                              description:
                                  'Temukan judul dan penulis favorit.',
                              color: const Color(0xFFDCEEFF),
                              iconColor: const Color(0xFF3276AA),
                              onTap: onExploreTap,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: _FeatureCard(
                              icon: Icons.bookmark_outline_rounded,
                              title: 'Bangun Koleksi',
                              description:
                                  'Siapkan ruang untuk buku favorit.',
                              color: Color(0xFFDDF4EA),
                              iconColor: Color(0xFF32866A),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: _FeatureCard(
                              icon: Icons.edit_note_rounded,
                              title: 'Catatan',
                              description:
                                  'Simpan pemikiran dari bacaanmu.',
                              color: Color(0xFFECE4FF),
                              iconColor: Color(0xFF8061BD),
                            ),
                          ),
                        ],
                      )
                    else
                      Column(
                        children: [
                          _FeatureCard(
                            icon: Icons.search_rounded,
                            title: 'Cari Buku',
                            description:
                                'Temukan judul dan penulis favorit.',
                            color: const Color(0xFFDCEEFF),
                            iconColor: const Color(0xFF3276AA),
                            onTap: onExploreTap,
                          ),
                          const SizedBox(height: 12),
                          const _FeatureCard(
                            icon: Icons.bookmark_outline_rounded,
                            title: 'Bangun Koleksi',
                            description:
                                'Siapkan ruang untuk buku favorit.',
                            color: Color(0xFFDDF4EA),
                            iconColor: Color(0xFF32866A),
                          ),
                          const SizedBox(height: 12),
                          const _FeatureCard(
                            icon: Icons.edit_note_rounded,
                            title: 'Catatan',
                            description:
                                'Simpan pemikiran dari bacaanmu.',
                            color: Color(0xFFECE4FF),
                            iconColor: Color(0xFF8061BD),
                          ),
                        ],
                      ),
                    const SizedBox(height: 28),
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFE1F0FC),
                            Color(0xFFF0F6FD),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: const Color(0xFFD9E9F6),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 54,
                            height: 54,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.8),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.auto_awesome_rounded,
                              color: blue,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Satu halaman, satu petualangan.',
                                  style: theme.textTheme.titleMedium
                                      ?.copyWith(
                                    color: navy,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Mulai temukan cerita berikutnya '
                                  'bersama BookNest.',
                                  style: theme.textTheme.bodyMedium
                                      ?.copyWith(
                                    color: const Color(0xFF58738B),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                FilledButton.icon(
                                  onPressed: onExploreTap,
                                  icon: const Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 19,
                                  ),
                                  label: const Text('Jelajahi Buku'),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: blue,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: Text(
                        'BOOKNEST  •  YOUR PERSONAL BOOKSPACE',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: const Color(0xFF91A2B2),
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHero(BuildContext context, bool wide) {
    final theme = Theme.of(context);

    final textContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Text(
            'HALO, PEMBACA! 👋',
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
          'Find your next\\nfavorite book.',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: navy,
            fontWeight: FontWeight.w900,
            height: 1.12,
            letterSpacing: -1.1,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Jelajahi ribuan buku, temukan penulis baru, '
          'dan bangun koleksi bacaanmu sendiri.',
          style: TextStyle(
            color: Color(0xFF58738B),
            fontSize: 14,
            height: 1.65,
          ),
        ),
        if (wide) ...[
          const SizedBox(height: 22),
          FilledButton.icon(
            onPressed: onExploreTap,
            icon: const Icon(Icons.search_rounded),
            label: const Text('Mulai Menjelajah'),
            style: FilledButton.styleFrom(
              backgroundColor: navy,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
            ),
          ),
        ],
      ],
    );

    final illustration = Container(
      constraints: const BoxConstraints(minHeight: 170),
      decoration: BoxDecoration(
        color: const Color(0xFFD6EAF8),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 18,
            right: 20,
            child: Icon(
              Icons.auto_awesome,
              size: 27,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          Positioned(
            left: 22,
            bottom: 20,
            child: Icon(
              Icons.circle,
              size: 15,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          const Icon(
            Icons.menu_book_rounded,
            size: 112,
            color: Color(0xFF3D7EAB),
          ),
          Positioned(
            bottom: 24,
            right: 26,
            child: Transform.rotate(
              angle: 0.15,
              child: const Icon(
                Icons.local_cafe_rounded,
                size: 38,
                color: Color(0xFF8D705C),
              ),
            ),
          ),
          Positioned(
            top: 28,
            left: 26,
            child: Icon(
              Icons.star_rounded,
              size: 25,
              color: const Color(0xFFE6B85C),
            ),
          ),
        ],
      ),
    );

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF3FC),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: const Color(0xFFDCEAF7),
        ),
      ),
      child: wide
          ? Row(
              children: [
                Expanded(flex: 6, child: textContent),
                const SizedBox(width: 24),
                Expanded(flex: 5, child: illustration),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textContent,
                const SizedBox(height: 24),
                SizedBox(
                  height: 185,
                  width: double.infinity,
                  child: illustration,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: onExploreTap,
                    icon: const Icon(Icons.search_rounded),
                    label: const Text('Jelajahi Buku'),
                    style: FilledButton.styleFrom(
                      backgroundColor: navy,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.iconColor,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final Color iconColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFFE7EDF3)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(17),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 27,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: const Color(0xFF173B57),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF718096),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF6E8CA5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
