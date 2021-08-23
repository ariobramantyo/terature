import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String judul;
  String tanggalDeadline;
  String jamDeadline;
  bool isDone;
  String dateTime;

  Task({
    required this.judul,
    required this.tanggalDeadline,
    required this.jamDeadline,
    this.isDone = false,
    required this.dateTime,
  });

  factory Task.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>>? map) {
    return Task(
      judul: map!['judul'],
      tanggalDeadline: map['tanggalDeadline'],
      jamDeadline: map['jamDeadline'],
      isDone: map['isDone'],
      dateTime: map['dateTime'],
    );
  }

  Map<String, dynamic> toMap() => {
        'judul': this.judul,
        'tanggalDeadline': this.tanggalDeadline,
        'jamDeadline': this.jamDeadline,
        'isDone': this.isDone,
        'dateTime': this.dateTime,
      };
}
