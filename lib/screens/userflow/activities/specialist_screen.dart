import 'package:flutter/material.dart';
import '../wellness/mindfulness_practitioners_screen.dart';

class SpecialistScreen extends StatelessWidget {
  final Locale locale;

  const SpecialistScreen({super.key, required this.locale});

  @override
  Widget build(BuildContext context) {
    // Use the same screen as mindfulness practitioners but with "Specialist" label
    return MindfulnessPractitionersScreen(
      locale: locale,
      title: 'Specialist',
    );
  }
}

