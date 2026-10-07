import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _currencyFormat = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 2,
  );

  static final NumberFormat _compactCurrencyFormat = NumberFormat.compactCurrency(
    symbol: '\$',
    decimalDigits: 2,
  );

  static String format(num? amount, {int decimalDigits = 2}) {
    if (amount == null) return '\$0.00';
    if (decimalDigits != 2) {
      return NumberFormat.currency(symbol: '\$', decimalDigits: decimalDigits).format(amount);
    }
    return _currencyFormat.format(amount);
  }

  static String formatCompact(num? amount) {
    if (amount == null) return '\$0.00';
    return _compactCurrencyFormat.format(amount);
  }

  static String formatCrypto(num? quantity, {String symbol = ''}) {
    if (quantity == null) return '0.00 $symbol'.trim();
    final formatted = quantity.toStringAsFixed(quantity < 1 ? 4 : 2);
    return symbol.isNotEmpty ? '$formatted $symbol' : formatted;
  }

  static String formatPercentage(num? percentage) {
    if (percentage == null) return '0.00%';
    final sign = percentage > 0 ? '+' : '';
    return '$sign${percentage.toStringAsFixed(2)}%';
  }
}
