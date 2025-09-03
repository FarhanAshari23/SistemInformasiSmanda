import 'package:dartz/dartz.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/kelas/kelas.dart';
import 'package:new_sistem_informasi_smanda/domain/repository/schedule/schedule.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';

class CreateClassUsecase implements Usecase<Either, KelasEntity> {
  @override
  Future<Either> call({KelasEntity? params}) async {
    return await sl<ScheduleRepository>().createClass(params!);
  }
}
