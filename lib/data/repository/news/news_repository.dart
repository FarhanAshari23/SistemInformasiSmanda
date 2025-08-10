import 'package:dartz/dartz.dart';
import 'package:new_sistem_informasi_smanda/data/models/news/news.dart';
import 'package:new_sistem_informasi_smanda/data/sources/news/news_firebase_service.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/news/news.dart';
import 'package:new_sistem_informasi_smanda/domain/repository/news/news.dart';
import 'package:new_sistem_informasi_smanda/service_locator.dart';

class NewsRepositoryImpl extends NewsRepository {
  @override
  Future<Either> createNews(NewsModel createNewsReq) async {
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
  Future<Either> deleteNews(String uidNews) async {
    return await sl<NewsFirebaseService>().deleteNews(uidNews);
  }

  @override
  Future<Either> updateNews(NewsEntity updateNewsReq) async {
    return await sl<NewsFirebaseService>().updateNews(updateNewsReq);
  }
}
