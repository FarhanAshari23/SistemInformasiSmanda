import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../../entities/attandance/param_delete_attendance.dart';
import '../../repository/attandance/attandance.dart';

class DeleteMonthAttendancesUsecase
    implements Usecase<Either, ParamDeleteAttendance> {
  @override
  Future<Either> call({ParamDeleteAttendance? params}) async {
    return await sl<AttandanceRepository>().deleteMonthAttendances(params!);
  }
}
