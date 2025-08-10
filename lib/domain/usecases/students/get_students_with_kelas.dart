import 'package:dartz/dartz.dart';
import 'package:new_sistem_informasi_smanda/domain/repository/students/students.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';

class GetStudentsWithKelas implements Usecase<Either, String> {
  @override
  Future<Either> call({String? params}) async {
    return await sl<StudentRepository>().getStudentsByClass(params!);
  }
}
