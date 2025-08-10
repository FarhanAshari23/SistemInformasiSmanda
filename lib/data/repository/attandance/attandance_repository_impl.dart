import 'package:dartz/dartz.dart';
import 'package:new_sistem_informasi_smanda/data/models/attendance/attendance.dart';
import 'package:new_sistem_informasi_smanda/data/sources/attandance/attandance_firebase_service.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/auth/user.dart';
import 'package:new_sistem_informasi_smanda/domain/repository/attandance/attandance.dart';

import '../../../domain/entities/attandance/param_attendance.dart';
import '../../../service_locator.dart';
import '../../models/auth/user.dart';

class AttandanceRepositoryImpl extends AttandanceRepository {
  @override
  Future<Either> createDate() async {
    return await sl<AttandanceFirebaseService>().createDate();
  }

  @override
  Future<Either> addStudentAttendances(UserEntity userAddReq) async {
    return await sl<AttandanceFirebaseService>()
        .addStudentAttendances(userAddReq);
  }

  @override
  Future<Either> getListAttendanceDate() async {
    var returnedData =
        await sl<AttandanceFirebaseService>().getListAttendanceDate();
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(data)
              .map((e) => AttendanceModel.fromMap(e).toEntity())
              .toList(),
        );
      },
    );
  }

  @override
  Future<Either> getAttendanceStudents(
      ParamAttendanceEntity attendanceReq) async {
    var returnedData = await sl<AttandanceFirebaseService>()
        .getAttendanceStudents(attendanceReq);
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(data)
              .map(
                (e) => UserModel.fromMap(e).toEntity(),
              )
              .toList(),
        );
      },
    );
  }

  @override
  Future<Either> searchStudentAttendance(
      ParamAttendanceEntity attendanceReq) async {
    var returnedData = await sl<AttandanceFirebaseService>()
        .searchStudentAttendance(attendanceReq);
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(data)
              .map(
                (e) => UserModel.fromMap(e).toEntity(),
              )
              .toList(),
        );
      },
    );
  }
}
