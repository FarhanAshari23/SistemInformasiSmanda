import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../../entities/student/student.dart';
import '../../repository/attandance/attandance.dart';

class AddStudentAttendanceUseCase implements Usecase<Either, StudentEntity> {
  @override
  Future<Either> call({StudentEntity? params}) async {
    return await sl<AttandanceRepository>().addStudentAttendances(params!);
  }
}
