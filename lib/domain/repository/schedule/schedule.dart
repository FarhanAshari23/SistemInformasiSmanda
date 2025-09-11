import 'package:dartz/dartz.dart';

import '../../entities/kelas/kelas.dart';
import '../../entities/schedule/schedule.dart';

abstract class ScheduleRepository {
  Future<Either> getJadwal();
  Future<Either> getAllJadwal();
  Future<Either> getActivities();
  Future<Either> createClass(KelasEntity kelasReq);
  Future<Either> createJadwal(ScheduleEntity scheduleReq);
  Future<Either> updateJadwal(ScheduleEntity scheduleReq);
  Future<Either> deleteJadwal(String kelas);
  Future<Either> deleteKelas(String kelas);
  Future<Either> createActivities(String kegiatan);
}
