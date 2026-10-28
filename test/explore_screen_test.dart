import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:book_nest/models/book.dart';
import 'package:book_nest/providers/book_provider.dart';
import 'package:book_nest/repositories/book_repository.dart';
import 'package:book_nest/screens/explore_screen.dart';

class FakeBookRepository implements BookRepository {
  String? lastQuery;

  @override
  Future<List<Book>> searchBooks(String query) async {
    lastQuery = query;
    return [];
  }
}

void main() {
  late FakeBookRepository repository;
  late BookProvider provider;

  setUp(() {
    repository = FakeBookRepository();
    provider = BookProvider(repository: repository);
  });

  tearDown(() {
    provider.dispose();
  });

  Future<void> pumpExploreScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<BookProvider>.value(
        value: provider,
        child: const MaterialApp(
          home: ExploreScreen(),
        ),
      ),
    );
  }

  testWidgets('menampilkan tampilan awal Explore Books',
      (WidgetTester tester) async {
    await pumpExploreScreen(tester);

    expect(find.text('Explore Books'), findsOneWidget);
    expect(find.text('Temukan bacaan berikutnya.'), findsOneWidget);
    expect(find.text('Dunia buku menantimu'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('pencarian kosong menampilkan pesan buku tidak ditemukan',
      (WidgetTester tester) async {
    await pumpExploreScreen(tester);

    await tester.enterText(
      find.byType(TextField),
      'buku-yang-tidak-ada',
    );
    await tester.tap(find.byTooltip('Search books'));
    await tester.pumpAndSettle();

    expect(repository.lastQuery, 'buku-yang-tidak-ada');
    expect(find.text('Buku tidak ditemukan'), findsOneWidget);
  });
}
