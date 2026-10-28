import 'package:flutter_test/flutter_test.dart';
import 'package:book_nest/models/book.dart';
import 'package:book_nest/providers/book_provider.dart';
import 'package:book_nest/repositories/book_repository.dart';
import 'package:book_nest/services/book_api_service.dart';

class FakeBookApiService extends BookApiService {
  FakeBookApiService() : super();

  @override
  Future<List<Book>> searchBooks(String query) async => [];
}

class FakeBookRepository implements BookRepository {
  FakeBookRepository({
    this.result = const [],
    this.shouldFail = false,
  });

  final List<Book> result;
  final bool shouldFail;
  String? lastQuery;

  @override
  Future<List<Book>> searchBooks(String query) async {
    lastQuery = query;

    if (shouldFail) {
      throw Exception('Network error');
    }

    return result;
  }
}

void main() {
  group('BookProvider', () {
    test('starts with initial state', () {
      final provider = BookProvider(
        repository: FakeBookRepository(),
      );

      expect(provider.status, BookStatus.initial);
      expect(provider.books, isEmpty);
      expect(provider.errorMessage, isNull);
      expect(provider.query, '');

      provider.dispose();
    });

    test('empty query resets provider state', () async {
      final provider = BookProvider(
        repository: FakeBookRepository(),
      );

      await provider.searchBooks('   ');

      expect(provider.status, BookStatus.initial);
      expect(provider.books, isEmpty);
      expect(provider.errorMessage, isNull);

      provider.dispose();
    });

    test('trims query and returns successful result', () async {
      final book = Book(
        id: '/works/OL123W',
        title: 'Flutter Development',
        authors: ['Test Author'],
      );

      final repository = FakeBookRepository(result: [book]);
      final provider = BookProvider(repository: repository);

      await provider.searchBooks('  flutter  ');

      expect(repository.lastQuery, 'flutter');
      expect(provider.query, 'flutter');
      expect(provider.status, BookStatus.success);
      expect(provider.books, [book]);
      expect(provider.errorMessage, isNull);

      provider.dispose();
    });

    test('sets error state when repository fails', () async {
      final provider = BookProvider(
        repository: FakeBookRepository(shouldFail: true),
      );

      await provider.searchBooks('flutter');

      expect(provider.status, BookStatus.error);
      expect(provider.books, isEmpty);
      expect(provider.errorMessage, contains('Gagal memuat buku'));

      provider.dispose();
    });
  });
}
