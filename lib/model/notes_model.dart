class NotesModel {
  final int? id;
  final String? title;
  final int? age;
  final String? description;
  final String? email;
  NotesModel({
    required this.age,
    required this.description,
    required this.email,
    this.id,
    required this.title,
  });
  NotesModel.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        title = res["title"],
        age = res["age"],
        description = res["description"],
        email = res["email"];
  Map<String, Object?> toMap() {
    return {
      "id": id,
      "title": title,
      "age": age,
      "description": description,
      "email": email,
    };
  }
}
