import 'package:dartz/dartz.dart';
import 'package:new_sistem_informasi_smanda/data/models/ekskul/ekskul.dart';
import 'package:new_sistem_informasi_smanda/domain/repository/ekskul/ekskul.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';

class CreateEkskulUseCase implements Usecase<Either, EkskulModel> {
  @override
  Future<Either> call({EkskulModel? params}) async {
    return await sl<EkskulRepository>().createEkskul(params!);
  }
}
