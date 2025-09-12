import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../../repository/schedule/schedule.dart';

class DeleteActivityUsecase implements Usecase<Either, String> {
  @override
  Future<Either> call({String? params}) async {
    return await sl<ScheduleRepository>().deleteActivity(params!);
  }
}
