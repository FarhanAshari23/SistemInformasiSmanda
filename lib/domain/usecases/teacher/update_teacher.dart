import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../../entities/teacher/teacher_golang.dart';
import '../../repository/teacher/teacher.dart';

class UpdateTeacherUsecase implements Usecase<Either, TeacherGolangEntity> {
  @override
  Future<Either> call({TeacherGolangEntity? params}) async {
    return await sl<TeacherRepository>().updateTeacher(params!);
  }
}
