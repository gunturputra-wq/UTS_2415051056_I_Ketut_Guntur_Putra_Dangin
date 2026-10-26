
import 'package:book_nest/main.dart';
import 'package:book_nest/models/reading_note.dart';
import 'package:book_nest/repositories/reading_note_repository.dart';
import 'package:book_nest/services/reading_note_service.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeReadingNoteService extends ReadingNoteService {
  @override
  Future<List<ReadingNote>> getReadingNotes() async {
    return [];
  }

  @override
  Future<ReadingNote> addReadingNote(ReadingNote note) async {
    return note;
  }

  @override
  Future<ReadingNote> updateReadingNote(ReadingNote note) async {
    return note;
  }

  @override
  Future<void> deleteReadingNote(int id) async {}
}

void main() {
  testWidgets(
    'BookNest displays the Home screen and navigation',
    (WidgetTester tester) async {
      final service = FakeReadingNoteService();
      final repository = ReadingNoteRepository(service: service);

      await tester.pumpWidget(
        BookNestApp(
          readingNoteRepository: repository,
        ),
      );

      // Tunggu proses pemuatan awal selesai tanpa menunggu
      // animasi yang mungkin terus berjalan.
      await tester.pumpAndSettle();

      expect(find.text('BookNest'), findsOneWidget);
      expect(find.text('Jelajahi dunia buku'), findsOneWidget);

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Explore'), findsOneWidget);
      expect(find.text('My Library'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    },
  );
}
