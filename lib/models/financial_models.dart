// Financial calculation models for FinSwitch app
import 'dart:math' as math;

class RDCalculation {
  final double monthlyDeposit;
  final double interestRate;
  final int tenureMonths;
  final double maturityAmount;
  final double totalDeposited;
  final double totalInterest;

  RDCalculation({
    required this.monthlyDeposit,
    required this.interestRate,
    required this.tenureMonths,
    required this.maturityAmount,
    required this.totalDeposited,
    required this.totalInterest,
  });

  static RDCalculation calculate({
    required double monthlyDeposit,
    required double annualInterestRate,
    required int tenureMonths,
  }) {
    // RD calculation formula: M = P * [(1 + r)^n - 1] / r * (1 + r)
    // Where P = monthly deposit, r = monthly interest rate, n = number of months
    
    final double monthlyRate = annualInterestRate / (12 * 100);
    final double totalDeposited = monthlyDeposit * tenureMonths;
    
    double maturityAmount;
    if (monthlyRate == 0) {
      maturityAmount = totalDeposited;
    } else {
      final double factor = (1 + monthlyRate);
      final double numerator = (factor * (math.pow(factor, tenureMonths) - 1));
      maturityAmount = monthlyDeposit * numerator / monthlyRate;
    }
    
    final double totalInterest = maturityAmount - totalDeposited;

    return RDCalculation(
      monthlyDeposit: monthlyDeposit,
      interestRate: annualInterestRate,
      tenureMonths: tenureMonths,
      maturityAmount: maturityAmount,
      totalDeposited: totalDeposited,
      totalInterest: totalInterest,
    );
  }
}

class FDCalculation {
  final double principal;
  final double interestRate;
  final int tenureMonths;
  final double maturityAmount;
  final double totalInterest;
  final bool isCompounded;

  FDCalculation({
    required this.principal,
    required this.interestRate,
    required this.tenureMonths,
    required this.maturityAmount,
    required this.totalInterest,
    required this.isCompounded,
  });

  static FDCalculation calculate({
    required double principal,
    required double annualInterestRate,
    required int tenureMonths,
    bool isCompounded = true,
  }) {
    // FD calculation
    // Simple Interest: A = P(1 + rt)
    // Compound Interest: A = P(1 + r/n)^(nt)
    
    final double rate = annualInterestRate / 100;
    final double time = tenureMonths / 12.0;
    
    double maturityAmount;
    
    if (isCompounded) {
      // Quarterly compounding (n=4)
      maturityAmount = principal * math.pow(1 + rate / 4, 4 * time);
    } else {
      // Simple interest
      maturityAmount = principal * (1 + rate * time);
    }
    
    final double totalInterest = maturityAmount - principal;

    return FDCalculation(
      principal: principal,
      interestRate: annualInterestRate,
      tenureMonths: tenureMonths,
      maturityAmount: maturityAmount,
      totalInterest: totalInterest,
      isCompounded: isCompounded,
    );
  }
}

class LoanCalculation {
  final double principal;
  final double interestRate;
  final int tenureMonths;
  final double emi;
  final double totalAmount;
  final double totalInterest;
  final List<EMIBreakdown> emiBreakdowns;

  LoanCalculation({
    required this.principal,
    required this.interestRate,
    required this.tenureMonths,
    required this.emi,
    required this.totalAmount,
    required this.totalInterest,
    required this.emiBreakdowns,
  });

  static LoanCalculation calculate({
    required double principal,
    required double annualInterestRate,
    required int tenureMonths,
  }) {
    // EMI calculation formula: EMI = [P * r * (1+r)^n] / [(1+r)^n - 1]
    // Where P = principal, r = monthly interest rate, n = number of months
    
    final double monthlyRate = annualInterestRate / (12 * 100);
    
    double emi;
    if (monthlyRate == 0) {
      emi = principal / tenureMonths;
    } else {
      final double factor = math.pow(1 + monthlyRate, tenureMonths).toDouble();
      emi = (principal * monthlyRate * factor) / (factor - 1);
    }
    
    final double totalAmount = emi * tenureMonths;
    final double totalInterest = totalAmount - principal;
    
    // Generate EMI breakdown
    List<EMIBreakdown> emiBreakdowns = [];
    double remainingPrincipal = principal;
    
    for (int i = 1; i <= tenureMonths; i++) {
      final double interestComponent = remainingPrincipal * monthlyRate;
      final double principalComponent = emi - interestComponent;
      remainingPrincipal -= principalComponent;
      
      emiBreakdowns.add(EMIBreakdown(
        month: i,
        emi: emi,
        principalComponent: principalComponent,
        interestComponent: interestComponent,
        remainingBalance: remainingPrincipal > 0 ? remainingPrincipal : 0,
      ));
    }

    return LoanCalculation(
      principal: principal,
      interestRate: annualInterestRate,
      tenureMonths: tenureMonths,
      emi: emi,
      totalAmount: totalAmount,
      totalInterest: totalInterest,
      emiBreakdowns: emiBreakdowns,
    );
  }
}

class EMIBreakdown {
  final int month;
  final double emi;
  final double principalComponent;
  final double interestComponent;
  final double remainingBalance;

  EMIBreakdown({
    required this.month,
    required this.emi,
    required this.principalComponent,
    required this.interestComponent,
    required this.remainingBalance,
  });
}

class CurrencyRate {
  final String fromCurrency;
  final String toCurrency;
  final double rate;
  final DateTime lastUpdated;

  CurrencyRate({
    required this.fromCurrency,
    required this.toCurrency,
    required this.rate,
    required this.lastUpdated,
  });

  factory CurrencyRate.fromJson(Map<String, dynamic> json) {
    return CurrencyRate(
      fromCurrency: json['from'] ?? '',
      toCurrency: json['to'] ?? '',
      rate: (json['rate'] ?? 0.0).toDouble(),
      lastUpdated: DateTime.now(),
    );
  }
}


