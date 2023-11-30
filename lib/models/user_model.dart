class UserModel {
  final String name;
  final String pic;
  final String uid;
  final String email;
  final String phone;
  final String gender;
  final DateTime? birth;
  final DateTime? timestamp;
  final String link;
  final List? wallet;
  final List? address;
  bool verified;
  bool blocked;
  double coins;

  UserModel(
      {this.name = '',
      this.pic = '',
      this.uid = '',
      this.email = '',
      this.phone = '',
      this.birth,
      this.gender = '',
      this.timestamp,
      this.coins = 0.0,
      this.link = '',
      this.wallet,
      this.address,
      this.blocked = false,
      this.verified = false});

  factory UserModel.fromJson(Map json) {
    return UserModel(
      name: json['name'] ?? '',
      pic: json['pic'] ?? '',
      uid: json['uid'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      gender: json['gender'] ?? '',
      birth: json['birth'].toDate() ?? DateTime.now(),
      timestamp: json['timestamp'].toDate() ?? DateTime.now(),
      verified: json['verified'] ?? false,
      blocked: json['blocked'] ?? false,
      coins: double.parse(json['coins'].toString()),
      wallet: json['wallet'] ?? [],
      address: json['address'] ?? [],
      link: json['link'] ?? '',
    );
  }
}
