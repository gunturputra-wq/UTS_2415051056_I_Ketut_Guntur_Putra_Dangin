import 'package:flutter/foundation.dart';

import '../models/book.dart';
import '../repositories/book_repository.dart';

enum BookStatus {
  initial,
  loading,
  success,
  error,
}

class BookProvider extends ChangeNotifier {
  BookProvider({required this._repository});

  final BookRepository _repository;

  List<Book> _books = [];
  BookStatus _status = BookStatus.initial;
  String? _errorMessage;
  String _query = '';

  List<Book> get books => List.unmodifiable(_books);
  BookStatus get status => _status;
  String? get errorMessage => _errorMessage;
  String get query => _query;

  Future<void> searchBooks(String query) async {
    _query = query.trim();

    if (_query.isEmpty) {
      _books = [];
      _errorMessage = null;
      _status = BookStatus.initial;
      notifyListeners();
      return;
    }

    _status = BookStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _books = await _repository.searchBooks(_query);
      _status = BookStatus.success;
    } catch (error) {
      _books = [];
      _errorMessage =
          'Gagal memuat buku. Periksa koneksi internet.';
      _status = BookStatus.error;

      debugPrint('Book search error: $error');
    }

    notifyListeners();
  }
}
