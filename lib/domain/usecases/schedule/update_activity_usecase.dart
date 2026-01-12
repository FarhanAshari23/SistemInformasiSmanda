import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../../entities/schedule/activity.dart';
import '../../repository/schedule/schedule.dart';

class UpdateActivityUsecase implements Usecase<Either, ActivityEntity> {
  @override
  Future<Either> call({ActivityEntity? params}) async {
    return await sl<ScheduleRepository>().updateActivity(params!);
  }
}
