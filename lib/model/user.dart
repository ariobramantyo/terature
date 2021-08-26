class UserData {
  String? name;
  String? email;
  String? no;
  String? imageUrl;

  UserData({this.name, this.email, this.no, this.imageUrl = ''});

  Map<String, dynamic> toMap() => {
        'name': this.name,
        'email': this.email,
        'no': this.no,
        'imageUrl': this.imageUrl,
      };
}
