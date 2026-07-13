// ignore: avoid_types_as_parameter_names
abstract class Usecase<Type, Params> {
  Future<Type> call({Params params});
}
