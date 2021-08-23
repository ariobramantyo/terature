class UserData {
  String name;
  String email;
  String no;
  String imageUrl;

  UserData(
      {required this.name,
      required this.email,
      required this.no,
      this.imageUrl = ''});

  Map<String, dynamic> toMap() => {
        'name': this.name,
        'email': this.email,
        'no': this.no,
        'imageUrl': this.imageUrl,
      };
}
