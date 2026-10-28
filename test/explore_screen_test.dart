import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:book_nest/models/book.dart';
import 'package:book_nest/providers/book_provider.dart';
import 'package:book_nest/repositories/book_repository.dart';
import 'package:book_nest/screens/explore_screen.dart';

class FakeBookRepository implements BookRepository {
  String? lastQuery;
  bool shouldFail = false;
  Completer<List<Book>>? completer;

  @override
  Future<List<Book>> searchBooks(String query) async {
    lastQuery = query;

    if (completer != null) {
      return completer!.future;
    }

    if (shouldFail) {
      throw Exception('Network error');
    }

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

  Future<void> searchFor(
    WidgetTester tester,
    String query,
  ) async {
    await tester.enterText(find.byType(TextField), query);
    await tester.tap(find.byTooltip('Search books'));
  }

  testWidgets('menampilkan tampilan awal Explore Books',
      (WidgetTester tester) async {
    await pumpExploreScreen(tester);

    expect(find.text('Explore Books'), findsOneWidget);
    expect(find.text('Temukan bacaan berikutnya.'), findsOneWidget);
    expect(find.text('Dunia buku menantimu'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('pencarian tanpa hasil menampilkan pesan yang sesuai',
      (WidgetTester tester) async {
    await pumpExploreScreen(tester);

    await searchFor(tester, 'buku-yang-tidak-ada');
    await tester.pumpAndSettle();

    expect(repository.lastQuery, 'buku-yang-tidak-ada');
    expect(find.text('Buku tidak ditemukan'), findsOneWidget);
  });

  testWidgets('menampilkan indikator ketika pencarian sedang berlangsung',
      (WidgetTester tester) async {
    repository.completer = Completer<List<Book>>();

    await pumpExploreScreen(tester);
    await searchFor(tester, 'flutter');
    await tester.pump();

    expect(provider.status, BookStatus.loading);
    expect(find.text('Sedang mencari buku...'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    repository.completer!.complete([]);
    await tester.pumpAndSettle();

    expect(provider.status, BookStatus.success);
  });

  testWidgets('menampilkan pesan error ketika pencarian gagal',
      (WidgetTester tester) async {
    repository.shouldFail = true;

    await pumpExploreScreen(tester);
    await searchFor(tester, 'flutter');
    await tester.pumpAndSettle();

    expect(provider.status, BookStatus.error);
    expect(find.text('Buku belum bisa dimuat'), findsOneWidget);
    expect(find.text('Coba Lagi'), findsOneWidget);
  });
}
