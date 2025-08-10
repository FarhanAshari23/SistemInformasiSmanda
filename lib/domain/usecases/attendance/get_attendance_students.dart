import 'package:dartz/dartz.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/attandance/param_attendance.dart';
import 'package:new_sistem_informasi_smanda/domain/repository/attandance/attandance.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';

class GetAttendanceStudentsUsecase
    implements Usecase<Either, ParamAttendanceEntity> {
  @override
  Future<Either> call({ParamAttendanceEntity? params}) async {
    return await sl<AttandanceRepository>().getAttendanceStudents(params!);
  }
}
