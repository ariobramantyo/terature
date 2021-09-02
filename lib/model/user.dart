class UserData {
  String? uid;
  String? name;
  String? email;
  String? no;
  String? imageUrl;

  UserData({this.uid, this.name, this.email, this.no, this.imageUrl = ''});

  Map<String, dynamic> toMap() => {
        'uid': this.uid,
        'name': this.name,
        'email': this.email,
        'no': this.no,
        'imageUrl': this.imageUrl,
      };
}
