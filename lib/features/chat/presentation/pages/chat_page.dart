import 'package:doctor_booking_app/features/chat/domain/models/chat_message.dart';
import 'package:flutter/material.dart';
import '../widgets/chat_app_bar.dart';
import '../widgets/chat_input_area.dart';
import '../widgets/chat_message_bubble.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [
    ChatMessage(
      text:
          "Hello! I've reviewed your latest lab results. Everything looks normal. How are you feeling today?",
      time: '10:24 AM',
      isMe: false,
    ),
    ChatMessage(
      text:
          "That's great to hear! I've been feeling much better, but I have a quick question about the medication dosage.",
      time: '10:26 AM',
      isMe: true,
    ),
    ChatMessage(
      text:
          "Of course. Please refer to this updated schedule I've attached. We should maintain the current dose for another week.",
      time: '10:30 AM',
      isMe: false,
    ),
    ChatMessage(
      text: "Medication_Schedule.pdf",
      time: '10:30 AM',
      isMe: false,
      type: MessageType.file,
      attachmentName: "Medication_Schedule.pdf",
    ),
    ChatMessage(
      text: "Understood. I'll follow this schedule. Thank you, Doctor!",
      time: '10:32 AM',
      isMe: true,
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    // Basic send logic for UI demonstration
    if (_messageController.text.isNotEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Message sent!')));
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ChatAppBar(onBack: () => Navigator.pop(context)),
      body: Column(
        children: [
          const SizedBox(height: 12),
          _buildDateDivider('TODAY'),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ChatMessageBubble(message: _messages[index]);
              },
            ),
          ),
          ChatInputArea(controller: _messageController, onSend: _sendMessage),
        ],
      ),
    );
  }

  Widget _buildDateDivider(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF94A3B8),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
