class CouponModel {
  final String id;
  final String descriptionEn;
  final String descriptionAr;
  final String code;
  final double discount;
  final double max;
  final DateTime? timestamp;
  final DateTime? endTime;
  final String link;

  CouponModel(
      {this.id = '',
      this.descriptionEn = '',
      this.descriptionAr = '',
      this.code = '',
      this.timestamp,
      this.endTime,
      this.discount = 0.0,
      this.max = 0.0,
      this.link = ''});

  factory CouponModel.fromJson(Map json) {
    return CouponModel(
        descriptionEn: json['descriptionEn'] ?? '',
        descriptionAr: json['descriptionAr'] ?? '',
        id: json['id'] ?? '',
        code: json['code'] ?? '',
        timestamp: json['timestamp'] ?? DateTime.now(),
        endTime: json['endTime'] ?? DateTime.now(),
        link: json['link'] ?? '',
        max: json['max'] ?? 0.0,
        discount: json['discount'] ?? 0.0);
  }
}
