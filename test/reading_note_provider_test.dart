import 'package:flutter_test/flutter_test.dart';
import 'package:book_nest/models/reading_note.dart';
import 'package:book_nest/providers/reading_note_provider.dart';
import 'package:book_nest/repositories/reading_note_repository.dart';

class FakeReadingNoteRepository implements ReadingNoteRepository {
  List<ReadingNote> storedNotes = [];
  bool failLoad = false;
  bool failAdd = false;
  bool failUpdate = false;
  bool failDelete = false;

  @override
  Future<List<ReadingNote>> getReadingNotes() async {
    if (failLoad) throw Exception('Load failed');
    return List.of(storedNotes);
  }

  @override
  Future<ReadingNote> addReadingNote(ReadingNote note) async {
    if (failAdd) throw Exception('Add failed');
    final created = note.copyWith(id: 2);
    storedNotes = [created, ...storedNotes];
    return created;
  }

  @override
  Future<ReadingNote> updateReadingNote(ReadingNote note) async {
    if (failUpdate) throw Exception('Update failed');
    storedNotes = storedNotes
        .map((item) => item.id == note.id ? note : item)
        .toList();
    return note;
  }

  @override
  Future<void> deleteReadingNote(int id) async {
    if (failDelete) throw Exception('Delete failed');
    storedNotes = storedNotes.where((note) => note.id != id).toList();
  }
}

void main() {
  late FakeReadingNoteRepository repository;
  late ReadingNoteProvider provider;

  const sampleNote = ReadingNote(
    id: 1,
    bookId: '/works/OL123W',
    title: 'Buku Awal',
    author: 'Penulis Tes',
  );

  setUp(() {
    repository = FakeReadingNoteRepository()
      ..storedNotes = [sampleNote];
    provider = ReadingNoteProvider(repository: repository);
  });

  tearDown(() {
    provider.dispose();
  });

  test('loadNotes memuat catatan dan mengubah status menjadi success', () async {
    await provider.loadNotes();

    expect(provider.status, ReadingNoteStatus.success);
    expect(provider.notes, hasLength(1));
    expect(provider.notes.first.title, 'Buku Awal');
    expect(provider.errorMessage, isNull);
  });

  test('addNote menambahkan catatan baru', () async {
    await provider.loadNotes();

    final result = await provider.addNote(
      const ReadingNote(
        bookId: '/works/OL456W',
        title: 'Buku Baru',
        author: 'Penulis Baru',
      ),
    );

    expect(result, isTrue);
    expect(provider.notes, hasLength(2));
    expect(provider.notes.first.id, 2);
    expect(provider.notes.first.title, 'Buku Baru');
    expect(provider.isSaving, isFalse);
  });

  test('updateNote memperbarui catatan yang sesuai', () async {
    await provider.loadNotes();

    final result = await provider.updateNote(
      sampleNote.copyWith(title: 'Judul Diperbarui'),
    );

    expect(result, isTrue);
    expect(provider.notes, hasLength(1));
    expect(provider.notes.first.title, 'Judul Diperbarui');
    expect(provider.isSaving, isFalse);
  });

  test('deleteNote menghapus catatan berdasarkan ID', () async {
    await provider.loadNotes();

    final result = await provider.deleteNote(1);

    expect(result, isTrue);
    expect(provider.notes, isEmpty);
    expect(provider.status, ReadingNoteStatus.success);
  });

  test('loadNotes menangani kegagalan pemuatan', () async {
    repository.failLoad = true;

    await provider.loadNotes();

    expect(provider.status, ReadingNoteStatus.error);
    expect(
      provider.errorMessage,
      'Gagal memuat koleksi buku dari database.',
    );
  });

  test('addNote menangani kegagalan penyimpanan', () async {
    await provider.loadNotes();
    repository.failAdd = true;

    final result = await provider.addNote(
      const ReadingNote(
        bookId: '/works/OL456W',
        title: 'Buku Baru',
        author: 'Penulis Baru',
      ),
    );

    expect(result, isFalse);
    expect(provider.notes, hasLength(1));
    expect(provider.errorMessage, 'Gagal menyimpan catatan buku.');
    expect(provider.isSaving, isFalse);
  });

  test('deleteNote menangani kegagalan penghapusan', () async {
    await provider.loadNotes();
    repository.failDelete = true;

    final result = await provider.deleteNote(1);

    expect(result, isFalse);
    expect(provider.notes, hasLength(1));
    expect(provider.errorMessage, 'Gagal menghapus catatan buku.');
  });
}
