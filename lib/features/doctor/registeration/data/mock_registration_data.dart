class MockRegistrationData {
  static const List<String> specialties = [
    'Cardiologist',
    'Dermatologist',
    'Neurologist',
    'Pediatrician',
    'General Practitioner',
    'Surgeon',
    'Psychiatrist',
    'Orthopedic',
  ];

  static const List<String> genders = ['Male', 'Female', 'Other'];

  static List<int> get graduationYears {
    final currentYear = DateTime.now().year;
    return List.generate(40, (index) => currentYear - index);
  }
}
