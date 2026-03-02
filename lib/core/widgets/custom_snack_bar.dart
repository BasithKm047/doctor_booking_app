import 'package:doctor_booking_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomSnackBar {
  static void show(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    scaffoldMessenger.hideCurrentSnackBar();

    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              // Icon(
              //   isError ? Icons.error_outline : Icons.check_circle_outline,
              //   color: Colors.white,
              //   size: 28,
              // ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: isError
            ? Colors.red.shade600
            : AppColors.medConnectPrimary,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        duration: const Duration(seconds: 3),
        elevation: 6,
      ),
    );
  }
}
