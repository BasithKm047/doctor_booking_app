import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppLoadingIndicator extends StatelessWidget {
  final double progress;
  final double height;
  final double horizontalPadding;

  const AppLoadingIndicator({
    super.key,
    required this.progress,
    this.height = 6.0,
    this.horizontalPadding = 64.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: progress,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.brandBlue,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
