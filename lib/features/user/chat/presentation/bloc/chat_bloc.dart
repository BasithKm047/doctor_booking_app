import 'package:bloc/bloc.dart';
import 'package:doctor_booking_app/features/user/chat/data/disease_data.dart'
    as disease_data;
import 'package:doctor_booking_app/features/user/chat/data/recomendation_engine.dart';
import 'package:doctor_booking_app/features/user/chat/domain/models/chat_message.dart';
import 'package:doctor_booking_app/features/user/home/domain/entities/user_doctor_entity.dart';
import 'package:doctor_booking_app/features/user/home/domain/usecases/get_user_doctors.dart';

import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetUserDoctors getUserDoctors;
  String? name;
  String? age;
  String? sex;
  String? complaint;
  List<String> symptomsList = [];

  ChatBloc({required this.getUserDoctors})
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
    on<StartChat>(_resetChat);
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

  void _resetChat(StartChat event, Emitter<ChatState> emit) {
    name = null;
    age = null;
    sex = null;
    complaint = null;
    symptomsList = [];
    emit(
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
    );
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
    UserDoctorEntity? selectedDoctor;

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
        symptomsList = userInput.split(",").map((e) => e.trim()).toList();

        final disease = RecommendationEngine.matchDisease(
          complaint!,
          symptomsList,
          disease_data.diseases,
        );

        if (disease != null) {
          aiResponse =
              "Based on your symptoms, I recommend seeing a ${disease.doctorType}.";

          // Fetch real doctors from repository
          final doctors = await getUserDoctors();
          UserDoctorEntity? matchedDoc;

          if (doctors.isNotEmpty) {
            // Try to find matching specialty
            try {
              matchedDoc = doctors.firstWhere(
                (doc) => doc.specialization.toLowerCase().contains(
                  disease.doctorType.toLowerCase(),
                ),
              );
            } catch (_) {
              // Fallback to General Physician or first available
              try {
                matchedDoc = doctors.firstWhere(
                  (doc) => doc.specialization.toLowerCase().contains('general'),
                );
              } catch (_) {
                matchedDoc = doctors.first;
              }
            }
          }

          selectedDoctor = matchedDoc;
        } else {
          aiResponse =
              "I'm not entirely sure, but a General Physician can help with an initial diagnosis.";

          final doctors = await getUserDoctors();
          UserDoctorEntity? fallbackDoc;

          if (doctors.isNotEmpty) {
            try {
              fallbackDoc = doctors.firstWhere(
                (doc) => doc.specialization.toLowerCase().contains('general'),
              );
            } catch (_) {
              fallbackDoc = doctors.first;
            }
          }
          selectedDoctor = fallbackDoc;
        }
        nextStep = "completed";
        break;

      case "completed":
        aiResponse =
            "I've already provided a recommendation. Feel free to restart chat if you have more concerns.";
        break;
    }

    if (aiResponse.isNotEmpty) {
      updatedMessages.add(
        ChatMessage(
          text: aiResponse,
          time: _currentTime(),
          isMe: false,
          type: selectedDoctor != null
              ? MessageType.recommendation
              : MessageType.text,
          recommendedDoctor: selectedDoctor,
        ),
      );
    }

    emit(
      state.copyWith(
        messages: updatedMessages,
        currentStep: nextStep,
        isTyping: false,
        recommendedDoctor: selectedDoctor,
      ),
    );
  }
}
