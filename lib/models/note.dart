/// Model data catatan kuliah.
class Note {
  final String id;
  final String title;
  final DateTime date;
  final String? content;

  Note({
    required this.id,
    required this.title,
    required this.date,
    this.content,
  });

  /// Mengubah Note menjadi Map untuk disimpan sebagai JSON.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
    };
  }

  /// Membuat Note dari Map (JSON).
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      date: DateTime.parse(map['date']),
    );
  }

  /// Mengembalikan salinan Note.
  Note copyWith({String? id, String? title, DateTime? date, String? content}) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      content: content ?? this.content,
    );
  }
}