import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../../entities/teacher/teacher.dart';
import '../../repository/teacher/teacher.dart';

class CreateTeacherUseCase implements Usecase<Either, TeacherEntity> {
  @override
  Future<Either> call({TeacherEntity? params}) async {
    return await sl<TeacherRepository>().createTeacher(params!);
  }
}
