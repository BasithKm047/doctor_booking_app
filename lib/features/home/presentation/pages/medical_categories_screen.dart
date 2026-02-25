import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/medical_category.dart';

class MedicalCategoriesScreen extends StatelessWidget {
  const MedicalCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      MedicalCategory(
        title: 'Dental',
        description: 'Oral Health',
        icon: Icons.health_and_safety,
        color: AppColors.medConnectPrimary,
      ),
      MedicalCategory(
        title: 'Cardio',
        description: 'Heart Care',
        icon: Icons.favorite,
        color: AppColors.medConnectPrimary,
      ),
      MedicalCategory(
        title: 'Eye Care',
        description: 'Vision Specialist',
        icon: Icons.remove_red_eye,
        color: AppColors.medConnectPrimary,
      ),
      MedicalCategory(
        title: 'Brain',
        description: 'Neurology',
        icon: Icons.psychology,
        color: AppColors.medConnectPrimary,
      ),
      MedicalCategory(
        title: 'Skin',
        description: 'Dermatology',
        icon: Icons.spa,
        color: AppColors.medConnectPrimary,
      ),
      MedicalCategory(
        title: 'Kids',
        description: 'Pediatrics',
        icon: Icons.child_care,
        color: AppColors.medConnectPrimary,
      ),
      MedicalCategory(
        title: 'Physio',
        description: 'Therapy',
        icon: Icons.fitness_center,
        color: AppColors.medConnectPrimary,
      ),
      MedicalCategory(
        title: 'Others',
        description: 'General Care',
        icon: Icons.more_horiz,
        color: AppColors.medConnectPrimary,
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Medical Categories',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF1E293B)),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Find your specialist',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Select a category to browse available doctors and healthcare providers.',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF64748B),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.9,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return _buildCategoryCard(categories[index]);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(MedicalCategory category) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: category.color.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(category.icon, color: category.color, size: 28),
          ),
          const SizedBox(height: 16),
          Text(
            category.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            category.description ?? '',
            style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
          ),
        ],
      ),
    );
  }
}
