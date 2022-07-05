class PromoCode {
  String user;
  String code;
  String email;
  int rons;
  int ronsLeft;
  String expire;

  PromoCode(
      {this.user,
      this.code,
      this.email,
      this.rons,
      this.ronsLeft,
      this.expire});

  PromoCode.fromJson(Map<String, dynamic> json)
      : user = json['user'],
        code = json['code'],
        email = json['email'],
        rons = json['rons'],
        expire = json['expire'],
        ronsLeft = json['ronsLeft'];
}
