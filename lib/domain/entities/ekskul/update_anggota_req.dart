import 'anggota.dart';

class UpdateAnggotaReq {
  final AnggotaEntity anggota;
  final List<String> namaEkskul;

  UpdateAnggotaReq({
    required this.namaEkskul,
    required this.anggota,
  });
}
