import 'package:flutter/material.dart';

import 'app/app.dart';
import 'core/demo_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final store = await DemoStore.load();
  runApp(SafeLabApp(store: store));
}
