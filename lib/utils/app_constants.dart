import 'package:flutter/material.dart';

class AppConstants {
  // App Information
  static const String appName = 'FinSwitch';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Your Complete Financial Calculator';

  // Colors
  static const Color primaryColor = Color(0xFF2E7D32);
  static const Color secondaryColor = Color(0xFF4CAF50);
  static const Color accentColor = Color(0xFF81C784);
  static const Color backgroundColor = Color(0xFFF1F8E9);
  static const Color cardColor = Color(0xFFFFFFFF);
  static const Color textPrimaryColor = Color(0xFF1B5E20);
  static const Color textSecondaryColor = Color(0xFF388E3C);
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color successColor = Color(0xFF388E3C);
  static const Color warningColor = Color(0xFFF57C00);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryColor, secondaryColor],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE8F5E8), Color(0xFFF1F8E9)],
  );

  // Spacing
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  // Responsive spacing
  static double getResponsivePadding(double screenWidth) {
    if (screenWidth < 400) return paddingSmall;
    if (screenWidth < 600) return paddingMedium;
    return paddingLarge;
  }

  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;

  // Font Sizes
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 14.0;
  static const double fontSizeLarge = 16.0;
  static const double fontSizeXLarge = 18.0;
  static const double fontSizeXXLarge = 20.0;
  static const double fontSizeTitle = 24.0;
  static const double fontSizeHeading = 28.0;

  // Animation Durations
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationMedium = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // Scroll Configuration
  static const double scrollPadding = 20.0;
  static const ScrollPhysics scrollPhysics = AlwaysScrollableScrollPhysics();

  // Financial Constants
  static const double minAmount = 1.0;
  static const double maxAmount = 10000000.0;
  static const double minInterestRate = 0.1;
  static const double maxInterestRate = 50.0;
  static const int minTenureMonths = 1;
  static const int maxTenureMonths = 600; // 50 years

  // Default Values
  static const double defaultRDAmount = 1000.0;
  static const double defaultFDAmount = 10000.0;
  static const double defaultLoanAmount = 100000.0;
  static const double defaultInterestRate = 8.5;
  static const int defaultTenureMonths = 12;

  // Feature Icons
  static const IconData rdIcon = Icons.savings;
  static const IconData fdIcon = Icons.account_balance;
  static const IconData loanIcon = Icons.credit_card;
  static const IconData currencyIcon = Icons.currency_exchange;
  static const IconData calculatorIcon = Icons.calculate;
  static const IconData historyIcon = Icons.history;
  static const IconData settingsIcon = Icons.settings;
  static const IconData infoIcon = Icons.info;

  // Feature Colors
  static const Color rdColor = Color(0xFF1976D2);
  static const Color fdColor = Color(0xFF388E3C);
  static const Color loanColor = Color(0xFFD32F2F);
  static const Color currencyColor = Color(0xFF7B1FA2);

  // Validation Messages
  static const String invalidAmountMessage = 'Please enter a valid amount';
  static const String invalidRateMessage = 'Please enter a valid interest rate';
  static const String invalidTenureMessage = 'Please enter a valid tenure';
  static const String networkErrorMessage = 'Network error. Please check your connection.';
  static const String genericErrorMessage = 'Something went wrong. Please try again.';

  // Success Messages
  static const String calculationSuccessMessage = 'Calculation completed successfully';
  static const String dataUpdatedMessage = 'Data updated successfully';

  // Feature Descriptions
  static const String rdDescription = 'Calculate returns on your Recurring Deposits with compound interest';
  static const String fdDescription = 'Calculate maturity amount for your Fixed Deposits';
  static const String loanDescription = 'Calculate EMI and total interest for your loans';
  static const String currencyDescription = 'Convert between different currencies with live rates';

  // Shared Preferences Keys
  static const String keyThemeMode = 'theme_mode';
  static const String keyDefaultCurrency = 'default_currency';
  static const String keyCalculationHistory = 'calculation_history';
  static const String keyFirstLaunch = 'first_launch';

  // API Configuration
  static const Duration apiTimeout = Duration(seconds: 10);
  static const int maxRetryAttempts = 3;

  // Number Formatting
  static const String currencyPattern = '#,##,##0.00';
  static const String percentagePattern = '#0.00';
  static const String integerPattern = '#,##,##0';

  // Validation Patterns
  static final RegExp amountPattern = RegExp(r'^\d+(\.\d{1,2})?$');
  static final RegExp ratePattern = RegExp(r'^\d+(\.\d{1,2})?$');
  static final RegExp tenurePattern = RegExp(r'^\d+$');
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppConstants.primaryColor,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardTheme(
        color: AppConstants.cardColor,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingLarge,
            vertical: AppConstants.paddingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppConstants.primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppConstants.errorColor, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppConstants.errorColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: TextStyle(
          color: Colors.grey[500],
          fontWeight: FontWeight.normal,
        ),
        labelStyle: TextStyle(
          color: Colors.grey[700],
          fontWeight: FontWeight.w500,
        ),
        floatingLabelStyle: const TextStyle(
          color: AppConstants.primaryColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: AppConstants.fontSizeHeading,
          fontWeight: FontWeight.bold,
          color: AppConstants.textPrimaryColor,
        ),
        headlineMedium: TextStyle(
          fontSize: AppConstants.fontSizeTitle,
          fontWeight: FontWeight.w600,
          color: AppConstants.textPrimaryColor,
        ),
        bodyLarge: TextStyle(
          fontSize: AppConstants.fontSizeLarge,
          color: AppConstants.textPrimaryColor,
        ),
        bodyMedium: TextStyle(
          fontSize: AppConstants.fontSizeMedium,
          color: AppConstants.textSecondaryColor,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppConstants.primaryColor,
        brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}
