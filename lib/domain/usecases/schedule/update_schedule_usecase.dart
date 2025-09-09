import 'package:dartz/dartz.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/schedule/schedule.dart';
import 'package:new_sistem_informasi_smanda/domain/repository/schedule/schedule.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';

class UpdateScheduleUsecase implements Usecase<Either, ScheduleEntity> {
  @override
  Future<Either> call({ScheduleEntity? params}) async {
    return await sl<ScheduleRepository>().updateJadwal(params!);
  }
}
