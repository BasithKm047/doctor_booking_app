import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppPrimaryButton extends StatelessWidget {
  final double width;

  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color foregroundColor;
  final double height;
  final double borderRadius;
  final Widget? child;

  const AppPrimaryButton({
    this.width = double.infinity,
    super.key,

    required this.text,
    this.onPressed,
    this.icon,
    this.backgroundColor,
    this.foregroundColor = Colors.white,
    this.child,
    this.height = 56.0,
    this.borderRadius = 15,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor =
        backgroundColor ?? AppColors.medConnectPrimary;

    return SizedBox(
      width: width,
      height: height,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: effectiveBackgroundColor,
            foregroundColor: foregroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            elevation: 4,
            shadowColor: effectiveBackgroundColor.withAlpha(80),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (icon != null) ...[const SizedBox(width: 8), Icon(icon)],
            ],
          ),
        ),
      ),
    );
  }
}
