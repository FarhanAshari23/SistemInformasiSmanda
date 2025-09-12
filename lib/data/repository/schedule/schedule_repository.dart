import 'package:dartz/dartz.dart';

import '../../../domain/entities/kelas/kelas.dart';
import '../../../domain/entities/schedule/schedule.dart';
import '../../../domain/repository/schedule/schedule.dart';
import '../../../service_locator.dart';
import '../../models/schedule/activity.dart';
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

  @override
  Future<Either> getAllJadwal() async {
    var returnedData = await sl<ScheduleFirebaseService>().getAllJadwal();
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(data)
              .map((e) => ScheduleModel.fromMap(e).toEntity())
              .toList(),
        );
      },
    );
  }

  @override
  Future<Either> createClass(KelasEntity kelasReq) async {
    return await sl<ScheduleFirebaseService>().createClass(kelasReq);
  }

  @override
  Future<Either> getActivities() async {
    var returnedData = await sl<ScheduleFirebaseService>().getActivities();
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(data)
              .map((e) => ActivityModel.fromMap(e).toEntity())
              .toList(),
        );
      },
    );
  }

  @override
  Future<Either> createJadwal(ScheduleEntity scheduleReq) async {
    return await sl<ScheduleFirebaseService>().createSchedule(scheduleReq);
  }

  @override
  Future<Either> updateJadwal(ScheduleEntity scheduleReq) async {
    return await sl<ScheduleFirebaseService>().updateJadwal(scheduleReq);
  }

  @override
  Future<Either> deleteJadwal(String kelas) async {
    return await sl<ScheduleFirebaseService>().deleteJadwal(kelas);
  }

  @override
  Future<Either> createActivities(String kegiatan) async {
    return await sl<ScheduleFirebaseService>().createActivities(kegiatan);
  }

  @override
  Future<Either> deleteKelas(String kelas) async {
    return await sl<ScheduleFirebaseService>().deleteKelas(kelas);
  }

  @override
  Future<Either> deleteActivity(String activity) async {
    return await sl<ScheduleFirebaseService>().deleteActivity(activity);
  }
}
