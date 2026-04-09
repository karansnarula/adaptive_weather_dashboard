import 'package:flutter/material.dart';

import '../widgets/language_selector.dart';
import '../widgets/unit_selector.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: const SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                LanguageSelector(),
                SizedBox(height: 16),
                UnitSelector(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}