import 'package:doctor_booking_app/features/user/home/presentation/widgets/doctor_card.dart';
import 'package:flutter/material.dart';
import '../../domain/models/doctor.dart';
import '../widgets/all_doctors_app_bar.dart';
import '../widgets/all_doctors_search_bar.dart';
import '../widgets/specialty_chip_list.dart';

class AllDoctorsScreen extends StatelessWidget {
  const AllDoctorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final doctors = [
      Doctor(
        id: '4',
        name: 'Dr. Sophia Williams',
        specialty: 'Neurologist',
        hospital: 'City Clinic',
        rating: 4.9,
        reviews: 128,
        nextAvailable: 'Today',
        imagePath: 'assets/images/doctor_image_1.png',
        about:
            'Dr. Sophia Williams is a board-certified neurologist specializing in chronic headaches and brain health.',
        experience: '14 years',
        fee: 140.0,
      ),
      Doctor(
        id: '1',
        name: 'Dr. James Miller',
        specialty: 'Cardiologist',
        hospital: 'Heart Hospital',
        rating: 4.8,
        reviews: 94,
        nextAvailable: '10:30 AM',
        imagePath: 'assets/images/doctor_image_1.png',
        about:
            'Dr. James Miller offers comprehensive cardiac care with a focus on minimally invasive procedures.',
        experience: '16 years',
        fee: 130.0,
      ),
      Doctor(
        id: '2',
        name: 'Dr. Elena Rodriguez',
        specialty: 'Dermatologist',
        hospital: 'Smile Clinic',
        rating: 5.0,
        reviews: 215,
        nextAvailable: 'Tomorrow',
        imagePath: 'assets/images/doctor_image_1.png',
        about:
            'Dr. Elena Rodriguez is an expert in dermatology, treating a wide range of skin conditions with advanced therapies.',
        experience: '9 years',
        fee: 100.0,
      ),
      Doctor(
        id: '3',
        name: 'Dr. David Chen',
        specialty: 'Pediatrician',
        hospital: 'Vision Center',
        rating: 4.7,
        reviews: 156,
        nextAvailable: 'Oct 26',
        imagePath: 'assets/images/doctor_image_1.png',
        about:
            'Dr. David Chen provides compassionate pediatric care for children of all ages, from infants to adolescents.',
        experience: '8 years',
        fee: 95.0,
      ),
      Doctor(
        id: '5',
        name: 'Dr. Michael Ross',
        specialty: 'Orthopedic Surgeon',
        hospital: 'Central Hospital',
        rating: 4.6,
        reviews: 82,
        nextAvailable: 'Oct 27',
        imagePath: 'assets/images/doctor_image_1.png',
        about:
            'Dr. Michael Ross is a fellowship-trained orthopedic surgeon specializing in joint replacements and sports medicine.',
        experience: '18 years',
        fee: 160.0,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AllDoctorsAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            const AllDoctorsSearchBar(),
            const SizedBox(height: 20),
            const SpecialtyChipList(),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: doctors.length,
                padding: const EdgeInsets.only(bottom: 24),
                itemBuilder: (context, index) {
                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: Duration(milliseconds: 500 + (index * 100)),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 50 * (1 - value)),
                          child: child,
                        ),
                      );
                    },
                    child: DoctorCard(doctor: doctors[index],isDark: index % 2 != 0),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
