import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../../entities/auth/user.dart';
import '../../repository/students/students.dart';

class DeleteStudentUsecase implements Usecase<Either, UserEntity> {
  @override
  Future<Either> call({UserEntity? params}) async {
    return await sl<StudentRepository>().deleteStudent(params!);
  }
}
