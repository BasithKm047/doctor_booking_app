import 'package:flutter/material.dart';

class BrandHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const BrandHeader({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        Text(
          title,
          style: theme.textTheme.headlineMedium?.copyWith(
            color: isDark ? Colors.white : const Color(0xFF0F172A),
            fontWeight: FontWeight.w800,
            fontSize: 40,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: isDark ? Colors.white70 : const Color(0xFF475569),
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
