import 'package:dartz/dartz.dart';
import 'package:new_sistem_informasi_smanda/data/models/teacher/teacher.dart';
import 'package:new_sistem_informasi_smanda/domain/repository/teacher/teacher.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';

class CreateTeacherUseCase implements Usecase<Either, TeacherModel> {
  @override
  Future<Either> call({TeacherModel? params}) async {
    return await sl<TeacherRepository>().createTeacher(params!);
  }
}
