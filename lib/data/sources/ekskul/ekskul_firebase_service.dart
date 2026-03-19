import 'package:dartz/dartz.dart';

import '../../../core/networks/network.dart';
import '../../../domain/entities/ekskul/ekskul.dart';
import '../../models/ekskul/ekskul.dart';

abstract class EkskulFirebaseService {
  Future<Either> createEkskul(EkskulEntity ekskulCreationReq);
  Future<Either> getEkskul();
  Future<Either> updateEkskul(EkskulEntity ekskulUpdateReq);
  Future<Either> deleteEkskul(int ekskulId);
}

class EkskulFirebaseServiceImpl extends EkskulFirebaseService {
  @override
  Future<Either> createEkskul(EkskulEntity ekskulCreationReq) async {
    try {
      final model = EkskulModelX.fromEntity(ekskulCreationReq);
      final response = await Network.apiClient.post(
        "/extracurricular",
        body: model.createReq(),
      );

      if (response.statusCode == 500) {
        return left("Connection error: ${response.message}");
      }

      final data = EkskulModel.fromMap(response.data['data']);
      return Right("Upload ekskul ${data.name} berhasil");
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> getEkskul() async {
    try {
      final response = await Network.apiClient.get("/extracurriculars");
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
  Future<Either> updateEkskul(EkskulEntity ekskulUpdateReq) async {
    try {
      final model = EkskulModelX.fromEntity(ekskulUpdateReq);
      final response = await Network.apiClient.put(
          "/extracurricular/${ekskulUpdateReq.id}",
          body: model.updateReq());

      if (response.statusCode == 500) {
        return left("Connection error: ${response.message}");
      }

      final data = EkskulModel.fromMap(response.data['data']);
      return Right("Upload ekskul ${data.name} berhasil");
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> deleteEkskul(int ekskulId) async {
    try {
      final response =
          await Network.apiClient.delete("/extracurricular/$ekskulId");

      if (response.statusCode == 500) {
        return left("Connection error: ${response.message}");
      }
      return const Right("Delete ekskul berhasil");
    } catch (e) {
      return Left(e.toString());
    }
  }
}
