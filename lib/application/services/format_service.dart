class FormatService {
  FormatService({this.currencySymbol = r'\$', this.locale = 'en_US'});

  final String currencySymbol;
  final String locale;

  String currency(num value, {bool withSymbol = true}) {
    final formatted = value.toStringAsFixed(2);
    return withSymbol ? '$currencySymbol$formatted' : formatted;
  }

  String compactNumber(num value) {
    final abs = value.abs();
    String suffix = '';
    double scaled = abs.toDouble();
    if (abs >= 1000000) {
      suffix = 'M';
      scaled = abs / 1000000;
    } else if (abs >= 1000) {
      suffix = 'K';
      scaled = abs / 1000;
    }
    final sign = value < 0 ? '-' : '';
    return '$sign${scaled.toStringAsFixed(scaled >= 100 ? 0 : 1)}$suffix';
  }

  String digits(num value, {int decimals = 0}) {
    return value.toStringAsFixed(decimals);
  }

  String vatAmount(num value, {double vatRate = 0.15}) {
    final vat = value * vatRate;
    return currency(vat);
  }

  String formatUnits(num value, String unitKey) {
    switch (unitKey) {
      case 'weight':
        return '${value.toStringAsFixed(1)} kg';
      case 'length':
        return '${value.toStringAsFixed(1)} cm';
      default:
        return value.toString();
    }
  }

  String timeRemaining(Duration duration) {
    if (duration.isNegative) {
      return '0s';
    }
    if (duration.inDays >= 1) {
      return '${duration.inDays}d';
    }
    if (duration.inHours >= 1) {
      return '${duration.inHours}h';
    }
    if (duration.inMinutes >= 1) {
      return '${duration.inMinutes}m';
    }
    return '${duration.inSeconds}s';
  }

  String dateTimeShort(DateTime date) {
    final month = _twoDigits(date.month);
    final day = _twoDigits(date.day);
    final hour = _twoDigits(date.hour);
    final minute = _twoDigits(date.minute);
    return '$day/$month ${hour}:$minute';
  }

  String _twoDigits(int value) => value.toString().padLeft(2, '0');
}
