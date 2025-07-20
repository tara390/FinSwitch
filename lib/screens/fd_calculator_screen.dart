import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/financial_models.dart';
import '../utils/app_constants.dart';
import '../utils/helpers.dart';
import '../widgets/custom_widgets.dart';

class FDCalculatorScreen extends StatefulWidget {
  const FDCalculatorScreen({super.key});

  @override
  State<FDCalculatorScreen> createState() => _FDCalculatorScreenState();
}

class _FDCalculatorScreenState extends State<FDCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _principalController = TextEditingController();
  final _interestRateController = TextEditingController();
  final _tenureController = TextEditingController();

  FDCalculation? _result;
  bool _isCalculating = false;
  bool _isCompounded = true;

  @override
  void initState() {
    super.initState();
    _setDefaultValues();
  }

  void _setDefaultValues() {
    _principalController.text = AppConstants.defaultFDAmount.toString();
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
        title: const Text('FD Calculator', style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: AppConstants.fdColor,
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
            AppConstants.fdColor,
            AppConstants.fdColor.withValues(alpha: 0.8),
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
                    Icons.account_balance,
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
                        'Fixed Deposit',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Calculate your FD maturity amount',
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
              color: AppConstants.fdColor,
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
              _buildQuickStat('Type', _result!.isCompounded ? 'Compound' : 'Simple'),
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
            color: AppConstants.fdColor,
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
          _buildPrincipalAmountCard(),
          const SizedBox(height: 16),
          _buildInterestRateCard(),
          const SizedBox(height: 16),
          _buildTenureCard(),
          const SizedBox(height: 16),
          _buildInterestTypeCard(),
          const SizedBox(height: 24),
          _buildCalculateButton(),
        ],
      ),
    );
  }

  Widget _buildPrincipalAmountCard() {
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
                  color: AppConstants.fdColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.account_balance,
                  color: AppConstants.fdColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Principal Amount',
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
              color: AppConstants.fdColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Slider(
            value: amount.clamp(10000, 10000000),
            min: 10000,
            max: 10000000,
            divisions: 100,
            activeColor: AppConstants.fdColor,
            onChanged: (value) {
              setState(() {
                _principalController.text = value.round().toString();
              });
              _calculateFD();
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('₹10K', style: Theme.of(context).textTheme.bodySmall),
              Text('₹1Cr', style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInterestRateCard() {
    final rate = double.tryParse(_interestRateController.text) ?? 6.5;
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
              _calculateFD();
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
              _calculateFD();
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

  Widget _buildInterestTypeCard() {
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
                  color: AppConstants.fdColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.trending_up,
                  color: AppConstants.fdColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Interest Type',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isCompounded = true;
                    });
                    _calculateFD();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _isCompounded ? AppConstants.fdColor : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.trending_up,
                          color: _isCompounded ? Colors.white : Colors.grey[600],
                          size: 20,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Compound',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: _isCompounded ? Colors.white : Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Quarterly',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: _isCompounded ? Colors.white.withValues(alpha: 0.8) : Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isCompounded = false;
                    });
                    _calculateFD();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: !_isCompounded ? AppConstants.fdColor : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.show_chart,
                          color: !_isCompounded ? Colors.white : Colors.grey[600],
                          size: 20,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Simple',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: !_isCompounded ? Colors.white : Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Linear',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: !_isCompounded ? Colors.white.withValues(alpha: 0.8) : Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
          colors: [AppConstants.fdColor, AppConstants.fdColor.withValues(alpha: 0.8)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppConstants.fdColor.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _isCalculating ? null : _calculateFD,
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
                        'Calculate FD',
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
          _buildComparisonCard(),
        ],
      ),
    );
  }

  Widget _buildBreakdownCard() {
    final interestPercentage = (_result!.totalInterest / _result!.maturityAmount) * 100;
    final principalPercentage = (_result!.principal / _result!.maturityAmount) * 100;

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
                'Investment Breakdown',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppConstants.fdColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _result!.isCompounded ? 'Compound' : 'Simple',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppConstants.fdColor,
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
            AppConstants.fdColor,
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
            AppConstants.fdColor,
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

  Widget _buildResultSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Calculation Results',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppConstants.fdColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
                final childAspectRatio = constraints.maxWidth > 600 ? 1.2 : 1.1;

                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: AppConstants.paddingSmall,
                  mainAxisSpacing: AppConstants.paddingSmall,
                  childAspectRatio: childAspectRatio,
              children: [
                ResultCard(
                  title: 'Maturity Amount',
                  value: Helpers.formatCurrency(_result!.maturityAmount),
                  color: AppConstants.successColor,
                  icon: Icons.trending_up,
                ),
                ResultCard(
                  title: 'Principal Amount',
                  value: Helpers.formatCurrency(_result!.principal),
                  color: AppConstants.fdColor,
                  icon: Icons.account_balance,
                ),
                ResultCard(
                  title: 'Total Interest',
                  value: Helpers.formatCurrency(_result!.totalInterest),
                  color: AppConstants.warningColor,
                  icon: Icons.percent,
                ),
                ResultCard(
                  title: 'Interest Type',
                  value: _result!.isCompounded ? 'Compound' : 'Simple',
                  color: AppConstants.textSecondaryColor,
                  icon: Icons.timeline,
                ),
              ],
                );
              },
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            _buildSummaryCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    final returnPercentage = (_result!.totalInterest / _result!.principal) * 100;
    
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppConstants.fdColor.withOpacity(0.1),
            AppConstants.fdColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Investment Summary',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppConstants.fdColor,
            ),
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Principal Amount:', style: Theme.of(context).textTheme.bodyMedium),
              Text(
                Helpers.formatCurrency(_result!.principal),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tenure:', style: Theme.of(context).textTheme.bodyMedium),
              Text(
                Helpers.formatTenure(_result!.tenureMonths),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Return:', style: Theme.of(context).textTheme.bodyMedium),
              Text(
                Helpers.formatPercentage(returnPercentage),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppConstants.successColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Interest Type:', style: Theme.of(context).textTheme.bodyMedium),
              Text(
                _result!.isCompounded ? 'Compound (Quarterly)' : 'Simple Interest',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppConstants.fdColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getTenureText() {
    final tenure = int.tryParse(_tenureController.text);
    if (tenure == null) return '';
    return Helpers.formatTenure(tenure);
  }

  Widget _buildComparisonCard() {
    // Calculate both simple and compound for comparison
    final principal = double.tryParse(_principalController.text) ?? 100000;
    final interestRate = double.tryParse(_interestRateController.text) ?? 6.5;
    final tenure = int.tryParse(_tenureController.text) ?? 12;

    final simpleResult = FDCalculation.calculate(
      principal: principal,
      annualInterestRate: interestRate,
      tenureMonths: tenure,
      isCompounded: false,
    );

    final compoundResult = FDCalculation.calculate(
      principal: principal,
      annualInterestRate: interestRate,
      tenureMonths: tenure,
      isCompounded: true,
    );

    final difference = compoundResult.maturityAmount - simpleResult.maturityAmount;

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
            'Simple vs Compound Interest',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildComparisonItem(
                  'Simple Interest',
                  Helpers.formatCurrency(simpleResult.maturityAmount),
                  Icons.show_chart,
                  Colors.grey[600]!,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildComparisonItem(
                  'Compound Interest',
                  Helpers.formatCurrency(compoundResult.maturityAmount),
                  Icons.trending_up,
                  AppConstants.successColor,
                ),
              ),
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
                    'Compound interest earns ${Helpers.formatCurrency(difference)} more than simple interest',
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

  Widget _buildComparisonItem(String title, String amount, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _calculateFD() {
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
        final result = FDCalculation.calculate(
          principal: principal,
          annualInterestRate: interestRate,
          tenureMonths: tenure,
          isCompounded: _isCompounded,
        );

        setState(() {
          _result = result;
          _isCalculating = false;
        });
      }
    });
  }
}
