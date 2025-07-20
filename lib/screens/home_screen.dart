import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/app_constants.dart';
import '../widgets/custom_widgets.dart';
import 'rd_calculator_screen.dart';
import 'fd_calculator_screen.dart';
import 'loan_calculator_screen.dart';
import 'currency_converter_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _setStatusBarColor();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _setStatusBarColor();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _setStatusBarColor();
  }

  void _setStatusBarColor() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF4CAF50),
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Force set status bar color on every build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setStatusBarColor();
    });

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              _buildHeroHeader(context),
              _buildDashboardCards(context),
              _buildCalculatorGrid(context),
              _buildFinancialInsights(context),
              _buildFooterSection(context),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppConstants.primaryColor,
            AppConstants.primaryColor.withValues(alpha: 0.8),
            AppConstants.secondaryColor.withValues(alpha: 0.6),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Good ${_getGreeting()}! 👋',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'FinSwitch',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Your Smart Financial Companion',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      Icons.lightbulb_rounded,
                      color: AppConstants.primaryColor,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Calculate • Convert • Plan',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Make informed financial decisions',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 11,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    return 'Evening';
  }

  Widget _buildDashboardCards(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -20),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Expanded(
              child: _buildDashboardCard(
                context,
                'Quick EMI',
                'Calculate loan payments',
                Icons.calculate_rounded,
                AppConstants.loanColor,
                () => _navigateToScreen(context, const LoanCalculatorScreen()),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDashboardCard(
                context,
                'Currency',
                'Convert rates instantly',
                Icons.currency_exchange_rounded,
                AppConstants.currencyColor,
                () => _navigateToScreen(context, const CurrencyConverterScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
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
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  'Open',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: color,
                  size: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildCalculatorGrid(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.dashboard_rounded,
                  color: AppConstants.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Financial Calculators',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Powerful tools for smart financial decisions',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = constraints.maxWidth;
              final crossAxisCount = screenWidth > 600 ? 3 : 2;
              final childAspectRatio = screenWidth > 600 ? 0.9 : 0.75;

              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: childAspectRatio,
                children: [
                  _buildCalculatorCard(
                    context,
                    'RD Calculator',
                    'Recurring Deposits',
                    'Plan monthly savings',
                    Icons.savings_rounded,
                    AppConstants.rdColor,
                    () => _navigateToScreen(context, const RDCalculatorScreen()),
                  ),
                  _buildCalculatorCard(
                    context,
                    'FD Calculator',
                    'Fixed Deposits',
                    'Calculate maturity',
                    Icons.account_balance_rounded,
                    AppConstants.fdColor,
                    () => _navigateToScreen(context, const FDCalculatorScreen()),
                  ),
                  _buildCalculatorCard(
                    context,
                    'Loan Calculator',
                    'EMI & Interest',
                    'Calculate payments',
                    Icons.credit_card_rounded,
                    AppConstants.loanColor,
                    () => _navigateToScreen(context, const LoanCalculatorScreen()),
                  ),
                  _buildCalculatorCard(
                    context,
                    'Currency Converter',
                    'Exchange Rates',
                    'Convert currencies',
                    Icons.currency_exchange_rounded,
                    AppConstants.currencyColor,
                    () => _navigateToScreen(context, const CurrencyConverterScreen()),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCalculatorCard(
    BuildContext context,
    String title,
    String subtitle,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.08),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          color,
                          color.withValues(alpha: 0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: Colors.white, size: 20),
                  ),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      color: color,
                      size: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Expanded(
                child: Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    height: 1.2,
                    fontSize: 11,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFinancialInsights(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: _buildInsightCard(context),
    );
  }

  Widget _buildInsightCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppConstants.successColor.withValues(alpha: 0.1),
            AppConstants.successColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppConstants.successColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF4CAF50),
                      Color(0xFF2E7D32),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppConstants.successColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.lightbulb_rounded, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Financial Tip',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppConstants.successColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Smart Planning Starts Here',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Use our calculators to compare different investment options and make informed financial decisions. Regular planning helps you achieve your financial goals faster.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[700],
              height: 1.4,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }





  Widget _buildFooterSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.support_agent_rounded,
                  color: AppConstants.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Need Help?',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Our financial calculators are designed to help you make informed decisions.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.help_outline_rounded,
                        color: AppConstants.primaryColor,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'Help Center',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppConstants.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: AppConstants.successColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.feedback_rounded,
                        color: AppConstants.successColor,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'Feedback',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppConstants.successColor,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}
