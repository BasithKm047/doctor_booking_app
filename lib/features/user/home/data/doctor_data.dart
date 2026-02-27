import '../domain/models/doctor.dart';

final List<Doctor> doctors = [
  Doctor(
    id: '1',
    name: 'Dr. James Robinson',
    specialty: 'General Physician',
    hospital: 'Heart Hospital',
    rating: 4.8,
    reviews: 120,
    nextAvailable: '10:30 AM',
    imagePath: 'assets/images/doctor_image_1.png',
    about:
        'Dr. James Robinson is a renowned general physician with extensive experience in preventive care.',
    experience: '15 years',
    fee: 120.0,
    availabilitySlots: 4,
  ),
  Doctor(
    id: '2',
    name: 'Dr. Sarah Jenkins',
    specialty: 'General Physician',
    hospital: 'Smile Clinic',
    rating: 4.9,
    reviews: 85,
    nextAvailable: 'Tomorrow',
    imagePath: 'assets/images/doctor_image_1.png',
    about:
        'Dr. Sarah Jenkins specializes in general medicine with a focus on patient comfort.',
    experience: '10 years',
    fee: 80.0,
    availabilitySlots: 7,
  ),
  Doctor(
    id: '3',
    name: 'Dr. Michael Chen',
    specialty: 'Gastroenterologist',
    hospital: 'Vision Center',
    rating: 4.7,
    reviews: 210,
    nextAvailable: 'Oct 26',
    imagePath: 'assets/images/doctor_image_1.png',
    about:
        'Dr. Michael Chen is a leading expert in gastroenterology, providing advanced treatments for digestive health.',
    experience: '12 years',
    fee: 110.0,
    availabilitySlots: 5,
  ),
];
