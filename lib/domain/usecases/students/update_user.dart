import 'package:dartz/dartz.dart';
import 'package:new_sistem_informasi_smanda/data/models/auth/update_user.dart';
import 'package:new_sistem_informasi_smanda/domain/repository/students/students.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';

class UpdateStudentUsecase implements Usecase<Either, UpdateUserReq> {
  @override
  Future<Either> call({UpdateUserReq? params}) async {
    return await sl<StudentRepository>().updateStudent(params!);
  }
}
