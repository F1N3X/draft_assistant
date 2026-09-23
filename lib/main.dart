import 'package:flutter/material.dart';
import 'package:draft_assistant/src/router/app_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';
import 'package:draft_assistant/src/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    providerAndroid: kDebugMode
        ? AndroidDebugProvider()
        : AndroidPlayIntegrityProvider(),
  );
  // final model = FirebaseAI.googleAI().generativeModel(model: 'gemini-3.5-flash');
  // final prompt = [Content.text('Say hi.')];
  // final response = await model.generateContent(prompt);
  // print(response.text);
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: AppTheme.theme,
    );
  }
}
