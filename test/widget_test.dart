import 'package:flutter_test/flutter_test.dart';
import 'package:career_pulse/app.dart';

void main() {
  testWidgets('CareerPulseApp initializes and renders successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const CareerPulseApp());
    // Advance beyond splash screen delay
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pumpAndSettle();

    expect(find.byType(CareerPulseApp), findsOneWidget);
  });
}
