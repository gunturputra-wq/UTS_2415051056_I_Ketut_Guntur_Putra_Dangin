import 'package:flutter_test/flutter_test.dart';
import 'package:book_nest/models/book.dart';
import 'package:book_nest/repositories/book_repository.dart';
import 'package:book_nest/services/book_api_service.dart';

class FakeBookApiService extends Fake implements BookApiService {
  String? receivedQuery;
  List<Book> booksToReturn = [];
  Exception? errorToThrow;

  @override
  Future<List<Book>> searchBooks(String query) async {
    receivedQuery = query;

    if (errorToThrow != null) {
      throw errorToThrow!;
    }

    return booksToReturn;
  }
}

void main() {
  late FakeBookApiService apiService;
  late BookRepository repository;

  setUp(() {
    apiService = FakeBookApiService();
    repository = BookRepository(apiService: apiService);
  });

  test('searchBooks meneruskan query ke API service', () async {
    await repository.searchBooks('Flutter');

    expect(apiService.receivedQuery, 'Flutter');
  });

  test('searchBooks mengembalikan hasil dari API service', () async {
    const book = Book(
      id: '/works/OL123W',
      title: 'Belajar Flutter',
      authors: ['Penulis Tes'],
    );

    apiService.booksToReturn = [book];

    final result = await repository.searchBooks('Flutter');

    expect(result, hasLength(1));
    expect(result.single, same(book));
    expect(result.single.title, 'Belajar Flutter');
  });

  test('searchBooks meneruskan error dari API service', () async {
    apiService.errorToThrow = Exception('API gagal');

    await expectLater(
      repository.searchBooks('Flutter'),
      throwsA(isA<Exception>()),
    );
  });
}
