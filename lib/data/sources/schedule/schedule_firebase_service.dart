import 'package:dartz/dartz.dart';

import '../../../core/networks/network.dart';
import '../../../domain/entities/kelas/kelas.dart';
import '../../../domain/entities/schedule/activity.dart';
import '../../models/kelas/class.dart';

abstract class ScheduleFirebaseService {
  Future<Either> getJadwal(int kelasId);
  Future<Either> getAllKelas();
  Future<Either> createClass(KelasEntity kelasReq);
  Future<Either> updateClass(KelasEntity kelasReq);
  Future<Either> deleteClass(int kelasId);
  Future<Either> getActivities();
  Future<Either> deleteActivity(int idActivity);
  Future<Either> updateActivity(ActivityEntity activity);
  Future<Either> createActivities(String kegiatan);
}

class ScheduleFirebaseServiceImpl extends ScheduleFirebaseService {
  @override
  Future<Either> getJadwal(int kelasId) async {
    try {
      final response =
          await Network.apiClient.get("/schedule-by-class/$kelasId");
      if (response.statusCode == 500) {
        return left("Connection error: ${response.message}");
      }
      final dataList = response.data['data'] as List<dynamic>;
      return Right(dataList);
    } catch (e) {
      return Left("Something error: ${e.toString()}");
    }
  }

  @override
  Future<Either> createClass(KelasEntity kelasReq) async {
    try {
      final model = kelasReq.fromEntity();
      final body = model.toCreateRequestMap();
      final response =
          await Network.apiClient.post("/class-with-schedules", body: body);
      if (response.statusCode == 500) {
        return left("Connection error: ${response.message}");
      }
      return const Right("Mata Pelajaran berhasil dibuat");
    } catch (e) {
      return Left("Something error: ${e.toString()}");
    }
  }

  @override
  Future<Either> getActivities() async {
    try {
      final response = await Network.apiClient.get("/subjects");
      if (response.statusCode == 500) {
        return left("Connection error: ${response.message}");
      }
      final dataList = response.data['data'] as List<dynamic>;
      return Right(dataList);
    } catch (e) {
      return Left("Something error: ${e.toString()}");
    }
  }

  @override
  Future<Either> createActivities(String kegiatan) async {
    try {
      final response =
          await Network.apiClient.post("/subject", body: {"name": kegiatan});
      if (response.statusCode == 500) {
        return left("Connection error: ${response.message}");
      }
      return const Right("Mata Pelajaran berhasil dibuat");
    } catch (e) {
      return Left("Something error: ${e.toString()}");
    }
  }

  @override
  Future<Either> deleteActivity(int idActivity) async {
    try {
      final response = await Network.apiClient.delete("/subject/$idActivity");
      if (response.statusCode == 500) {
        return left("Connection error: ${response.message}");
      }
      return const Right("Mata Pelajaran berhasil dihapus");
    } catch (e) {
      return Left("Something error: ${e.toString()}");
    }
  }

  @override
  Future<Either> updateActivity(ActivityEntity activity) async {
    try {
      final response = await Network.apiClient
          .put("/subject/${activity.id}", body: {"name": activity.name});
      if (response.statusCode == 500) {
        return left("Connection error: ${response.message}");
      }
      return const Right("Mata Pelajaran berhasil diubah");
    } catch (e) {
      return Left("Something error: ${e.toString()}");
    }
  }

  @override
  Future<Either> deleteClass(int kelasId) async {
    try {
      final response = await Network.apiClient.delete("/class/$kelasId");
      if (response.statusCode == 500) {
        return left("Connection error: ${response.message}");
      }
      return const Right("Kelas berhasil dihapus");
    } catch (e) {
      return Left("Something error: ${e.toString()}");
    }
  }

  @override
  Future<Either> updateClass(KelasEntity kelasReq) async {
    try {
      final model = kelasReq.fromEntity();
      final response = await Network.apiClient
          .put("/class/${kelasReq.id}", body: model.toMap());
      if (response.statusCode == 500) {
        return left("Connection error: ${response.message}");
      }
      return const Right("Kelas berhasil diubah ");
    } catch (e) {
      return Left("Something error: ${e.toString()}");
    }
  }

  @override
  Future<Either> getAllKelas() async {
    try {
      final response = await Network.apiClient.get("/classes");
      if (response.statusCode == 500) {
        return left("Connection error: ${response.message}");
      }
      final dataList = response.data['data'] as List<dynamic>;
      return Right(dataList);
    } catch (e) {
      return Left("Something error: ${e.toString()}");
    }
  }
}
