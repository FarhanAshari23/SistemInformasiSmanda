import 'package:new_sistem_informasi_smanda/domain/entities/auth/teacher.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/auth/user.dart';

class EkskulEntity {
  final String namaEkskul;
  final TeacherEntity pembina;
  final UserEntity ketua;
  final UserEntity wakilKetua;
  final UserEntity sekretaris;
  final UserEntity bendahara;
  final String deskripsi;
  final List<UserEntity> anggota;
  final String? oldNamaEkskul;

  EkskulEntity({
    required this.namaEkskul,
    required this.pembina,
    required this.ketua,
    required this.wakilKetua,
    required this.sekretaris,
    required this.bendahara,
    required this.deskripsi,
    required this.anggota,
    this.oldNamaEkskul,
  });
}
