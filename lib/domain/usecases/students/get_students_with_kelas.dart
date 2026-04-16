import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../../repository/students/students.dart';

class GetStudentsWithKelas implements Usecase<Either, int> {
  @override
  Future<Either> call({int? params}) async {
    return await sl<StudentRepository>().getStudentsByClass(params!);
  }
}
