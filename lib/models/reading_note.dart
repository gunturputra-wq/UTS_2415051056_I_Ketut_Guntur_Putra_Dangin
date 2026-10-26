class ReadingNote {
  final int? id;
  final String bookId;
  final String title;
  final String author;
  final String status;
  final String notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ReadingNote({
    this.id,
    required this.bookId,
    required this.title,
    required this.author,
    this.status = 'Ingin dibaca',
    this.notes = '',
    this.createdAt,
    this.updatedAt,
  });

  factory ReadingNote.fromJson(Map<String, dynamic> json) {
    return ReadingNote(
      id: (json['id'] as num?)?.toInt(),
      bookId: (json['book_id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      author: (json['author'] ?? 'Unknown author').toString(),
      status: (json['status'] ?? 'Ingin dibaca').toString(),
      notes: (json['notes'] ?? '').toString(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.tryParse(json['created_at'].toString()),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.tryParse(json['updated_at'].toString()),
    );
  }

  Map<String, dynamic> toInsertJson() {
    return {
      'book_id': bookId,
      'title': title,
      'author': author,
      'status': status,
      'notes': notes,
    };
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'book_id': bookId,
      'title': title,
      'author': author,
      'status': status,
      'notes': notes,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    };
  }

  ReadingNote copyWith({
    int? id,
    String? bookId,
    String? title,
    String? author,
    String? status,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReadingNote(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      title: title ?? this.title,
      author: author ?? this.author,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
