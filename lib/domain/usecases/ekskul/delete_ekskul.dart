import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../../repository/ekskul/ekskul.dart';

class DeleteEkskulUsecase implements Usecase<Either, String> {
  @override
  Future<Either> call({String? params}) async {
    return await sl<EkskulRepository>().deleteEkskul(params!);
  }
}
