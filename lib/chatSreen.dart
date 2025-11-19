import 'package:chatbot/chatService.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> messages = [];
  bool isTyping = false;

  void sendMessage() async {
    String text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add({"msg": text, "me": true});
      isTyping = true;
    });

    _controller.clear();
    _scrollToBottom();

    String reply = await ChatService().chatResponse(text);

    setState(() {
      messages.add({"msg": reply, "me": false});
      isTyping = false;
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("AI Assistant 🤖"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(12),
                itemCount: messages.length,
                itemBuilder: (context, i) {
                  bool me = messages[i]["me"];
                  return Align(
                    alignment: me
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: me
                            ? Colors.deepPurpleAccent
                            : Colors.grey.shade900,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(18),
                          topRight: const Radius.circular(18),
                          bottomLeft: me
                              ? const Radius.circular(18)
                              : const Radius.circular(2),
                          bottomRight: me
                              ? const Radius.circular(2)
                              : const Radius.circular(18),
                        ),
                      ),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75,
                      ),
                      child: Text(
                        messages[i]["msg"],
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            if (isTyping) _typingIndicator(),

            _buildChatInput(),
          ],
        ),
      ),
    );
  }

  Widget _typingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 10,
            backgroundColor: Colors.deepPurple,
          ),
          const SizedBox(width: 6),
          SizedBox(
            height: 15,
            child: Row(
              children: [
                _dot(),
                _dot(delay: 200),
                _dot(delay: 400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot({int delay = 0}) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 900),
      curve: Curves.easeInOut,
      tween: Tween(begin: 0.3, end: 1.0),
      onEnd: () {},
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Container(
              width: 7,
              height: 7,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildChatInput() {
    return Container(
      padding: EdgeInsets.only(
        left: 8,
        right: 8,
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
      color: Colors.black,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Ask something...",
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.grey.shade900,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: sendMessage,
            child: const CircleAvatar(
              backgroundColor: Colors.deepPurple,
              child: Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
