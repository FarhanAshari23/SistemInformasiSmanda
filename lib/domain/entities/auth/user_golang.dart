import 'dart:io';

class UserGolang {
  int? id;
  String? nisn;
  String? name;
  int? kelasId;
  String? nameClass;
  String? religion;
  String? address;
  String? email;
  String? mobileNum;
  int? gender;
  DateTime? birthDate;
  String? password;
  bool? isRegister;
  bool? isAdmin;
  String? iv;
  File? imageFile;

  UserGolang({
    this.id,
    this.nisn,
    this.name,
    this.kelasId,
    this.nameClass,
    this.religion,
    this.address,
    this.mobileNum,
    this.gender,
    this.birthDate,
    this.password,
    this.isRegister,
    this.isAdmin,
    this.iv,
    this.email,
    this.imageFile,
  });

  UserGolang copyWith({
    int? id,
    String? nisn,
    String? name,
    int? kelasId,
    String? nameClass,
    String? religion,
    String? address,
    String? email,
    String? mobileNum,
    int? gender,
    DateTime? birthDate,
    String? password,
    bool? isRegister,
    bool? isAdmin,
    String? iv,
    File? imageFile,
  }) {
    return UserGolang(
      id: id ?? this.id,
      nisn: nisn ?? this.nisn,
      name: name ?? this.name,
      kelasId: kelasId ?? this.kelasId,
      nameClass: nameClass ?? this.nameClass,
      religion: religion ?? this.religion,
      address: address ?? this.address,
      email: email ?? this.email,
      mobileNum: mobileNum ?? this.mobileNum,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      password: password ?? this.password,
      isRegister: isRegister ?? this.isRegister,
      isAdmin: isAdmin ?? this.isAdmin,
      iv: iv ?? this.iv,
      imageFile: imageFile ?? this.imageFile,
    );
  }
}
