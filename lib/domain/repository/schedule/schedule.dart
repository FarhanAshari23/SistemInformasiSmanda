import 'package:dartz/dartz.dart';

import '../../entities/kelas/kelas.dart';

abstract class ScheduleRepository {
  Future<Either> getJadwal();
  Future<Either> getAllJadwal();
  Future<Either> getActivities();
  Future<Either> createClass(KelasEntity kelasReq);
}
