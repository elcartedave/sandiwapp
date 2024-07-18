import 'dart:convert';

class MyUser {
  final String? id;
  final String name;
  final String nickname;
  final String birthday;
  final String age;
  final String contactno;
  final String collegeAddress;
  final String homeAddress;
  final String email;
  final String password;
  final String sponsor;
  final String batch;
  final bool confirmed;
  final bool paid;
  final String balance;
  final String merit;
  final String demerit;
  final String? position;
  final String? photoUrl;
  final String? lupon;
  final String? paymentProofUrl;
  final bool acknowledged;
  final String degprog;

  MyUser({
    this.id,
    required this.name,
    required this.nickname,
    required this.birthday,
    required this.age,
    required this.contactno,
    required this.collegeAddress,
    required this.homeAddress,
    required this.email,
    required this.password,
    required this.sponsor,
    required this.batch,
    required this.confirmed,
    required this.paid,
    required this.balance,
    required this.merit,
    required this.demerit,
    required this.position,
    required this.photoUrl,
    required this.lupon,
    required this.paymentProofUrl,
    required this.acknowledged,
    required this.degprog,
  });
  factory MyUser.fromJson(Map<String, dynamic> json) {
    return MyUser(
      id: json['id'],
      name: json['name'],
      nickname: json['nickname'],
      birthday: json['birthday'],
      age: json['age'],
      contactno: json['contactno'],
      collegeAddress: json['collegeAddress'],
      homeAddress: json['homeAddress'],
      email: json['email'],
      password: '',
      sponsor: json['sponsor'],
      batch: json['batch'],
      confirmed: json['confirmed'],
      paid: json['paid'],
      balance: json['balance'],
      merit: json['merit'],
      demerit: json['demerit'],
      position: json['position'],
      photoUrl: json['photoUrl'],
      lupon: json['lupon'],
      paymentProofUrl: json['paymentProofUrl'],
      acknowledged: json['acknowledged'],
      degprog: json['degprog'],
    );
  }
  static List<MyUser> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<MyUser>((dynamic d) => MyUser.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(MyUser user) {
    return {
      'name': user.name,
      'nickname': user.nickname,
      'birthday': user.birthday,
      'age': user.age,
      'contactno': user.contactno,
      'collegeAddress': user.collegeAddress,
      'homeAddress': user.homeAddress,
      'email': user.email,
      'sponsor': user.sponsor,
      'batch': user.batch,
      'confirmed': user.confirmed,
      'paid': user.paid,
      'balance': user.balance,
      'merit': user.merit,
      'demerit': user.demerit,
      'position': user.position,
      'photoUrl': user.photoUrl,
      'lupon': user.lupon,
      'paymentProofUrl': user.paymentProofUrl,
      'acknowledged': user.acknowledged,
      'degprog': user.degprog
    };
  }
}
