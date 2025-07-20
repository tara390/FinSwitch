import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'utils/app_constants.dart';
import 'utils/scroll_behavior.dart';
import 'screens/home_screen.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() {
  runApp(const FinSwitchApp());
}

class FinSwitchApp extends StatelessWidget {
  const FinSwitchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appName,
      navigatorObservers: [routeObserver],
      theme: AppTheme.lightTheme.copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(
          AppTheme.lightTheme.textTheme,
        ),
      ),
      builder: (context, child) {
        return AppScrollConfiguration(
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const HomeScreen(),
    );
  }
}


