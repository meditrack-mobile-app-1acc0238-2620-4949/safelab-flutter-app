import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safelab_flutter_app/app/app.dart';
import 'package:safelab_flutter_app/core/demo_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Manager can enter offline demo and navigate the dashboard', (tester) async {
    final store = await DemoStore.load();
    await tester.pumpWidget(SafeLabApp(store: store));
    await tester.enterText(find.byKey(const Key('loginIdentifier')), 'gerente.andes@safelab.test');
    await tester.enterText(find.byKey(const Key('loginPassword')), 'not-a-real-password');
    await tester.ensureVisible(find.byKey(const Key('signInButton')));
    await tester.tap(find.byKey(const Key('signInButton')));
    await tester.pumpAndSettle();

    expect(find.text('Dashboard'), findsWidgets);
    expect(find.text('Laboratorios Andinos S.A.C.'), findsWidgets);
    expect(find.byIcon(Icons.sensors_rounded), findsWidgets);
  });
}
