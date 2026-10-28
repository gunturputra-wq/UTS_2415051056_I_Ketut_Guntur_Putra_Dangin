import 'package:flutter_test/flutter_test.dart';
import 'package:book_nest/models/reading_note.dart';

void main() {
  group('ReadingNote model', () {
    test('parses JSON data correctly', () {
      final note = ReadingNote.fromJson({
        'id': 10,
        'book_id': '/works/OL123W',
        'title': 'Flutter Development',
        'author': 'Test Author',
        'status': 'Sedang dibaca',
        'notes': 'Bab pertama selesai',
        'created_at': '2026-10-28T10:00:00Z',
        'updated_at': '2026-10-28T11:00:00Z',
      });

      expect(note.id, 10);
      expect(note.bookId, '/works/OL123W');
      expect(note.title, 'Flutter Development');
      expect(note.author, 'Test Author');
      expect(note.status, 'Sedang dibaca');
      expect(note.notes, 'Bab pertama selesai');
      expect(note.createdAt, DateTime.parse('2026-10-28T10:00:00Z'));
      expect(note.updatedAt, DateTime.parse('2026-10-28T11:00:00Z'));
    });

    test('uses defaults when optional JSON fields are missing', () {
      final note = ReadingNote.fromJson({});

      expect(note.id, isNull);
      expect(note.bookId, '');
      expect(note.title, '');
      expect(note.author, 'Unknown author');
      expect(note.status, 'Ingin dibaca');
      expect(note.notes, '');
      expect(note.createdAt, isNull);
      expect(note.updatedAt, isNull);
    });

    test('converts note to insert JSON without database fields', () {
      const note = ReadingNote(
        id: 10,
        bookId: '/works/OL123W',
        title: 'Flutter Development',
        author: 'Test Author',
        status: 'Ingin dibaca',
        notes: 'Read later',
      );

      expect(note.toInsertJson(), {
        'book_id': '/works/OL123W',
        'title': 'Flutter Development',
        'author': 'Test Author',
        'status': 'Ingin dibaca',
        'notes': 'Read later',
      });
    });

    test('includes updated_at in update JSON', () {
      const note = ReadingNote(
        id: 10,
        bookId: '/works/OL123W',
        title: 'Flutter Development',
        author: 'Test Author',
      );

      final json = note.toUpdateJson();

      expect(json['book_id'], '/works/OL123W');
      expect(json['title'], 'Flutter Development');
      expect(json['author'], 'Test Author');
      expect(json['status'], 'Ingin dibaca');
      expect(json['notes'], '');
      expect(json['updated_at'], isA<String>());
      expect(
        DateTime.tryParse(json['updated_at'] as String),
        isNotNull,
      );
    });

    test('copyWith changes selected fields and preserves others', () {
      const original = ReadingNote(
        id: 10,
        bookId: '/works/OL123W',
        title: 'Original Title',
        author: 'Test Author',
        status: 'Ingin dibaca',
        notes: 'Original notes',
      );

      final updated = original.copyWith(
        title: 'Updated Title',
        status: 'Sedang dibaca',
      );

      expect(updated.id, 10);
      expect(updated.bookId, '/works/OL123W');
      expect(updated.title, 'Updated Title');
      expect(updated.author, 'Test Author');
      expect(updated.status, 'Sedang dibaca');
      expect(updated.notes, 'Original notes');
    });
  });
}
