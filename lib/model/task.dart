import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  int id;
  String judul;
  String tanggalDeadline;
  String jamDeadline;
  bool isDone;
  String tanggalDibuat;

  Task({
    required this.id,
    required this.judul,
    required this.tanggalDeadline,
    required this.jamDeadline,
    this.isDone = false,
    required this.tanggalDibuat,
  });

  factory Task.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>>? map) {
    return Task(
      id: map!['id'],
      judul: map['judul'],
      tanggalDeadline: map['tanggalDeadline'],
      jamDeadline: map['jamDeadline'],
      isDone: map['isDone'],
      tanggalDibuat: map['tanggalDibuat'],
    );
  }

  Map<String, dynamic> toMap() => {
        'id': this.id,
        'judul': this.judul,
        'tanggalDeadline': this.tanggalDeadline,
        'jamDeadline': this.jamDeadline,
        'isDone': this.isDone,
        'tanggalDibuat': this.tanggalDibuat,
      };
}
