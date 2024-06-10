class JoinRequest {
  String loginId;
  String password;
  String passwordCheck;
  String name;

  JoinRequest({
    required this.loginId,
    required this.password,
    required this.passwordCheck,
    required this.name,
  });

  factory JoinRequest.fromJson(Map<String, dynamic> json) {
    return JoinRequest(
      loginId: json['loginId'],
      password: json['password'],
      passwordCheck: json['passwordCheck'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'loginId': loginId,
      'password': password,
      'passwordCheck': passwordCheck,
      'name': name,
    };
  }
}
