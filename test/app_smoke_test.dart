import 'package:flutter_test/flutter_test.dart';
import 'package:poke_guess_head_2_head/main.dart';

void main() {
  testWidgets('App loads and shows welcome screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    // Look for a widget that should always be on your welcome screen
    expect(find.text('Create Game'), findsOneWidget);
    expect(find.text('Join Game'), findsOneWidget);
  });
}
