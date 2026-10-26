
import 'package:book_nest/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('BookNest displays the Home screen and navigation', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const BookNestApp());

    expect(find.text('BookNest'), findsOneWidget);
    expect(find.text('YOUR PERSONAL BOOKSPACE'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('My Library'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });
}
