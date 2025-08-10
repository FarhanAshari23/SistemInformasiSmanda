import 'package:dartz/dartz.dart';
import 'package:new_sistem_informasi_smanda/domain/repository/ekskul/ekskul.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';

class GetEkskulUsecase implements Usecase<Either, dynamic> {
  @override
  Future<Either> call({dynamic params}) async {
    return await sl<EkskulRepository>().getEkskul();
  }
}
