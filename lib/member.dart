
class Member {
  final int id;
  final String loginId;
  final String name;
  final String role;
  final String? provider;
  final String? providerId;

  Member({
    required this.id,
    required this.loginId,
    required this.name,
    required this.role,
    this.provider,
    this.providerId,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    print("json : $json");
    return Member(
      id: json['id'],
      loginId: json['loginId'],
      name: json['name'],
      role: json['role'],
      provider: json['provider'],
      providerId: json['providerId'],
    );
  }
}
