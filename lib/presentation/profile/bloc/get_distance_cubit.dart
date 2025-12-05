import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'get_distace_state.dart';

class GetDistanceCubit extends Cubit<GetDistanceState> {
  GetDistanceCubit() : super(GetDistanceLoading());

  Future<bool> handleLocationPermission() async {
    emit(GetDistanceLoading());
    bool serviceEnabled;
    LocationPermission permission;

    // cek apakah GPS hidup
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    // cek permission
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    // jika permanently denied
    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  Future<void> getDistance() async {
    final allowed = await handleLocationPermission();

    if (!allowed) return;
    // const LatLng target = LatLng(-5.148647396589983, 105.27443431769255);
    const LatLng target = LatLng(-5.101879928775731, 105.32641136718615);
    try {
      // ambil lokasi user sekarang
      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      double distance = Geolocator.distanceBetween(
        pos.latitude,
        pos.longitude,
        target.latitude,
        target.longitude,
      );

      emit(
        GetDistanceLoaded(
          isNear: distance <= 500,
        ),
      );
    } catch (e) {
      emit(GetDistanceFailure(errorMessage: e.toString()));
    }
  }
}
