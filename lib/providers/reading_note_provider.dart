import 'package:flutter/foundation.dart';

import '../models/reading_note.dart';
import '../repositories/reading_note_repository.dart';

enum ReadingNoteStatus {
  initial,
  loading,
  success,
  error,
}

class ReadingNoteProvider extends ChangeNotifier {
  ReadingNoteProvider({required this._repository});

  final ReadingNoteRepository _repository;

  List<ReadingNote> _notes = [];
  ReadingNoteStatus _status = ReadingNoteStatus.initial;
  String? _errorMessage;
  bool _isSaving = false;

  List<ReadingNote> get notes => List.unmodifiable(_notes);
  ReadingNoteStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isSaving => _isSaving;

  Future<void> loadNotes() async {
    _status = ReadingNoteStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _notes = await _repository.getReadingNotes();
      _status = ReadingNoteStatus.success;
    } catch (error, stackTrace) {
      _status = ReadingNoteStatus.error;
      _errorMessage = 'Gagal memuat koleksi buku dari database.';
      debugPrint('Load reading notes error: $error');
      debugPrintStack(stackTrace: stackTrace);
    }

    notifyListeners();
  }

  Future<bool> addNote(ReadingNote note) async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final createdNote = await _repository.addReadingNote(note);
      _notes = [createdNote, ..._notes];
      _status = ReadingNoteStatus.success;
      return true;
    } catch (error, stackTrace) {
      _errorMessage = 'Gagal menyimpan catatan buku.';
      debugPrint('Add reading note error: $error');
      debugPrintStack(stackTrace: stackTrace);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> updateNote(ReadingNote note) async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedNote = await _repository.updateReadingNote(note);
      _notes = _notes
          .map((item) => item.id == updatedNote.id ? updatedNote : item)
          .toList();
      _status = ReadingNoteStatus.success;
      return true;
    } catch (error, stackTrace) {
      _errorMessage = 'Gagal memperbarui catatan buku.';
      debugPrint('Update reading note error: $error');
      debugPrintStack(stackTrace: stackTrace);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> deleteNote(int id) async {
    _errorMessage = null;

    try {
      await _repository.deleteReadingNote(id);
      _notes = _notes.where((item) => item.id != id).toList();
      _status = ReadingNoteStatus.success;
      notifyListeners();
      return true;
    } catch (error, stackTrace) {
      _errorMessage = 'Gagal menghapus catatan buku.';
      debugPrint('Delete reading note error: $error');
      debugPrintStack(stackTrace: stackTrace);
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
