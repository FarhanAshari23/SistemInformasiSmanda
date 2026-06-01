import 'package:dartz/dartz.dart';

import '../../../domain/entities/news/news.dart';
import '../../../domain/repository/news/news.dart';
import '../../../service_locator.dart';
import '../../models/news/news.dart';
import '../../sources/news/news_firebase_service.dart';

class NewsRepositoryImpl extends NewsRepository {
  @override
  Future<Either> createNews(NewsEntity createNewsReq) async {
    return await sl<NewsFirebaseService>().createNews(createNewsReq);
  }

  @override
  Future<Either> getNews() async {
    var returnedData = await sl<NewsFirebaseService>().getNews();
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(data).map((e) => NewsModel.fromMap(e).toEntity()).toList(),
        );
      },
    );
  }

  @override
  Future<Either> deleteNews(int idNews) async {
    return await sl<NewsFirebaseService>().deleteNews(idNews);
  }

  @override
  Future<Either> updateNews(NewsEntity updateNewsReq) async {
    return await sl<NewsFirebaseService>().updateNews(updateNewsReq);
  }

  @override
  Future<Either> getNewsByClass(int classId) async {
    var returnedData = await sl<NewsFirebaseService>().getNewsByClass(classId);
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(data).map((e) => NewsModel.fromMap(e).toEntity()).toList(),
        );
      },
    );
  }

  @override
  Future<Either> getNewsGlobal() async {
    var returnedData = await sl<NewsFirebaseService>().getNewsGlobal();
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(data).map((e) => NewsModel.fromMap(e).toEntity()).toList(),
        );
      },
    );
  }

  @override
  Future<Either> getNewsByTeacher(int teacherId) async {
    var returnedData =
        await sl<NewsFirebaseService>().getNewsByTeacher(teacherId);
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(data).map((e) => NewsModel.fromMap(e).toEntity()).toList(),
        );
      },
    );
  }
}
