import 'app_localizations.dart';

class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get appTitle => 'فکر لیس';

  @override
  String get login => 'لاگ ان';

  @override
  String get signup => 'سائن اپ';

  @override
  String get forgotPassword => 'پاس ورڈ بھول گئے؟';

  @override
  String get emailHint => 'اپنا ای میل درج کریں';

  @override
  String get passwordHint => 'اپنا پاس ورڈ درج کریں';

  @override
  String get otpSent => 'OTP کامیابی سے بھیج دیا گیا!';

  @override
  String get routeNotFound => 'راستہ نہیں ملا';

  // BeforeLogin screen
  @override
  String get getStarted => 'شروع کریں';

  @override
  String get loginTitle => 'آپ کی محفوظ جگہ';

  @override
  String get loginSubtitle => 'دماغی صحت کی دیکھ بھال';

  @override
  String get loginDescription =>
      'FikrLess آپ کو اپنے موڈ کو ٹریک کرنے، سپورٹ سے جڑنے، اور خود کی دیکھ بھال کرنے میں مدد دیتا ہے۔';

  @override
  String get loginButton => 'لاگ ان کریں';

  @override
  String get loginWithPhone => 'فون نمبر کے ساتھ لاگ ان کریں';

  @override
  String get loginWithEmail => 'ای میل کے ساتھ لاگ ان کریں';

  @override
  String get loginPrompt => 'اکاؤنٹ نہیں ہے؟ ';

  @override
  String get signupLink => 'سائن اپ';

  @override
  String get loginSuccess => 'لاگ ان کامیاب ✅';

  @override
  String get loginFailed => 'لاگ ان ناکام ❌';

  @override
  String get networkError => 'نیٹ ورک کی خرابی: ';

  // ChooseWhoAreYouScreen
  @override
  String get chooseTitle => 'آپ کون ہیں منتخب کریں؟';

  @override
  String get chooseSubtitle => 'براہ کرم سائن اپ کے لیے اپنا کردار منتخب کریں۔';

  @override
  String get signupSpecialist => 'ماہر کے طور پر سائن اپ کریں';

  @override
  String get signupUser => 'صارف کے طور پر سائن اپ کریں';

  // UserSignUpScreen
  @override
  String get signupTitle => 'سائن اپ';

  @override
  String get signupSubtitle =>
      'اپنا اکاؤنٹ رجسٹر کرنے کے لیے نیچے دیے گئے فیلڈز کو پُر کریں تاکہ ایپ کی تمام خصوصیات تک رسائی حاصل ہو۔';

  @override
  String get phoneLabel => 'فون نمبر';

  @override
  String get phoneHint => 'اپنا فون نمبر درج کریں';

  @override
  String get phoneErrorEmpty => 'براہ کرم فون نمبر درج کریں';

  @override
  String get phoneErrorInvalid => 'درست فون نمبر درج کریں';

  @override
  String get passwordLabel => 'پاس ورڈ';

  @override
  String get passwordErrorEmpty => 'براہ کرم پاس ورڈ درج کریں';

  @override
  String get passwordErrorShort =>
      'پاس ورڈ کم از کم 6 حروف پر مشتمل ہونا چاہیے';

  @override
  String get termsText => 'میں اتفاق کرتا ہوں ';

  @override
  String get termsPolicy => 'شرائط و ضوابط';

  @override
  String get termsError => 'براہ کرم شرائط و ضوابط سے اتفاق کریں';

  @override
  String get signupButton => 'سائن اپ';

  @override
  String get signupWithEmail => 'ای میل کے ساتھ سائن اپ کریں';

  @override
  String get loginPromptExisting => 'پہلے سے اکاؤنٹ موجود ہے؟ ';

  @override
  String get loginLink => 'لاگ ان کریں';

  // userVerifiedScreen
  @override
  String get userVerifiedTitle => 'کامیابی کے ساتھ تصدیق شدہ';

  @override
  String userVerifiedPhoneMessage(String maskedContact) =>
      'آپ کا فون نمبر $maskedContact\nکامیابی کے ساتھ تصدیق ہو گیا ہے۔\nاب آپ لاگ ان کے ساتھ آگے بڑھ سکتے ہیں۔';

  @override
  String userVerifiedEmailMessage(String maskedContact) =>
      'آپ کا ای میل $maskedContact\nکامیابی کے ساتھ تصدیق ہو گیا ہے۔\nاب آپ لاگ ان کے ساتھ آگے بڑھ سکتے ہیں۔';

  @override
  String get setUpProfile => 'پروفائل سیٹ کریں';

  // OTP Verification screen
  @override
  String get enterOtpTitle => 'OTP درج کریں';

  @override
  String otpSentMessagePhone(String contactValue) =>
      'ہم نے آپ کے فون نمبر $contactValue پر OTP بھیجا ہے۔\nبراہ کرم اپنے پیغامات چیک کریں اور OTP درج کریں۔';

  @override
  String otpSentMessageEmail(String contactValue) =>
      'ہم نے آپ کے ای میل $contactValue پر OTP بھیجا ہے۔\nبراہ کرم اپنا ان باکس چیک کریں اور OTP درج کریں۔';

  @override
  String get resendCode => 'کوڈ دوبارہ بھیجیں';

  @override
  String get didNotGetCode => 'کوڈ نہیں ملا؟ ';

  @override
  String get submit => 'جمع کریں';

  @override
  String get editPhoneNumber => 'فون نمبر تبدیل کریں';

  @override
  String get editEmailAddress => 'ای میل ایڈریس تبدیل کریں';

  @override
  String get invalidOtpMessage => 'براہ کرم درست 4 ہندسوں کا OTP درج کریں';

  @override
  String get passwordResetSuccessMessage =>
      'آپ کا پاس ورڈ کامیابی کے ساتھ تبدیل ہو گیا ہے۔\nاب آپ لاگ ان کے ساتھ آگے بڑھ سکتے ہیں۔';

  // ResetPasswordScreen
  @override
  String get resetPasswordTitle => 'پاس ورڈ ری سیٹ کریں';

  @override
  String resetPasswordDescription(String contactValue) =>
      'پاس ورڈ ری سیٹ کیا جا رہا ہے $contactValue کے لیے';

  @override
  String get newPasswordLabel => 'نیا پاس ورڈ';

  @override
  String get confirmPasswordLabel => 'نیا پاس ورڈ دوبارہ درج کریں';

  @override
  String get enterNewPasswordHint => 'اپنا نیا پاس ورڈ درج کریں';

  @override
  String get reEnterPasswordHint => 'اپنا پاس ورڈ دوبارہ درج کریں';

  @override
  String get newPasswordErrorEmpty => 'براہ کرم اپنا نیا پاس ورڈ درج کریں';

  @override
  String get newPasswordErrorWeak =>
      'پاس ورڈ میں 4+ حروف، 1 بڑا حرف، 1 نمبر اور 1 خصوصی کردار ہونا چاہیے';

  @override
  String get confirmPasswordErrorEmpty =>
      'براہ کرم اپنا پاس ورڈ دوبارہ درج کریں';

  @override
  String get confirmPasswordErrorMismatch => 'پاس ورڈ مماثل نہیں ہیں';

  // ------------------ Basic Information ------------------
  @override
  String get basicInformationTitle => 'بنیادی معلومات';

  @override
  String get fullNameLabel => 'پورا نام';

  @override
  String get fullNameHint => 'اپنا پورا نام درج کریں';

  @override
  String get designationLabel => 'عہدہ';

  @override
  String get designationHint => 'اپنا عہدہ درج کریں';

  @override
  String get locationLabel => 'مقام';

  @override
  List<String> get locationOptions => [
    'کراچی، پاکستان',
    'لاہور، پاکستان',
    'اسلام آباد، پاکستان',
  ];

  @override
  String get hourlyRateLabel => 'گھنٹہ وار فیس';

  @override
  String get hourlyRateHint => 'گھنٹہ وار فیس درج کریں';

  @override
  List<String> get currencyOptions => ['PKR', 'USD', 'GBP'];

  @override
  String get specializationLabel => 'تخصص';

  @override
  String get addSpecialization => 'تخصص شامل کریں';

  @override
  String get languagesLabel => 'زبانیں';

  @override
  String get addLanguage => 'زبان شامل کریں';

  @override
  String get addChipButton => '+ شامل کریں';

  @override
  String get nextButton => 'اگلا';

  @override
  String addDialogTitle(String title) => '$title';

  @override
  String get addDialogHint => 'نیا آئٹم درج کریں';

  @override
  String get cancelButton => 'منسوخ کریں';

  @override
  String get addButton => 'شامل کریں';

  // ------------------ Education & Certifications ------------------
  @override
  String get educationCertificationsTitle => 'تعلیم اور سرٹیفیکیشنز';

  @override
  String get educationSectionTitle => '🎓 تعلیم';

  @override
  String get certificationsSectionTitle => '📜 سرٹیفیکیشنز';

  @override
  List<String> get educationFields => ['ڈگری', 'ادارہ'];

  @override
  List<String> get certificationFields => ['سرٹیفیکیشن کا عنوان', 'پروائیڈر'];

  @override
  String get degreeHint => 'ڈگری درج کریں';

  @override
  String get instituteHint => 'ادارہ درج کریں';

  @override
  String get certificateHint => 'سرٹیفیکیشن کا عنوان درج کریں';

  @override
  String get providerHint => 'پروائیڈر درج کریں';

  @override
  String get removeButton => 'حذف کریں';

  @override
  String get addMoreButton => 'مزید شامل کریں';

  @override
  String get certificationFieldProvider => 'پروائیڈر';

  @override
  String get certificationFieldTitle => 'سرٹیفیکیشن کا عنوان';

  @override
  String get educationFieldDegree => 'ڈگری';

  @override
  String get educationFieldInstitute => 'ادارہ';

  // ------------------ Basic Demographics ------------------
  @override
  String get basicDemographicsTitle => 'بنیادی آبادیات';

  @override
  String get basicDemographicsSubtitle =>
      'ہمیں آپ کے بارے میں جاننے میں مدد کریں';

  @override
  String get ageLabel => 'عمر';

  @override
  String get genderIdentityLabel => 'صنف';

  @override
  String get countryLabel => 'ملکِ رہائش';

  @override
  String get relationshipStatusLabel => 'رشتہ کی حالت';

  @override
  String get ageOption1 => '16 – 25';
  @override
  String get ageOption2 => '26 – 35';
  @override
  String get ageOption3 => '36 – 45';
  @override
  String get ageOption4 => '46+';

  @override
  String get countryOption1 => 'کراچی، پاکستان';
  @override
  String get countryOption2 => 'لاہور، پاکستان';
  @override
  String get countryOption3 => 'اسلام آباد، پاکستان';
  @override
  String get countryOption4 => 'ملتان، پاکستان';
  @override
  String get countryOption5 => 'دیگر';

  @override
  String get genderMale => 'مرد';
  @override
  String get genderFemale => 'خاتون';
  @override
  String get genderPreferNotToSay => 'کہنا مناسب نہیں';

  @override
  String get relationshipSingle => 'اکیلا';
  @override
  String get relationshipInRelationship => 'رشتے میں';
  @override
  String get relationshipMarried => 'شادی شدہ';
  @override
  String get relationshipDivorced => 'طلاق یافتہ';
  @override
  String get relationshipWidowed => 'بیوہ/بیوہا';

  @override
  String get disclaimerTitle => 'دستبرداری';

  @override
  String get disclaimerDescription =>
      'یہ ڈیٹا جمع کرنے کے مقصد کے لیے ہے تاکہ ایپ کو آپ کی ضروریات کے مطابق ڈھالا جا سکے۔';

  @override
  String get submittingButton => 'جمع کر رہا ہے...';

  @override
  String pageProgressText(int currentStep, int totalSteps) =>
      'صفحہ $currentStep از $totalSteps';

  // ------------------ Mental Health Section ------------------
  @override
  String get mentalHealthGoalsTitle => 'دماغی صحت کے اہداف';

  @override
  String get mentalHealthReasonsTitle => 'آج آپ یہاں کیوں ہیں؟';

  @override
  String get mentalHealthOtherHint => 'براہ کرم وضاحت کریں...';

  @override
  String get mentalHealthGoalsSectionTitle =>
      'اس ایپ کے استعمال کے لیے آپ کے اہداف کیا ہیں؟ (اوپر سے 2 منتخب کریں)';

  @override
  String get mentalHealthNextButton => 'اگلا';

  @override
  String get mentalHealthSelectError =>
      'براہ کرم کم از کم ایک وجہ اور ایک ہدف منتخب کریں۔';

  @override
  String mentalHealthPageProgress(int currentStep, int totalSteps) =>
      'صفحہ $currentStep از $totalSteps';

  @override
  String get mentalHealthReasonAnxiety => 'پریشانی یا دباؤ';
  @override
  String get mentalHealthReasonDepression => 'ڈپریشن یا موڈ میں کمی';
  @override
  String get mentalHealthReasonRelationship => 'رشتے یا خاندانی مسائل';
  @override
  String get mentalHealthReasonTrauma => 'صدمہ یا غم';
  @override
  String get mentalHealthReasonSelfEsteem => 'اعتماد یا خود اعتمادی';
  @override
  String get mentalHealthReasonWork => 'کام یا تعلیمی دباؤ';
  @override
  String get mentalHealthReasonOther => 'دیگر (تحریری وضاحت)';

  @override
  String get mentalHealthGoalReduceStress => 'پریشانی/دباؤ کم کریں';
  @override
  String get mentalHealthGoalImproveMood => 'موڈ اور حوصلہ بہتر کریں';
  @override
  String get mentalHealthGoalHealthyHabits =>
      'صحت مند عادات بنائیں (نیند، جرنلنگ، ورزش)';
  @override
  String get mentalHealthGoalCoping => 'مقابلہ کرنے کی حکمت عملی سیکھیں';
  @override
  String get mentalHealthGoalTalkProfessional => 'ماہر سے بات کریں';
  @override
  String get mentalHealthGoalPersonalGrowth => 'ذاتی ترقی / ذہنی آگاہی';

  // ------------------ Current Mental Health Section ------------------
  @override
  String get currentMentalHealthTitle => 'موجودہ دماغی صحت کی حالت';

  @override
  String get mentalHealthDiagnosisQuestion =>
      'کیا آپ کو کبھی کسی دماغی صحت کی بیماری کی تشخیص ہوئی ہے؟';

  @override
  String get mentalHealthFollowUpQuestion => 'پیروی: کونسی؟';

  @override
  String get seeingProfessionalQuestion =>
      'کیا آپ اس وقت کسی دماغی صحت کے ماہر سے ملاقات کر رہے ہیں؟';

  @override
  String get suicidalThoughtsQuestion =>
      'کیا آپ نے کبھی خودکشی کے خیالات یا خود کو نقصان پہنچانے کا سوچا ہے؟';

  @override
  String get diagnosedYes => 'ہاں';
  @override
  String get diagnosedNo => 'نہیں';
  @override
  String get diagnosedPreferNot => 'کہنا مناسب نہیں';

  @override
  String get seeingProfessionalNone => 'مندرجہ بالا میں سے کوئی نہیں';

  @override
  String get suicidalYesRecent => 'ہاں (حال ہی میں)';
  @override
  String get suicidalYesPast => 'ہاں (ماضی میں)';
  @override
  String get suicidalNever => 'کبھی نہیں';

  @override
  String get followUpPersistentSadness => 'مسلسل اداسی';
  @override
  String get followUpPanicAttacks => 'پینک اٹیک';
  @override
  String get followUpSleepDifficulty => 'نیند میں مشکلات';
  @override
  String get followUpLossInterest => 'سرگرمیوں میں دلچسپی کی کمی';
  @override
  String get followUpConcentrationDifficulty => 'توجہ مرکوز کرنے میں مشکلات';
  @override
  String get followUpNone => 'مندرجہ بالا میں سے کوئی نہیں';

  @override
  String get currentMentalHealthNextButton => 'اگلا';

  @override
  String currentMentalHealthPageProgress(int currentStep, int totalSteps) =>
      'صفحہ $currentStep از $totalSteps';

  // ------------------ Lifestyle & Support Section ------------------
  @override
  String get lifestyleSupportTitle => 'طرز زندگی اور سپورٹ';

  @override
  String get exerciseFrequencyQuestion => 'آپ کتنی بار ورزش کرتے ہیں؟';
  @override
  String get exerciseOptionNever => 'کبھی نہیں';
  @override
  String get exerciseOptionOccasionally => 'کبھی کبھار';
  @override
  String get exerciseOptionWeekly => 'ہفتہ وار';
  @override
  String get exerciseOptionDaily => 'روزانہ';

  @override
  String get substanceUseQuestion =>
      'آپ کتنی بار الکحل یا دیگر مادے استعمال کرتے ہیں؟';
  @override
  String get substanceOptionNever => 'کبھی نہیں';
  @override
  String get substanceOptionOccasionally => 'کبھی کبھار';
  @override
  String get substanceOptionFrequently => 'بار بار';

  @override
  String get supportSystemQuestion =>
      'کیا آپ کے پاس مضبوط سپورٹ سسٹم ہے (خاندان/دوست)؟';
  @override
  String get supportOptionYes => 'ہاں';
  @override
  String get supportOptionSomewhat => 'کچھ حد تک';
  @override
  String get supportOptionNo => 'نہیں';

  @override
  String get lifestyleNextButton => 'اگلا';

  @override
  String lifestylePageProgress(int currentStep, int totalSteps) =>
      'صفحہ $currentStep از $totalSteps';

  // ---------------- PreferencesScreen ----------------
  @override
  String get preferencesTitle => 'ترجیحات';

  @override
  String get preferredSupportTypeLabel => 'مدد کی پسندیدہ قسم:';
  @override
  String get preferredTherapistLabel => 'معالج کی پسندیدہ خصوصیات:';
  @override
  String get preferredLanguageLabel => 'پسندیدہ زبان:';

  @override
  String get supportOptionSelfHelp =>
      'ذاتی مدد کے اوزار (جرنل لکھنا، مراقبہ، ورزش)';
  @override
  String get supportOptionChatProfessional => 'پروفیشنل کے ساتھ چیٹ کریں';
  @override
  String get supportOptionVideoTherapy => 'ویڈیو/آڈیو تھراپی';
  @override
  String get supportOptionPeerSupport => 'ہم عمر کمیونٹی سپورٹ';

  @override
  String get therapistOptionMale => 'مرد';
  @override
  String get therapistOptionFemale => 'خاتون';
  @override
  String get therapistOptionNoPreference => 'کوئی ترجیح نہیں';

  @override
  String get languageOptionEnglish => 'انگریزی';
  @override
  String get languageOptionUrdu => 'اردو';
  @override
  String get selectLanguageHint => 'زبان منتخب کریں';

  @override
  String stepProgress(int currentStep, int totalSteps) =>
      'مرحلہ $currentStep میں سے $totalSteps';

  // ---------------- ConsentSafetyScreen ----------------
  @override
  String get consentSafetyTitle => 'رضامندی اور حفاظت';

  @override
  String get consentMessage =>
      'میں سمجھتا ہوں کہ یہ ایپ ایمرجنسی طبی خدمات کی جگہ نہیں لے سکتی۔';
  @override
  String get agreeCheckbox => 'ہاں، میں متفق ہوں';

  @override
  String get safetyWarning =>
      'اگر آپ کو کبھی خطرہ محسوس ہو یا خود کو نقصان پہنچانے کے خیالات ہوں، تو فوراً اپنے مقامی ایمرجنسی نمبر سے رابطہ کریں۔';

  @override
  String get submitButton => 'جمع کریں اور لاگ ان پر جائیں';
  @override
  String pageProgress(int currentStep, int totalSteps) =>
      'صفحہ $currentStep میں سے $totalSteps';

  @override
  String get surveySubmitted => 'Survey submitted successfully!';

  @override
  String get surveySubmitFailed => 'Failed to submit survey';

  @override
  String get surveySubmitError => 'Error submitting survey';
  @override
  String get forgotDescription =>
      'ری سیٹ کوڈ حاصل کرنے کے لیے اپنا رجسٹرڈ ای میل ایڈریس درج کریں۔';

  @override
  String get validEmailError => 'درست ای میل ایڈریس درج کریں';

  @override
  String get failedToSendOtp => 'او ٹی پی بھیجنے میں ناکامی';

  @override
  String get back => 'واپس';
}
