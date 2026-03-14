import 'package:dartz/dartz.dart';

import '../../entities/kelas/kelas.dart';
import '../../entities/schedule/activity.dart';

abstract class ScheduleRepository {
  Future<Either> getJadwal(int kelasId);
  Future<Either> createClass(KelasEntity kelasReq);
  Future<Either> updateClass(KelasEntity kelasReq);
  Future<Either> deleteClass(int kelasId);
  Future<Either> getActivities();
  Future<Either> getAllKelas();
  Future<Either> deleteActivity(int idActivity);
  Future<Either> updateActivity(ActivityEntity activity);
  Future<Either> createActivities(String kegiatan);
}
