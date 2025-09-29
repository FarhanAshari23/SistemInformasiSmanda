import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../../entities/ekskul/update_anggota_req.dart';
import '../../repository/ekskul/ekskul.dart';

class UpdateAnggotaUsecase implements Usecase<Either, UpdateAnggotaReq> {
  @override
  Future<Either> call({UpdateAnggotaReq? params}) async {
    return await sl<EkskulRepository>().updateAnggota(params!);
  }
}
