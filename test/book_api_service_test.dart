import 'dart:convert';

import 'package:book_nest/models/book.dart';
import 'package:book_nest/services/book_api_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('BookApiService', () {
    test('mengubah respons API menjadi daftar buku', () async {
      final client = MockClient((request) async {
        expect(request.url.host, 'openlibrary.org');
        expect(request.url.path, '/search.json');
        expect(request.url.queryParameters['q'], 'flutter');

        return http.Response(
          jsonEncode({
            'docs': [
              {
                'key': '/works/OL123W',
                'title': 'Learning Flutter',
                'author_name': ['John Doe'],
                'first_publish_year': 2024,
                'cover_i': 12345,
                'edition_key': ['OL456M'],
              }
            ],
          }),
          200,
        );
      });

      final service = BookApiService(client: client);

      try {
        final books = await service.searchBooks('flutter');

        expect(books, hasLength(1));
        expect(books.first, isA<Book>());
        expect(books.first.id, '/works/OL123W');
        expect(books.first.title, 'Learning Flutter');
        expect(books.first.authors, ['John Doe']);
        expect(books.first.firstPublishYear, 2024);
        expect(books.first.coverId, '12345');
        expect(books.first.editionKey, 'OL456M');
      } finally {
        service.dispose();
      }
    });

    test('query kosong menghasilkan daftar kosong', () async {
      var requestSent = false;

      final client = MockClient((request) async {
        requestSent = true;
        return http.Response('{}', 200);
      });

      final service = BookApiService(client: client);

      try {
        final books = await service.searchBooks('   ');

        expect(books, isEmpty);
        expect(requestSent, isFalse);
      } finally {
        service.dispose();
      }
    });

    test('respons HTTP gagal menghasilkan exception', () async {
      final client = MockClient((request) async {
        return http.Response('Server error', 500);
      });

      final service = BookApiService(client: client);

      try {
        expect(
          () => service.searchBooks('flutter'),
          throwsA(
            isA<Exception>().having(
              (error) => error.toString(),
              'message',
              contains('HTTP 500'),
            ),
          ),
        );
      } finally {
        service.dispose();
      }
    });

    test('respons tanpa daftar docs menghasilkan FormatException',
        () async {
      final client = MockClient((request) async {
        return http.Response(jsonEncode({'unexpected': []}), 200);
      });

      final service = BookApiService(client: client);

      try {
        expect(
          service.searchBooks('flutter'),
          throwsA(isA<FormatException>()),
        );
      } finally {
        service.dispose();
      }
    });
    test('JSON bukan objek menghasilkan FormatException', () async {
      final client = MockClient((request) async {
        return http.Response('[]', 200);
      });

      final service = BookApiService(client: client);

      try {
        expect(
          service.searchBooks('flutter'),
          throwsA(isA<FormatException>()),
        );
      } finally {
        service.dispose();
      }
    });

    test('entri docs yang bukan objek dilewati', () async {
      final client = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'docs': [
              'data tidak valid',
              {
                'key': '/works/OL123W',
                'title': 'Learning Flutter',
              },
            ],
          }),
          200,
        );
      });

      final service = BookApiService(client: client);

      try {
        final books = await service.searchBooks('flutter');

        expect(books, hasLength(1));
        expect(books.single.id, '/works/OL123W');
      } finally {
        service.dispose();
      }
    });

  });
}

