class UserData {
  String name;
  String email;
  String no;

  UserData({required this.name, required this.email, required this.no});

  Map<String, dynamic> toMap() =>
      {'name': this.name, 'email': this.email, 'no': this.no};
}
