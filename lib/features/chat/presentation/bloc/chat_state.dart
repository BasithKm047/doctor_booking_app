import '../../domain/models/chat_message.dart';
import '../../../home/domain/models/doctor.dart';

class ChatState {
  final List<ChatMessage> messages;
  final String currentStep;
  final bool isTyping;
  final Doctor? recommendedDoctor;

  ChatState({
    required this.messages,
    required this.currentStep,
    this.isTyping = false,
    this.recommendedDoctor,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    String? currentStep,
    bool? isTyping,
    Doctor? recommendedDoctor,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      currentStep: currentStep ?? this.currentStep,
      isTyping: isTyping ?? this.isTyping,
      recommendedDoctor: recommendedDoctor ?? this.recommendedDoctor,
    );
  }
}
