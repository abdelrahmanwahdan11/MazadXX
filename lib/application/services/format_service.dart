class FormatService {
  FormatService({this.currencySymbol = r'\$'});

  final String currencySymbol;

  String currency(num value) {
    return '$currencySymbol${value.toStringAsFixed(2)}';
  }

  String timeRemaining(Duration duration) {
    if (duration.inHours >= 24) {
      final days = duration.inDays;
      return '${days}d';
    }
    if (duration.inHours >= 1) {
      return '${duration.inHours}h';
    }
    if (duration.inMinutes >= 1) {
      return '${duration.inMinutes}m';
    }
    return '${duration.inSeconds}s';
  }
}
