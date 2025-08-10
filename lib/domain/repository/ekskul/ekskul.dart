import 'package:dartz/dartz.dart';
import 'package:new_sistem_informasi_smanda/data/models/ekskul/ekskul.dart';

import '../../entities/ekskul/ekskul.dart';

abstract class EkskulRepository {
  Future<Either> createEkskul(EkskulModel ekskulCreationReq);
  Future<Either> getEkskul();
  Future<Either> updateEkskul(EkskulEntity ekskulUpdateReq);
  Future<Either> deleteEkskul(String nameEkskul);
}
