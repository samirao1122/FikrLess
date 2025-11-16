// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get appTitle => 'فکر لیس';

  @override
  String get getStarted => 'شروع کریں';

  @override
  String get routeNotFound => 'راستہ نہیں ملا';

  @override
  String get login => 'لاگ ان';

  @override
  String get loginTitle => 'آپ کی محفوظ جگہ';

  @override
  String get loginSubtitle => 'دماغی صحت کی دیکھ بھال';

  @override
  String get loginDescription => 'فکر لیس آپ کو اپنے موڈ کو ٹریک کرنے، مدد سے جڑنے اور خود کی دیکھ بھال کرنے میں مدد دیتا ہے۔';

  @override
  String get forgotPassword => 'پاس ورڈ بھول گئے؟';

  @override
  String get emailHint => 'اپنا ای میل درج کریں';

  @override
  String get passwordHint => 'اپنا پاس ورڈ درج کریں';

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
  String get phoneErrorInvalid => 'درست فون نمبر درج کریں';

  @override
  String get phoneErrorEmpty => 'براہ کرم فون نمبر درج کریں';

  @override
  String get passwordErrorEmpty => 'براہ کرم پاس ورڈ درج کریں';

  @override
  String get passwordErrorShort => 'پاس ورڈ کم از کم 6 حروف کا ہونا چاہیے';

  @override
  String get loginSuccess => 'لاگ ان کامیاب ✅';

  @override
  String get loginFailed => 'لاگ ان ناکام ❌';

  @override
  String get networkError => 'نیٹ ورک کی خرابی: ';

  @override
  String get chooseTitle => 'آپ کون ہیں منتخب کریں؟';

  @override
  String get chooseSubtitle => 'براہ کرم سائن اپ کے لیے اپنا کردار منتخب کریں۔';

  @override
  String get signupSpecialist => 'ماہر کے طور پر سائن اپ کریں';

  @override
  String get signupUser => 'صارف کے طور پر سائن اپ کریں';

  @override
  String get signupTitle => 'سائن اپ';

  @override
  String get signupSubtitle => 'اپنا اکاؤنٹ رجسٹر کرنے کے لیے، نیچے دیے گئے فیلڈز پُر کریں تاکہ آپ ایپ کی تمام خصوصیات تک رسائی حاصل کر سکیں۔';

  @override
  String get phoneLabel => 'فون نمبر';

  @override
  String get phoneHint => 'اپنا فون نمبر درج کریں';

  @override
  String get passwordLabel => 'پاس ورڈ';

  @override
  String get termsText => 'میں متفق ہوں ';

  @override
  String get termsPolicy => 'شرائط و پالیسی';

  @override
  String get termsError => 'براہ کرم شرائط و پالیسی سے اتفاق کریں';

  @override
  String get signupButton => 'سائن اپ';

  @override
  String get signupWithEmail => 'ای میل کے ساتھ سائن اپ کریں';

  @override
  String get loginPromptExisting => 'پہلے سے اکاؤنٹ موجود ہے؟ ';

  @override
  String get loginLink => 'لاگ ان کریں';

  @override
  String get otpSent => 'OTP کامیابی سے بھیج دیا گیا!';

  @override
  String get userVerifiedTitle => 'کامیابی کے ساتھ تصدیق شدہ';

  @override
  String userVerifiedPhoneMessage(Object maskedContact) {
    return 'آپ کا فون نمبر $maskedContact\nکامیابی کے ساتھ تصدیق ہو گیا ہے۔\nاب آپ لاگ ان کے ساتھ آگے بڑھ سکتے ہیں۔';
  }

  @override
  String userVerifiedEmailMessage(Object maskedContact) {
    return 'آپ کا ای میل $maskedContact\nکامیابی کے ساتھ تصدیق ہو گیا ہے۔\nاب آپ لاگ ان کے ساتھ آگے بڑھ سکتے ہیں۔';
  }

  @override
  String get setUpProfile => 'پروفائل سیٹ کریں';

  @override
  String get enterOtpTitle => 'OTP درج کریں';

  @override
  String otpSentMessagePhone(Object contactValue) {
    return 'ہم نے آپ کے فون نمبر $contactValue پر OTP بھیج دیا ہے۔\nبراہ کرم اپنے پیغامات چیک کریں اور OTP درج کریں۔';
  }

  @override
  String otpSentMessageEmail(Object contactValue) {
    return 'ہم نے آپ کے ای میل $contactValue پر OTP بھیج دیا ہے۔\nبراہ کرم اپنا ان باکس چیک کریں اور OTP درج کریں۔';
  }

  @override
  String get resendCode => 'کوڈ دوبارہ بھیجیں';

  @override
  String get didNotGetCode => 'کوڈ نہیں ملا؟ ';

  @override
  String get submit => 'جمع کروائیں';

  @override
  String get editPhoneNumber => 'فون نمبر تبدیل کریں';

  @override
  String get editEmailAddress => 'ای میل ایڈریس تبدیل کریں';

  @override
  String get invalidOtpMessage => 'براہ کرم 4 ہندسوں کا درست OTP درج کریں';

  @override
  String get passwordResetSuccessMessage => 'آپ کا پاس ورڈ کامیابی سے تبدیل ہو گیا ہے۔\nاب آپ لاگ ان کے ساتھ آگے بڑھ سکتے ہیں۔';

  @override
  String get resetPasswordTitle => 'پاس ورڈ ری سیٹ کریں';

  @override
  String resetPasswordDescription(Object contactValue) {
    return '$contactValue کے لیے پاس ورڈ ری سیٹ ہو رہا ہے';
  }

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
  String get newPasswordErrorWeak => 'پاس ورڈ میں 4+ حروف، 1 بڑا حرف، 1 نمبر اور 1 خاص حرف ہونا چاہیے';

  @override
  String get confirmPasswordErrorEmpty => 'براہ کرم اپنا پاس ورڈ دوبارہ درج کریں';

  @override
  String get confirmPasswordErrorMismatch => 'پاس ورڈ میل نہیں کھاتے';

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
  String get locationKarachi => 'کراچی، پاکستان';

  @override
  String get locationLahore => 'لاہور، پاکستان';

  @override
  String get locationIslamabad => 'اسلام آباد، پاکستان';

  @override
  String get locationMultan => 'ملتان، پاکستان';

  @override
  String get locationOther => 'دیگر';

  @override
  String get hourlyRateLabel => 'فی گھنٹہ ریٹ';

  @override
  String get hourlyRateHint => 'فی گھنٹہ ریٹ';

  @override
  String get currencyPKR => 'روپے (PKR)';

  @override
  String get currencyUSD => 'ڈالر (USD)';

  @override
  String get currencyGBP => 'پاؤنڈ (GBP)';

  @override
  String get specializationLabel => 'مہارت';

  @override
  String get addSpecialization => 'مہارت شامل کریں';

  @override
  String get languagesLabel => 'زبانیں';

  @override
  String get addLanguage => 'زبان شامل کریں';

  @override
  String get addChipButton => '+ شامل کریں';

  @override
  String get nextButton => 'اگلا';

  @override
  String addDialogTitle(Object title) {
    return '$title';
  }

  @override
  String get addDialogHint => 'نئی چیز درج کریں';

  @override
  String get cancelButton => 'منسوخ کریں';

  @override
  String get addButton => 'شامل کریں';

  @override
  String get educationCertificationsTitle => 'تعلیم اور سرٹیفیکیشنز';

  @override
  String get educationSectionTitle => '🎓 تعلیم';

  @override
  String get certificationsSectionTitle => '📜 سرٹیفیکیشنز';

  @override
  String get educationFieldDegree => 'ڈگری';

  @override
  String get educationFieldInstitute => 'ادارہ کا نام';

  @override
  String get certificationFieldTitle => 'سرٹیفکیٹ کا عنوان';

  @override
  String get certificationFieldProvider => 'ادارہ';

  @override
  String get degreeHint => 'ڈگری درج کریں';

  @override
  String get instituteHint => 'ادارہ کا نام درج کریں';

  @override
  String get certificateHint => 'سرٹیفکیٹ کا عنوان درج کریں';

  @override
  String get providerHint => 'ادارہ درج کریں';

  @override
  String get removeButton => 'ہٹائیں';

  @override
  String get addMoreButton => 'مزید شامل کریں';

  @override
  String get basicDemographicsTitle => 'بنیادی آبادی کی معلومات';

  @override
  String get basicDemographicsSubtitle => 'ہمیں جاننے میں مدد کریں';

  @override
  String get ageLabel => 'عمر';

  @override
  String get genderIdentityLabel => 'صنف';

  @override
  String get countryLabel => 'رہائش کا ملک';

  @override
  String get relationshipStatusLabel => 'ازدواجی حیثیت';

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
  String get genderPreferNotToSay => 'کہنے سے گریز کریں';

  @override
  String get relationshipSingle => 'اکیلے';

  @override
  String get relationshipInRelationship => 'رشتہ میں';

  @override
  String get relationshipMarried => 'شادی شدہ';

  @override
  String get relationshipDivorced => 'طلاق شدہ';

  @override
  String get relationshipWidowed => 'بیوہ/بیوہ';

  @override
  String get disclaimerTitle => 'ڈسکلیمر';

  @override
  String get disclaimerDescription => 'یہ ڈیٹا اکٹھا کرنے کے لیے ہے تاکہ ایپ آپ کی ضروریات کے مطابق ہو۔';

  @override
  String get submittingButton => 'جمع کر رہے ہیں...';

  @override
  String pageProgressText(Object currentStep, Object totalSteps) {
    return 'صفحہ $currentStep از $totalSteps';
  }

  @override
  String get mentalHealthGoalsTitle => 'دماغی صحت کے اہداف';

  @override
  String get mentalHealthReasonsTitle => 'آپ آج یہاں کیوں آئے ہیں؟';

  @override
  String get mentalHealthOtherHint => 'براہ کرم وضاحت کریں...';

  @override
  String get mentalHealthGoalsSectionTitle => 'اس ایپ کے استعمال کے اپنے اہداف کیا ہیں؟ (سب سے اوپر 2 منتخب کریں)';

  @override
  String get mentalHealthNextButton => 'اگلا';

  @override
  String get mentalHealthSelectError => 'براہ کرم کم از کم ایک وجہ اور ایک مقصد منتخب کریں۔';

  @override
  String mentalHealthPageProgress(Object currentStep, Object totalSteps) {
    return 'صفحہ $currentStep از $totalSteps';
  }

  @override
  String get mentalHealthReasonAnxiety => 'فکر یا دباؤ';

  @override
  String get mentalHealthReasonDepression => 'اداسی یا موڈ میں کمی';

  @override
  String get mentalHealthReasonRelationship => 'رشتہ یا خاندانی مسائل';

  @override
  String get mentalHealthReasonTrauma => 'صدمہ یا غم';

  @override
  String get mentalHealthReasonSelfEsteem => 'خود اعتمادی یا اعتماد';

  @override
  String get mentalHealthReasonWork => 'کام یا تعلیمی دباؤ';

  @override
  String get mentalHealthReasonOther => 'دیگر (متن میں درج کریں)';

  @override
  String get mentalHealthGoalReduceStress => 'فکر/دباؤ کم کریں';

  @override
  String get mentalHealthGoalImproveMood => 'موڈ اور حوصلہ بڑھائیں';

  @override
  String get mentalHealthGoalHealthyHabits => 'صحت مند عادات بنائیں (نیند، جرنلنگ، ورزش)';

  @override
  String get mentalHealthGoalCoping => 'مددگار حکمت عملی سیکھیں';

  @override
  String get mentalHealthGoalTalkProfessional => 'پیشہ ور سے بات کریں';

  @override
  String get mentalHealthGoalPersonalGrowth => 'ذاتی نشوونما / ذہنی سکون';

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
  String get substanceUseQuestion => 'آپ کتنی بار شراب یا منشیات استعمال کرتے ہیں؟';

  @override
  String get substanceOptionNever => 'کبھی نہیں';

  @override
  String get substanceOptionOccasionally => 'کبھی کبھار';

  @override
  String get substanceOptionFrequently => 'اکثر';

  @override
  String get supportSystemQuestion => 'کیا آپ کے پاس مضبوط معاون نظام ہے (خاندان/دوست)؟';

  @override
  String get supportOptionYes => 'ہاں';

  @override
  String get supportOptionSomewhat => 'کچھ حد تک';

  @override
  String get supportOptionNo => 'نہیں';

  @override
  String get lifestyleNextButton => 'اگلا';

  @override
  String lifestylePageProgress(Object currentStep, Object totalSteps) {
    return 'صفحہ $currentStep از $totalSteps';
  }

  @override
  String get currentMentalHealthTitle => 'موجودہ دماغی صحت کی صورتحال';

  @override
  String get mentalHealthDiagnosisQuestion => 'کیا آپ کو کبھی دماغی صحت کی بیماری کی تشخیص ہوئی ہے؟';

  @override
  String get mentalHealthFollowUpQuestion => 'فالو اپ: کون سی؟';

  @override
  String get seeingProfessionalQuestion => 'کیا آپ اس وقت کسی دماغی صحت کے ماہر سے ملاقات کر رہے ہیں؟';

  @override
  String get suicidalThoughtsQuestion => 'کیا آپ نے کبھی خودکشی یا خود کو نقصان پہنچانے کے خیالات رکھے ہیں؟';

  @override
  String get diagnosedYes => 'ہاں';

  @override
  String get diagnosedNo => 'نہیں';

  @override
  String get diagnosedPreferNot => 'کہنے سے گریز کریں';

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
  String get followUpSleepDifficulty => 'نیند میں دشواری';

  @override
  String get followUpLossInterest => 'سرگرمیوں میں دلچسپی کا نقصان';

  @override
  String get followUpConcentrationDifficulty => 'توجہ مرکوز کرنے میں مشکل';

  @override
  String get followUpNone => 'مندرجہ بالا میں سے کوئی نہیں';

  @override
  String get currentMentalHealthNextButton => 'اگلا';

  @override
  String currentMentalHealthPageProgress(Object currentStep, Object totalSteps) {
    return 'صفحہ $currentStep از $totalSteps';
  }

  @override
  String get preferencesTitle => 'ترجیحات';

  @override
  String get preferredSupportTypeLabel => 'مدد کی پسندیدہ قسم:';

  @override
  String get preferredTherapistLabel => 'تھراپسٹ کی خصوصیات کی ترجیح:';

  @override
  String get preferredLanguageLabel => 'پسندیدہ زبان:';

  @override
  String get supportOptionSelfHelp => 'خود مدد کے اوزار (جرنلنگ، مراقبہ، مشقیں)';

  @override
  String get supportOptionChatProfessional => 'پیشہ ور کے ساتھ چیٹ';

  @override
  String get supportOptionVideoTherapy => 'ویڈیو/آواز تھراپی';

  @override
  String get supportOptionPeerSupport => 'ساتھی کمیونٹی کی حمایت';

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
  String stepProgress(Object currentStep, Object totalSteps) {
    return 'مرحلہ $currentStep از $totalSteps';
  }

  @override
  String get consentSafetyTitle => 'رضامندی اور حفاظت';

  @override
  String get consentMessage => 'میں سمجھتا/سمجھتی ہوں کہ یہ ایپ ہنگامی طبی خدمات کی جگہ نہیں لے سکتی۔';

  @override
  String get agreeCheckbox => 'ہاں، میں متفق ہوں';

  @override
  String get safetyWarning => 'اگر آپ خود کو غیر محفوظ محسوس کریں یا خود کو نقصان پہنچانے کے خیالات ہوں، تو براہ کرم فوری طور پر اپنے مقامی ہنگامی نمبر پر رابطہ کریں۔';

  @override
  String get submitButton => 'جمع کریں اور لاگ ان پر جائیں';

  @override
  String pageProgress(Object currentStep, Object totalSteps) {
    return 'صفحہ $currentStep از $totalSteps';
  }

  @override
  String get surveySubmitted => 'سروے کامیابی سے جمع ہو گیا!';

  @override
  String get surveySubmitFailed => 'سروے جمع کرنے میں ناکامی';

  @override
  String get surveySubmitError => 'سروے جمع کرنے میں خرابی';

  @override
  String get forgotDescription => 'ری سیٹ کوڈ حاصل کرنے کے لیے اپنا رجسٹرڈ ای میل ایڈریس درج کریں۔';

  @override
  String get validEmailError => 'درست ای میل ایڈریس درج کریں';

  @override
  String get failedToSendOtp => 'او ٹی پی بھیجنے میں ناکامی';

  @override
  String get back => 'واپس';

  @override
  String get homeTitle => 'ہوم';

  @override
  String get myActivity => 'میری سرگرمی';

  @override
  String get seeMore => 'مزید دیکھیں';

  @override
  String get steps => 'قدم';

  @override
  String get mood => 'موڈ';

  @override
  String get quickActions => 'فوری اعمال';

  @override
  String get goal => 'ہدف';

  @override
  String get journal => 'جرنل';

  @override
  String get specialist => 'ماہر';

  @override
  String get exercise => 'ورزش';

  @override
  String get quoteOfTheDay => 'آج کا اقتباس';

  @override
  String get loadingQuote => 'اقتباس لوڈ ہو رہا ہے...';

  @override
  String get loadingMood => 'موڈ لوڈ ہو رہا ہے...';

  @override
  String get noMoodSet => 'موڈ سیٹ نہیں کیا گیا';

  @override
  String get article => 'مضمون';

  @override
  String get forum => 'فورم';

  @override
  String get chat => 'چیٹ';

  @override
  String get wellness => 'صحت';

  @override
  String get profile => 'پروفائل';

  @override
  String get notifications => 'اطلاعات';

  @override
  String get moodSelection => 'اپنا موڈ منتخب کریں';

  @override
  String get selectMood => 'موڈ منتخب کریں';

  @override
  String get moodSubmitted => 'موڈ کامیابی سے جمع ہو گیا';

  @override
  String get moodSubmitFailed => 'موڈ جمع کرنے میں ناکامی';

  @override
  String get stepsPermissionDenied => 'قدم شمار کرنے کی اجازت مسترد';

  @override
  String get stepsError => 'قدم شمار کرنے تک رسائی میں خرابی';

  @override
  String get spiritualHub => 'روحانی مرکز';

  @override
  String get dailyLifeReminders => 'روزمرہ زندگی کی یاد دہانیاں';

  @override
  String get guidedMeditations => 'ہدایت یافتہ مراقبے';

  @override
  String get learnMore => 'مزید جانیں';

  @override
  String get mindfulnessPractitioners => 'ذہن سازی کے ماہرین';

  @override
  String get noRemindersAvailable => 'کوئی یاد دہانیاں دستیاب نہیں';

  @override
  String get noMeditationsAvailable => 'کوئی مراقبے دستیاب نہیں';

  @override
  String get noPractitionersAvailable => 'کوئی ماہرین دستیاب نہیں';

  @override
  String meditation(int number) {
    return 'مراقبہ $number';
  }

  @override
  String get all => 'سب';

  @override
  String get bookASession => 'سیشن بک کریں';

  @override
  String get downloading => 'ڈاؤن لوڈ ہو رہا ہے...';

  @override
  String get downloadFailed => 'ڈاؤن لوڈ ناکام';

  @override
  String get howAreYouFeelingToday => 'آج آپ کیسا محسوس کر رہے ہیں؟';

  @override
  String get todaysJournal => 'آج کا جرنل';

  @override
  String get write => 'لکھیں';

  @override
  String get tapWriteToAdd => '\"لکھیں\" پر ٹیپ کریں تاکہ نجی جرنل انٹری شامل کریں';

  @override
  String get expressYourThoughts => 'اپنے خیالات اور جذبات کو محفوظ طریقے سے ظاہر کریں';

  @override
  String get saveTodaysMood => 'آج کا موڈ محفوظ کریں';

  @override
  String get cancel => 'منسوخ کریں';

  @override
  String get noNotificationsYet => 'ابھی تک کوئی اطلاعات نہیں';

  @override
  String get markAsUnread => 'غیر پڑھا ہوا نشان زد کریں';

  @override
  String get clearAll => 'سب صاف کریں';

  @override
  String get deleteNotifications => 'اطلاعات حذف کریں';

  @override
  String get deleteNotificationsConfirm => 'کیا آپ واقعی تمام اطلاعات حذف کرنا چاہتے ہیں؟';

  @override
  String get delete => 'حذف کریں';

  @override
  String get notificationsCleared => 'تمام اطلاعات صاف کر دی گئیں';

  @override
  String get errorOccurred => 'ایک خرابی پیش آئی';

  @override
  String get recentMoods => 'حالیہ موڈ';

  @override
  String get today => 'آج';

  @override
  String get yesterday => 'کل';

  @override
  String get whatsInYourMindToday => 'آج آپ کے ذہن میں کیا ہے؟';

  @override
  String get moodSaved => 'موڈ کامیابی سے محفوظ ہو گیا';

  @override
  String get moodSaveFailed => 'موڈ محفوظ کرنے میں ناکامی';

  @override
  String get overview => 'جائزہ';

  @override
  String get achievements => 'کامیابیاں';

  @override
  String get settings => 'ترتیبات';

  @override
  String get memberSince => 'رکنیت از';

  @override
  String get thisWeekMode => 'اس ہفتے کا موڈ';

  @override
  String get recentAchievements => 'حالیہ کامیابیاں';

  @override
  String get yourAchievements => 'آپ کی کامیابیاں';

  @override
  String get unlocked => 'کھلا ہوا';

  @override
  String get noAchievementsYet => 'ابھی تک کوئی کامیابی نہیں';

  @override
  String get loadingAchievements => 'کامیابیاں لوڈ ہو رہی ہیں...';

  @override
  String get accountSettings => 'اکاؤنٹ کی ترتیبات';

  @override
  String get personalDetails => 'ذاتی تفصیلات';

  @override
  String get changePhoneNumber => 'فون نمبر تبدیل کریں';

  @override
  String get changePassword => 'پاس ورڈ تبدیل کریں';

  @override
  String get appSetting => 'ایپ کی ترتیب';

  @override
  String get language => 'زبان';

  @override
  String get legal => 'قانونی';

  @override
  String get privacyPolicy => 'پرائیویسی پالیسی';

  @override
  String get termsOfUse => 'استعمال کی شرائط';

  @override
  String get helpAndSupport => 'مدد اور تعاون';

  @override
  String get customerSupport => 'کسٹمر سپورٹ';

  @override
  String get faqs => 'اکثر پوچھے جانے والے سوالات';

  @override
  String get rateUs => 'ہمیں درجہ دیں';

  @override
  String get languageChanged => 'زبان تبدیل ہو گئی۔ تبدیلیاں دیکھنے کے لیے براہ کرم ایپ کو دوبارہ شروع کریں۔';

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
