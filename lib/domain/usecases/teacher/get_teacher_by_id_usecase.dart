import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../../repository/teacher/teacher.dart';

class GetTeacherByIdUsecase implements Usecase<Either, int> {
  @override
  Future<Either> call({int? params}) async {
    return await sl<TeacherRepository>().getTeacherById(params!);
  }
}
