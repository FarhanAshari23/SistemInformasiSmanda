import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/domain/usecases/news/get_news.dart';
import 'package:new_sistem_informasi_smanda/presentation/home/bloc/news_state.dart';

import '../../../service_locator.dart';

class NewsCubit extends Cubit<NewsState> {
  NewsCubit() : super(NewsLoading());

  void displayNews() async {
    var returnedData = await sl<GetNewsUseCase>().call();
    returnedData.fold(
      (error) {
        return emit(NewsFailure(errorMessage: error));
      },
      (data) {
        return emit(NewsLoaded(news: data));
      },
    );
  }
}
