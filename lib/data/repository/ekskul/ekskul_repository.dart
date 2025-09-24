import 'package:dartz/dartz.dart';
import 'package:new_sistem_informasi_smanda/data/models/ekskul/ekskul.dart';
import 'package:new_sistem_informasi_smanda/data/sources/ekskul/ekskul_firebase_service.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/ekskul/ekskul.dart';
import 'package:new_sistem_informasi_smanda/domain/repository/ekskul/ekskul.dart';
import 'package:new_sistem_informasi_smanda/service_locator.dart';

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
  Future<Either> deleteEkskul(String nameEkskul) async {
    return await sl<EkskulFirebaseService>().deleteEkskul(nameEkskul);
  }

  @override
  Future<Either> updateEkskul(EkskulEntity ekskulUpdateReq) async {
    return await sl<EkskulFirebaseService>().updateEkskul(ekskulUpdateReq);
  }

  @override
  Future<Either> updateAnggota(String anggota, namaEkskul) async {
    return await sl<EkskulFirebaseService>().updateAnggota(anggota, namaEkskul);
  }
}
