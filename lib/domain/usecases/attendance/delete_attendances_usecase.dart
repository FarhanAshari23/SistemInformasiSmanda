import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../../repository/attandance/attandance.dart';

class DeleteAttendancesUsecase implements Usecase<Either, dynamic> {
  @override
  Future<Either> call({params}) async {
    return await sl<AttandanceRepository>().deleteAllAttendances();
  }
}
