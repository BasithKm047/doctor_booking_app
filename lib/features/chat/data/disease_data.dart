import 'disease_model.dart';

final List<Disease> diseases = [
  Disease(
    id: "D1",
    name: "Fever",
    symptoms: [
      "Body heat",
      "Headache",
      "Chills",
      "Weakness",
      "Body pain"
    ],
    doctorType: "General Physician",
  ),
  Disease(
    id: "D2",
    name: "Common Cold",
    symptoms: [
      "Runny nose",
      "Sneezing",
      "Sore throat",
      "Mild cough"
    ],
    doctorType: "General Physician",
  ),
  Disease(
    id: "D3",
    name: "Stomach Upset",
    symptoms: [
      "Abdominal pain",
      "Vomiting",
      "Diarrhea",
      "Nausea"
    ],
    doctorType: "Gastroenterologist",
  ),
];