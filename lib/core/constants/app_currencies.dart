class AppCurrency {
  final String code;
  final String symbol;
  final String name;

  const AppCurrency({
    required this.code,
    required this.symbol,
    required this.name,
  });
}

class AppCurrencies {
  AppCurrencies._();

  static const List<AppCurrency> all = [
    AppCurrency(code: 'PKR', symbol: '₨', name: 'Pakistani Rupee'),
    AppCurrency(code: 'USD', symbol: '\$', name: 'US Dollar'),
  ];

  static const AppCurrency defaultCurrency = AppCurrency(
    code: 'PKR',
    symbol: '₨',
    name: 'Pakistani Rupee',
  );

  static String symbolFor(String code) {
    final normalizedCode = code.trim().toUpperCase();

    final matches = all.where((currency) => currency.code == normalizedCode);

    if (matches.isEmpty) return code;

    return matches.first.symbol;
  }

  static String formatAmount({required String code, required double amount}) {
    final symbol = symbolFor(code);

    if (amount % 1 == 0) {
      return '$symbol${amount.toStringAsFixed(0)}';
    }

    return '$symbol${amount.toStringAsFixed(2)}';
  }
}
