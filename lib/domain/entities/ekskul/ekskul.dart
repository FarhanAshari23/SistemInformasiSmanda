import '../student/student.dart';
import '../teacher/teacher.dart';

class EkskulEntity {
  final String namaEkskul;
  final TeacherEntity pembina;
  final StudentEntity ketua;
  final StudentEntity wakilKetua;
  final StudentEntity sekretaris;
  final StudentEntity bendahara;
  final String deskripsi;
  final List<StudentEntity> anggota;
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
