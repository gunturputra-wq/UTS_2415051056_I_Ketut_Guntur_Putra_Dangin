
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/book.dart';

class BookApiService {
  BookApiService({http.Client? client})
      : _client = client ?? http.Client();

  final http.Client _client;

  Future<List<Book>> searchBooks(String query) async {
    final trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty) {
      return [];
    }

    final uri = Uri.https(
      'openlibrary.org',
      '/search.json',
      {
        'q': trimmedQuery,
        'limit': '20',
        'fields':
            'key,title,author_name,first_publish_year,cover_i,edition_key',
      },
    );

    final response = await _client.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load books (HTTP ${response.statusCode})',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Invalid response from Open Library');
    }

    final documents = decoded['docs'];

    if (documents is! List) {
      throw const FormatException('Book list was not found in the response');
    }

    return documents
        .whereType<Map<String, dynamic>>()
        .map(Book.fromJson)
        .toList();
  }

  void dispose() {
    _client.close();
  }
}
