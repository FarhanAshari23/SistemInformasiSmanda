import 'dart:io';

class TeacherGolangEntity {
  int? id, gender;
  List<int>? tasksId;
  List<String>? tasksName;
  String? waliKelas, name, nip, email, password;
  DateTime? birthDate;
  File? imageFile;

  TeacherGolangEntity({
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

  TeacherGolangEntity copyWith({
    int? id,
    gender,
    List<int>? tasksId,
    String? waliKelas,
    name,
    nip,
    email,
    password,
    DateTime? birthDate,
    List<String>? tasksName,
    File? imageFile,
  }) {
    return TeacherGolangEntity(
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
