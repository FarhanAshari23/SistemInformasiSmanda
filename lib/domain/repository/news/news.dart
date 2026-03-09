import 'package:dartz/dartz.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/news/news.dart';

abstract class NewsRepository {
  Future<Either> createNews(NewsEntity createNewsReq);
  Future<Either> updateNews(NewsEntity updateNewsReq);
  Future<Either> deleteNews(int idNews);
  Future<Either> getNews();
}
