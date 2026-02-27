import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class BrandLogo extends StatelessWidget {
  final double size;
  const BrandLogo({super.key, this.size = 120});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.brandTeal.withAlpha(12),
        borderRadius: BorderRadius.circular(size * 0.2),
      ),
      padding: EdgeInsets.all(size * 0.1),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.brandTeal,
          borderRadius: BorderRadius.circular(size * 0.13),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.eco_outlined, color: Colors.greenAccent, size: 24),
                  Icon(Icons.eco, color: Colors.greenAccent, size: 24),
                ],
              ),
              Text(
                'HEALTHCARE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
