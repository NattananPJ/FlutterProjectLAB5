class Note {
  int? id;
  String title, description;
  DateTime createdAt;
  String time;

  Note({
    this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt.toString(),
      'time': time,
    };
  }
}