import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ur.dart'; // ✅ Import Urdu localization

abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ur'), // ✅ Added Urdu support
  ];

  // 🔑 Common strings
  String get appTitle;
  String get login;
  String get signup;
  String get forgotPassword;
  String get emailHint;
  String get passwordHint;
  String get otpSent;
  String get routeNotFound;

  // 🏁 BeforeLogin screen
  String get getStarted;
  String get loginTitle;
  String get loginSubtitle;
  String get loginDescription;
  String get loginButton;
  String get loginWithPhone;
  String get loginWithEmail;
  String get loginPrompt;
  String get signupLink;
  String get loginSuccess;
  String get loginFailed;
  String get networkError;

  // 👤 ChooseWhoAreYouScreen
  String get chooseTitle;
  String get chooseSubtitle;
  String get signupSpecialist;
  String get signupUser;

  // 📱 UserSignUpScreen
  String get signupTitle;
  String get signupSubtitle;
  String get phoneLabel;
  String get phoneHint;
  String get phoneErrorEmpty;
  String get phoneErrorInvalid;
  String get passwordLabel;
  String get passwordErrorEmpty;
  String get passwordErrorShort;
  String get termsText;
  String get termsPolicy;
  String get termsError;
  String get signupButton;
  String get signupWithEmail;
  String get loginPromptExisting;
  String get loginLink;

  // ✅ userVerifiedScreen translations
  String get userVerifiedTitle;
  String userVerifiedPhoneMessage(String maskedContact);
  String userVerifiedEmailMessage(String maskedContact);
  String get setUpProfile;

  // 🆕 OTP Verification screen translations
  String get enterOtpTitle;
  String otpSentMessagePhone(String contactValue);
  String otpSentMessageEmail(String contactValue);
  String get resendCode;
  String get didNotGetCode;
  String get submit;
  String get editPhoneNumber;
  String get editEmailAddress;
  String get invalidOtpMessage;

  // 🔔 Password reset success message
  String get passwordResetSuccessMessage;

  // 🔑 Reset Password Screen keys
  String get resetPasswordTitle;
  String resetPasswordDescription(String contactValue);
  String get newPasswordLabel;
  String get confirmPasswordLabel;
  String get enterNewPasswordHint;
  String get reEnterPasswordHint;
  String get newPasswordErrorEmpty;
  String get newPasswordErrorWeak;
  String get confirmPasswordErrorEmpty;
  String get confirmPasswordErrorMismatch;

  String get forgotDescription;
  String get validEmailError;
  String get failedToSendOtp;
  String get back;

  // ------------------ Basic Information Screen ------------------
  String get basicInformationTitle;
  String get fullNameLabel;
  String get fullNameHint;
  String get designationLabel;
  String get designationHint;
  String get locationLabel;
  List<String> get locationOptions;
  String get hourlyRateLabel;
  String get hourlyRateHint;
  List<String> get currencyOptions;
  String get specializationLabel;
  String get addSpecialization;
  String get languagesLabel;
  String get addLanguage;
  String get addChipButton;
  String get nextButton;
  String addDialogTitle(String title);
  String get addDialogHint;
  String get cancelButton;
  String get addButton;

  // ------------------ Education & Certifications Screen ------------------
  String get educationCertificationsTitle;
  String get educationSectionTitle;
  String get certificationsSectionTitle;

  // 🔑 Added missing fields for red errors
  String get educationFieldDegree;
  String get educationFieldInstitute;
  String get certificationFieldTitle;
  String get certificationFieldProvider;

  List<String> get educationFields;
  List<String> get certificationFields;

  String get degreeHint;
  String get instituteHint;
  String get certificateHint;
  String get providerHint;
  String get removeButton;
  String get addMoreButton;
  // ------------------ Basic Demographics Screen ------------------
  String get basicDemographicsTitle;
  String get basicDemographicsSubtitle;
  String get ageLabel;
  String get genderIdentityLabel;
  String get countryLabel;
  String get relationshipStatusLabel;

  String get ageOption1;
  String get ageOption2;
  String get ageOption3;
  String get ageOption4;

  String get countryOption1;
  String get countryOption2;
  String get countryOption3;
  String get countryOption4;
  String get countryOption5;

  String get genderMale;
  String get genderFemale;
  String get genderPreferNotToSay;

  String get relationshipSingle;
  String get relationshipInRelationship;
  String get relationshipMarried;
  String get relationshipDivorced;
  String get relationshipWidowed;

  String get disclaimerTitle;
  String get disclaimerDescription;

  String get submittingButton;

  // Page progress
  String pageProgressText(int currentStep, int totalSteps);

  // ------------------ Mental Health Screen ------------------
  String get mentalHealthGoalsTitle;
  String get mentalHealthReasonsTitle;
  String get mentalHealthOtherHint;
  String get mentalHealthGoalsSectionTitle;
  String get mentalHealthNextButton;
  String get mentalHealthSelectError;
  String mentalHealthPageProgress(int currentStep, int totalSteps);

  String get mentalHealthReasonAnxiety;
  String get mentalHealthReasonDepression;
  String get mentalHealthReasonRelationship;
  String get mentalHealthReasonTrauma;
  String get mentalHealthReasonSelfEsteem;
  String get mentalHealthReasonWork;
  String get mentalHealthReasonOther;

  String get mentalHealthGoalReduceStress;
  String get mentalHealthGoalImproveMood;
  String get mentalHealthGoalHealthyHabits;
  String get mentalHealthGoalCoping;
  String get mentalHealthGoalTalkProfessional;
  String get mentalHealthGoalPersonalGrowth;
  // ------------------ Lifestyle & Support Screen ------------------
  // ------------------ Lifestyle & Support Screen ------------------
  String get lifestyleSupportTitle;
  String get exerciseFrequencyQuestion;
  String get exerciseOptionNever;
  String get exerciseOptionOccasionally;
  String get exerciseOptionWeekly;
  String get exerciseOptionDaily;

  String get substanceUseQuestion;
  String get substanceOptionNever;
  String get substanceOptionOccasionally;
  String get substanceOptionFrequently;

  String get supportSystemQuestion;
  String get supportOptionYes;
  String get supportOptionSomewhat;
  String get supportOptionNo;

  String get lifestyleNextButton;
  String lifestylePageProgress(int currentStep, int totalSteps);
  // ------------------ Current Mental Health Status ------------------
  String get currentMentalHealthTitle;
  String get mentalHealthDiagnosisQuestion;
  String get mentalHealthFollowUpQuestion;
  String get seeingProfessionalQuestion;
  String get suicidalThoughtsQuestion;

  String get diagnosedYes;
  String get diagnosedNo;
  String get diagnosedPreferNot;

  String get seeingProfessionalNone;

  String get suicidalYesRecent;
  String get suicidalYesPast;
  String get suicidalNever;

  String get followUpPersistentSadness;
  String get followUpPanicAttacks;
  String get followUpSleepDifficulty;
  String get followUpLossInterest;
  String get followUpConcentrationDifficulty;
  String get followUpNone;

  String get currentMentalHealthNextButton;
  String currentMentalHealthPageProgress(int currentStep, int totalSteps);

  // ---------------- PreferencesScreen ----------------
  String get preferencesTitle;
  String get preferredSupportTypeLabel;
  String get preferredTherapistLabel;
  String get preferredLanguageLabel;

  String get supportOptionSelfHelp;
  String get supportOptionChatProfessional;
  String get supportOptionVideoTherapy;
  String get supportOptionPeerSupport;

  String get therapistOptionMale;
  String get therapistOptionFemale;
  String get therapistOptionNoPreference;

  String get languageOptionEnglish;
  String get languageOptionUrdu;
  String get selectLanguageHint;

  String stepProgress(int currentStep, int totalSteps);

  // ---------------- ConsentSafetyScreen ----------------
  String get consentSafetyTitle;
  String get consentMessage;
  String get agreeCheckbox;
  String get safetyWarning;
  String get submitButton;
  String get surveySubmitted;
  String get surveySubmitFailed;
  String get surveySubmitError;
  String pageProgress(int currentStep, int totalSteps);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ur'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ur':
      return AppLocalizationsUr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
