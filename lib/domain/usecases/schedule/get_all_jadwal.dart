import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../../repository/schedule/schedule.dart';

class GetAllJadwalUsecase implements Usecase<Either, dynamic> {
  @override
  Future<Either> call({dynamic params}) async {
    return await sl<ScheduleRepository>().getAllJadwal();
  }
}
