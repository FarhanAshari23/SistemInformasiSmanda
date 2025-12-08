import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../../entities/attandance/param_attendance_teacher.dart';
import '../../repository/attandance/attandance.dart';

class GetAttendanceAllTeacherUsecase
    implements Usecase<Either, ParamAttendanceTeacher> {
  @override
  Future<Either> call({ParamAttendanceTeacher? params}) async {
    return await sl<AttandanceRepository>().getAttendanceAllTeacher(params!);
  }
}
