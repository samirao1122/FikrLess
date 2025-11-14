// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Fikr Less';

  @override
  String get login => 'Log in';

  @override
  String get signup => 'Sign Up';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get emailHint => 'Enter your email address';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get otpSent => 'OTP sent successfully!';

  @override
  String get routeNotFound => 'Route not found';

  // BeforeLogin screen
  @override
  String get getStarted => 'Get Started';

  @override
  String get loginTitle => 'Your Safe Space for';

  @override
  String get loginSubtitle => 'Mental Wellness';

  @override
  String get loginDescription =>
      'FikrLess helps you track your mood, connect with support, and practice self-care in a stigma-free environment.';

  @override
  String get loginButton => 'Log in';

  @override
  String get loginWithPhone => 'Log in with Phone Number';

  @override
  String get loginWithEmail => 'Log in with Email';

  @override
  String get loginPrompt => 'Don’t have an account? ';

  @override
  String get signupLink => 'Sign up';

  @override
  String get loginSuccess => 'Login successful ✅';

  @override
  String get loginFailed => 'Login failed ❌';

  @override
  String get networkError => 'Network error: ';

  // ChooseWhoAreYouScreen
  @override
  String get chooseTitle => 'Choose Who Are You?';

  @override
  String get chooseSubtitle =>
      'Kindly choose according to your role to proceed the sign up.';

  @override
  String get signupSpecialist => 'Sign up as a Specialist';

  @override
  String get signupUser => 'Sign up as a User';

  // UserSignUpScreen
  @override
  String get signupTitle => 'Sign Up';

  @override
  String get signupSubtitle =>
      'To register your account, please fill the below fields to access the full features of this app.';

  @override
  String get phoneLabel => 'Phone Number';

  @override
  String get phoneHint => 'Enter your phone number';

  @override
  String get phoneErrorEmpty => 'Please enter your phone number';

  @override
  String get phoneErrorInvalid => 'Please enter a valid phone number';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordErrorEmpty => 'Please enter your password';

  @override
  String get passwordErrorShort => 'Password must be at least 6 characters';

  @override
  String get termsText => 'I agree with ';

  @override
  String get termsPolicy => 'Terms & Policy';

  @override
  String get termsError => 'Please agree to Terms & Policy';

  @override
  String get signupButton => 'Sign up';

  @override
  String get signupWithEmail => 'Sign up with Email';

  @override
  String get loginPromptExisting => 'Already have an account? ';

  @override
  String get loginLink => 'Log in';

  // UserVerifiedScreen
  @override
  String get userVerifiedTitle => 'Successfully Verified';

  @override
  String userVerifiedPhoneMessage(String maskedContact) =>
      'Your phone number $maskedContact\nhas been verified successfully.\nYou can now continue with log in.';

  @override
  String userVerifiedEmailMessage(String maskedContact) =>
      'Your email $maskedContact\nhas been verified successfully.\nYou can now continue with log in.';

  @override
  String get setUpProfile => 'Set up Profile';

  // OTP Verification screen
  @override
  String get enterOtpTitle => 'Enter OTP';

  @override
  String otpSentMessagePhone(String contactValue) =>
      'We have sent an OTP to your phone number $contactValue.\nPlease check your messages and enter the OTP.';

  @override
  String otpSentMessageEmail(String contactValue) =>
      'We have sent an OTP to your email $contactValue.\nPlease check your inbox and enter the OTP.';

  @override
  String get resendCode => 'Resend Code';

  @override
  String get didNotGetCode => "Didn't get the code? ";

  @override
  String get submit => 'Submit';

  @override
  String get editPhoneNumber => 'Edit Phone Number';

  @override
  String get editEmailAddress => 'Edit Email Address';

  @override
  String get invalidOtpMessage => 'Please enter a valid 4-digit OTP';

  @override
  String get passwordResetSuccessMessage =>
      'Your password has been successfully changed.\nYou can now continue with log in.';

  // ResetPasswordScreen
  @override
  String get resetPasswordTitle => 'Reset Password';

  @override
  String resetPasswordDescription(String contactValue) =>
      'Resetting password for $contactValue';

  @override
  String get newPasswordLabel => 'New Password';

  @override
  String get confirmPasswordLabel => 'Confirm New Password';

  @override
  String get enterNewPasswordHint => 'Enter your new password';

  @override
  String get reEnterPasswordHint => 'Re-enter your password';

  @override
  String get newPasswordErrorEmpty => 'Please enter your new password';

  @override
  String get newPasswordErrorWeak =>
      'Password must have 4+ chars, 1 uppercase, 1 number, and 1 special char';

  @override
  String get confirmPasswordErrorEmpty => 'Please confirm your password';

  @override
  String get confirmPasswordErrorMismatch => 'Passwords do not match';

  // Basic Information Screen
  @override
  String get basicInformationTitle => 'Basic Information';

  @override
  String get fullNameLabel => 'Full Name';

  @override
  String get fullNameHint => 'Enter your full name';

  @override
  String get designationLabel => 'Designation';

  @override
  String get designationHint => 'Enter your designation';

  @override
  String get locationLabel => 'Location';

  @override
  List<String> get locationOptions => [
    'Karachi, Pakistan',
    'Lahore, Pakistan',
    'Islamabad, Pakistan',
  ];

  @override
  String get hourlyRateLabel => 'Hourly Rate';

  @override
  String get hourlyRateHint => 'Hourly Rate';

  @override
  List<String> get currencyOptions => ['PKR', 'USD', 'GBP'];

  @override
  String get specializationLabel => 'Specialization';

  @override
  String get addSpecialization => 'Add Specialization';

  @override
  String get languagesLabel => 'Languages';

  @override
  String get addLanguage => 'Add Language';

  @override
  String get addChipButton => '+ Add';

  @override
  String get nextButton => 'Next';

  @override
  String addDialogTitle(String title) => '$title';

  @override
  String get addDialogHint => 'Enter new item';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get addButton => 'Add';

  // Education & Certifications Screen
  @override
  String get educationCertificationsTitle => 'Education & Certifications';

  @override
  String get educationSectionTitle => '🎓 Education';

  @override
  String get certificationsSectionTitle => '📜 Certifications';

  @override
  List<String> get educationFields => ['Degree', 'Institute Name'];

  @override
  List<String> get certificationFields => ['Certificate Title', 'Provider'];

  @override
  String get degreeHint => 'Enter degree';

  @override
  String get instituteHint => 'Enter institute name';

  @override
  String get certificateHint => 'Enter certificate title';

  @override
  String get providerHint => 'Enter provider';

  @override
  String get removeButton => 'Remove';

  @override
  String get addMoreButton => 'Add More';

  @override
  String get educationFieldDegree => 'Degree';
  @override
  String get educationFieldInstitute => 'Institute Name';
  @override
  String get certificationFieldTitle => 'Certificate Title';
  @override
  String get certificationFieldProvider => 'Provider';

  // Basic Demographics Screen
  @override
  String get basicDemographicsTitle => 'Basic Demographics';

  @override
  String get basicDemographicsSubtitle => 'Help us get to know you';

  @override
  String get ageLabel => 'Age';

  @override
  String get genderIdentityLabel => 'Gender identity';

  @override
  String get countryLabel => 'Country of residence';

  @override
  String get relationshipStatusLabel => 'Relationship status';

  @override
  String get ageOption1 => '16 – 25';
  @override
  String get ageOption2 => '26 – 35';
  @override
  String get ageOption3 => '36 – 45';
  @override
  String get ageOption4 => '46+';

  @override
  String get countryOption1 => 'Karachi, Pakistan';
  @override
  String get countryOption2 => 'Lahore, Pakistan';
  @override
  String get countryOption3 => 'Islamabad, Pakistan';
  @override
  String get countryOption4 => 'Multan, Pakistan';
  @override
  String get countryOption5 => 'Other';

  @override
  String get genderMale => 'Male';
  @override
  String get genderFemale => 'Female';
  @override
  String get genderPreferNotToSay => 'Prefer not to say';

  @override
  String get relationshipSingle => 'Single';
  @override
  String get relationshipInRelationship => 'In a relationship';
  @override
  String get relationshipMarried => 'Married';
  @override
  String get relationshipDivorced => 'Divorced';
  @override
  String get relationshipWidowed => 'Widowed';

  @override
  String get disclaimerTitle => 'Disclaimer';

  @override
  String get disclaimerDescription =>
      'This is for data collection purposes to tailor this app to your needs.';

  @override
  String get submittingButton => 'Submitting...';

  @override
  String pageProgressText(int currentStep, int totalSteps) =>
      'Page $currentStep of $totalSteps';

  // Mental Health Section
  @override
  String get mentalHealthGoalsTitle => 'Mental Health Goals';

  @override
  String get mentalHealthReasonsTitle => 'What brings you here today?';

  @override
  String get mentalHealthOtherHint => 'Please specify...';

  @override
  String get mentalHealthGoalsSectionTitle =>
      'What are your goals for using this app? (Select top 2)';

  @override
  String get mentalHealthNextButton => 'Next';

  @override
  String get mentalHealthSelectError =>
      'Please select at least one reason and one goal.';

  @override
  String mentalHealthPageProgress(int currentStep, int totalSteps) =>
      'Page $currentStep of $totalSteps';

  @override
  String get mentalHealthReasonAnxiety => 'Anxiety or stress';
  @override
  String get mentalHealthReasonDepression => 'Depression or low mood';
  @override
  String get mentalHealthReasonRelationship => 'Relationship or family issues';
  @override
  String get mentalHealthReasonTrauma => 'Trauma or grief';
  @override
  String get mentalHealthReasonSelfEsteem => 'Self-esteem or confidence';
  @override
  String get mentalHealthReasonWork => 'Work or academic stress';
  @override
  String get mentalHealthReasonOther => 'Other (free text)';

  @override
  String get mentalHealthGoalReduceStress => 'Reduce stress/anxiety';
  @override
  String get mentalHealthGoalImproveMood => 'Improve mood & motivation';
  @override
  String get mentalHealthGoalHealthyHabits =>
      'Build healthy habits (sleep, journaling, exercise)';
  @override
  String get mentalHealthGoalCoping => 'Learn coping strategies';
  @override
  String get mentalHealthGoalTalkProfessional => 'Talk to a professional';
  @override
  String get mentalHealthGoalPersonalGrowth => 'Personal growth / mindfulness';

  // Current Mental Health Status Section
  @override
  String get currentMentalHealthTitle => 'Current Mental Health Status';

  @override
  String get mentalHealthDiagnosisQuestion =>
      'Have you ever been diagnosed with a mental health condition?';

  @override
  String get mentalHealthFollowUpQuestion => 'Follow-up: Which one(s)?';

  @override
  String get seeingProfessionalQuestion =>
      'Are you currently seeing a mental health professional?';

  @override
  String get suicidalThoughtsQuestion =>
      'Have you ever had suicidal thoughts or self-harm behaviors?';

  @override
  String get diagnosedYes => 'Yes';
  @override
  String get diagnosedNo => 'No';
  @override
  String get diagnosedPreferNot => 'Prefer not to say';

  @override
  String get seeingProfessionalNone => 'None of the above';

  @override
  String get suicidalYesRecent => 'Yes (recently)';
  @override
  String get suicidalYesPast => 'Yes (in the past)';
  @override
  String get suicidalNever => 'Never';

  @override
  String get followUpPersistentSadness => 'Persistent sadness';
  @override
  String get followUpPanicAttacks => 'Panic attacks';
  @override
  String get followUpSleepDifficulty => 'Difficulty sleeping';
  @override
  String get followUpLossInterest => 'Loss of interest in activities';
  @override
  String get followUpConcentrationDifficulty => 'Difficulty concentrating';
  @override
  String get followUpNone => 'None of the above';

  @override
  String get currentMentalHealthNextButton => 'Next';

  @override
  String currentMentalHealthPageProgress(int currentStep, int totalSteps) =>
      'Page $currentStep of $totalSteps';

  // Lifestyle & Support Screen
  @override
  String get lifestyleSupportTitle => 'Lifestyle & Support';

  @override
  String get exerciseFrequencyQuestion => 'How often do you exercise?';
  @override
  String get exerciseOptionNever => 'Never';
  @override
  String get exerciseOptionOccasionally => 'Occasionally';
  @override
  String get exerciseOptionWeekly => 'Weekly';
  @override
  String get exerciseOptionDaily => 'Daily';

  @override
  String get substanceUseQuestion =>
      'How often do you use alcohol or substances?';
  @override
  String get substanceOptionNever => 'Never';
  @override
  String get substanceOptionOccasionally => 'Occasionally';
  @override
  String get substanceOptionFrequently => 'Frequently';

  @override
  String get supportSystemQuestion =>
      'Do you have a strong support system (family/friends)?';
  @override
  String get supportOptionYes => 'Yes';
  @override
  String get supportOptionSomewhat => 'Somewhat';
  @override
  String get supportOptionNo => 'No';

  @override
  String get lifestyleNextButton => 'Next';

  @override
  String lifestylePageProgress(int currentStep, int totalSteps) =>
      'Page $currentStep of $totalSteps';

  // ---------------- PreferencesScreen ----------------
  @override
  String get preferencesTitle => 'Preferences';

  @override
  String get preferredSupportTypeLabel => 'Preferred type of support:';
  @override
  String get preferredTherapistLabel => 'Preferred therapist characteristics:';
  @override
  String get preferredLanguageLabel => 'Preferred language:';

  @override
  String get supportOptionSelfHelp =>
      'Self–help tools (journaling, meditation, exercises)';
  @override
  String get supportOptionChatProfessional => 'Chat with a professional';
  @override
  String get supportOptionVideoTherapy => 'Video/voice therapy';
  @override
  String get supportOptionPeerSupport => 'Peer community support';

  @override
  String get therapistOptionMale => 'Male';
  @override
  String get therapistOptionFemale => 'Female';
  @override
  String get therapistOptionNoPreference => 'No preference';

  @override
  String get languageOptionEnglish => 'English';
  @override
  String get languageOptionUrdu => 'Urdu';
  @override
  String get selectLanguageHint => 'Select language';

  @override
  String stepProgress(int currentStep, int totalSteps) =>
      'Step $currentStep of $totalSteps';

  // ---------------- ConsentSafetyScreen ----------------
  @override
  String get consentSafetyTitle => 'Consent & Safety';

  @override
  String get consentMessage =>
      'I understand this app does not replace emergency medical services.';
  @override
  String get agreeCheckbox => 'Yes, I agree';

  @override
  String get safetyWarning =>
      'If you ever feel unsafe or have thoughts of self-harm, please contact your local emergency number immediately.';

  @override
  String get submitButton => 'Submit & Go to Login';
  @override
  String pageProgress(int currentStep, int totalSteps) =>
      'Page $currentStep of $totalSteps';
  @override
  String get surveySubmitted => 'Survey submitted successfully!';

  @override
  String get surveySubmitFailed => 'Failed to submit survey';

  @override
  String get surveySubmitError => 'Error submitting survey';
  @override
  String get forgotDescription =>
      'Enter your registered email address to receive a reset code.';

  @override
  String get validEmailError => 'Enter a valid email address';

  @override
  String get failedToSendOtp => 'Failed to send OTP.';

  @override
  String get back => 'Back';
}
