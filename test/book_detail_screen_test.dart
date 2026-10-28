import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:book_nest/models/book.dart';
import 'package:book_nest/screens/book_detail_screen.dart';

void main() {
  const book = Book(
    id: '/works/OL123W',
    title: 'Flutter for Beginners',
    authors: ['A. Writer'],
    firstPublishYear: 2024,
    editionKey: 'OL456M',
  );

  Future<void> pumpDetailScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: BookDetailScreen(book: book),
      ),
    );
  }

  testWidgets('menampilkan judul dan informasi utama buku',
      (WidgetTester tester) async {
    await pumpDetailScreen(tester);

    expect(find.text('Book Details'), findsOneWidget);
    expect(find.text('Flutter for Beginners'), findsOneWidget);
    expect(find.text('A. Writer'), findsNWidgets(2));
    expect(find.text('2024'), findsNWidgets(2));
    expect(find.text('BOOK DETAILS'), findsOneWidget);
  });

  testWidgets('menampilkan informasi detail buku',
      (WidgetTester tester) async {
    await pumpDetailScreen(tester);

    expect(find.text('Book information'), findsOneWidget);
    expect(find.text('Author'), findsOneWidget);
    expect(find.text('First publication'), findsOneWidget);
    expect(find.text('Book ID'), findsOneWidget);
    expect(find.text('/works/OL123W'), findsOneWidget);
    expect(find.text('Edition key'), findsOneWidget);
    expect(find.text('OL456M'), findsOneWidget);
  });

  testWidgets('tombol kembali membawa pengguna ke halaman sebelumnya',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => const BookDetailScreen(book: book),
                    ),
                  );
                },
                child: const Text('Open detail'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open detail'));
    await tester.pumpAndSettle();

    expect(find.text('Book Details'), findsOneWidget);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    expect(find.text('Open detail'), findsOneWidget);
    expect(find.text('Book Details'), findsNothing);
  });

  testWidgets('menampilkan fallback jika tahun dan ID tidak tersedia',
      (WidgetTester tester) async {
    const bookWithoutMetadata = Book(
      id: '',
      title: 'Unknown Publication',
      authors: [],
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: BookDetailScreen(book: bookWithoutMetadata),
      ),
    );

    expect(find.text('Unknown Publication'), findsOneWidget);
    expect(find.text('Unknown author'), findsNWidgets(2));
    expect(find.text('Year unavailable'), findsOneWidget);
    expect(find.text('Not available'), findsNWidgets(2));
  });
}

