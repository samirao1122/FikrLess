import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ur.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ur')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Fikr Less'**
  String get appTitle;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @routeNotFound.
  ///
  /// In en, this message translates to:
  /// **'Route not found'**
  String get routeNotFound;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get login;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Safe Space for'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Mental Wellness'**
  String get loginSubtitle;

  /// No description provided for @loginDescription.
  ///
  /// In en, this message translates to:
  /// **'FikrLess helps you track your mood, connect with support, and practice self-care in a stigma-free environment.'**
  String get loginDescription;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get emailHint;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHint;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get loginButton;

  /// No description provided for @loginWithPhone.
  ///
  /// In en, this message translates to:
  /// **'Log in with Phone Number'**
  String get loginWithPhone;

  /// No description provided for @loginWithEmail.
  ///
  /// In en, this message translates to:
  /// **'Log in with Email'**
  String get loginWithEmail;

  /// No description provided for @loginPrompt.
  ///
  /// In en, this message translates to:
  /// **'Don’t have an account? '**
  String get loginPrompt;

  /// No description provided for @signupLink.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signupLink;

  /// No description provided for @phoneErrorInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get phoneErrorInvalid;

  /// No description provided for @phoneErrorEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get phoneErrorEmpty;

  /// No description provided for @passwordErrorEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get passwordErrorEmpty;

  /// No description provided for @passwordErrorShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordErrorShort;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Login successful ✅'**
  String get loginSuccess;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed ❌'**
  String get loginFailed;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network error: '**
  String get networkError;

  /// No description provided for @chooseTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose Who Are You?'**
  String get chooseTitle;

  /// No description provided for @chooseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Kindly choose according to your role to proceed the sign up.'**
  String get chooseSubtitle;

  /// No description provided for @signupSpecialist.
  ///
  /// In en, this message translates to:
  /// **'Sign up as a Specialist'**
  String get signupSpecialist;

  /// No description provided for @signupUser.
  ///
  /// In en, this message translates to:
  /// **'Sign up as a User'**
  String get signupUser;

  /// No description provided for @signupTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signupTitle;

  /// No description provided for @signupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'To register your account, please fill the below fields to access the full features of this app.'**
  String get signupSubtitle;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneLabel;

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get phoneHint;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @termsText.
  ///
  /// In en, this message translates to:
  /// **'I agree with '**
  String get termsText;

  /// No description provided for @termsPolicy.
  ///
  /// In en, this message translates to:
  /// **'Terms & Policy'**
  String get termsPolicy;

  /// No description provided for @termsError.
  ///
  /// In en, this message translates to:
  /// **'Please agree to Terms & Policy'**
  String get termsError;

  /// No description provided for @signupButton.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signupButton;

  /// No description provided for @signupWithEmail.
  ///
  /// In en, this message translates to:
  /// **'Sign up with Email'**
  String get signupWithEmail;

  /// No description provided for @loginPromptExisting.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get loginPromptExisting;

  /// No description provided for @loginLink.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get loginLink;

  /// No description provided for @otpSent.
  ///
  /// In en, this message translates to:
  /// **'OTP sent successfully!'**
  String get otpSent;

  /// No description provided for @userVerifiedTitle.
  ///
  /// In en, this message translates to:
  /// **'Successfully Verified'**
  String get userVerifiedTitle;

  /// Phone verification message
  ///
  /// In en, this message translates to:
  /// **'Your phone number {maskedContact}\nhas been verified successfully.\nYou can now continue with log in.'**
  String userVerifiedPhoneMessage(Object maskedContact);

  /// Email verification message
  ///
  /// In en, this message translates to:
  /// **'Your email {maskedContact}\nhas been verified successfully.\nYou can now continue with log in.'**
  String userVerifiedEmailMessage(Object maskedContact);

  /// No description provided for @setUpProfile.
  ///
  /// In en, this message translates to:
  /// **'Set up Profile'**
  String get setUpProfile;

  /// No description provided for @enterOtpTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get enterOtpTitle;

  /// OTP sent message for phone
  ///
  /// In en, this message translates to:
  /// **'We have sent an OTP to your phone number {contactValue}.\nPlease check your messages and enter the OTP.'**
  String otpSentMessagePhone(Object contactValue);

  /// OTP sent message for email
  ///
  /// In en, this message translates to:
  /// **'We have sent an OTP to your email {contactValue}.\nPlease check your inbox and enter the OTP.'**
  String otpSentMessageEmail(Object contactValue);

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendCode;

  /// No description provided for @didNotGetCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t get the code? '**
  String get didNotGetCode;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @editPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Edit Phone Number'**
  String get editPhoneNumber;

  /// No description provided for @editEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Edit Email Address'**
  String get editEmailAddress;

  /// No description provided for @invalidOtpMessage.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid 4-digit OTP'**
  String get invalidOtpMessage;

  /// No description provided for @passwordResetSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Your password has been successfully changed.\nYou can now continue with log in.'**
  String get passwordResetSuccessMessage;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPasswordTitle;

  /// Message showing the email or phone for which password is being reset
  ///
  /// In en, this message translates to:
  /// **'Resetting password for {contactValue}'**
  String resetPasswordDescription(Object contactValue);

  /// No description provided for @newPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPasswordLabel;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmPasswordLabel;

  /// No description provided for @enterNewPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password'**
  String get enterNewPasswordHint;

  /// No description provided for @reEnterPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
  String get reEnterPasswordHint;

  /// No description provided for @newPasswordErrorEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter your new password'**
  String get newPasswordErrorEmpty;

  /// No description provided for @newPasswordErrorWeak.
  ///
  /// In en, this message translates to:
  /// **'Password must have 4+ chars, 1 uppercase, 1 number, and 1 special char'**
  String get newPasswordErrorWeak;

  /// No description provided for @confirmPasswordErrorEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get confirmPasswordErrorEmpty;

  /// No description provided for @confirmPasswordErrorMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get confirmPasswordErrorMismatch;

  /// No description provided for @basicInformationTitle.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basicInformationTitle;

  /// No description provided for @fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullNameLabel;

  /// No description provided for @fullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get fullNameHint;

  /// No description provided for @designationLabel.
  ///
  /// In en, this message translates to:
  /// **'Designation'**
  String get designationLabel;

  /// No description provided for @designationHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your designation'**
  String get designationHint;

  /// No description provided for @locationLabel.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get locationLabel;

  /// No description provided for @locationKarachi.
  ///
  /// In en, this message translates to:
  /// **'Karachi, Pakistan'**
  String get locationKarachi;

  /// No description provided for @locationLahore.
  ///
  /// In en, this message translates to:
  /// **'Lahore, Pakistan'**
  String get locationLahore;

  /// No description provided for @locationIslamabad.
  ///
  /// In en, this message translates to:
  /// **'Islamabad, Pakistan'**
  String get locationIslamabad;

  /// No description provided for @locationMultan.
  ///
  /// In en, this message translates to:
  /// **'Multan, Pakistan'**
  String get locationMultan;

  /// No description provided for @locationOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get locationOther;

  /// No description provided for @hourlyRateLabel.
  ///
  /// In en, this message translates to:
  /// **'Hourly Rate'**
  String get hourlyRateLabel;

  /// No description provided for @hourlyRateHint.
  ///
  /// In en, this message translates to:
  /// **'Hourly Rate'**
  String get hourlyRateHint;

  /// No description provided for @currencyPKR.
  ///
  /// In en, this message translates to:
  /// **'PKR'**
  String get currencyPKR;

  /// No description provided for @currencyUSD.
  ///
  /// In en, this message translates to:
  /// **'USD'**
  String get currencyUSD;

  /// No description provided for @currencyGBP.
  ///
  /// In en, this message translates to:
  /// **'GBP'**
  String get currencyGBP;

  /// No description provided for @specializationLabel.
  ///
  /// In en, this message translates to:
  /// **'Specialization'**
  String get specializationLabel;

  /// No description provided for @addSpecialization.
  ///
  /// In en, this message translates to:
  /// **'Add Specialization'**
  String get addSpecialization;

  /// No description provided for @languagesLabel.
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get languagesLabel;

  /// No description provided for @addLanguage.
  ///
  /// In en, this message translates to:
  /// **'Add Language'**
  String get addLanguage;

  /// No description provided for @addChipButton.
  ///
  /// In en, this message translates to:
  /// **'+ Add'**
  String get addChipButton;

  /// No description provided for @nextButton.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextButton;

  /// Dialog title for adding a new tag
  ///
  /// In en, this message translates to:
  /// **'{title}'**
  String addDialogTitle(Object title);

  /// No description provided for @addDialogHint.
  ///
  /// In en, this message translates to:
  /// **'Enter new item'**
  String get addDialogHint;

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// No description provided for @addButton.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addButton;

  /// No description provided for @educationCertificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Education & Certifications'**
  String get educationCertificationsTitle;

  /// No description provided for @educationSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'🎓 Education'**
  String get educationSectionTitle;

  /// No description provided for @certificationsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'📜 Certifications'**
  String get certificationsSectionTitle;

  /// No description provided for @educationFieldDegree.
  ///
  /// In en, this message translates to:
  /// **'Degree'**
  String get educationFieldDegree;

  /// No description provided for @educationFieldInstitute.
  ///
  /// In en, this message translates to:
  /// **'Institute Name'**
  String get educationFieldInstitute;

  /// No description provided for @certificationFieldTitle.
  ///
  /// In en, this message translates to:
  /// **'Certificate Title'**
  String get certificationFieldTitle;

  /// No description provided for @certificationFieldProvider.
  ///
  /// In en, this message translates to:
  /// **'Provider'**
  String get certificationFieldProvider;

  /// No description provided for @degreeHint.
  ///
  /// In en, this message translates to:
  /// **'Enter degree'**
  String get degreeHint;

  /// No description provided for @instituteHint.
  ///
  /// In en, this message translates to:
  /// **'Enter institute name'**
  String get instituteHint;

  /// No description provided for @certificateHint.
  ///
  /// In en, this message translates to:
  /// **'Enter certificate title'**
  String get certificateHint;

  /// No description provided for @providerHint.
  ///
  /// In en, this message translates to:
  /// **'Enter provider'**
  String get providerHint;

  /// No description provided for @removeButton.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get removeButton;

  /// No description provided for @addMoreButton.
  ///
  /// In en, this message translates to:
  /// **'Add More'**
  String get addMoreButton;

  /// No description provided for @basicDemographicsTitle.
  ///
  /// In en, this message translates to:
  /// **'Basic Demographics'**
  String get basicDemographicsTitle;

  /// No description provided for @basicDemographicsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Help us get to know you'**
  String get basicDemographicsSubtitle;

  /// No description provided for @ageLabel.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get ageLabel;

  /// No description provided for @genderIdentityLabel.
  ///
  /// In en, this message translates to:
  /// **'Gender identity'**
  String get genderIdentityLabel;

  /// No description provided for @countryLabel.
  ///
  /// In en, this message translates to:
  /// **'Country of residence'**
  String get countryLabel;

  /// No description provided for @relationshipStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Relationship status'**
  String get relationshipStatusLabel;

  /// No description provided for @ageOption1.
  ///
  /// In en, this message translates to:
  /// **'16 – 25'**
  String get ageOption1;

  /// No description provided for @ageOption2.
  ///
  /// In en, this message translates to:
  /// **'26 – 35'**
  String get ageOption2;

  /// No description provided for @ageOption3.
  ///
  /// In en, this message translates to:
  /// **'36 – 45'**
  String get ageOption3;

  /// No description provided for @ageOption4.
  ///
  /// In en, this message translates to:
  /// **'46+'**
  String get ageOption4;

  /// No description provided for @countryOption1.
  ///
  /// In en, this message translates to:
  /// **'Karachi, Pakistan'**
  String get countryOption1;

  /// No description provided for @countryOption2.
  ///
  /// In en, this message translates to:
  /// **'Lahore, Pakistan'**
  String get countryOption2;

  /// No description provided for @countryOption3.
  ///
  /// In en, this message translates to:
  /// **'Islamabad, Pakistan'**
  String get countryOption3;

  /// No description provided for @countryOption4.
  ///
  /// In en, this message translates to:
  /// **'Multan, Pakistan'**
  String get countryOption4;

  /// No description provided for @countryOption5.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get countryOption5;

  /// No description provided for @genderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get genderMale;

  /// No description provided for @genderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get genderFemale;

  /// No description provided for @genderPreferNotToSay.
  ///
  /// In en, this message translates to:
  /// **'Prefer not to say'**
  String get genderPreferNotToSay;

  /// No description provided for @relationshipSingle.
  ///
  /// In en, this message translates to:
  /// **'Single'**
  String get relationshipSingle;

  /// No description provided for @relationshipInRelationship.
  ///
  /// In en, this message translates to:
  /// **'In a relationship'**
  String get relationshipInRelationship;

  /// No description provided for @relationshipMarried.
  ///
  /// In en, this message translates to:
  /// **'Married'**
  String get relationshipMarried;

  /// No description provided for @relationshipDivorced.
  ///
  /// In en, this message translates to:
  /// **'Divorced'**
  String get relationshipDivorced;

  /// No description provided for @relationshipWidowed.
  ///
  /// In en, this message translates to:
  /// **'Widowed'**
  String get relationshipWidowed;

  /// No description provided for @disclaimerTitle.
  ///
  /// In en, this message translates to:
  /// **'Disclaimer'**
  String get disclaimerTitle;

  /// No description provided for @disclaimerDescription.
  ///
  /// In en, this message translates to:
  /// **'This is for data collection purposes to tailor this app to your needs.'**
  String get disclaimerDescription;

  /// No description provided for @submittingButton.
  ///
  /// In en, this message translates to:
  /// **'Submitting...'**
  String get submittingButton;

  /// Shows the current page number out of total steps in a multi-step survey
  ///
  /// In en, this message translates to:
  /// **'Page {currentStep} of {totalSteps}'**
  String pageProgressText(Object currentStep, Object totalSteps);

  /// No description provided for @mentalHealthGoalsTitle.
  ///
  /// In en, this message translates to:
  /// **'Mental Health Goals'**
  String get mentalHealthGoalsTitle;

  /// No description provided for @mentalHealthReasonsTitle.
  ///
  /// In en, this message translates to:
  /// **'What brings you here today?'**
  String get mentalHealthReasonsTitle;

  /// No description provided for @mentalHealthOtherHint.
  ///
  /// In en, this message translates to:
  /// **'Please specify...'**
  String get mentalHealthOtherHint;

  /// No description provided for @mentalHealthGoalsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'What are your goals for using this app? (Select top 2)'**
  String get mentalHealthGoalsSectionTitle;

  /// No description provided for @mentalHealthNextButton.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get mentalHealthNextButton;

  /// No description provided for @mentalHealthSelectError.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one reason and one goal.'**
  String get mentalHealthSelectError;

  /// Shows the current page number out of total steps in the mental health flow
  ///
  /// In en, this message translates to:
  /// **'Page {currentStep} of {totalSteps}'**
  String mentalHealthPageProgress(Object currentStep, Object totalSteps);

  /// No description provided for @mentalHealthReasonAnxiety.
  ///
  /// In en, this message translates to:
  /// **'Anxiety or stress'**
  String get mentalHealthReasonAnxiety;

  /// No description provided for @mentalHealthReasonDepression.
  ///
  /// In en, this message translates to:
  /// **'Depression or low mood'**
  String get mentalHealthReasonDepression;

  /// No description provided for @mentalHealthReasonRelationship.
  ///
  /// In en, this message translates to:
  /// **'Relationship or family issues'**
  String get mentalHealthReasonRelationship;

  /// No description provided for @mentalHealthReasonTrauma.
  ///
  /// In en, this message translates to:
  /// **'Trauma or grief'**
  String get mentalHealthReasonTrauma;

  /// No description provided for @mentalHealthReasonSelfEsteem.
  ///
  /// In en, this message translates to:
  /// **'Self-esteem or confidence'**
  String get mentalHealthReasonSelfEsteem;

  /// No description provided for @mentalHealthReasonWork.
  ///
  /// In en, this message translates to:
  /// **'Work or academic stress'**
  String get mentalHealthReasonWork;

  /// No description provided for @mentalHealthReasonOther.
  ///
  /// In en, this message translates to:
  /// **'Other (free text)'**
  String get mentalHealthReasonOther;

  /// No description provided for @mentalHealthGoalReduceStress.
  ///
  /// In en, this message translates to:
  /// **'Reduce stress/anxiety'**
  String get mentalHealthGoalReduceStress;

  /// No description provided for @mentalHealthGoalImproveMood.
  ///
  /// In en, this message translates to:
  /// **'Improve mood & motivation'**
  String get mentalHealthGoalImproveMood;

  /// No description provided for @mentalHealthGoalHealthyHabits.
  ///
  /// In en, this message translates to:
  /// **'Build healthy habits (sleep, journaling, exercise)'**
  String get mentalHealthGoalHealthyHabits;

  /// No description provided for @mentalHealthGoalCoping.
  ///
  /// In en, this message translates to:
  /// **'Learn coping strategies'**
  String get mentalHealthGoalCoping;

  /// No description provided for @mentalHealthGoalTalkProfessional.
  ///
  /// In en, this message translates to:
  /// **'Talk to a professional'**
  String get mentalHealthGoalTalkProfessional;

  /// No description provided for @mentalHealthGoalPersonalGrowth.
  ///
  /// In en, this message translates to:
  /// **'Personal growth / mindfulness'**
  String get mentalHealthGoalPersonalGrowth;

  /// No description provided for @lifestyleSupportTitle.
  ///
  /// In en, this message translates to:
  /// **'Lifestyle & Support'**
  String get lifestyleSupportTitle;

  /// No description provided for @exerciseFrequencyQuestion.
  ///
  /// In en, this message translates to:
  /// **'How often do you exercise?'**
  String get exerciseFrequencyQuestion;

  /// No description provided for @exerciseOptionNever.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get exerciseOptionNever;

  /// No description provided for @exerciseOptionOccasionally.
  ///
  /// In en, this message translates to:
  /// **'Occasionally'**
  String get exerciseOptionOccasionally;

  /// No description provided for @exerciseOptionWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get exerciseOptionWeekly;

  /// No description provided for @exerciseOptionDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get exerciseOptionDaily;

  /// No description provided for @substanceUseQuestion.
  ///
  /// In en, this message translates to:
  /// **'How often do you use alcohol or substances?'**
  String get substanceUseQuestion;

  /// No description provided for @substanceOptionNever.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get substanceOptionNever;

  /// No description provided for @substanceOptionOccasionally.
  ///
  /// In en, this message translates to:
  /// **'Occasionally'**
  String get substanceOptionOccasionally;

  /// No description provided for @substanceOptionFrequently.
  ///
  /// In en, this message translates to:
  /// **'Frequently'**
  String get substanceOptionFrequently;

  /// No description provided for @supportSystemQuestion.
  ///
  /// In en, this message translates to:
  /// **'Do you have a strong support system (family/friends)?'**
  String get supportSystemQuestion;

  /// No description provided for @supportOptionYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get supportOptionYes;

  /// No description provided for @supportOptionSomewhat.
  ///
  /// In en, this message translates to:
  /// **'Somewhat'**
  String get supportOptionSomewhat;

  /// No description provided for @supportOptionNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get supportOptionNo;

  /// No description provided for @lifestyleNextButton.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get lifestyleNextButton;

  /// Shows the current page number out of total steps in the lifestyle & support flow
  ///
  /// In en, this message translates to:
  /// **'Page {currentStep} of {totalSteps}'**
  String lifestylePageProgress(Object currentStep, Object totalSteps);

  /// No description provided for @currentMentalHealthTitle.
  ///
  /// In en, this message translates to:
  /// **'Current Mental Health Status'**
  String get currentMentalHealthTitle;

  /// No description provided for @mentalHealthDiagnosisQuestion.
  ///
  /// In en, this message translates to:
  /// **'Have you ever been diagnosed with a mental health condition?'**
  String get mentalHealthDiagnosisQuestion;

  /// No description provided for @mentalHealthFollowUpQuestion.
  ///
  /// In en, this message translates to:
  /// **'Follow-up: Which one(s)?'**
  String get mentalHealthFollowUpQuestion;

  /// No description provided for @seeingProfessionalQuestion.
  ///
  /// In en, this message translates to:
  /// **'Are you currently seeing a mental health professional?'**
  String get seeingProfessionalQuestion;

  /// No description provided for @suicidalThoughtsQuestion.
  ///
  /// In en, this message translates to:
  /// **'Have you ever had suicidal thoughts or self-harm behaviors?'**
  String get suicidalThoughtsQuestion;

  /// No description provided for @diagnosedYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get diagnosedYes;

  /// No description provided for @diagnosedNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get diagnosedNo;

  /// No description provided for @diagnosedPreferNot.
  ///
  /// In en, this message translates to:
  /// **'Prefer not to say'**
  String get diagnosedPreferNot;

  /// No description provided for @seeingProfessionalNone.
  ///
  /// In en, this message translates to:
  /// **'None of the above'**
  String get seeingProfessionalNone;

  /// No description provided for @suicidalYesRecent.
  ///
  /// In en, this message translates to:
  /// **'Yes (recently)'**
  String get suicidalYesRecent;

  /// No description provided for @suicidalYesPast.
  ///
  /// In en, this message translates to:
  /// **'Yes (in the past)'**
  String get suicidalYesPast;

  /// No description provided for @suicidalNever.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get suicidalNever;

  /// No description provided for @followUpPersistentSadness.
  ///
  /// In en, this message translates to:
  /// **'Persistent sadness'**
  String get followUpPersistentSadness;

  /// No description provided for @followUpPanicAttacks.
  ///
  /// In en, this message translates to:
  /// **'Panic attacks'**
  String get followUpPanicAttacks;

  /// No description provided for @followUpSleepDifficulty.
  ///
  /// In en, this message translates to:
  /// **'Difficulty sleeping'**
  String get followUpSleepDifficulty;

  /// No description provided for @followUpLossInterest.
  ///
  /// In en, this message translates to:
  /// **'Loss of interest in activities'**
  String get followUpLossInterest;

  /// No description provided for @followUpConcentrationDifficulty.
  ///
  /// In en, this message translates to:
  /// **'Difficulty concentrating'**
  String get followUpConcentrationDifficulty;

  /// No description provided for @followUpNone.
  ///
  /// In en, this message translates to:
  /// **'None of the above'**
  String get followUpNone;

  /// No description provided for @currentMentalHealthNextButton.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get currentMentalHealthNextButton;

  /// Shows the current page number out of total steps in the mental health flow
  ///
  /// In en, this message translates to:
  /// **'Page {currentStep} of {totalSteps}'**
  String currentMentalHealthPageProgress(Object currentStep, Object totalSteps);

  /// No description provided for @preferencesTitle.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferencesTitle;

  /// No description provided for @preferredSupportTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Preferred type of support:'**
  String get preferredSupportTypeLabel;

  /// No description provided for @preferredTherapistLabel.
  ///
  /// In en, this message translates to:
  /// **'Preferred therapist characteristics:'**
  String get preferredTherapistLabel;

  /// No description provided for @preferredLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'Preferred language:'**
  String get preferredLanguageLabel;

  /// No description provided for @supportOptionSelfHelp.
  ///
  /// In en, this message translates to:
  /// **'Self–help tools (journaling, meditation, exercises)'**
  String get supportOptionSelfHelp;

  /// No description provided for @supportOptionChatProfessional.
  ///
  /// In en, this message translates to:
  /// **'Chat with a professional'**
  String get supportOptionChatProfessional;

  /// No description provided for @supportOptionVideoTherapy.
  ///
  /// In en, this message translates to:
  /// **'Video/voice therapy'**
  String get supportOptionVideoTherapy;

  /// No description provided for @supportOptionPeerSupport.
  ///
  /// In en, this message translates to:
  /// **'Peer community support'**
  String get supportOptionPeerSupport;

  /// No description provided for @therapistOptionMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get therapistOptionMale;

  /// No description provided for @therapistOptionFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get therapistOptionFemale;

  /// No description provided for @therapistOptionNoPreference.
  ///
  /// In en, this message translates to:
  /// **'No preference'**
  String get therapistOptionNoPreference;

  /// No description provided for @languageOptionEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageOptionEnglish;

  /// No description provided for @languageOptionUrdu.
  ///
  /// In en, this message translates to:
  /// **'Urdu'**
  String get languageOptionUrdu;

  /// No description provided for @selectLanguageHint.
  ///
  /// In en, this message translates to:
  /// **'Select language'**
  String get selectLanguageHint;

  /// Shows the current page number out of total steps in the mental health flow
  ///
  /// In en, this message translates to:
  /// **'Step {currentStep} of {totalSteps}'**
  String stepProgress(Object currentStep, Object totalSteps);

  /// No description provided for @consentSafetyTitle.
  ///
  /// In en, this message translates to:
  /// **'Consent & Safety'**
  String get consentSafetyTitle;

  /// No description provided for @consentMessage.
  ///
  /// In en, this message translates to:
  /// **'I understand this app does not replace emergency medical services.'**
  String get consentMessage;

  /// No description provided for @agreeCheckbox.
  ///
  /// In en, this message translates to:
  /// **'Yes, I agree'**
  String get agreeCheckbox;

  /// No description provided for @safetyWarning.
  ///
  /// In en, this message translates to:
  /// **'If you ever feel unsafe or have thoughts of self-harm, please contact your local emergency number immediately.'**
  String get safetyWarning;

  /// No description provided for @submitButton.
  ///
  /// In en, this message translates to:
  /// **'Submit & Go to Login'**
  String get submitButton;

  /// Shows the current page number out of total steps in the mental health flow
  ///
  /// In en, this message translates to:
  /// **'Page {currentStep} of {totalSteps}'**
  String pageProgress(Object currentStep, Object totalSteps);

  /// No description provided for @surveySubmitted.
  ///
  /// In en, this message translates to:
  /// **'Survey submitted successfully!'**
  String get surveySubmitted;

  /// No description provided for @surveySubmitFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit survey'**
  String get surveySubmitFailed;

  /// No description provided for @surveySubmitError.
  ///
  /// In en, this message translates to:
  /// **'Error submitting survey'**
  String get surveySubmitError;

  /// No description provided for @forgotDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter your registered email address to receive a reset code.'**
  String get forgotDescription;

  /// No description provided for @validEmailError.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get validEmailError;

  /// No description provided for @failedToSendOtp.
  ///
  /// In en, this message translates to:
  /// **'Failed to send OTP.'**
  String get failedToSendOtp;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// No description provided for @myActivity.
  ///
  /// In en, this message translates to:
  /// **'My Activity'**
  String get myActivity;

  /// No description provided for @seeMore.
  ///
  /// In en, this message translates to:
  /// **'See More'**
  String get seeMore;

  /// No description provided for @steps.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get steps;

  /// No description provided for @mood.
  ///
  /// In en, this message translates to:
  /// **'Mood'**
  String get mood;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @goal.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get goal;

  /// No description provided for @journal.
  ///
  /// In en, this message translates to:
  /// **'Journal'**
  String get journal;

  /// No description provided for @specialist.
  ///
  /// In en, this message translates to:
  /// **'Specialist'**
  String get specialist;

  /// No description provided for @exercise.
  ///
  /// In en, this message translates to:
  /// **'Exercise'**
  String get exercise;

  /// No description provided for @quoteOfTheDay.
  ///
  /// In en, this message translates to:
  /// **'Quote of the day'**
  String get quoteOfTheDay;

  /// No description provided for @loadingQuote.
  ///
  /// In en, this message translates to:
  /// **'Loading quote...'**
  String get loadingQuote;

  /// No description provided for @loadingMood.
  ///
  /// In en, this message translates to:
  /// **'Loading mood...'**
  String get loadingMood;

  /// No description provided for @noMoodSet.
  ///
  /// In en, this message translates to:
  /// **'No mood set'**
  String get noMoodSet;

  /// No description provided for @article.
  ///
  /// In en, this message translates to:
  /// **'Article'**
  String get article;

  /// No description provided for @forum.
  ///
  /// In en, this message translates to:
  /// **'Forum'**
  String get forum;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @wellness.
  ///
  /// In en, this message translates to:
  /// **'Wellness'**
  String get wellness;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @moodSelection.
  ///
  /// In en, this message translates to:
  /// **'Select Your Mood'**
  String get moodSelection;

  /// No description provided for @selectMood.
  ///
  /// In en, this message translates to:
  /// **'Select Mood'**
  String get selectMood;

  /// No description provided for @moodSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Mood submitted successfully'**
  String get moodSubmitted;

  /// No description provided for @moodSubmitFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit mood'**
  String get moodSubmitFailed;

  /// No description provided for @stepsPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Step counter permission denied'**
  String get stepsPermissionDenied;

  /// No description provided for @stepsError.
  ///
  /// In en, this message translates to:
  /// **'Error accessing step counter'**
  String get stepsError;

  /// No description provided for @spiritualHub.
  ///
  /// In en, this message translates to:
  /// **'Spiritual Hub'**
  String get spiritualHub;

  /// No description provided for @dailyLifeReminders.
  ///
  /// In en, this message translates to:
  /// **'Daily Life Reminders'**
  String get dailyLifeReminders;

  /// No description provided for @guidedMeditations.
  ///
  /// In en, this message translates to:
  /// **'Guided Meditations'**
  String get guidedMeditations;

  /// No description provided for @learnMore.
  ///
  /// In en, this message translates to:
  /// **'Learn More'**
  String get learnMore;

  /// No description provided for @mindfulnessPractitioners.
  ///
  /// In en, this message translates to:
  /// **'Mindfulness Practitioners'**
  String get mindfulnessPractitioners;

  /// No description provided for @noRemindersAvailable.
  ///
  /// In en, this message translates to:
  /// **'No reminders available'**
  String get noRemindersAvailable;

  /// No description provided for @noMeditationsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No meditations available'**
  String get noMeditationsAvailable;

  /// No description provided for @noPractitionersAvailable.
  ///
  /// In en, this message translates to:
  /// **'No practitioners available'**
  String get noPractitionersAvailable;

  /// No description provided for @meditation.
  ///
  /// In en, this message translates to:
  /// **'Meditation {number}'**
  String meditation(int number);

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @bookASession.
  ///
  /// In en, this message translates to:
  /// **'Book a Session'**
  String get bookASession;

  /// No description provided for @downloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading...'**
  String get downloading;

  /// No description provided for @downloadFailed.
  ///
  /// In en, this message translates to:
  /// **'Download failed'**
  String get downloadFailed;

  /// No description provided for @howAreYouFeelingToday.
  ///
  /// In en, this message translates to:
  /// **'How are you feeling today?'**
  String get howAreYouFeelingToday;

  /// No description provided for @todaysJournal.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Journal'**
  String get todaysJournal;

  /// No description provided for @write.
  ///
  /// In en, this message translates to:
  /// **'Write'**
  String get write;

  /// No description provided for @tapWriteToAdd.
  ///
  /// In en, this message translates to:
  /// **'Tap \"Write\" to add a private journal entry'**
  String get tapWriteToAdd;

  /// No description provided for @expressYourThoughts.
  ///
  /// In en, this message translates to:
  /// **'Express your thoughts and feelings safely'**
  String get expressYourThoughts;

  /// No description provided for @saveTodaysMood.
  ///
  /// In en, this message translates to:
  /// **'Save Today\'s Mood'**
  String get saveTodaysMood;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @noNotificationsYet.
  ///
  /// In en, this message translates to:
  /// **'No Notifications Yet'**
  String get noNotificationsYet;

  /// No description provided for @markAsUnread.
  ///
  /// In en, this message translates to:
  /// **'Mark as Unread'**
  String get markAsUnread;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @deleteNotifications.
  ///
  /// In en, this message translates to:
  /// **'Delete Notifications'**
  String get deleteNotifications;

  /// No description provided for @deleteNotificationsConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete all notifications?'**
  String get deleteNotificationsConfirm;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @notificationsCleared.
  ///
  /// In en, this message translates to:
  /// **'All notifications cleared'**
  String get notificationsCleared;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// No description provided for @recentMoods.
  ///
  /// In en, this message translates to:
  /// **'Recent Moods'**
  String get recentMoods;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @whatsInYourMindToday.
  ///
  /// In en, this message translates to:
  /// **'What\'s in your mind today?'**
  String get whatsInYourMindToday;

  /// No description provided for @moodSaved.
  ///
  /// In en, this message translates to:
  /// **'Mood saved successfully'**
  String get moodSaved;

  /// No description provided for @moodSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save mood'**
  String get moodSaveFailed;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @memberSince.
  ///
  /// In en, this message translates to:
  /// **'Member Since'**
  String get memberSince;

  /// No description provided for @thisWeekMode.
  ///
  /// In en, this message translates to:
  /// **'This Week Mode'**
  String get thisWeekMode;

  /// No description provided for @recentAchievements.
  ///
  /// In en, this message translates to:
  /// **'Recent Achievements'**
  String get recentAchievements;

  /// No description provided for @yourAchievements.
  ///
  /// In en, this message translates to:
  /// **'Your Achievements'**
  String get yourAchievements;

  /// No description provided for @unlocked.
  ///
  /// In en, this message translates to:
  /// **'Unlocked'**
  String get unlocked;

  /// No description provided for @noAchievementsYet.
  ///
  /// In en, this message translates to:
  /// **'No achievements yet'**
  String get noAchievementsYet;

  /// No description provided for @loadingAchievements.
  ///
  /// In en, this message translates to:
  /// **'Loading achievements...'**
  String get loadingAchievements;

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get accountSettings;

  /// No description provided for @personalDetails.
  ///
  /// In en, this message translates to:
  /// **'Personal Details'**
  String get personalDetails;

  /// No description provided for @changePhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Change Phone Number'**
  String get changePhoneNumber;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @appSetting.
  ///
  /// In en, this message translates to:
  /// **'App Setting'**
  String get appSetting;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @legal.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get legal;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfUse.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get termsOfUse;

  /// No description provided for @helpAndSupport.
  ///
  /// In en, this message translates to:
  /// **'Help and Support'**
  String get helpAndSupport;

  /// No description provided for @customerSupport.
  ///
  /// In en, this message translates to:
  /// **'Customer Support'**
  String get customerSupport;

  /// No description provided for @faqs.
  ///
  /// In en, this message translates to:
  /// **'FAQs'**
  String get faqs;

  /// No description provided for @rateUs.
  ///
  /// In en, this message translates to:
  /// **'Rate Us'**
  String get rateUs;

  /// No description provided for @languageChanged.
  ///
  /// In en, this message translates to:
  /// **'Language changed. Please restart the app to see changes.'**
  String get languageChanged;

  List<String> get currencyOptions;

  List<String> get locationOptions;

  String  get addMoreCertifications ;

  String get saveChanges ;

  String get addMoreEducation ;

  String get aboutHint ;

  String get about ;

  String get basicInfo ;

  String get changePhoto ;

  String get editProfile ;

  String get profileUpdateFailed ;

  String get profileUpdated ;

  String get ratings ;

  String get hourlyRate ;

  String get addAboutYourself ;

  String get specializations ;

  String get education ;

  String get certifications ;

  String get addEducationCertifications ;

  String get logoutConfirm ;

  String get logOut ;

  String get yes ;

  get currency ;

  get deleteMyAccount ;

  String get sessions ;

  String get upcoming ;

  String get wallet ;

  String get totalEarnings ;

  String get todaysAppointments ;

  String get viewAll ;

  String get initialConsultation ;

  String get feedbackSession ;

  String get crisisSupport ;

  String get view ;

  String get dashboard ;

  String get others ;

  String get notificationSettings ;

  String get emailNotifications ;

  String get receiveNotificationsViaEmail ;

  String get smsNotifications ;

  String get receiveNotificationsViaSMS ;

  String get appointmentReminders ;

  String get getRemindersForUpcomingSessions ;

  String get paymentNotifications ;

  String get getNotifiedAboutPaymentsReceived ;

  String get professionalStatus ;

  String get verificationStatus ;

  String get yourProfessionalCredentials ;

  String get verified ;

  String get licenseNumber ;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ur'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ur': return AppLocalizationsUr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
