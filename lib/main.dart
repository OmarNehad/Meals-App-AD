import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meals/screens/tabs.dart';
import 'package:provider/provider.dart';
import 'package:meals/providers/theme_provider.dart';
import 'package:meals/screens/mode.dart';

final darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 239, 124, 53),
  ),
  textTheme: GoogleFonts.latoTextTheme(),
);

final lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.light,
    seedColor: const Color.fromARGB(255, 239, 124, 53),
  ),
  textTheme: GoogleFonts.latoTextTheme(),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final uiProvider = UiProvider();
  await uiProvider.init();

  runApp(
    ChangeNotifierProvider(
      create: (context) => uiProvider,
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UiProvider>(
      builder: (context, uiProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: uiProvider.isDark ? darkTheme : lightTheme,
          home: const TabsScreen(),
          routes: {
            '/mode': (context) => const ModeScreen(), // Delete this page later
          },
        );
      },
    );
  }
}
