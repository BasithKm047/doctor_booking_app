enum MessageType { text, image, file }

class ChatMessage {
  final String text;
  final String time;
  final bool isMe;
  final MessageType type;
  final String? attachmentName;
  final String? attachmentPath;

  ChatMessage({
    required this.text,
    required this.time,
    required this.isMe,
    this.type = MessageType.text,
    this.attachmentName,
    this.attachmentPath,
  });
}
