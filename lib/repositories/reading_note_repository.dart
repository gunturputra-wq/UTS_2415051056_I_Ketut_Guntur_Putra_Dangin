import '../models/reading_note.dart';
import '../services/reading_note_service.dart';

class ReadingNoteRepository {
  ReadingNoteRepository({required this._service});

  final ReadingNoteService _service;

  Future<List<ReadingNote>> getReadingNotes() {
    return _service.getReadingNotes();
  }

  Future<ReadingNote> addReadingNote(ReadingNote note) {
    return _service.addReadingNote(note);
  }

  Future<ReadingNote> updateReadingNote(ReadingNote note) {
    return _service.updateReadingNote(note);
  }

  Future<void> deleteReadingNote(int id) {
    return _service.deleteReadingNote(id);
  }
}
