import 'package:flutter_test/flutter_test.dart';
import 'package:book_nest/models/reading_note.dart';
import 'package:book_nest/repositories/reading_note_repository.dart';
import 'package:book_nest/services/reading_note_service.dart';

class FakeReadingNoteService extends Fake
    implements ReadingNoteService {
  final List<String> calls = [];
  final List<ReadingNote> notes = [];
  ReadingNote? receivedNote;

  @override
  Future<List<ReadingNote>> getReadingNotes() async {
    calls.add('get');
    return notes;
  }

  @override
  Future<ReadingNote> addReadingNote(ReadingNote note) async {
    calls.add('add');
    receivedNote = note;
    return note;
  }

  @override
  Future<ReadingNote> updateReadingNote(ReadingNote note) async {
    calls.add('update');
    receivedNote = note;
    return note;
  }

  @override
  Future<void> deleteReadingNote(int id) async {
    calls.add('delete:$id');
  }
}

void main() {
  late FakeReadingNoteService service;
  late ReadingNoteRepository repository;

  setUp(() {
    service = FakeReadingNoteService();
    repository = ReadingNoteRepository(service: service);
  });

  test('getReadingNotes meneruskan pemanggilan ke service', () async {
    final result = await repository.getReadingNotes();

    expect(result, isEmpty);
    expect(service.calls, contains('get'));
  });

  test('addReadingNote meneruskan catatan ke service', () async {
    const note = ReadingNote(
      bookId: 'book-10',
      title: 'Belajar Flutter',
      author: 'Penulis Tes',
      notes: 'Catatan pengujian',
    );

    final result = await repository.addReadingNote(note);

    expect(result, same(note));
    expect(service.calls, contains('add'));
    expect(service.receivedNote, same(note));
  });

  test('updateReadingNote meneruskan catatan ke service', () async {
    const note = ReadingNote(
      id: 1,
      bookId: 'book-10',
      title: 'Belajar Flutter',
      author: 'Penulis Tes',
      notes: 'Catatan diperbarui',
    );

    final result = await repository.updateReadingNote(note);

    expect(result, same(note));
    expect(service.calls, contains('update'));
    expect(service.receivedNote, same(note));
  });

  test('deleteReadingNote meneruskan ID ke service', () async {
    await repository.deleteReadingNote(7);

    expect(service.calls, contains('delete:7'));
  });
}
