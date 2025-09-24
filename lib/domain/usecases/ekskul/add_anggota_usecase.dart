import 'package:dartz/dartz.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/ekskul/update_anggota_req.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../../repository/ekskul/ekskul.dart';

class AddAnggotaUsecase implements Usecase<Either, UpdateAnggotaReq> {
  @override
  Future<Either> call({UpdateAnggotaReq? params}) async {
    return await sl<EkskulRepository>().addAnggota(params!);
  }
}
