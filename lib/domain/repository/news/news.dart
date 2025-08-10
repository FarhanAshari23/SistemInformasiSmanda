import 'package:dartz/dartz.dart';
import 'package:new_sistem_informasi_smanda/data/models/news/news.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/news/news.dart';

abstract class NewsRepository {
  Future<Either> createNews(NewsModel createNewsReq);
  Future<Either> updateNews(NewsEntity updateNewsReq);
  Future<Either> deleteNews(String uidNews);
  Future<Either> getNews();
}
