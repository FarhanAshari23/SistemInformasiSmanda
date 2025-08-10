import 'package:dartz/dartz.dart';
import 'package:new_sistem_informasi_smanda/domain/repository/teacher/teacher.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';

class GetKepalaSekolah implements Usecase<Either, dynamic> {
  @override
  Future<Either> call({dynamic params}) async {
    return await sl<TeacherRepository>().getKepalaSekolah();
  }
}
