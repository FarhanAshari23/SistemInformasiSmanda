import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../../entities/schedule/role.dart';
import '../../repository/teacher/teacher.dart';

class UpdateRoleUsecase implements Usecase<Either, RoleEntity> {
  @override
  Future<Either> call({RoleEntity? params}) async {
    return await sl<TeacherRepository>().updateRoles(params!);
  }
}
