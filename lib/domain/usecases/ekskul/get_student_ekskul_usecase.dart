import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../../repository/ekskul/ekskul.dart';

class GetStudentEkskulUsecase implements Usecase<Either, int> {
  @override
  Future<Either> call({int? params}) async {
    return await sl<EkskulRepository>().getStudentEkskul(params!);
  }
}
