import 'package:dartz/dartz.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/auth/user.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../../repository/attandance/attandance.dart';

class AddStudentAttendanceUseCase implements Usecase<Either, UserEntity> {
  @override
  Future<Either> call({UserEntity? params}) async {
    return await sl<AttandanceRepository>().addStudentAttendances(params!);
  }
}
