import 'package:dartz/dartz.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/ekskul/ekskul.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../../repository/ekskul/ekskul.dart';

class UpdateEkskulUsecase implements Usecase<Either, EkskulEntity> {
  @override
  Future<Either> call({EkskulEntity? params}) async {
    return await sl<EkskulRepository>().updateEkskul(params!);
  }
}
