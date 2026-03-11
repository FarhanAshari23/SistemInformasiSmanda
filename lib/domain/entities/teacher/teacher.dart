import 'dart:io';

class TeacherEntity {
  int? id, gender;
  List<int>? tasksId;
  List<String>? tasksName;
  String? waliKelas, name, nip, email, password;
  DateTime? birthDate;
  File? imageFile;

  TeacherEntity({
    this.id,
    this.gender,
    this.tasksId,
    this.waliKelas,
    this.name,
    this.nip,
    this.email,
    this.birthDate,
    this.tasksName,
    this.imageFile,
    this.password,
  });

  TeacherEntity copyWith({
    int? id,
    int? gender,
    List<int>? tasksId,
    String? waliKelas,
    String? name,
    String? nip,
    String? email,
    String? password,
    DateTime? birthDate,
    List<String>? tasksName,
    File? imageFile,
  }) {
    return TeacherEntity(
      id: id ?? this.id,
      gender: gender ?? this.gender,
      tasksId: tasksId ?? this.tasksId,
      waliKelas: waliKelas ?? this.waliKelas,
      name: name ?? this.name,
      nip: nip ?? this.nip,
      email: email ?? this.email,
      birthDate: birthDate ?? this.birthDate,
      tasksName: tasksName ?? this.tasksName,
      imageFile: imageFile ?? this.imageFile,
      password: password ?? this.password,
    );
  }
}
