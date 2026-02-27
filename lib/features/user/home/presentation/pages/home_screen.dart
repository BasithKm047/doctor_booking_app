import 'dart:developer';

import 'package:doctor_booking_app/features/user/home/data/doctor_data.dart' as doc_data;
import 'package:doctor_booking_app/features/user/home/presentation/pages/medical_categories_screen.dart';
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../domain/models/doctor.dart';
import '../../domain/models/medical_category.dart';
import 'all_doctors_screen.dart';
import '../widgets/category_icon.dart';
import '../widgets/doctor_card.dart';
import '../widgets/home_app_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final medicalCategories = [
      MedicalCategory(
        title: 'Dental',
        icon: Icons.details,
        color: AppColors.medConnectPrimary,
      ),
      MedicalCategory(
        title: 'Cardiology',
        icon: Icons.favorite_outline,
        color: AppColors.medConnectPrimary,
      ),
      MedicalCategory(
        title: 'Lungs',
        icon: Icons.air,
        color: AppColors.medConnectPrimary,
      ),
      MedicalCategory(
        title: 'Brain',
        icon: Icons.psychology_outlined,
        color: AppColors.medConnectPrimary,
      ),
      MedicalCategory(
        title: 'Ear',
        icon: Icons.hearing_outlined,
        color: AppColors.medConnectPrimary,
      ),
      MedicalCategory(
        title: 'Optometry',
        icon: Icons.remove_red_eye_outlined,
        color: AppColors.medConnectPrimary,
      ),
    ];

    final doctors = doc_data.doctors;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const HomeAppBar(),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          _buildSearchBar(),
          const SizedBox(height: 24),
          _buildFilterSection(),
          const SizedBox(height: 32),
          _buildSectionHeader(
            'Categories',
            'See All',
            onAction: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const MedicalCategoriesScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          _buildCategoryGrid(medicalCategories),
          const SizedBox(height: 32),
          _buildSectionHeader(
            'Recommended Doctors',
            'View All',
            onAction: () {
              log('Navigating to AllDoctorsScreen');
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AllDoctorsScreen(),
      
                ),
              );
              log('AllDoctorsScreen');
            },
          ),
          const SizedBox(height: 20),
          _buildDoctorList(doctors),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const TextField(
          decoration: InputDecoration(
            hintText: 'Search condition, doctor...',
            hintStyle: TextStyle(color: Color(0xFF94A3B8)),
            icon: Icon(Icons.search, color: Color(0xFF94A3B8)),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: _buildFilterItem(
              Icons.location_on,
              'New York, NY',
              'Location',
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildFilterItem(
              Icons.calendar_today,
              'Oct 24, 2023',
              'Date',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterItem(IconData icon, String text, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.medConnectPrimary, size: 18),
              const SizedBox(width: 8),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(
    String title,
    String action, {
    VoidCallback? onAction,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onAction,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  action,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.medConnectPrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid(List<MedicalCategory> categories) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        mainAxisSpacing: 24,
        crossAxisSpacing: 16,
        childAspectRatio: 0.9,
        children: categories.map((cat) => CategoryIcon(category: cat)).toList(),
      ),
    );
  }

  Widget _buildDoctorList(List<Doctor> doctors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          return DoctorCard(doctor: doctors[index], isDark: index % 2 != 0);
        },
      ),
    );
  }
}
