import 'package:dartz/dartz.dart';

import '../../entities/news/news.dart';

abstract class NewsRepository {
  Future<Either> createNews(NewsEntity createNewsReq);
  Future<Either> updateNews(NewsEntity updateNewsReq);
  Future<Either> deleteNews(int idNews);
  Future<Either> getNews();
  Future<Either> getNewsGlobal();
  Future<Either> getNewsByClass(int classId);
  Future<Either> getNewsByTeacher(int teacherId);
}
