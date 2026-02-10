import 'package:flutter_test/flutter_test.dart';
import 'package:campus_directory_week3/main.dart';

void main() {
  testWidgets('App loads without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const CampusDirectoryApp());

    // Check that the home screen title appears
    expect(find.text('VVU Campus Directory'), findsOneWidget);
  });
}
