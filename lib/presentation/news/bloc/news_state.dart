import 'package:new_sistem_informasi_smanda/domain/entities/news/news.dart';

abstract class NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<NewsEntity> news;
  NewsLoaded({required this.news});
}

class NewsFailure extends NewsState {
  final String errorMessage;
  NewsFailure({required this.errorMessage});
}
