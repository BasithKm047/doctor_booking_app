import 'disease_model.dart';

class RecommendationEngine {
  static Disease? matchDisease(
    String complaint,
    List<String> selectedSymptoms,
    List<Disease> diseases,
  ) {
    Disease? matched;
    double highestScore = 0;

    for (var disease in diseases) {
      // Step 1: Check complaint match
      if (disease.name.toLowerCase() == complaint.toLowerCase()) {
        
        // Step 2: Count matching symptoms
        final matchCount = disease.symptoms
            .where((symptom) =>
                selectedSymptoms
                    .map((e) => e.toLowerCase())
                    .contains(symptom.toLowerCase()))
            .length;

        // Step 3: Calculate score
        final score = matchCount / disease.symptoms.length;

        if (score > highestScore) {
          highestScore = score;
          matched = disease;
        }
      }
    }

    return highestScore >= 0.3 ? matched : null;
  }
}