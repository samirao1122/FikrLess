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
  String get getStarted => 'Get Started';

  @override
  String get routeNotFound => 'Route not found';

  @override
  String get login => 'Log in';

  @override
  String get loginTitle => 'Your Safe Space for';

  @override
  String get loginSubtitle => 'Mental Wellness';

  @override
  String get loginDescription => 'FikrLess helps you track your mood, connect with support, and practice self-care in a stigma-free environment.';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get emailHint => 'Enter your email address';

  @override
  String get passwordHint => 'Enter your password';

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
  String get phoneErrorInvalid => 'Please enter a valid phone number';

  @override
  String get phoneErrorEmpty => 'Please enter your phone number';

  @override
  String get passwordErrorEmpty => 'Please enter your password';

  @override
  String get passwordErrorShort => 'Password must be at least 6 characters';

  @override
  String get loginSuccess => 'Login successful ✅';

  @override
  String get loginFailed => 'Login failed ❌';

  @override
  String get networkError => 'Network error: ';

  @override
  String get chooseTitle => 'Choose Who Are You?';

  @override
  String get chooseSubtitle => 'Kindly choose according to your role to proceed the sign up.';

  @override
  String get signupSpecialist => 'Sign up as a Specialist';

  @override
  String get signupUser => 'Sign up as a User';

  @override
  String get signupTitle => 'Sign Up';

  @override
  String get signupSubtitle => 'To register your account, please fill the below fields to access the full features of this app.';

  @override
  String get phoneLabel => 'Phone Number';

  @override
  String get phoneHint => 'Enter your phone number';

  @override
  String get passwordLabel => 'Password';

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

  @override
  String get otpSent => 'OTP sent successfully!';

  @override
  String get userVerifiedTitle => 'Successfully Verified';

  @override
  String userVerifiedPhoneMessage(Object maskedContact) {
    return 'Your phone number $maskedContact\nhas been verified successfully.\nYou can now continue with log in.';
  }

  @override
  String userVerifiedEmailMessage(Object maskedContact) {
    return 'Your email $maskedContact\nhas been verified successfully.\nYou can now continue with log in.';
  }

  @override
  String get setUpProfile => 'Set up Profile';

  @override
  String get enterOtpTitle => 'Enter OTP';

  @override
  String otpSentMessagePhone(Object contactValue) {
    return 'We have sent an OTP to your phone number $contactValue.\nPlease check your messages and enter the OTP.';
  }

  @override
  String otpSentMessageEmail(Object contactValue) {
    return 'We have sent an OTP to your email $contactValue.\nPlease check your inbox and enter the OTP.';
  }

  @override
  String get resendCode => 'Resend Code';

  @override
  String get didNotGetCode => 'Didn\'t get the code? ';

  @override
  String get submit => 'Submit';

  @override
  String get editPhoneNumber => 'Edit Phone Number';

  @override
  String get editEmailAddress => 'Edit Email Address';

  @override
  String get invalidOtpMessage => 'Please enter a valid 4-digit OTP';

  @override
  String get passwordResetSuccessMessage => 'Your password has been successfully changed.\nYou can now continue with log in.';

  @override
  String get resetPasswordTitle => 'Reset Password';

  @override
  String resetPasswordDescription(Object contactValue) {
    return 'Resetting password for $contactValue';
  }

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
  String get newPasswordErrorWeak => 'Password must have 4+ chars, 1 uppercase, 1 number, and 1 special char';

  @override
  String get confirmPasswordErrorEmpty => 'Please confirm your password';

  @override
  String get confirmPasswordErrorMismatch => 'Passwords do not match';

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
  String get locationKarachi => 'Karachi, Pakistan';

  @override
  String get locationLahore => 'Lahore, Pakistan';

  @override
  String get locationIslamabad => 'Islamabad, Pakistan';

  @override
  String get locationMultan => 'Multan, Pakistan';

  @override
  String get locationOther => 'Other';

  @override
  String get hourlyRateLabel => 'Hourly Rate';

  @override
  String get hourlyRateHint => 'Hourly Rate';

  @override
  String get currencyPKR => 'PKR';

  @override
  String get currencyUSD => 'USD';

  @override
  String get currencyGBP => 'GBP';

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
  String addDialogTitle(Object title) {
    return '$title';
  }

  @override
  String get addDialogHint => 'Enter new item';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get addButton => 'Add';

  @override
  String get educationCertificationsTitle => 'Education & Certifications';

  @override
  String get educationSectionTitle => '🎓 Education';

  @override
  String get certificationsSectionTitle => '📜 Certifications';

  @override
  String get educationFieldDegree => 'Degree';

  @override
  String get educationFieldInstitute => 'Institute Name';

  @override
  String get certificationFieldTitle => 'Certificate Title';

  @override
  String get certificationFieldProvider => 'Provider';

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
  String get disclaimerDescription => 'This is for data collection purposes to tailor this app to your needs.';

  @override
  String get submittingButton => 'Submitting...';

  @override
  String pageProgressText(Object currentStep, Object totalSteps) {
    return 'Page $currentStep of $totalSteps';
  }

  @override
  String get mentalHealthGoalsTitle => 'Mental Health Goals';

  @override
  String get mentalHealthReasonsTitle => 'What brings you here today?';

  @override
  String get mentalHealthOtherHint => 'Please specify...';

  @override
  String get mentalHealthGoalsSectionTitle => 'What are your goals for using this app? (Select top 2)';

  @override
  String get mentalHealthNextButton => 'Next';

  @override
  String get mentalHealthSelectError => 'Please select at least one reason and one goal.';

  @override
  String mentalHealthPageProgress(Object currentStep, Object totalSteps) {
    return 'Page $currentStep of $totalSteps';
  }

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
  String get mentalHealthGoalHealthyHabits => 'Build healthy habits (sleep, journaling, exercise)';

  @override
  String get mentalHealthGoalCoping => 'Learn coping strategies';

  @override
  String get mentalHealthGoalTalkProfessional => 'Talk to a professional';

  @override
  String get mentalHealthGoalPersonalGrowth => 'Personal growth / mindfulness';

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
  String get substanceUseQuestion => 'How often do you use alcohol or substances?';

  @override
  String get substanceOptionNever => 'Never';

  @override
  String get substanceOptionOccasionally => 'Occasionally';

  @override
  String get substanceOptionFrequently => 'Frequently';

  @override
  String get supportSystemQuestion => 'Do you have a strong support system (family/friends)?';

  @override
  String get supportOptionYes => 'Yes';

  @override
  String get supportOptionSomewhat => 'Somewhat';

  @override
  String get supportOptionNo => 'No';

  @override
  String get lifestyleNextButton => 'Next';

  @override
  String lifestylePageProgress(Object currentStep, Object totalSteps) {
    return 'Page $currentStep of $totalSteps';
  }

  @override
  String get currentMentalHealthTitle => 'Current Mental Health Status';

  @override
  String get mentalHealthDiagnosisQuestion => 'Have you ever been diagnosed with a mental health condition?';

  @override
  String get mentalHealthFollowUpQuestion => 'Follow-up: Which one(s)?';

  @override
  String get seeingProfessionalQuestion => 'Are you currently seeing a mental health professional?';

  @override
  String get suicidalThoughtsQuestion => 'Have you ever had suicidal thoughts or self-harm behaviors?';

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
  String currentMentalHealthPageProgress(Object currentStep, Object totalSteps) {
    return 'Page $currentStep of $totalSteps';
  }

  @override
  String get preferencesTitle => 'Preferences';

  @override
  String get preferredSupportTypeLabel => 'Preferred type of support:';

  @override
  String get preferredTherapistLabel => 'Preferred therapist characteristics:';

  @override
  String get preferredLanguageLabel => 'Preferred language:';

  @override
  String get supportOptionSelfHelp => 'Self–help tools (journaling, meditation, exercises)';

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
  String stepProgress(Object currentStep, Object totalSteps) {
    return 'Step $currentStep of $totalSteps';
  }

  @override
  String get consentSafetyTitle => 'Consent & Safety';

  @override
  String get consentMessage => 'I understand this app does not replace emergency medical services.';

  @override
  String get agreeCheckbox => 'Yes, I agree';

  @override
  String get safetyWarning => 'If you ever feel unsafe or have thoughts of self-harm, please contact your local emergency number immediately.';

  @override
  String get submitButton => 'Submit & Go to Login';

  @override
  String pageProgress(Object currentStep, Object totalSteps) {
    return 'Page $currentStep of $totalSteps';
  }

  @override
  String get surveySubmitted => 'Survey submitted successfully!';

  @override
  String get surveySubmitFailed => 'Failed to submit survey';

  @override
  String get surveySubmitError => 'Error submitting survey';

  @override
  String get forgotDescription => 'Enter your registered email address to receive a reset code.';

  @override
  String get validEmailError => 'Enter a valid email address';

  @override
  String get failedToSendOtp => 'Failed to send OTP.';

  @override
  String get back => 'Back';

  @override
  String get homeTitle => 'Home';

  @override
  String get myActivity => 'My Activity';

  @override
  String get seeMore => 'See More';

  @override
  String get steps => 'Steps';

  @override
  String get mood => 'Mood';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get goal => 'Goal';

  @override
  String get journal => 'Journal';

  @override
  String get specialist => 'Specialist';

  @override
  String get exercise => 'Exercise';

  @override
  String get quoteOfTheDay => 'Quote of the day';

  @override
  String get loadingQuote => 'Loading quote...';

  @override
  String get loadingMood => 'Loading mood...';

  @override
  String get noMoodSet => 'No mood set';

  @override
  String get article => 'Article';

  @override
  String get forum => 'Forum';

  @override
  String get chat => 'Chat';

  @override
  String get wellness => 'Wellness';

  @override
  String get profile => 'Profile';

  @override
  String get notifications => 'Notifications';

  @override
  String get moodSelection => 'Select Your Mood';

  @override
  String get selectMood => 'Select Mood';

  @override
  String get moodSubmitted => 'Mood submitted successfully';

  @override
  String get moodSubmitFailed => 'Failed to submit mood';

  @override
  String get stepsPermissionDenied => 'Step counter permission denied';

  @override
  String get stepsError => 'Error accessing step counter';

  @override
  String get spiritualHub => 'Spiritual Hub';

  @override
  String get dailyLifeReminders => 'Daily Life Reminders';

  @override
  String get guidedMeditations => 'Guided Meditations';

  @override
  String get learnMore => 'Learn More';

  @override
  String get mindfulnessPractitioners => 'Mindfulness Practitioners';

  @override
  String get noRemindersAvailable => 'No reminders available';

  @override
  String get noMeditationsAvailable => 'No meditations available';

  @override
  String get noPractitionersAvailable => 'No practitioners available';

  @override
  String meditation(int number) {
    return 'Meditation $number';
  }

  @override
  String get all => 'All';

  @override
  String get bookASession => 'Book a Session';

  @override
  String get downloading => 'Downloading...';

  @override
  String get downloadFailed => 'Download failed';

  @override
  String get howAreYouFeelingToday => 'How are you feeling today?';

  @override
  String get todaysJournal => 'Today\'s Journal';

  @override
  String get write => 'Write';

  @override
  String get tapWriteToAdd => 'Tap \"Write\" to add a private journal entry';

  @override
  String get expressYourThoughts => 'Express your thoughts and feelings safely';

  @override
  String get saveTodaysMood => 'Save Today\'s Mood';

  @override
  String get cancel => 'Cancel';

  @override
  String get noNotificationsYet => 'No Notifications Yet';

  @override
  String get markAsUnread => 'Mark as Unread';

  @override
  String get clearAll => 'Clear All';

  @override
  String get deleteNotifications => 'Delete Notifications';

  @override
  String get deleteNotificationsConfirm => 'Are you sure you want to delete all notifications?';

  @override
  String get delete => 'Delete';

  @override
  String get notificationsCleared => 'All notifications cleared';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get recentMoods => 'Recent Moods';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get whatsInYourMindToday => 'What\'s in your mind today?';

  @override
  String get moodSaved => 'Mood saved successfully';

  @override
  String get moodSaveFailed => 'Failed to save mood';

  @override
  String get overview => 'Overview';

  @override
  String get achievements => 'Achievements';

  @override
  String get settings => 'Settings';

  @override
  String get memberSince => 'Member Since';

  @override
  String get thisWeekMode => 'This Week Mode';

  @override
  String get recentAchievements => 'Recent Achievements';

  @override
  String get yourAchievements => 'Your Achievements';

  @override
  String get unlocked => 'Unlocked';

  @override
  String get noAchievementsYet => 'No achievements yet';

  @override
  String get loadingAchievements => 'Loading achievements...';

  @override
  String get accountSettings => 'Account Settings';

  @override
  String get personalDetails => 'Personal Details';

  @override
  String get changePhoneNumber => 'Change Phone Number';

  @override
  String get changePassword => 'Change Password';

  @override
  String get appSetting => 'App Setting';

  @override
  String get language => 'Language';

  @override
  String get legal => 'Legal';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfUse => 'Terms of Use';

  @override
  String get helpAndSupport => 'Help and Support';

  @override
  String get customerSupport => 'Customer Support';

  @override
  String get faqs => 'FAQs';

  @override
  String get rateUs => 'Rate Us';

  @override
  String get languageChanged => 'Language changed. Please restart the app to see changes.';

  @override
  List<String> get locationOptions => [
    locationKarachi,
    locationLahore,
    locationIslamabad,
    locationMultan,
    locationOther,
  ];

  @override
  List<String> get currencyOptions => [
    currencyPKR,
    currencyUSD,
    currencyGBP,
  ];
}
