import 'package:dartz/dartz.dart';
import 'package:new_sistem_informasi_smanda/domain/repository/schedule/schedule.dart';

import '../../../service_locator.dart';
import '../../models/schedule/schedule.dart';
import '../../sources/schedule/schedule_firebase_service.dart';

class ScheduleRepositoryImpl extends ScheduleRepository {
  @override
  Future<Either> getJadwal() async {
    var returnedData = await sl<ScheduleFirebaseService>().getJadwal();
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(data)
              .map(
                (e) => ScheduleModel.fromMap(e).toEntity(),
              )
              .toList(),
        );
      },
    );
  }
}
