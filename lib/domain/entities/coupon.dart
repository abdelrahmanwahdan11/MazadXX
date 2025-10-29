class Coupon {
  const Coupon({
    required this.code,
    required this.discount,
    required this.expires,
  });

  final String code;
  final double discount;
  final DateTime expires;
}
