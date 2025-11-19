import 'package:chatbot/chatSreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


Future<void> main() async {
  // Ensure Flutter bindings
  WidgetsFlutterBinding.ensureInitialized();

  // Load the .env file
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ChatScreen(),
    );
  }
}
