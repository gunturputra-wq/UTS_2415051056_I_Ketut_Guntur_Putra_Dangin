import '../models/book.dart';
import '../services/book_api_service.dart';

class BookRepository {
  BookRepository({required this._apiService});

  final BookApiService _apiService;

  Future<List<Book>> searchBooks(String query) {
    return _apiService.searchBooks(query);
  }
}
