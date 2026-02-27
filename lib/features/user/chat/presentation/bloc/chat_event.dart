abstract class ChatEvent {}

class StartChat extends ChatEvent {}

class UserMessageSent extends ChatEvent {
  final String message;

  UserMessageSent(this.message);
}