import 'package:doctor_booking_app/features/home/presentation/widgets/doctor_card.dart';
import 'package:doctor_booking_app/features/chat/domain/models/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:doctor_booking_app/core/theme/app_colors.dart';

class ChatMessageBubble extends StatefulWidget {
  final ChatMessage message;
  const ChatMessageBubble({super.key, required this.message});

  @override
  State<ChatMessageBubble> createState() => _ChatMessageBubbleState();
}

class _ChatMessageBubbleState extends State<ChatMessageBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMe = widget.message.isMe;
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _offsetAnimation,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Row(
            mainAxisAlignment: isMe
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isMe) ...[
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: Color(0xFFE0E7FF),
                  child: Icon(
                    Icons.smart_toy_outlined,
                    color: AppColors.medConnectPrimary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
              ],
              Flexible(
                child: Column(
                  crossAxisAlignment: isMe
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    if (widget.message.type == MessageType.file)
                      _buildFileCard(widget.message)
                    else if (widget.message.type == MessageType.recommendation)
                      _buildRecommendationCard(widget.message)
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: isMe
                              ? AppColors.medConnectPrimary
                              : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(24),
                            topRight: const Radius.circular(24),
                            bottomLeft: Radius.circular(isMe ? 24 : 4),
                            bottomRight: Radius.circular(isMe ? 4 : 24),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          widget.message.text,
                          style: TextStyle(
                            color: isMe
                                ? Colors.white
                                : const Color(0xFF334155),
                            fontSize: 15,
                            height: 1.5,
                          ),
                        ),
                      ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.message.time,
                          style: const TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (isMe) ...[
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.done_all,
                            color: AppColors.medConnectPrimary,
                            size: 14,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              if (isMe) const SizedBox(width: 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendationCard(ChatMessage message) {
    if (message.recommendedDoctor == null) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            message.text,
            style: const TextStyle(
              color: Color(0xFF475569),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        DoctorCard(doctor: message.recommendedDoctor!),
      ],
    );
  }

  Widget _buildFileCard(ChatMessage message) {
    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: Container(
              height: 120,
              width: double.infinity,
              color: const Color(0xFFE0E7FF),
              child: const Icon(
                Icons.insert_drive_file_outlined,
                size: 48,
                color: AppColors.medConnectPrimary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.medConnectPrimary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.description,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message.attachmentName ?? "File",
                    style: const TextStyle(
                      color: Color(0xFF1E293B),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(
                  Icons.file_download_outlined,
                  color: Color(0xFF64748B),
                  size: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
