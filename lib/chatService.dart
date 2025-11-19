import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatService {
  static final ChatService _instance = ChatService._internal();
  factory ChatService() => _instance;
  ChatService._internal();

  final model = GenerativeModel(
    model :  dotenv.env['MODEL'].toString(),
    apiKey: dotenv.env['API_KEY'].toString()
  );

  Future<String> chatResponse(String userMessage) async {
  final prompt = Content.text("""
You are 'SoulBot', a friendly AI companion. Respond like a real friend:
- Mirror the user's emotion (happy, sad, angry, funny, sarcastic, excited).
- Use short, 1–2 sentence responses, easy to read.
- Add humor or emojis if it fits the mood.
- If the user is rude, respond playfully or sarcastically.
- If the user is sad, comfort them warmly.
- If the user is happy, celebrate with them.-
- If the user is funny, respond with humor and emojis 😆
User said: "$userMessage"
""");

    final response = await model.generateContent([prompt]);
    return response.text ?? "No response 🤖";
  }
}
