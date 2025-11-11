class UserSurveyData {
  String? userId;
  String? ageRange;
  String? genderIdentity;
  String? countryOfResidence;
  String? relationshipStatus;
  List<String>? whatBringsYouHere;
  String? otherReason;
  List<String>? goalsForUsingApp;
  String? mentalHealthDiagnosis;
  List<String>? diagnosedConditions;
  String? seeingProfessional;
  String? suicidalThoughts;
  String? exerciseFrequency;
  String? substanceUse;
  String? supportSystem;
  List<String>? preferredSupportType;
  String? preferredTherapistGender;
  String? preferredLanguage;
  bool? understandsEmergencyDisclaimer;

  UserSurveyData({
    this.userId,
    this.ageRange,
    this.genderIdentity,
    this.countryOfResidence,
    this.relationshipStatus,
    this.whatBringsYouHere,
    this.otherReason,
    this.goalsForUsingApp,
    this.mentalHealthDiagnosis,
    this.diagnosedConditions,
    this.seeingProfessional,
    this.suicidalThoughts,
    this.exerciseFrequency,
    this.substanceUse,
    this.supportSystem,
    this.preferredSupportType,
    this.preferredTherapistGender,
    this.preferredLanguage,
    this.understandsEmergencyDisclaimer,
  });

  Map<String, dynamic> toJson() {
    return {
      "user_id": userId,
      "demographics": {
        "age_range": ageRange,
        "gender_identity": genderIdentity,
        "country_of_residence": countryOfResidence,
        "relationship_status": relationshipStatus,
        "what_brings_you_here": whatBringsYouHere,
        "other_reason": otherReason,
        "goals_for_using_app": goalsForUsingApp,
        "mental_health_diagnosis": mentalHealthDiagnosis,
        "diagnosed_conditions": diagnosedConditions,
        "seeing_professional": seeingProfessional,
        "suicidal_thoughts": suicidalThoughts,
        "exercise_frequency": exerciseFrequency,
        "substance_use": substanceUse,
        "support_system": supportSystem,
        "preferred_support_type": preferredSupportType,
        "preferred_therapist_gender": preferredTherapistGender,
        "preferred_language": preferredLanguage,
        "understands_emergency_disclaimer": understandsEmergencyDisclaimer,
      },
    };
  }
}
