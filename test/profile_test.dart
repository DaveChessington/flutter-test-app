import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/profile.dart';

void main() {
  testWidgets('Profile can be rendered without a user', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Profile()));

    expect(find.text('Profile Info'), findsOneWidget);
  });
}
