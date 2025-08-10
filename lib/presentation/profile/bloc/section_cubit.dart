import 'package:flutter_bloc/flutter_bloc.dart';

enum TwoContainersState { initial, containerOneSelected, containerTwoSelected }

class TwoContainersCubit extends Cubit<TwoContainersState> {
  TwoContainersCubit() : super(TwoContainersState.containerOneSelected);

  void selectContainerOne() => emit(TwoContainersState.containerOneSelected);

  void selectContainerTwo() => emit(TwoContainersState.containerTwoSelected);

  void resetSelection() => emit(TwoContainersState.initial);
}
