import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:learnvocabulary/view_models/location_view_model.dart';
import 'package:learnvocabulary/view_models/quiz_view_model.dart';
import 'package:learnvocabulary/view_models/vocabulary_view_model.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'views/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LocationViewModel()..fetchLocations(),
        ),ChangeNotifierProvider(
          create: (_) => QuizViewModel()..fetchQuizzes(),
        ),ChangeNotifierProvider(
          create: (_) => VocabularyViewModel(),
        ),
      ],
      child: MaterialApp(
        title: 'Learn Vocabulary',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
