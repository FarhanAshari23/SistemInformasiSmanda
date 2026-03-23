import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../../entities/attandance/attandance_teacher.dart';
import '../../repository/attandance/attandance.dart';

class GetAttendanceAllTeacherUsecase
    implements Usecase<Either, AttandanceTeacherEntity> {
  @override
  Future<Either> call({AttandanceTeacherEntity? params}) async {
    return await sl<AttandanceRepository>().getAttendanceAllTeacher(params!);
  }
}
