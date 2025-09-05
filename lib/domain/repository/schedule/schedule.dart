import 'package:dartz/dartz.dart';

import '../../../data/models/schedule/schedule.dart';
import '../../entities/kelas/kelas.dart';

abstract class ScheduleRepository {
  Future<Either> getJadwal();
  Future<Either> getAllJadwal();
  Future<Either> getActivities();
  Future<Either> createClass(KelasEntity kelasReq);
  Future<Either> createJadwal(ScheduleModel scheduleReq);
}
