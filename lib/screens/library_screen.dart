import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/reading_note.dart';
import '../providers/reading_note_provider.dart';
import 'reading_note_form_screen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  static const Color navy = Color(0xFF496A81);
  static const Color background = Color(0xFFF5F8FC);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ReadingNoteProvider>().loadNotes();
      }
    });
  }
  Future<void> _editNote(ReadingNote note) async {
    final updated = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => ReadingNoteFormScreen(note: note),
      ),
    );

    if (!mounted) return;

    if (updated == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Perubahan buku berhasil disimpan.'),
        ),
      );
    }
  }

  Future<void> _showAddNoteDialog() async {
    final formKey = GlobalKey<FormState>();
    final bookIdController = TextEditingController();
    final titleController = TextEditingController();
    final authorController = TextEditingController();
    final notesController = TextEditingController();
    String selectedStatus = 'Ingin dibaca';

    final provider = context.read<ReadingNoteProvider>();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        bool saving = false;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Tambah buku'),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: bookIdController,
                        decoration: const InputDecoration(
                          labelText: 'ID buku',
                          hintText: 'Contoh: OL12345W',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'ID buku wajib diisi'
                                : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          labelText: 'Judul buku',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'Judul buku wajib diisi'
                                : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: authorController,
                        decoration: const InputDecoration(
                          labelText: 'Penulis',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'Nama penulis wajib diisi'
                                : null,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: selectedStatus,
                        decoration: const InputDecoration(
                          labelText: 'Status membaca',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Ingin dibaca',
                            child: Text('Ingin dibaca'),
                          ),
                          DropdownMenuItem(
                            value: 'Sedang dibaca',
                            child: Text('Sedang dibaca'),
                          ),
                          DropdownMenuItem(
                            value: 'Selesai',
                            child: Text('Selesai'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setDialogState(() {
                              selectedStatus = value;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: notesController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Catatan (opsional)',
                          border: OutlineInputBorder(),
                          alignLabelWithHint: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: saving
                      ? null
                      : () => Navigator.pop(dialogContext),
                  child: const Text('Batal'),
                ),
                FilledButton(
                  onPressed: saving
                      ? null
                      : () async {
                          if (!formKey.currentState!.validate()) return;

                          setDialogState(() => saving = true);

                          final note = ReadingNote(
                            bookId: bookIdController.text.trim(),
                            title: titleController.text.trim(),
                            author: authorController.text.trim(),
                            status: selectedStatus,
                            notes: notesController.text.trim(),
                          );

                          final success = await provider.addNote(note);

                          if (!mounted || !dialogContext.mounted) return;

                          if (success) {
                            Navigator.pop(dialogContext);
                            ScaffoldMessenger.of(this.context)
                                .showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Buku berhasil ditambahkan.',
                                ),
                              ),
                            );
                          } else {
                            setDialogState(() => saving = false);
                            ScaffoldMessenger.of(this.context)
                                .showSnackBar(
                              SnackBar(
                                content: Text(
                                  provider.errorMessage ??
                                      'Gagal menambahkan buku.',
                                ),
                              ),
                            );
                          }
                        },
                  child: saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );

    bookIdController.dispose();
    titleController.dispose();
    authorController.dispose();
    notesController.dispose();
  }

  Future<void> _confirmDelete(ReadingNote note) async {
    if (note.id == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus buku?'),
        content: Text(
          'Buku "${note.title}" akan dihapus dari koleksimu.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red.shade700,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final success =
        await context.read<ReadingNoteProvider>().deleteNote(note.id!);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Buku berhasil dihapus.'
              : 'Buku gagal dihapus. Periksa koneksi database.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddNoteDialog,
        backgroundColor: navy,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Tambah buku'),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () =>
              context.read<ReadingNoteProvider>().loadNotes(),
          child: Consumer<ReadingNoteProvider>(
            builder: (context, provider, child) {
              final notes = provider.notes;
              final wantToRead = notes
                  .where((note) => note.status == 'Ingin dibaca')
                  .length;
              final reading = notes
                  .where((note) => note.status == 'Sedang dibaca')
                  .length;
              final finished =
                  notes.where((note) => note.status == 'Selesai').length;

              return ListView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'My Library',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF263746),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Koleksi dan perjalanan membacamu',
                              style: TextStyle(
                                color: Colors.blueGrey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: 'Muat ulang',
                        onPressed: provider.loadNotes,
                        icon: const Icon(Icons.refresh),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: navy,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Koleksi bukumu',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Terus tumbuh,\nterus belajar.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.auto_stories_rounded,
                          color: Colors.white,
                          size: 58,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _SummaryCard(
                          title: 'Ingin dibaca',
                          count: wantToRead,
                          icon: Icons.bookmark_outline,
                          color: const Color(0xFFE9F1FA),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _SummaryCard(
                          title: 'Dibaca',
                          count: reading,
                          icon: Icons.menu_book_rounded,
                          color: const Color(0xFFE8F5EF),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _SummaryCard(
                          title: 'Selesai',
                          count: finished,
                          icon: Icons.check_circle_outline,
                          color: const Color(0xFFFFF1DC),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Koleksi saya',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF263746),
                    ),
                  ),
                  const SizedBox(height: 14),
                  if (provider.status == ReadingNoteStatus.loading &&
                      notes.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(36),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (provider.status == ReadingNoteStatus.error &&
                      notes.isEmpty)
                    _MessageState(
                      icon: Icons.cloud_off_outlined,
                      title: 'Gagal memuat koleksi',
                      message: provider.errorMessage ??
                          'Periksa koneksi internet dan konfigurasi Supabase.',
                      buttonText: 'Coba lagi',
                      onPressed: provider.loadNotes,
                    )
                  else if (notes.isEmpty)
                    _MessageState(
                      icon: Icons.library_books_outlined,
                      title: 'Perpustakaanmu masih kosong',
                      message:
                          'Tambahkan buku pertama untuk mulai mencatat perjalanan membacamu.',
                      buttonText: 'Tambah buku',
                      onPressed: _showAddNoteDialog,
                    )
                  else
                    ...notes.map(
                      (note) => _NoteCard(
                        note: note,
                        onEdit: () => _editNote(note),
                        onDelete: () => _confirmDelete(note),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
  });

  final String title;
  final int count;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF496A81), size: 23),
          const SizedBox(height: 12),
          Text(
            '$count',
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 11),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({
    required this.note,
    required this.onEdit,
    required this.onDelete,
  });

  final ReadingNote note;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final statusColor = switch (note.status) {
      'Selesai' => const Color(0xFF287A56),
      'Sedang dibaca' => const Color(0xFF496A81),
      _ => const Color(0xFF94651D),
    };

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: Colors.blueGrey.shade50),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 54,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFFE9F1FA),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.menu_book_rounded,
                size: 30,
                color: Color(0xFF496A81),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    note.author,
                    style: TextStyle(
                      color: Colors.blueGrey.shade600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 9),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      note.status,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (note.notes.trim().isNotEmpty) ...[
                    const SizedBox(height: 9),
                    Text(
                      note.notes,
                      style: TextStyle(
                        color: Colors.blueGrey.shade700,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            IconButton(

              tooltip: 'Edit buku',

              onPressed: onEdit,

              icon: const Icon(Icons.edit_outlined, color: Color(0xFF496A81)),

            ),

            IconButton(

              tooltip: 'Hapus buku',
              onPressed: onDelete,
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.redAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageState extends StatelessWidget {
  const _MessageState({
    required this.icon,
    required this.title,
    required this.message,
    required this.buttonText,
    required this.onPressed,
  });

  final IconData icon;
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 12),
      child: Column(
        children: [
          Icon(icon, size: 54, color: Colors.blueGrey.shade300),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.blueGrey.shade600),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: onPressed,
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }
}




