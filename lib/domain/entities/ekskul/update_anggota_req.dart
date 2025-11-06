import '../auth/user.dart';

class UpdateAnggotaReq {
  final UserEntity anggota;
  final List<String> namaEkskul;

  UpdateAnggotaReq({
    required this.namaEkskul,
    required this.anggota,
  });
}
