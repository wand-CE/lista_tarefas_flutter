import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'AppRoutes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'YOUR-APP-URL-HERE',
    anonKey: 'YOUR-KEY-HERE',
  );

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.loginPage,
      routes: AppRoutes.define(),
    ),
  );
}

final supabase = Supabase.instance.client;
