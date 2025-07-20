import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/currency_service.dart';
import '../utils/app_constants.dart';
import '../utils/helpers.dart';


class CurrencyConverterScreen extends StatefulWidget {
  const CurrencyConverterScreen({super.key});

  @override
  State<CurrencyConverterScreen> createState() => _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  String _fromCurrency = 'USD';
  String _toCurrency = 'INR';
  double _convertedAmount = 0.0;
  double _exchangeRate = 0.0;
  bool _isLoading = false;
  DateTime? _lastUpdated;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _amountController.text = '100';
    // Add a small delay to ensure the widget is fully built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _convertCurrency();
      }
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Currency Converter', style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: AppConstants.currencyColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _convertCurrency,
            tooltip: 'Refresh rates',
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                if (_errorMessage != null) ...[
                  _buildErrorCard(),
                  const SizedBox(height: 16),
                ],
                _buildMainConverterCard(),
                const SizedBox(height: 20),
                if (_convertedAmount > 0) _buildResultCard(),
                const SizedBox(height: 20),
                _buildExchangeRateCard(),
                const SizedBox(height: 20),
                _buildQuickCurrencySelector(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainConverterCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildAmountInputSection(),
            const SizedBox(height: 24),
            _buildCurrencySwapSection(),
            const SizedBox(height: 24),
            _buildConvertButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppConstants.currencyColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.attach_money_rounded,
                color: AppConstants.currencyColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Amount to Convert',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!, width: 1),
          ),
          child: TextFormField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppConstants.currencyColor,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              hintText: 'Enter amount',
              hintStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.grey[400],
                fontWeight: FontWeight.normal,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(20),
              prefixIcon: Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppConstants.currencyColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.monetization_on_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an amount';
              }
              final amount = double.tryParse(value);
              if (amount == null) {
                return 'Please enter a valid number';
              }
              if (amount <= 0) {
                return 'Amount must be greater than 0';
              }
              if (amount > 1000000000) {
                return 'Amount too large';
              }
              return null;
            },
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            onChanged: (value) {
              if (value.isNotEmpty && _formKey.currentState!.validate()) {
                _convertCurrency();
              }
            },
            onTap: () {
              _amountController.selection = TextSelection(
                baseOffset: 0,
                extentOffset: _amountController.text.length,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCurrencySwapSection() {
    return Row(
      children: [
        Expanded(
          child: _buildCurrencyCard(
            label: 'From',
            currency: _fromCurrency,
            onTap: () => _showCurrencyPicker(true),
          ),
        ),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: _swapCurrencies,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppConstants.currencyColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppConstants.currencyColor.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.swap_horiz_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildCurrencyCard(
            label: 'To',
            currency: _toCurrency,
            onTap: () => _showCurrencyPicker(false),
          ),
        ),
      ],
    );
  }

  Widget _buildCurrencyCard({
    required String label,
    required String currency,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!, width: 1),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppConstants.currencyColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  CurrencyService.getCurrencySymbol(currency),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppConstants.currencyColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              currency,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            Text(
              CurrencyService.getCurrencyName(currency),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorCard() {
    return Card(
      elevation: 2,
      color: AppConstants.errorColor.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: AppConstants.errorColor,
              size: 20,
            ),
            const SizedBox(width: AppConstants.paddingSmall),
            Expanded(
              child: Text(
                _errorMessage!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppConstants.errorColor,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 16),
              onPressed: () {
                setState(() {
                  _errorMessage = null;
                });
              },
              color: AppConstants.errorColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConvertButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppConstants.currencyColor,
            AppConstants.currencyColor.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppConstants.currencyColor.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _isLoading ? null : () {
            if (_formKey.currentState!.validate()) {
              setState(() {
                _errorMessage = null;
              });
              _convertCurrency();
            }
          },
          child: Center(
            child: _isLoading
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
                        Icons.currency_exchange_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Convert Currency',
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

  Widget _buildResultCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppConstants.currencyColor.withValues(alpha: 0.1),
            AppConstants.currencyColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppConstants.currencyColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppConstants.currencyColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.trending_up_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Conversion Result',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppConstants.currencyColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        CurrencyService.getCurrencySymbol(_fromCurrency),
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppConstants.currencyColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _fromCurrency,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 24),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppConstants.currencyColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 24),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        CurrencyService.getCurrencySymbol(_toCurrency),
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppConstants.currencyColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _toCurrency,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    '${_amountController.text} $_fromCurrency',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_convertedAmount.toStringAsFixed(2)} $_toCurrency',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: AppConstants.currencyColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 36,
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

  Widget _buildExchangeRateCard() {
    if (_exchangeRate <= 0) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.timeline_rounded,
                    color: Colors.blue,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Exchange Rate',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '1 $_fromCurrency',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.blue,
                    size: 20,
                  ),
                  Text(
                    '${_exchangeRate.toStringAsFixed(4)} $_toCurrency',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            if (_lastUpdated != null) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Updated ${_lastUpdated!.hour.toString().padLeft(2, '0')}:${_lastUpdated!.minute.toString().padLeft(2, '0')}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showCurrencyPicker(bool isFromCurrency) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Select Currency',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: CurrencyService.popularCurrencies.length,
                itemBuilder: (context, index) {
                  final currency = CurrencyService.popularCurrencies[index];
                  return ListTile(
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppConstants.currencyColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          CurrencyService.getCurrencySymbol(currency),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppConstants.currencyColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      currency,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      CurrencyService.getCurrencyName(currency),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        if (isFromCurrency) {
                          _fromCurrency = currency;
                        } else {
                          _toCurrency = currency;
                        }
                        _errorMessage = null;
                      });
                      Navigator.pop(context);
                      if (_formKey.currentState!.validate()) {
                        _convertCurrency();
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickCurrencySelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.star_rounded,
                    color: Colors.green,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Popular Currencies',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: ['USD', 'EUR', 'GBP', 'JPY', 'INR', 'AUD', 'CAD', 'CHF'].map((currency) {
                final isSelected = currency == _fromCurrency || currency == _toCurrency;
                return GestureDetector(
                  onTap: () {
                    if (!isSelected) {
                      setState(() {
                        _toCurrency = currency;
                        _errorMessage = null;
                      });
                      if (_formKey.currentState!.validate()) {
                        _convertCurrency();
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppConstants.currencyColor.withValues(alpha: 0.1)
                          : Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppConstants.currencyColor.withValues(alpha: 0.3)
                            : Colors.grey[200]!,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppConstants.currencyColor
                                : Colors.grey[400],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: Text(
                              CurrencyService.getCurrencySymbol(currency),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          currency,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? AppConstants.currencyColor
                                : Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }













  Widget _buildPopularCurrencies() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Convert',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            Wrap(
              spacing: AppConstants.paddingSmall,
              runSpacing: AppConstants.paddingSmall,
              children: ['USD', 'EUR', 'GBP', 'JPY', 'INR', 'AUD'].map((currency) {
                final isSelected = currency == _fromCurrency || currency == _toCurrency;
                return FilterChip(
                  label: Text(
                    '$currency ${CurrencyService.getCurrencySymbol(currency)}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected && currency != _fromCurrency && currency != _toCurrency) {
                      setState(() {
                        _toCurrency = currency;
                        _errorMessage = null;
                      });
                      if (_formKey.currentState!.validate()) {
                        _convertCurrency();
                      }
                    }
                  },
                  selectedColor: AppConstants.currencyColor.withValues(alpha: 0.2),
                  backgroundColor: Colors.grey.withValues(alpha: 0.1),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _swapCurrencies() {
    setState(() {
      final temp = _fromCurrency;
      _fromCurrency = _toCurrency;
      _toCurrency = temp;
      _errorMessage = null;
    });

    if (_formKey.currentState!.validate()) {
      _convertCurrency();
    }
  }

  Future<void> _convertCurrency() async {
    final amountText = _amountController.text;
    if (amountText.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter an amount to convert';
      });
      return;
    }

    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      setState(() {
        _errorMessage = 'Please enter a valid amount greater than 0';
      });
      return;
    }

    if (_fromCurrency == _toCurrency) {
      setState(() {
        _exchangeRate = 1.0;
        _convertedAmount = amount;
        _lastUpdated = DateTime.now();
        _errorMessage = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final rate = await CurrencyService.getExchangeRate(_fromCurrency, _toCurrency);
      final converted = CurrencyService.convertCurrency(amount, rate);

      if (mounted) {
        setState(() {
          _exchangeRate = rate;
          _convertedAmount = converted;
          _lastUpdated = DateTime.now();
          _isLoading = false;
          _errorMessage = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to fetch exchange rate. Please check your internet connection and try again.';
        });
      }
    }
  }
}
