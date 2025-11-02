import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../../entities/ekskul/ekskul.dart';
import '../../repository/ekskul/ekskul.dart';

class DeleteEkskulUsecase implements Usecase<Either, EkskulEntity> {
  @override
  Future<Either> call({EkskulEntity? params}) async {
    return await sl<EkskulRepository>().deleteEkskul(params!);
  }
}
