import 'package:dartz/dartz.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/auth/teacher.dart';
import 'package:new_sistem_informasi_smanda/domain/repository/teacher/teacher.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';

class DeleteTeacherUsecase implements Usecase<Either, TeacherEntity> {
  @override
  Future<Either> call({TeacherEntity? params}) async {
    return await sl<TeacherRepository>().deleteTeacher(params!);
  }
}
