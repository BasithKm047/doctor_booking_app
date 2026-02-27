import 'package:flutter/material.dart';

class AllDoctorsSearchBar extends StatelessWidget {
  const AllDoctorsSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: 'Search name, specialty, or clinic...',
          hintStyle: TextStyle(color: Color(0xFF94A3B8)),
          icon: Icon(Icons.search, color: Color(0xFF94A3B8)),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
