import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:consultarviacep/screens/home_screen.dart';

void main() {
  testWidgets('Testa a HomeScreen', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: HomeScreen()));

    expect(find.text('Consulta CEP ViaCEP'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);

    await tester.enterText(find.byType(TextField), '01311000');

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

  });
}