import 'package:dartz/dartz.dart';

import '../../../domain/entities/ekskul/ekskul.dart';
import '../../../domain/repository/ekskul/ekskul.dart';
import '../../../service_locator.dart';
import '../../models/ekskul/ekskul.dart';
import '../../models/ekskul/member.dart';
import '../../sources/ekskul/ekskul_firebase_service.dart';

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
  Future<Either> deleteEkskul(int ekskulId) async {
    return await sl<EkskulFirebaseService>().deleteEkskul(ekskulId);
  }

  @override
  Future<Either> updateEkskul(EkskulEntity ekskulUpdateReq) async {
    return await sl<EkskulFirebaseService>().updateEkskul(ekskulUpdateReq);
  }

  @override
  Future<Either> getStudentEkskul(int studentId) async {
    var returnedData =
        await sl<EkskulFirebaseService>().getStudentEkskul(studentId);
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(data)
              .map((e) => MemberModel.fromMap(e).toEntity())
              .toList(),
        );
      },
    );
  }
}
