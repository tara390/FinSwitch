import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/financial_models.dart';
import '../utils/app_constants.dart';
import '../utils/helpers.dart';
import '../widgets/custom_widgets.dart';

class LoanCalculatorScreen extends StatefulWidget {
  const LoanCalculatorScreen({super.key});

  @override
  State<LoanCalculatorScreen> createState() => _LoanCalculatorScreenState();
}

class _LoanCalculatorScreenState extends State<LoanCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _principalController = TextEditingController();
  final _interestRateController = TextEditingController();
  final _tenureController = TextEditingController();

  LoanCalculation? _result;
  bool _isCalculating = false;
  bool _showAmortization = false;

  @override
  void initState() {
    super.initState();
    _setDefaultValues();
  }

  void _setDefaultValues() {
    _principalController.text = AppConstants.defaultLoanAmount.toString();
    _interestRateController.text = AppConstants.defaultInterestRate.toString();
    _tenureController.text = AppConstants.defaultTenureMonths.toString();
  }

  @override
  void dispose() {
    _principalController.dispose();
    _interestRateController.dispose();
    _tenureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Loan Calculator', style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: AppConstants.loanColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_result != null)
            IconButton(
              icon: Icon(_showAmortization ? Icons.analytics : Icons.table_chart),
              onPressed: () {
                setState(() {
                  _showAmortization = !_showAmortization;
                });
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            _buildHeroSection(),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildInputSection(),
                  if (_result != null) ...[
                    _showAmortization ? _buildAmortizationSection() : _buildResultsSection(),
                  ],
                  const SizedBox(height: AppConstants.paddingLarge),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppConstants.loanColor,
            AppConstants.loanColor.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.calculate,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Loan EMI Calculator',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Calculate your monthly payments',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (_result != null) _buildEMIDisplay(),
          ],
        ),
      ),
    );
  }

  Widget _buildEMIDisplay() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Monthly EMI',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            Helpers.formatCurrency(_result!.emi),
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: AppConstants.loanColor,
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildQuickStat('Principal', Helpers.formatCompactCurrency(_result!.principal)),
              _buildQuickStat('Interest', Helpers.formatCompactCurrency(_result!.totalInterest)),
              _buildQuickStat('Total', Helpers.formatCompactCurrency(_result!.totalAmount)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppConstants.loanColor,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildInputSection() {
    return Container(
      margin: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        children: [
          _buildLoanAmountCard(),
          const SizedBox(height: 16),
          _buildInterestRateCard(),
          const SizedBox(height: 16),
          _buildTenureCard(),
          const SizedBox(height: 24),
          _buildCalculateButton(),
        ],
      ),
    );
  }

  Widget _buildLoanAmountCard() {
    final amount = double.tryParse(_principalController.text) ?? 100000;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppConstants.loanColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.currency_rupee,
                  color: AppConstants.loanColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Loan Amount',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            Helpers.formatCurrency(amount),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppConstants.loanColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Slider(
            value: amount.clamp(50000, 10000000),
            min: 50000,
            max: 10000000,
            divisions: 100,
            activeColor: AppConstants.loanColor,
            onChanged: (value) {
              setState(() {
                _principalController.text = value.round().toString();
              });
              _calculateLoan();
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('₹50K', style: Theme.of(context).textTheme.bodySmall),
              Text('₹1Cr', style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInterestRateCard() {
    final rate = double.tryParse(_interestRateController.text) ?? 8.5;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppConstants.warningColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.percent,
                  color: AppConstants.warningColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Interest Rate',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '${rate.toStringAsFixed(1)}% per annum',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppConstants.warningColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Slider(
            value: rate.clamp(1.0, 30.0),
            min: 1.0,
            max: 30.0,
            divisions: 290,
            activeColor: AppConstants.warningColor,
            onChanged: (value) {
              setState(() {
                _interestRateController.text = value.toStringAsFixed(1);
              });
              _calculateLoan();
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('1%', style: Theme.of(context).textTheme.bodySmall),
              Text('30%', style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTenureCard() {
    final tenure = int.tryParse(_tenureController.text) ?? 12;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppConstants.successColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.schedule,
                  color: AppConstants.successColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Loan Tenure',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            Helpers.formatTenure(tenure),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppConstants.successColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Slider(
            value: tenure.toDouble().clamp(6, 360),
            min: 6,
            max: 360,
            divisions: 354,
            activeColor: AppConstants.successColor,
            onChanged: (value) {
              setState(() {
                _tenureController.text = value.round().toString();
              });
              _calculateLoan();
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('6 months', style: Theme.of(context).textTheme.bodySmall),
              Text('30 years', style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalculateButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppConstants.loanColor, AppConstants.loanColor.withValues(alpha: 0.8)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppConstants.loanColor.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _isCalculating ? null : _calculateLoan,
          child: Center(
            child: _isCalculating
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.calculate,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Calculate EMI',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultsSection() {
    return Container(
      margin: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        children: [
          _buildBreakdownCard(),
          const SizedBox(height: 16),
          _buildPaymentBreakdownChart(),
          const SizedBox(height: 16),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildBreakdownCard() {
    final interestPercentage = (_result!.totalInterest / _result!.totalAmount) * 100;
    final principalPercentage = (_result!.principal / _result!.totalAmount) * 100;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Payment Breakdown',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppConstants.loanColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  Helpers.formatTenure(_result!.tenureMonths),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppConstants.loanColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildBreakdownItem(
            'Principal Amount',
            Helpers.formatCurrency(_result!.principal),
            principalPercentage,
            AppConstants.successColor,
          ),
          const SizedBox(height: 16),
          _buildBreakdownItem(
            'Total Interest',
            Helpers.formatCurrency(_result!.totalInterest),
            interestPercentage,
            AppConstants.warningColor,
          ),
          const SizedBox(height: 16),
          Container(
            height: 1,
            color: Colors.grey[200],
          ),
          const SizedBox(height: 16),
          _buildBreakdownItem(
            'Total Amount',
            Helpers.formatCurrency(_result!.totalAmount),
            100,
            AppConstants.loanColor,
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownItem(String title, String amount, double percentage, Color color, {bool isTotal = false}) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                  fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                amount,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: isTotal ? 18 : 16,
                ),
              ),
            ],
          ),
        ),
        if (!isTotal) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${percentage.toStringAsFixed(1)}%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPaymentBreakdownChart() {
    final principalPercentage = (_result!.principal / _result!.totalAmount) * 100;
    final interestPercentage = (_result!.totalInterest / _result!.totalAmount) * 100;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Composition',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 12,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: principalPercentage.round(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppConstants.successColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(6),
                        bottomLeft: Radius.circular(6),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: interestPercentage.round(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppConstants.warningColor,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(6),
                        bottomRight: Radius.circular(6),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildChartLegend('Principal', AppConstants.successColor, '${principalPercentage.toStringAsFixed(1)}%'),
              const SizedBox(width: 24),
              _buildChartLegend('Interest', AppConstants.warningColor, '${interestPercentage.toStringAsFixed(1)}%'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartLegend(String label, Color color, String percentage) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(width: 4),
        Text(
          percentage,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              border: Border.all(color: AppConstants.loanColor),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  setState(() {
                    _showAmortization = true;
                  });
                },
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.table_chart,
                        color: AppConstants.loanColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'View Schedule',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppConstants.loanColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: AppConstants.loanColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  // Share functionality can be added here
                  Helpers.showSuccessSnackbar(context, 'Share feature coming soon!');
                },
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.share,
                        color: AppConstants.loanColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Share',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppConstants.loanColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAmortizationSection() {
    return Container(
      margin: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Payment Schedule',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppConstants.loanColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            setState(() {
                              _showAmortization = false;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.arrow_back,
                                  color: AppConstants.loanColor,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Back',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppConstants.loanColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[200]!),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        child: Row(
                          children: [
                            _buildTableHeader('Month', flex: 1),
                            _buildTableHeader('EMI', flex: 2),
                            _buildTableHeader('Principal', flex: 2),
                            _buildTableHeader('Interest', flex: 2),
                            _buildTableHeader('Balance', flex: 2),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _result!.emiBreakdowns.length.clamp(0, 24),
                          itemBuilder: (context, index) {
                            final breakdown = _result!.emiBreakdowns[index];
                            return Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.grey[200]!),
                                ),
                              ),
                              child: Row(
                                children: [
                                  _buildTableCell(breakdown.month.toString(), flex: 1),
                                  _buildTableCell(Helpers.formatCompactCurrency(breakdown.emi), flex: 2),
                                  _buildTableCell(Helpers.formatCompactCurrency(breakdown.principalComponent), flex: 2),
                                  _buildTableCell(Helpers.formatCompactCurrency(breakdown.interestComponent), flex: 2),
                                  _buildTableCell(Helpers.formatCompactCurrency(breakdown.remainingBalance), flex: 2),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                if (_result!.emiBreakdowns.length > 24)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppConstants.loanColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Showing first 24 months of ${_result!.tenureMonths} months total',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppConstants.loanColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(String text, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.grey[700],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTableCell(String text, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          fontSize: 11,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }



  String _getTenureText() {
    final tenure = int.tryParse(_tenureController.text);
    if (tenure == null) return '';
    return Helpers.formatTenure(tenure);
  }

  void _calculateLoan() {
    final principalText = _principalController.text;
    final interestRateText = _interestRateController.text;
    final tenureText = _tenureController.text;

    if (principalText.isEmpty || interestRateText.isEmpty || tenureText.isEmpty) {
      return;
    }

    final principal = double.tryParse(principalText);
    final interestRate = double.tryParse(interestRateText);
    final tenure = int.tryParse(tenureText);

    if (principal == null || interestRate == null || tenure == null) {
      return;
    }

    if (principal < 1000 || interestRate < 0.1 || tenure < 1) {
      return;
    }

    setState(() {
      _isCalculating = true;
    });

    // Simulate calculation delay for better UX
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        final result = LoanCalculation.calculate(
          principal: principal,
          annualInterestRate: interestRate,
          tenureMonths: tenure,
        );

        setState(() {
          _result = result;
          _isCalculating = false;
          _showAmortization = false;
        });
      }
    });
  }
}
