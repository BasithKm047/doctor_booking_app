import 'package:doctor_booking_app/features/home/presentation/pages/medical_categories_screen.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/doctor.dart';
import '../../domain/models/medical_category.dart';
import '../pages/all_doctors_screen.dart';
import '../widgets/category_icon.dart';
import '../widgets/doctor_card.dart';
import '../widgets/home_app_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      MedicalCategory(
        title: 'Dental',
        icon: Icons.health_and_safety,
        color: AppColors.medConnectPrimary,
      ),
      MedicalCategory(
        title: 'Cardio',
        icon: Icons.favorite,
        color: AppColors.medConnectPrimary,
      ),
      MedicalCategory(
        title: 'Eye Care',
        icon: Icons.remove_red_eye,
        color: AppColors.medConnectPrimary,
      ),
      MedicalCategory(
        title: 'Brain',
        icon: Icons.psychology,
        color: AppColors.medConnectPrimary,
      ),
      MedicalCategory(
        title: 'Skin',
        icon: Icons.spa,
        color: AppColors.medConnectPrimary,
      ),
      MedicalCategory(
        title: 'Kids',
        icon: Icons.child_care,
        color: AppColors.medConnectPrimary,
      ),
      MedicalCategory(
        title: 'Physio',
        icon: Icons.fitness_center,
        color: AppColors.medConnectPrimary,
      ),
      MedicalCategory(
        title: 'Others',
        icon: Icons.more_horiz,
        color: AppColors.medConnectPrimary,
      ),
    ];

    final doctors = [
      Doctor(
        id: '1',
        name: 'Dr. James Robinson',
        specialty: 'Cardiologist',
        hospital: 'Heart Hospital',
        rating: 4.8,
        reviews: 120,
        nextAvailable: '10:30 AM',
        imagePath: 'assets/images/doctor_image_1.png',
        about:
            'Dr. James Robinson is a renowned cardiologist with extensive experience in heart surgery and preventive care.',
        experience: '15 years',
        fee: 120.0,
        isFavorite: true,
      ),
      Doctor(
        id: '2',
        name: 'Dr. Sarah Jenkins',
        specialty: 'Dentist',
        hospital: 'Smile Clinic',
        rating: 4.9,
        reviews: 85,
        nextAvailable: 'Tomorrow',
        imagePath: 'assets/images/doctor_image_1.png',
        about:
            'Dr. Sarah Jenkins specializes in restorative and cosmetic dentistry with a focus on patient comfort.',
        experience: '10 years',
        fee: 80.0,
      ),
      Doctor(
        id: '3',
        name: 'Dr. Michael Chen',
        specialty: 'Eye Specialist',
        hospital: 'Vision Center',
        rating: 4.7,
        reviews: 210,
        nextAvailable: 'Oct 26',
        imagePath: 'assets/images/doctor_image_1.png',
        about:
            'Dr. Michael Chen is a leading expert in ophthalmology, providing advanced treatments for vision health.',
        experience: '12 years',
        fee: 110.0,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const HomeAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            _buildCategoryGrid(categories),
            const SizedBox(height: 32),
            _buildSectionHeader(
              'Recommended Doctors',
              'View All',
              onAction: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AllDoctorsScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildDoctorList(doctors),
            const SizedBox(height: 24),
          ],
        ),
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
          GestureDetector(
            onTap: onAction,
            child: Text(
              action,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.medConnectPrimary,
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
        crossAxisCount: 4,
        mainAxisSpacing: 20,
        crossAxisSpacing: 16,
        childAspectRatio: 0.8,
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
          return DoctorCard(doctor: doctors[index]);
        },
      ),
    );
  }
}
