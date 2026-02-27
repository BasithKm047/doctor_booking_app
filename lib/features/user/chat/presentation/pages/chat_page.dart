import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/chat_app_bar.dart';
import '../widgets/chat_input_area.dart';
import '../widgets/chat_message_bubble.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_state.dart';
import '../bloc/chat_event.dart';
import 'recommendation_result_screen.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: ChatAppBar(onBack: () => Navigator.pop(context)),
        body: BlocListener<ChatBloc, ChatState>(
          listener: (context, state) {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) => _scrollToBottom(),
            );

            if (state.recommendedDoctor != null) {
              Future.delayed(const Duration(seconds: 2), () {
                if (mounted) {
                  Navigator.push(
                    // ignore: use_build_context_synchronously
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecommendationResultScreen(
                        doctor: state.recommendedDoctor!,
                      ),
                    ),
                  );
                }
              });
            }
          },
          child: BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                      itemCount:
                          state.messages.length + (state.isTyping ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == state.messages.length && state.isTyping) {
                          return _buildTypingIndicator();
                        }
                        return ChatMessageBubble(
                          message: state.messages[index],
                        );
                      },
                    ),
                  ),
                  ChatInputArea(
                    controller: _messageController,
                    onSend: () {
                      final text = _messageController.text.trim();
                      if (text.isNotEmpty) {
                        context.read<ChatBloc>().add(UserMessageSent(text));
                        _messageController.clear();
                      }
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xFFE0E7FF),
            child: Icon(
              Icons.smart_toy_outlined,
              color: Color(0xFF4F46E5),
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "Thinking...",
              style: TextStyle(
                color: Color(0xFF64748B),
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
