class Note {
  int? id;
  String text;
  DateTime? date;
  String? userId;
  Note({this.id, required this.text, this.date, this.userId});

  factory Note.fromMap(Map<dynamic, dynamic> map) {
    return Note(
        id: map['id'],
        text: map['text'],
        date: DateTime.parse(map['date']),
        userId: map['userId']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'date': date?.toIso8601String(),
      'userId': userId,
    };
  }
}
