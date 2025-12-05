import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../../entities/teacher/teacher.dart';
import '../../repository/attandance/attandance.dart';

class AddTeacherAttendanceUseCase implements Usecase<Either, TeacherEntity> {
  @override
  Future<Either> call({TeacherEntity? params}) async {
    return await sl<AttandanceRepository>().addTeacherAttendances(params!);
  }
}
