import 'package:flutter/material.dart';
import 'mental_health_goals.dart';
import 'user_survey_data.dart'; // ✅ Make sure this path is correct

class BasicDemographicsScreen extends StatefulWidget {
  final UserSurveyData surveyData;

  const BasicDemographicsScreen({super.key, required this.surveyData});

  @override
  State<BasicDemographicsScreen> createState() =>
      _BasicDemographicsScreenState();
}

class _BasicDemographicsScreenState extends State<BasicDemographicsScreen> {
  String? selectedAge;
  String? selectedCountry;
  String? gender;
  String? relationship;

  bool _isLoading = false;

  final int currentStep = 1; // Step 1
  final int totalSteps = 6;

  final List<String> ages = ['16 – 25', '26 – 35', '36 – 45', '46+'];
  final List<String> countries = [
    'Karachi, Pakistan',
    'Lahore, Pakistan',
    'Islamabad, Pakistan',
    'Multan, Pakistan',
    'Other',
  ];

  // ✅ Only collects data and navigates forward
  Future<void> _submitDemographics() async {
    if (selectedAge == null ||
        gender == null ||
        selectedCountry == null ||
        relationship == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields before continuing."),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // ✅ Save data to survey model
    widget.surveyData.ageRange = selectedAge;
    widget.surveyData.genderIdentity = gender;
    widget.surveyData.countryOfResidence = selectedCountry;
    widget.surveyData.relationshipStatus = relationship;

    await Future.delayed(const Duration(milliseconds: 300));
    setState(() => _isLoading = false);

    // ✅ Move to next screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MentalHealthGoalsScreen(surveyData: widget.surveyData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 17, bottom: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  "Basic Demographics",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF00A8A8),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 🧾 Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 22,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.18),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 145,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      "Help us get to know you",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 14),

                    _buildLabel("Age"),
                    const SizedBox(height: 6),
                    _buildDropdown(
                      hint: "16-25",
                      value: selectedAge,
                      items: ages,
                      onChanged: (val) => setState(() => selectedAge = val),
                    ),
                    const SizedBox(height: 16),

                    _buildLabel("Gender identity"),
                    const SizedBox(height: 2),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCheckbox("Male", gender == "Male", () {
                          setState(() => gender = "Male");
                        }),
                        _buildCheckbox("Female", gender == "Female", () {
                          setState(() => gender = "Female");
                        }),
                        _buildCheckbox(
                          "Prefer not to say",
                          gender == "Prefer not to say",
                          () {
                            setState(() => gender = "Prefer not to say");
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    _buildLabel("Country of residence"),
                    const SizedBox(height: 6),
                    _buildDropdown(
                      hint: "Karachi, Pakistan",
                      value: selectedCountry,
                      items: countries,
                      onChanged: (val) => setState(() => selectedCountry = val),
                    ),
                    const SizedBox(height: 16),

                    _buildLabel("Relationship status"),
                    const SizedBox(height: 4),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCheckbox("Single", relationship == "Single", () {
                          setState(() => relationship = "Single");
                        }),
                        _buildCheckbox(
                          "In a relationship",
                          relationship == "In a relationship",
                          () {
                            setState(() => relationship = "In a relationship");
                          },
                        ),
                        _buildCheckbox(
                          "Married",
                          relationship == "Married",
                          () {
                            setState(() => relationship = "Married");
                          },
                        ),
                        _buildCheckbox(
                          "Divorced",
                          relationship == "Divorced",
                          () {
                            setState(() => relationship = "Divorced");
                          },
                        ),
                        _buildCheckbox(
                          "Widowed",
                          relationship == "Widowed",
                          () {
                            setState(() => relationship = "Widowed");
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F6FA),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Disclaimer",
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 9),
                          Text(
                            "This is for data collection purposes to tailor this app to your needs.",
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 15,
                              height: 1.4,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 7),

                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _submitDemographics,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00A8A8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 7,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: _isLoading
                            ? const SizedBox(
                                width: 12,
                                height: 12,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Colors.white,
                                size: 12,
                              ),
                        label: Text(
                          _isLoading ? "Submitting..." : "Next",
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),
                    _buildSegmentedProgressBar(),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        "Page $currentStep of $totalSteps",
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'Roboto',
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 UI Helpers
  Widget _buildSegmentedProgressBar() {
    return Row(
      children: List.generate(totalSteps, (index) {
        final isFilled = index < currentStep;
        return Expanded(
          child: Container(
            height: 6,
            margin: EdgeInsets.only(right: index == totalSteps - 1 ? 0 : 4),
            decoration: BoxDecoration(
              color: isFilled ? const Color(0xFF00A8A8) : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Text(
            hint,
            style: const TextStyle(fontSize: 15, color: Colors.black54),
          ),
          value: value,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.black54,
          ),
          onChanged: onChanged,
          items: items
              .map(
                (e) => DropdownMenuItem<String>(
                  value: e,
                  child: Text(
                    e,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildCheckbox(String title, bool selected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Checkbox(
            value: selected,
            onChanged: (_) => onTap(),
            activeColor: const Color(0xFF00A8A8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            side: const BorderSide(width: 1.3, color: Colors.grey),
            visualDensity: const VisualDensity(horizontal: -2, vertical: -3),
          ),
          const SizedBox(width: 4),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 15,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 15.5,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }
}
