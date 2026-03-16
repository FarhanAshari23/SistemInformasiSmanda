import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../../entities/student/student.dart';
import '../../repository/students/students.dart';

class UpdateStudentUsecase implements Usecase<Either, StudentEntity> {
  @override
  Future<Either> call({StudentEntity? params}) async {
    return await sl<StudentRepository>().updateStudent(params!);
  }
}
