import 'package:flutter/material.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onBack;
  const ChatAppBar({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF64748B)),
        onPressed: onBack,
      ),
      title: Row(
        children: [
          Stack(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundColor: Color(0xFFE0E7FF),
                child: Icon(
                  Icons.smart_toy_rounded,
                  color: Color(0xFF4F46E5),
                  size: 24,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  height: 12,
                  width: 12,
                  decoration: BoxDecoration(
                    color: const Color(0xFF22C55E),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AI Health Assistant',
                style: TextStyle(
                  color: Color(0xFF1E293B),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Always active',
                style: TextStyle(
                  color: Color(0xFF4F46E5),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: const Color(0xFFF1F5F9), height: 1),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);
}
