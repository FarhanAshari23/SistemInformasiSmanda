import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../../entities/kelas/kelas.dart';
import '../../repository/schedule/schedule.dart';

class UpdateScheduleUsecase implements Usecase<Either, KelasEntity> {
  @override
  Future<Either> call({KelasEntity? params}) async {
    return await sl<ScheduleRepository>().updateClass(params!);
  }
}
