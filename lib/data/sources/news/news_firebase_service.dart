import 'package:dartz/dartz.dart';

import '../../../core/networks/network.dart';
import '../../../domain/entities/news/news.dart';
import '../../models/news/news.dart';

abstract class NewsFirebaseService {
  Future<Either> createNews(NewsEntity createNewsReq);
  Future<Either> updateNews(NewsEntity updateNewsReq);
  Future<Either> deleteNews(int idNews);
  Future<Either> getNews();
}

class NewsFirebaseServiceImpl extends NewsFirebaseService {
  @override
  Future<Either> createNews(NewsEntity createNewsReq) async {
    try {
      final model = NewsModelX.fromEntity(createNewsReq);
      final body = model.toMap();
      body.remove('created_at');
      final response =
          await Network.apiClient.post("/announcement", body: body);

      if (response.statusCode == 500) {
        return left("Connection error: ${response.message}");
      }
      return const Right("Pengumuman berhasil dibuat");
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> getNews() async {
    try {
      final response = await Network.apiClient.get("/announcements");
      if (response.statusCode == 500) {
        return left("Connection error: ${response.message}");
      }
      final dataList = response.data['data'] as List<Map<String, dynamic>>;
      return Right(dataList);
    } catch (e) {
      return Left("Something error: ${e.toString()}");
    }
  }

  @override
  Future<Either> deleteNews(int idNews) async {
    try {
      final response = await Network.apiClient.delete("/announcement/$idNews");
      if (response.statusCode == 500) {
        return left("Connection error: ${response.message}");
      }
      return const Right("Data pengumuman berhasil dihapus");
    } catch (e) {
      return Left("Something error: ${e.toString()}");
    }
  }

  @override
  Future<Either> updateNews(NewsEntity updateNewsReq) async {
    try {
      final model = NewsModelX.fromEntity(updateNewsReq);
      final response = await Network.apiClient
          .put("/announcement/${updateNewsReq.newsId}", body: model.toMap());
      if (response.statusCode == 500) {
        return left("Connection error: ${response.message}");
      }
      return const Right("Pengumuman berhasil diubah");
    } catch (e) {
      return Left(e.toString());
    }
  }
}
