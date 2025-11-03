import 'package:dartz/dartz.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/ekskul/update_anggota_req.dart';

import '../../entities/ekskul/ekskul.dart';

abstract class EkskulRepository {
  Future<Either> createEkskul(EkskulEntity ekskulCreationReq);
  Future<Either> addAnggota(UpdateAnggotaReq anggotaReq);
  Future<Either> updateAnggota(UpdateAnggotaReq anggotaReq);
  Future<Either> deleteAnggota(UpdateAnggotaReq anggotaReq);
  Future<Either> getEkskul();
  Future<Either> updateEkskul(EkskulEntity ekskulUpdateReq);
  Future<Either> deleteEkskul(EkskulEntity ekskul);
}
