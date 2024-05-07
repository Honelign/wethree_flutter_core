class Note {
  dynamic? id;
  int? employeeId;
  String? note;
  int? creatorId;
  int? clientId;
  String? createdAt;
  String? updatedAt;
  Map? data;

  Note({
    this.id,
    this.note,
    this.employeeId,
    this.creatorId,
    this.clientId,
    this.createdAt,
    this.updatedAt,
    this.data,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      note: json['note'],
      clientId: json['client_id'],
      creatorId: json['creator_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      data: json,
    );
  }
}
