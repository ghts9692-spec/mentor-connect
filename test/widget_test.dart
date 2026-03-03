import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memtor_connect/main.dart';
import 'package:memtor_connect/constants/strings.dart';

void main() {
  testWidgets('Splash screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MentorConnectApp()));
    // Let animations start
    await tester.pump();
    // Verify core splash content renders
    expect(find.text(AppStrings.appName), findsOneWidget);
    expect(find.text(AppStrings.tagline), findsOneWidget);
    expect(find.text(AppStrings.version), findsOneWidget);
  });
}
