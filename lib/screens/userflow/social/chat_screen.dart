import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import 'chat_list_screen.dart';

class ChatScreen extends StatelessWidget {
  final Locale locale;

  const ChatScreen({super.key, required this.locale});

  @override
  Widget build(BuildContext context) {
    return ChatListScreen(locale: locale);
  }
}

