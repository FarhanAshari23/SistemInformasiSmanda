class UpdateUserReq {
  final String nama;
  final String kelas;
  final String nisn;
  final String tanggalLahir;
  final String noHp;
  final String alamat;
  final String ekskul;
  final String agama;
  final int gender;

  UpdateUserReq({
    required this.nama,
    required this.kelas,
    required this.nisn,
    required this.tanggalLahir,
    required this.noHp,
    required this.alamat,
    required this.ekskul,
    required this.agama,
    required this.gender,
  });
}
