import '../../domain/entities/coupon.dart';

class CouponModel extends Coupon {
  const CouponModel({
    required super.code,
    required super.discount,
    required super.expires,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) => CouponModel(
        code: json['code'] as String,
        discount: (json['discount'] as num).toDouble(),
        expires: DateTime.parse(json['expires'] as String),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'code': code,
        'discount': discount,
        'expires': expires.toIso8601String(),
      };
}
