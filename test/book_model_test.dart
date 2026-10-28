import 'package:flutter_test/flutter_test.dart';
import 'package:book_nest/models/book.dart';

void main() {
  group('Book model', () {
    test('parses complete JSON data correctly', () {
      final book = Book.fromJson({
        'key': '/works/OL123W',
        'title': 'Flutter Development',
        'author_name': ['Test Author', 'Second Author'],
        'first_publish_year': 2024,
        'cover_i': 12345,
        'edition_key': ['OL456M'],
      });

      expect(book.id, '/works/OL123W');
      expect(book.title, 'Flutter Development');
      expect(book.authors, ['Test Author', 'Second Author']);
      expect(book.firstPublishYear, 2024);
      expect(book.coverId, '12345');
      expect(book.editionKey, 'OL456M');
    });

    test('uses fallback values when JSON fields are missing', () {
      final book = Book.fromJson({});

      expect(book.id, '');
      expect(book.title, 'Untitled');
      expect(book.authors, isEmpty);
      expect(book.firstPublishYear, isNull);
      expect(book.coverId, isNull);
      expect(book.editionKey, isNull);
    });

    test('formats author text correctly', () {
      final bookWithAuthors = Book(
        id: '1',
        title: 'Book One',
        authors: ['Author A', 'Author B'],
      );

      final bookWithoutAuthors = Book(
        id: '2',
        title: 'Book Two',
      );

      expect(bookWithAuthors.authorText, 'Author A, Author B');
      expect(bookWithoutAuthors.authorText, 'Unknown author');
    });

    test('creates cover URL when cover ID exists', () {
      final book = Book(
        id: '1',
        title: 'Book One',
        coverId: '12345',
      );

      expect(
        book.coverUrl,
        'https://covers.openlibrary.org/b/id/12345-M.jpg',
      );
    });

    test('returns null cover URL when cover ID is missing', () {
      final book = Book(
        id: '1',
        title: 'Book One',
      );

      expect(book.coverUrl, isNull);
    });
  });
}
