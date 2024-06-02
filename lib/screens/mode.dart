import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meals/providers/theme_provider.dart';

class ModeScreen extends StatelessWidget {
  const ModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mode"),
      ),
      body: Consumer<UiProvider>(
        builder: (context, notifier, child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ListTile(
                  leading: const Icon(Icons.dark_mode),
                  title: const Text("Dark theme"),
                  trailing: Switch(
                    value: notifier.isDark,
                    onChanged: (value) => notifier.changeTheme(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
