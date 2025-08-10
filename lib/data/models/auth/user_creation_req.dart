class UserCreationReq {
  String? email;
  String? password;
  String? nama;
  String? kelas;
  String? nisn;
  String? tanggalLahir;
  String? noHP;
  String? address;
  String? ekskul;
  int? gender;
  bool? isAdmin;
  String? agama;

  UserCreationReq({
    this.email,
    this.password,
    this.nama,
    this.kelas,
    this.nisn,
    this.tanggalLahir,
    this.noHP,
    this.address,
    this.ekskul,
    this.gender,
    this.isAdmin,
    this.agama,
  });
}
