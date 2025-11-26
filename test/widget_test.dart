import 'package:flutter_test/flutter_test.dart';
import 'package:ride_guard/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const RideGuardApp());
    expect(find.byType(RideGuardApp), findsOneWidget);
  });
}