import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'app_constants.dart';

class Helpers {
  // Number Formatting
  static String formatCurrency(double amount, {String symbol = '₹'}) {
    final formatter = NumberFormat(AppConstants.currencyPattern);
    return '$symbol${formatter.format(amount)}';
  }

  static String formatPercentage(double percentage) {
    final formatter = NumberFormat(AppConstants.percentagePattern);
    return '${formatter.format(percentage)}%';
  }

  static String formatInteger(int number) {
    final formatter = NumberFormat(AppConstants.integerPattern);
    return formatter.format(number);
  }

  static String formatCompactCurrency(double amount, {String symbol = '₹'}) {
    if (amount >= 10000000) {
      return '$symbol${(amount / 10000000).toStringAsFixed(2)}Cr';
    } else if (amount >= 100000) {
      return '$symbol${(amount / 100000).toStringAsFixed(2)}L';
    } else if (amount >= 1000) {
      return '$symbol${(amount / 1000).toStringAsFixed(2)}K';
    } else {
      return formatCurrency(amount, symbol: symbol);
    }
  }

  // Validation
  static bool isValidAmount(String value) {
    if (value.isEmpty) return false;
    final amount = double.tryParse(value);
    return amount != null && 
           amount >= AppConstants.minAmount && 
           amount <= AppConstants.maxAmount;
  }

  static bool isValidInterestRate(String value) {
    if (value.isEmpty) return false;
    final rate = double.tryParse(value);
    return rate != null && 
           rate >= AppConstants.minInterestRate && 
           rate <= AppConstants.maxInterestRate;
  }

  static bool isValidTenure(String value) {
    if (value.isEmpty) return false;
    final tenure = int.tryParse(value);
    return tenure != null && 
           tenure >= AppConstants.minTenureMonths && 
           tenure <= AppConstants.maxTenureMonths;
  }

  // Input Validation Messages
  static String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Amount is required';
    }
    if (!isValidAmount(value)) {
      return 'Enter amount between ${AppConstants.minAmount} and ${formatCompactCurrency(AppConstants.maxAmount)}';
    }
    return null;
  }

  static String? validateInterestRate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Interest rate is required';
    }
    if (!isValidInterestRate(value)) {
      return 'Enter rate between ${AppConstants.minInterestRate}% and ${AppConstants.maxInterestRate}%';
    }
    return null;
  }

  static String? validateTenure(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tenure is required';
    }
    if (!isValidTenure(value)) {
      return 'Enter tenure between ${AppConstants.minTenureMonths} and ${AppConstants.maxTenureMonths} months';
    }
    return null;
  }

  // Date Formatting
  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  static String formatDateWithTime(DateTime date) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(date);
  }

  static String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  // Tenure Conversion
  static String formatTenure(int months) {
    if (months < 12) {
      return '$months month${months > 1 ? 's' : ''}';
    } else {
      final years = months ~/ 12;
      final remainingMonths = months % 12;
      
      String result = '$years year${years > 1 ? 's' : ''}';
      if (remainingMonths > 0) {
        result += ' $remainingMonths month${remainingMonths > 1 ? 's' : ''}';
      }
      return result;
    }
  }

  static int convertYearsToMonths(double years) {
    return (years * 12).round();
  }

  static double convertMonthsToYears(int months) {
    return months / 12.0;
  }

  // Color Utilities
  static Color getFeatureColor(String feature) {
    switch (feature.toLowerCase()) {
      case 'rd':
      case 'recurring deposit':
        return AppConstants.rdColor;
      case 'fd':
      case 'fixed deposit':
        return AppConstants.fdColor;
      case 'loan':
      case 'emi':
        return AppConstants.loanColor;
      case 'currency':
      case 'converter':
        return AppConstants.currencyColor;
      default:
        return AppConstants.primaryColor;
    }
  }

  static IconData getFeatureIcon(String feature) {
    switch (feature.toLowerCase()) {
      case 'rd':
      case 'recurring deposit':
        return AppConstants.rdIcon;
      case 'fd':
      case 'fixed deposit':
        return AppConstants.fdIcon;
      case 'loan':
      case 'emi':
        return AppConstants.loanIcon;
      case 'currency':
      case 'converter':
        return AppConstants.currencyIcon;
      default:
        return AppConstants.calculatorIcon;
    }
  }

  // Snackbar Utilities
  static void showSuccessSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppConstants.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        ),
      ),
    );
  }

  static void showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppConstants.errorColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        ),
      ),
    );
  }

  static void showWarningSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppConstants.warningColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        ),
      ),
    );
  }

  // Dialog Utilities
  static Future<bool?> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String content,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  // Loading Dialog
  static void showLoadingDialog(BuildContext context, {String message = 'Loading...'}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: AppConstants.paddingMedium),
            Text(message),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        ),
      ),
    );
  }

  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  // Haptic Feedback
  static void lightHaptic() {
    // HapticFeedback.lightImpact();
  }

  static void mediumHaptic() {
    // HapticFeedback.mediumImpact();
  }

  static void heavyHaptic() {
    // HapticFeedback.heavyImpact();
  }
}
