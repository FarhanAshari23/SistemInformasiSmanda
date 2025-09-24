import 'package:dartz/dartz.dart';

import '../../entities/ekskul/ekskul.dart';

abstract class EkskulRepository {
  Future<Either> createEkskul(EkskulEntity ekskulCreationReq);
  Future<Either> getEkskul();
  Future<Either> updateEkskul(EkskulEntity ekskulUpdateReq);
  Future<Either> deleteEkskul(String nameEkskul);
}
