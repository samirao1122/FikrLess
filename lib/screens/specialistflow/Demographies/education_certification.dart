import 'dart:ui';
import 'package:flutter/material.dart';
import '../../auth/login/login_screen.dart';

class EducationCertificationsScreen extends StatefulWidget {
  const EducationCertificationsScreen({super.key});

  @override
  State<EducationCertificationsScreen> createState() =>
      _EducationCertificationsScreenState();
}

class _EducationCertificationsScreenState
    extends State<EducationCertificationsScreen> {
  List<Map<String, String>> educationList = [
    {'degree': '', 'institute': ''},
  ];

  List<Map<String, String>> certificationList = [
    {'certTitle': '', 'provider': ''},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 🌈 Background gradient (same as Page 1)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF8F8F8), Color.fromARGB(108, 78, 194, 194)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // 🧭 Foreground content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔙 Glassy Back Button
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.5),
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_ios_new_rounded),
                          color: const Color(0xFF01394F),
                          iconSize: 24,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // 🧾 Page Title
                  const Text(
                    "Education & Certifications",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF01394F),
                    ),
                  ),
                  const SizedBox(height: 13),

                  // 🪞 Glass Card Container
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
                                // 🎓 Education Section
                                _buildSectionTitle("🎓 Education"),
                                const SizedBox(height: 7),
                                ..._buildDynamicSection(
                                  context,
                                  educationList,
                                  ['Degree', 'Institute Name'],
                                  onAdd: () {
                                    setState(() {
                                      educationList.add({
                                        'degree': '',
                                        'institute': '',
                                      });
                                    });
                                  },
                                  onRemove: (index) {
                                    setState(() {
                                      educationList.removeAt(index);
                                    });
                                  },
                                ),
                                const SizedBox(height: 5),

                                // 📜 Certifications Section
                                _buildSectionTitle("📜 Certifications"),
                                const SizedBox(height: 10),
                                ..._buildDynamicSection(
                                  context,
                                  certificationList,
                                  ['Certificate Title', 'Provider'],
                                  onAdd: () {
                                    setState(() {
                                      certificationList.add({
                                        'certTitle': '',
                                        'provider': '',
                                      });
                                    });
                                  },
                                  onRemove: (index) {
                                    setState(() {
                                      certificationList.removeAt(index);
                                    });
                                  },
                                ),
                                const SizedBox(height: 10),

                                // 🟩 Login Button (matches Page 1 style)
                                _buildLoginButton(context),
                                const SizedBox(height: 15),

                                // 🟦 Progress Bar
                                _buildProgressBar(context, 1.0),
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

  // ----------------- UI Components -----------------

  Widget _buildSectionTitle(String title) => Text(
    title,
    style: const TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.w600,
      color: Color(0xFF01394F),
    ),
  );

  List<Widget> _buildDynamicSection(
    BuildContext context,
    List<Map<String, String>> list,
    List<String> fields, {
    required VoidCallback onAdd,
    required Function(int) onRemove,
  }) {
    return [
      for (int i = 0; i < list.length; i++) ...[
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.only(bottom: 18),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int j = 0; j < fields.length; j++) ...[
                Text(
                  fields[j],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF01394F),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  onChanged: (val) => list[i][list[i].keys.elementAt(j)] = val,
                  decoration: InputDecoration(
                    hintText: "Enter ${fields[j].toLowerCase()}",
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => onRemove(i),
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  label: const Text(
                    "Remove",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
      GestureDetector(
        onTap: onAdd,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            Icon(Icons.add_circle, color: Color(0xFF00A8A8)),
            SizedBox(width: 6),
            Text(
              "Add More",
              style: TextStyle(
                color: Color(0xFF00A8A8),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    ];
  }

  Widget _buildLoginButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
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
          "Login",
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
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
}
