import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/reading_note.dart';
import '../providers/reading_note_provider.dart';

class ReadingNoteFormScreen extends StatefulWidget {
  const ReadingNoteFormScreen({
    super.key,
    this.note,
  });

  final ReadingNote? note;

  bool get isEditing => note != null;

  @override
  State<ReadingNoteFormScreen> createState() =>
      _ReadingNoteFormScreenState();
}

class _ReadingNoteFormScreenState
    extends State<ReadingNoteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _bookIdController;
  late final TextEditingController _titleController;
  late final TextEditingController _authorController;
  late final TextEditingController _notesController;

  String _status = 'Ingin dibaca';
  bool _saving = false;

  static const Color navy = Color(0xFF496A81);

  @override
  void initState() {
    super.initState();

    final note = widget.note;
    _bookIdController = TextEditingController(
      text: note?.bookId ?? '',
    );
    _titleController = TextEditingController(
      text: note?.title ?? '',
    );
    _authorController = TextEditingController(
      text: note?.author ?? '',
    );
    _notesController = TextEditingController(
      text: note?.notes ?? '',
    );
    _status = note?.status ?? 'Ingin dibaca';
  }

  @override
  void dispose() {
    _bookIdController.dispose();
    _titleController.dispose();
    _authorController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _saving) return;

    setState(() => _saving = true);

    final provider = context.read<ReadingNoteProvider>();
    final existing = widget.note;

    final note = ReadingNote(
      id: existing?.id,
      bookId: _bookIdController.text.trim(),
      title: _titleController.text.trim(),
      author: _authorController.text.trim(),
      status: _status,
      notes: _notesController.text.trim(),
      createdAt: existing?.createdAt,
      updatedAt: existing?.updatedAt,
    );

    final success = existing == null
        ? await provider.addNote(note)
        : await provider.updateNote(note);

    if (!mounted) return;

    setState(() => _saving = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            existing == null
                ? 'Buku berhasil ditambahkan.'
                : 'Buku berhasil diperbarui.',
          ),
        ),
      );
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.errorMessage ?? 'Gagal menyimpan buku.',
          ),
        ),
      );
    }
  }

  String? _required(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$label wajib diisi.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FC),
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Buku' : 'Tambah Buku'),
        backgroundColor: const Color(0xFFF5F8FC),
        foregroundColor: const Color(0xFF263746),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: navy,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.auto_stories_rounded,
                      color: Colors.white,
                      size: 42,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        widget.isEditing
                            ? 'Perbarui informasi dan progres membacamu.'
                            : 'Catat buku baru ke dalam koleksi BookNest.',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _field(
                controller: _bookIdController,
                label: 'ID Buku',
                hint: 'Contoh: OL12345W',
                icon: Icons.tag,
                validator: (value) => _required(value, 'ID buku'),
              ),
              const SizedBox(height: 16),
              _field(
                controller: _titleController,
                label: 'Judul Buku',
                hint: 'Masukkan judul buku',
                icon: Icons.menu_book_outlined,
                validator: (value) => _required(value, 'Judul buku'),
              ),
              const SizedBox(height: 16),
              _field(
                controller: _authorController,
                label: 'Penulis',
                hint: 'Masukkan nama penulis',
                icon: Icons.person_outline,
                validator: (value) => _required(value, 'Penulis'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _status,
                decoration: const InputDecoration(
                  labelText: 'Status membaca',
                  prefixIcon: Icon(Icons.bookmark_outline),
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
                onChanged: _saving
                    ? null
                    : (value) {
                        if (value != null) {
                          setState(() => _status = value);
                        }
                      },
              ),
              const SizedBox(height: 16),
              _field(
                controller: _notesController,
                label: 'Catatan pribadi',
                hint: 'Tulis kesan atau catatan membaca (opsional)',
                icon: Icons.notes_rounded,
                maxLines: 4,
              ),
              const SizedBox(height: 28),
              SizedBox(
                height: 52,
                child: FilledButton.icon(
                  onPressed: _saving ? null : _save,
                  style: FilledButton.styleFrom(
                    backgroundColor: navy,
                    foregroundColor: Colors.white,
                  ),
                  icon: _saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.save_outlined),
                  label: Text(
                    _saving ? 'Menyimpan...' : 'Simpan Buku',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        alignLabelWithHint: maxLines > 1,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}
