import 'package:bloc/bloc.dart';
import 'package:doctor_booking_app/features/chat/data/disease_data.dart';
import 'package:doctor_booking_app/features/chat/data/recomendation_engine.dart';
import 'package:doctor_booking_app/features/chat/domain/models/chat_message.dart';
import 'package:doctor_booking_app/features/home/data/doctor_data.dart'
    as doc_data;
import 'package:doctor_booking_app/features/home/domain/models/doctor.dart';

import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  String? name;
  String? age;
  String? sex;
  String? complaint;
  List<String> symptoms = [];

  ChatBloc()
    : super(
        ChatState(
          messages: [
            ChatMessage(
              text: "Hi! I am your Health Assistant. What is your name?",
              time: _currentTime(),
              isMe: false,
            ),
          ],
          currentStep: "ask_name",
        ),
      ) {
    on<UserMessageSent>(_handleMessage);
  }

  static String _currentTime() {
    final now = DateTime.now();
    final hour = now.hour > 12
        ? now.hour - 12
        : (now.hour == 0 ? 12 : now.hour);
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? 'PM' : 'AM';
    return "$hour:$minute $period";
  }

  Future<void> _handleMessage(
    UserMessageSent event,
    Emitter<ChatState> emit,
  ) async {
    final userInput = event.message;

    final updatedMessages = List<ChatMessage>.from(state.messages)
      ..add(ChatMessage(text: userInput, time: _currentTime(), isMe: true));

    emit(state.copyWith(messages: updatedMessages, isTyping: true));

    // Simulate AI thinking
    await Future.delayed(const Duration(milliseconds: 800));

    String aiResponse = "";
    String nextStep = state.currentStep;

    switch (state.currentStep) {
      case "ask_name":
        name = userInput;
        aiResponse = "Nice to meet you, $name! Please enter your age.";
        nextStep = "ask_age";
        break;

      case "ask_age":
        age = userInput;
        aiResponse = "And what is your sex?";
        nextStep = "ask_sex";
        break;

      case "ask_sex":
        sex = userInput;
        aiResponse = "Got it. Now, what is your health concern today?";
        nextStep = "ask_complaint";
        break;

      case "ask_complaint":
        complaint = userInput;
        aiResponse = "I see. Please enter your symptoms separated by commas.";
        nextStep = "ask_symptoms";
        break;

      case "ask_symptoms":
        symptoms = userInput.split(",").map((e) => e.trim()).toList();

        final disease = RecommendationEngine.matchDisease(
          complaint!,
          symptoms,
          diseases,
        );

        Doctor? selectedDoctor;

        if (disease != null) {
          aiResponse =
              "Based on your symptoms, you might have ${disease.name}. I recommend consulting a ${disease.doctorType}.";

          updatedMessages.add(
            ChatMessage(text: aiResponse, time: _currentTime(), isMe: false),
          );

          // Find a matching doctor
          selectedDoctor = doc_data.doctors.firstWhere(
            (doc) => doc.specialty == disease.doctorType,
            orElse: () => doc_data.doctors.firstWhere(
              (doc) => doc.specialty == "General Physician",
            ),
          );

          updatedMessages.add(
            ChatMessage(
              text: "Here is a recommended doctor for you:",
              time: _currentTime(),
              isMe: false,
              type: MessageType.recommendation,
              recommendedDoctor: selectedDoctor,
            ),
          );

          aiResponse = ""; // Clear so we don't add another text message below
        } else {
          // Fallback logic
          aiResponse =
              "I couldn't identify a specific condition based on those symptoms. I recommend consulting a General Physician for a thorough check-up.";

          updatedMessages.add(
            ChatMessage(text: aiResponse, time: _currentTime(), isMe: false),
          );

          // Always pick General Physician for fallback
          selectedDoctor = doc_data.doctors.firstWhere(
            (doc) => doc.specialty == "General Physician",
            orElse: () => doc_data.doctors.first,
          );

          updatedMessages.add(
            ChatMessage(
              text: "I suggest you see this General Physician:",
              time: _currentTime(),
              isMe: false,
              type: MessageType.recommendation,
              recommendedDoctor: selectedDoctor,
            ),
          );

          aiResponse = "";
        }
        nextStep = "completed";

        // Emit recommendation to trigger navigation
        emit(
          state.copyWith(
            messages: updatedMessages,
            currentStep: nextStep,
            isTyping: false,
            recommendedDoctor: selectedDoctor,
          ),
        );
        return;

      case "completed":
        aiResponse =
            "I've already provided a recommendation. Is there anything else you'd like to ask about?";
        break;
    }

    if (aiResponse.isNotEmpty) {
      updatedMessages.add(
        ChatMessage(text: aiResponse, time: _currentTime(), isMe: false),
      );
    }

    emit(
      state.copyWith(
        messages: updatedMessages,
        currentStep: nextStep,
        isTyping: false,
      ),
    );
  }
}
