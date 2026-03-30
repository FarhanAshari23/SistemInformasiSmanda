import 'package:dartz/dartz.dart';

import '../../entities/ekskul/ekskul.dart';

abstract class EkskulRepository {
  Future<Either> getEkskul();
  Future<Either> getStudentEkskul(int studentId);
  Future<Either> createEkskul(EkskulEntity ekskulCreationReq);
  Future<Either> updateEkskul(EkskulEntity ekskulUpdateReq);
  Future<Either> deleteEkskul(int ekskulId);
}
