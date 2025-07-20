import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/financial_models.dart';
import '../utils/app_constants.dart';
import '../utils/helpers.dart';
import '../widgets/custom_widgets.dart';

class RDCalculatorScreen extends StatefulWidget {
  const RDCalculatorScreen({super.key});

  @override
  State<RDCalculatorScreen> createState() => _RDCalculatorScreenState();
}

class _RDCalculatorScreenState extends State<RDCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _monthlyAmountController = TextEditingController();
  final _interestRateController = TextEditingController();
  final _tenureController = TextEditingController();

  RDCalculation? _result;
  bool _isCalculating = false;

  @override
  void initState() {
    super.initState();
    _setDefaultValues();
  }

  void _setDefaultValues() {
    _monthlyAmountController.text = AppConstants.defaultRDAmount.toString();
    _interestRateController.text = AppConstants.defaultInterestRate.toString();
    _tenureController.text = AppConstants.defaultTenureMonths.toString();
  }

  @override
  void dispose() {
    _monthlyAmountController.dispose();
    _interestRateController.dispose();
    _tenureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('RD Calculator', style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: AppConstants.rdColor,
        foregroundColor: Colors.white,
        elevation: 0,
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
                  if (_result != null) _buildResultsSection(),
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
            AppConstants.rdColor,
            AppConstants.rdColor.withValues(alpha: 0.8),
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
                    Icons.savings,
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
                        'Recurring Deposit',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Calculate your RD maturity amount',
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
            if (_result != null) _buildMaturityDisplay(),
          ],
        ),
      ),
    );
  }

  Widget _buildMaturityDisplay() {
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
            'Maturity Amount',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            Helpers.formatCurrency(_result!.maturityAmount),
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: AppConstants.rdColor,
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildQuickStat('Deposited', Helpers.formatCompactCurrency(_result!.totalDeposited)),
              _buildQuickStat('Interest', Helpers.formatCompactCurrency(_result!.totalInterest)),
              _buildQuickStat('Growth', '${((_result!.totalInterest / _result!.totalDeposited) * 100).toStringAsFixed(1)}%'),
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
            color: AppConstants.rdColor,
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
          _buildMonthlyAmountCard(),
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

  Widget _buildMonthlyAmountCard() {
    final amount = double.tryParse(_monthlyAmountController.text) ?? 5000;
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
                  color: AppConstants.rdColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.savings,
                  color: AppConstants.rdColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Monthly Deposit',
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
              color: AppConstants.rdColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Slider(
            value: amount.clamp(500, 50000),
            min: 500,
            max: 50000,
            divisions: 100,
            activeColor: AppConstants.rdColor,
            onChanged: (value) {
              setState(() {
                _monthlyAmountController.text = value.round().toString();
              });
              _calculateRD();
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('₹500', style: Theme.of(context).textTheme.bodySmall),
              Text('₹50K', style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInterestRateCard() {
    final rate = double.tryParse(_interestRateController.text) ?? 7.5;
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
            value: rate.clamp(1.0, 15.0),
            min: 1.0,
            max: 15.0,
            divisions: 140,
            activeColor: AppConstants.warningColor,
            onChanged: (value) {
              setState(() {
                _interestRateController.text = value.toStringAsFixed(1);
              });
              _calculateRD();
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('1%', style: Theme.of(context).textTheme.bodySmall),
              Text('15%', style: Theme.of(context).textTheme.bodySmall),
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
                'Investment Tenure',
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
            value: tenure.toDouble().clamp(6, 120),
            min: 6,
            max: 120,
            divisions: 114,
            activeColor: AppConstants.successColor,
            onChanged: (value) {
              setState(() {
                _tenureController.text = value.round().toString();
              });
              _calculateRD();
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('6 months', style: Theme.of(context).textTheme.bodySmall),
              Text('10 years', style: Theme.of(context).textTheme.bodySmall),
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
          colors: [AppConstants.rdColor, AppConstants.rdColor.withValues(alpha: 0.8)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppConstants.rdColor.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _isCalculating ? null : _calculateRD,
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
                        'Calculate RD',
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
          _buildGrowthVisualization(),
        ],
      ),
    );
  }

  Widget _buildBreakdownCard() {
    final interestPercentage = (_result!.totalInterest / _result!.maturityAmount) * 100;
    final principalPercentage = (_result!.totalDeposited / _result!.maturityAmount) * 100;

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
            'Investment Breakdown',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          _buildBreakdownItem(
            'Total Deposited',
            Helpers.formatCurrency(_result!.totalDeposited),
            principalPercentage,
            AppConstants.rdColor,
          ),
          const SizedBox(height: 16),
          _buildBreakdownItem(
            'Interest Earned',
            Helpers.formatCurrency(_result!.totalInterest),
            interestPercentage,
            AppConstants.successColor,
          ),
          const SizedBox(height: 16),
          Container(
            height: 1,
            color: Colors.grey[200],
          ),
          const SizedBox(height: 16),
          _buildBreakdownItem(
            'Maturity Amount',
            Helpers.formatCurrency(_result!.maturityAmount),
            100,
            AppConstants.rdColor,
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

  Widget _buildGrowthVisualization() {
    final principalPercentage = (_result!.totalDeposited / _result!.maturityAmount) * 100;
    final interestPercentage = (_result!.totalInterest / _result!.maturityAmount) * 100;

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
            'Growth Visualization',
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
                      color: AppConstants.rdColor,
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
                      color: AppConstants.successColor,
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
              _buildChartLegend('Deposits', AppConstants.rdColor, '${principalPercentage.toStringAsFixed(1)}%'),
              const SizedBox(width: 24),
              _buildChartLegend('Interest', AppConstants.successColor, '${interestPercentage.toStringAsFixed(1)}%'),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppConstants.successColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.trending_up, color: AppConstants.successColor, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Your investment will grow by ${((_result!.totalInterest / _result!.totalDeposited) * 100).toStringAsFixed(1)}% over ${Helpers.formatTenure(_result!.tenureMonths)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppConstants.successColor,
                      fontWeight: FontWeight.w500,
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

  String _getTenureText() {
    final tenure = int.tryParse(_tenureController.text);
    if (tenure == null) return '';
    return Helpers.formatTenure(tenure);
  }

  void _calculateRD() {
    final monthlyAmountText = _monthlyAmountController.text;
    final interestRateText = _interestRateController.text;
    final tenureText = _tenureController.text;

    if (monthlyAmountText.isEmpty || interestRateText.isEmpty || tenureText.isEmpty) {
      return;
    }

    final monthlyAmount = double.tryParse(monthlyAmountText);
    final interestRate = double.tryParse(interestRateText);
    final tenure = int.tryParse(tenureText);

    if (monthlyAmount == null || interestRate == null || tenure == null) {
      return;
    }

    if (monthlyAmount < 100 || interestRate < 0.1 || tenure < 1) {
      return;
    }

    setState(() {
      _isCalculating = true;
    });

    // Simulate calculation delay for better UX
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        final result = RDCalculation.calculate(
          monthlyDeposit: monthlyAmount,
          annualInterestRate: interestRate,
          tenureMonths: tenure,
        );

        setState(() {
          _result = result;
          _isCalculating = false;
        });
      }
    });
  }
}
