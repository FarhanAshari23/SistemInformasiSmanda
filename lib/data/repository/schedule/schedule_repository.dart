import 'package:dartz/dartz.dart';

import '../../../domain/entities/kelas/kelas.dart';
import '../../../domain/entities/schedule/activity.dart';
import '../../../domain/repository/schedule/schedule.dart';
import '../../../service_locator.dart';
import '../../models/kelas/class.dart';
import '../../models/schedule/activity.dart';
import '../../models/schedule/day.dart';
import '../../sources/schedule/schedule_firebase_service.dart';

class ScheduleRepositoryImpl extends ScheduleRepository {
  @override
  Future<Either> getJadwal(int kelasId) async {
    var returnedData = await sl<ScheduleFirebaseService>().getJadwal(kelasId);
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(data)
              .map(
                (e) => DayModel.fromMap(e).toEntity(),
              )
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
  Future<Either> createActivities(String kegiatan) async {
    return await sl<ScheduleFirebaseService>().createActivities(kegiatan);
  }

  @override
  Future<Either> deleteClass(int kelasId) async {
    return await sl<ScheduleFirebaseService>().deleteClass(kelasId);
  }

  @override
  Future<Either> deleteActivity(int idActivity) async {
    return await sl<ScheduleFirebaseService>().deleteActivity(idActivity);
  }

  @override
  Future<Either> updateActivity(ActivityEntity activity) async {
    return await sl<ScheduleFirebaseService>().updateActivity(activity);
  }

  @override
  Future<Either> updateClass(KelasEntity kelasReq) async {
    return await sl<ScheduleFirebaseService>().updateClass(kelasReq);
  }

  @override
  Future<Either> getAllKelas() async {
    var returnedData = await sl<ScheduleFirebaseService>().getAllKelas();
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(data)
              .map(
                (e) => KelasModel.fromMap(e).toEntity(),
              )
              .toList(),
        );
      },
    );
  }
}
