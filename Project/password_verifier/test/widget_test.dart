// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:password_verifier/main.dart';

void main() {
  testWidgets(
      'Given user in home page when textfield is pressed and "my passwords" is entered, expect 50%',
      (WidgetTester tester) async {
    // ASSEMBLE
    await tester.pumpWidget(MyApp());

    // Verify that our password strength starts at 0%.
    expect(find.text('0%'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    Finder texter = find.byType(TextFormField);

    // ACT
    await tester.tap(texter);
    await tester.enterText(texter, 'Password123@');
    await tester.pump();

    // ASSERT
    Finder texters = find.byType(Text).last;
    var o = texters.evaluate().single.widget as Text;
    // Verify that our password strength is 100% after input given.
    expect(o.data, '100%');
  });
}
