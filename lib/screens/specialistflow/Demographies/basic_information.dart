import 'dart:ui';
import 'package:flutter/material.dart';
import 'education_certification.dart';

class BasicInformationScreen extends StatefulWidget {
  const BasicInformationScreen({super.key});

  @override
  State<BasicInformationScreen> createState() => _BasicInformationScreenState();
}

class _BasicInformationScreenState extends State<BasicInformationScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController hourlyRateController = TextEditingController(
    text: "500",
  );

  String? selectedLocation = "Karachi, Pakistan";
  String? selectedCurrency = "PKR";
  List<String> specializations = ["CBT"];
  List<String> languages = ["English"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Stack(
        children: [
          // 🌈 Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromARGB(108, 78, 194, 194), Color(0xFFF8F8F8)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // 🧭 Main Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Basic Information",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF01394F),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 🪞 Full-width Glass Card
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.4),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel("Full Name"),
                                _buildTextField(
                                  fullNameController,
                                  "Enter your full name",
                                ),
                                const SizedBox(height: 16),

                                _buildLabel("Designation"),
                                _buildTextField(
                                  designationController,
                                  "Enter your designation",
                                ),
                                const SizedBox(height: 16),

                                _buildLabel("Location"),
                                _buildDropdown<String>(
                                  value: selectedLocation,
                                  items: const [
                                    "Karachi, Pakistan",
                                    "Lahore, Pakistan",
                                    "Islamabad, Pakistan",
                                  ],
                                  onChanged: (val) =>
                                      setState(() => selectedLocation = val),
                                ),
                                const SizedBox(height: 16),

                                _buildLabel("Hourly Rate"),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildTextField(
                                        hourlyRateController,
                                        "Hourly Rate",
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    _buildDropdown<String>(
                                      value: selectedCurrency,
                                      items: const ["PKR", "USD", "GBP"],
                                      onChanged: (val) => setState(
                                        () => selectedCurrency = val,
                                      ),
                                      width: 90,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                _buildLabel("Specialization"),
                                _buildTagSection(
                                  specializations,
                                  "Add Specialization",
                                ),
                                const SizedBox(height: 16),

                                _buildLabel("Languages"),
                                _buildTagSection(languages, "Add Language"),
                                const SizedBox(height: 30),

                                // 🟦 Next Button ABOVE progress line
                                _buildNextButton(context),
                                const SizedBox(height: 20),

                                // Progress Bar (below)
                                _buildProgressBar(context, 0.5),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- UI Components ----------------

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        color: Color(0xFF01394F),
      ),
    ),
  );

  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required T? value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    double? width,
  }) {
    final dropdown = DropdownButtonHideUnderline(
      child: DropdownButton<T>(
        isExpanded: true,
        value: value,
        icon: const Icon(Icons.keyboard_arrow_down_rounded),
        items: items
            .map(
              (item) =>
                  DropdownMenuItem(value: item, child: Text(item.toString())),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );

    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: dropdown,
    );
  }

  Widget _buildTagSection(List<String> tags, String addLabel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 4,
        children: [
          ...tags.map(
            (tag) => Chip(
              label: Text(tag),
              deleteIconColor: Colors.redAccent,
              onDeleted: () => setState(() => tags.remove(tag)),
              backgroundColor: const Color(0xFFE0F7FA),
            ),
          ),
          GestureDetector(
            onTap: () async {
              final newTag = await _showAddDialog(addLabel);
              if (newTag != null && newTag.trim().isNotEmpty) {
                setState(() => tags.add(newTag.trim()));
              }
            },
            child: Chip(
              label: const Text("+ Add"),
              backgroundColor: Colors.grey.shade200,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context, double progress) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: LinearProgressIndicator(
        value: progress,
        backgroundColor: Colors.grey.shade300,
        color: const Color(0xFF00A8A8),
        minHeight: 5,
      ),
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EducationCertificationsScreen(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00A8A8),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        child: const Text(
          "Next",
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future<String?> _showAddDialog(String title) {
    final TextEditingController tagController = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: tagController,
          decoration: const InputDecoration(hintText: "Enter new item"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, tagController.text),
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }
}
