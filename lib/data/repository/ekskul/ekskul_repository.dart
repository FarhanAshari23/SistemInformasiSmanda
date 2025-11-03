import 'package:dartz/dartz.dart';
import 'package:new_sistem_informasi_smanda/data/models/ekskul/ekskul.dart';
import 'package:new_sistem_informasi_smanda/data/sources/ekskul/ekskul_firebase_service.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/ekskul/ekskul.dart';
import 'package:new_sistem_informasi_smanda/domain/repository/ekskul/ekskul.dart';
import 'package:new_sistem_informasi_smanda/service_locator.dart';

import '../../../domain/entities/ekskul/update_anggota_req.dart';

class EkskulRepositoryImpl extends EkskulRepository {
  @override
  Future<Either> createEkskul(EkskulEntity ekskulCreationReq) async {
    return await sl<EkskulFirebaseService>().createEkskul(ekskulCreationReq);
  }

  @override
  Future<Either> getEkskul() async {
    var returnedData = await sl<EkskulFirebaseService>().getEkskul();
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(data)
              .map((e) => EkskulModel.fromMap(e).toEntity())
              .toList(),
        );
      },
    );
  }

  @override
  Future<Either> deleteEkskul(EkskulEntity ekskul) async {
    return await sl<EkskulFirebaseService>().deleteEkskul(ekskul);
  }

  @override
  Future<Either> updateEkskul(EkskulEntity ekskulUpdateReq) async {
    return await sl<EkskulFirebaseService>().updateEkskul(ekskulUpdateReq);
  }

  @override
  Future<Either> addAnggota(UpdateAnggotaReq anggotaReq) async {
    return await sl<EkskulFirebaseService>().addAnggota(anggotaReq);
  }

  @override
  Future<Either> updateAnggota(UpdateAnggotaReq anggotaReq) async {
    return await sl<EkskulFirebaseService>().updateAnggota(anggotaReq);
  }

  @override
  Future<Either> deleteAnggota(UpdateAnggotaReq anggotaReq) async {
    return await sl<EkskulFirebaseService>().deleteAnggota(anggotaReq);
  }
}
