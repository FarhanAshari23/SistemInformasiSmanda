import '../student/student.dart';

class UpdateAnggotaReq {
  final StudentEntity anggota;
  final List<String> namaEkskul;

  UpdateAnggotaReq({
    required this.namaEkskul,
    required this.anggota,
  });
}
