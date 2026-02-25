import 'package:flutter/material.dart';

class ChatInputArea extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  const ChatInputArea({
    super.key,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      child: Row(
        children: [
          _buildActionButton(Icons.add),
          const SizedBox(width: 8),
          _buildActionButton(Icons.attach_file),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 15),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          InkWell(
            onTap: onSend,
            child: Container(
              height: 48,
              width: 48,
              decoration: const BoxDecoration(
                color: Color(0xFF1D4ED8),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: const Color(0xFF64748B), size: 20),
    );
  }
}
