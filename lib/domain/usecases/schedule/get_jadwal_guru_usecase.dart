import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../../repository/schedule/schedule.dart';

class GetJadwalGuruUsecase implements Usecase<Either, int> {
  @override
  Future<Either> call({int? params}) async {
    return await sl<ScheduleRepository>().getJadwalGuru(params!);
  }
}
