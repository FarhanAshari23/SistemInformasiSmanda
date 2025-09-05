import 'package:dartz/dartz.dart';
import 'package:new_sistem_informasi_smanda/domain/repository/schedule/schedule.dart';

import '../../../core/usecase/usecase.dart';
import '../../../data/models/schedule/schedule.dart';
import '../../../service_locator.dart';
import '../../entities/schedule/day.dart';

class CreateScheduleUsecase implements Usecase<Either, ScheduleModel> {
  @override
  Future<Either> call({ScheduleModel? params}) async {
    return await sl<ScheduleRepository>().createJadwal(params!);
  }
}
