class AppValidators {
  AppValidators._();

  static String? requiredField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Field is required';
    }
    return null;
  }

  static String? positiveNumber(String? value) {
    final parsed = double.tryParse(value ?? '');
    if (parsed == null || parsed <= 0) {
      return 'Enter a positive number';
    }
    return null;
  }
}
