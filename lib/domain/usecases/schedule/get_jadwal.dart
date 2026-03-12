import 'package:dartz/dartz.dart';
import 'package:new_sistem_informasi_smanda/domain/repository/schedule/schedule.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';

class GetJadwalUsecase implements Usecase<Either, int> {
  @override
  Future<Either> call({int? params}) async {
    return await sl<ScheduleRepository>().getJadwal(params!);
  }
}
