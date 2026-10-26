
class Book {
  final String id;
  final String title;
  final List<String> authors;
  final int? firstPublishYear;
  final String? coverId;
  final String? editionKey;

  const Book({
    required this.id,
    required this.title,
    this.authors = const [],
    this.firstPublishYear,
    this.coverId,
    this.editionKey,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final rawAuthors = json['author_name'];
    final rawYear = json['first_publish_year'];
    final rawCoverId = json['cover_i'];
    final rawEditionKeys = json['edition_key'];

    return Book(
      id: (json['key'] ?? '').toString(),
      title: (json['title'] ?? 'Untitled').toString(),
      authors: rawAuthors is List
          ? rawAuthors.map((author) => author.toString()).toList()
          : const [],
      firstPublishYear: rawYear is num ? rawYear.toInt() : null,
      coverId: rawCoverId is num ? rawCoverId.toInt().toString() : null,
      editionKey: rawEditionKeys is List && rawEditionKeys.isNotEmpty
          ? rawEditionKeys.first.toString()
          : null,
    );
  }

  String get authorText =>
      authors.isEmpty ? 'Unknown author' : authors.join(', ');

  String? get coverUrl => coverId == null
      ? null
      : 'https://covers.openlibrary.org/b/id/$coverId-M.jpg';
}
