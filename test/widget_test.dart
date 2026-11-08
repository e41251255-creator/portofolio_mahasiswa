import 'package:flutter_test/flutter_test.dart';
import 'package:portofolio_ilma/main.dart';

void main() {
  testWidgets('Portfolio app test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('My Portfolio'), findsOneWidget);
    expect(find.text('Beranda'), findsOneWidget);
    expect(find.text('Profil'), findsOneWidget);
    expect(find.text('Portofolio'), findsOneWidget);
    expect(find.text('Pengaturan'), findsOneWidget);
  });
}
