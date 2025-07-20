import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/financial_models.dart';

class CurrencyService {
  static const String _baseUrl = 'https://api.exchangerate-api.com/v4/latest';
  static const Duration _cacheTimeout = Duration(hours: 1);
  
  static Map<String, CurrencyRate> _cache = {};
  static DateTime? _lastCacheUpdate;

  // Popular currencies
  static const List<String> popularCurrencies = [
    'USD', 'EUR', 'GBP', 'JPY', 'AUD', 'CAD', 'CHF', 'CNY', 'SEK', 'NZD',
    'INR', 'SGD', 'HKD', 'NOK', 'MXN', 'ZAR', 'BRL', 'RUB', 'KRW', 'TRY'
  ];

  static const Map<String, String> currencyNames = {
    'USD': 'US Dollar',
    'EUR': 'Euro',
    'GBP': 'British Pound',
    'JPY': 'Japanese Yen',
    'AUD': 'Australian Dollar',
    'CAD': 'Canadian Dollar',
    'CHF': 'Swiss Franc',
    'CNY': 'Chinese Yuan',
    'SEK': 'Swedish Krona',
    'NZD': 'New Zealand Dollar',
    'INR': 'Indian Rupee',
    'SGD': 'Singapore Dollar',
    'HKD': 'Hong Kong Dollar',
    'NOK': 'Norwegian Krone',
    'MXN': 'Mexican Peso',
    'ZAR': 'South African Rand',
    'BRL': 'Brazilian Real',
    'RUB': 'Russian Ruble',
    'KRW': 'South Korean Won',
    'TRY': 'Turkish Lira',
  };

  static const Map<String, String> currencySymbols = {
    'USD': '\$',
    'EUR': '€',
    'GBP': '£',
    'JPY': '¥',
    'AUD': 'A\$',
    'CAD': 'C\$',
    'CHF': 'CHF',
    'CNY': '¥',
    'SEK': 'kr',
    'NZD': 'NZ\$',
    'INR': '₹',
    'SGD': 'S\$',
    'HKD': 'HK\$',
    'NOK': 'kr',
    'MXN': '\$',
    'ZAR': 'R',
    'BRL': 'R\$',
    'RUB': '₽',
    'KRW': '₩',
    'TRY': '₺',
  };

  static Future<double> getExchangeRate(String from, String to) async {
    if (from == to) return 1.0;

    final String cacheKey = '${from}_$to';
    
    // Check cache first
    if (_cache.containsKey(cacheKey) && _isCacheValid()) {
      return _cache[cacheKey]!.rate;
    }

    try {
      // Fetch from API
      final response = await http.get(
        Uri.parse('$_baseUrl/$from'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final rates = data['rates'] as Map<String, dynamic>;
        
        if (rates.containsKey(to)) {
          final rate = (rates[to] as num).toDouble();
          
          // Cache the result
          _cache[cacheKey] = CurrencyRate(
            fromCurrency: from,
            toCurrency: to,
            rate: rate,
            lastUpdated: DateTime.now(),
          );
          _lastCacheUpdate = DateTime.now();
          
          return rate;
        } else {
          throw Exception('Currency $to not found');
        }
      } else {
        throw Exception('Failed to fetch exchange rate: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback to cached data if available, even if expired
      if (_cache.containsKey(cacheKey)) {
        return _cache[cacheKey]!.rate;
      }
      
      // Return mock data for demo purposes
      return _getMockRate(from, to);
    }
  }

  static Future<Map<String, double>> getAllRates(String baseCurrency) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/$baseCurrency'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final rates = data['rates'] as Map<String, dynamic>;
        
        return rates.map((key, value) => MapEntry(key, (value as num).toDouble()));
      } else {
        throw Exception('Failed to fetch rates: ${response.statusCode}');
      }
    } catch (e) {
      // Return mock data for demo purposes
      return _getMockRates(baseCurrency);
    }
  }

  static double convertCurrency(double amount, double exchangeRate) {
    return amount * exchangeRate;
  }

  static bool _isCacheValid() {
    if (_lastCacheUpdate == null) return false;
    return DateTime.now().difference(_lastCacheUpdate!) < _cacheTimeout;
  }

  static void clearCache() {
    _cache.clear();
    _lastCacheUpdate = null;
  }

  // Mock data for demo purposes when API is not available
  static double _getMockRate(String from, String to) {
    final mockRates = {
      'USD_EUR': 0.85,
      'USD_GBP': 0.73,
      'USD_JPY': 110.0,
      'USD_INR': 74.5,
      'EUR_USD': 1.18,
      'EUR_GBP': 0.86,
      'EUR_JPY': 129.0,
      'EUR_INR': 87.8,
      'GBP_USD': 1.37,
      'GBP_EUR': 1.16,
      'GBP_JPY': 150.0,
      'GBP_INR': 102.0,
      'INR_USD': 0.0134,
      'INR_EUR': 0.0114,
      'INR_GBP': 0.0098,
      'INR_JPY': 1.48,
    };

    final key = '${from}_$to';
    if (mockRates.containsKey(key)) {
      return mockRates[key]!;
    }

    // If reverse rate exists, calculate inverse
    final reverseKey = '${to}_$from';
    if (mockRates.containsKey(reverseKey)) {
      return 1.0 / mockRates[reverseKey]!;
    }

    // Default fallback
    return 1.0;
  }

  static Map<String, double> _getMockRates(String baseCurrency) {
    final Map<String, double> rates = {};
    
    for (String currency in popularCurrencies) {
      if (currency != baseCurrency) {
        rates[currency] = _getMockRate(baseCurrency, currency);
      }
    }
    
    return rates;
  }

  static String getCurrencyName(String code) {
    return currencyNames[code] ?? code;
  }

  static String getCurrencySymbol(String code) {
    return currencySymbols[code] ?? code;
  }
}
