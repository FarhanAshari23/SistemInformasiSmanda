import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../../entities/attandance/attendance_student.dart';
import '../../repository/attandance/attandance.dart';

class GetAttendanceNameUsecase
    implements Usecase<Either, AttendanceStudentEntity> {
  @override
  Future<Either> call({AttendanceStudentEntity? params}) async {
    return await sl<AttandanceRepository>().searchStudentAttendance(params!);
  }
}
