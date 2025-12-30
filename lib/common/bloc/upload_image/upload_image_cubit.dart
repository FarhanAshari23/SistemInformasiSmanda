import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'upload_image_state.dart';

class UploadImageCubit extends Cubit<UploadImageState> {
  UploadImageCubit() : super(UploadImageInitial());

  void loadNetworkImage(String url) {
    emit(UploadImageNetwork(url));
  }

  void loadInitialImage(String? url) async {
    if (url == null || url.isEmpty) {
      emit(UploadImageFailure("Tidak berhasil mendapatkan gambar"));
    }
    bool checkImage = await isUrlReachable(url!);
    if (checkImage) {
      emit(UploadImageNetwork(url));
    } else {
      emit(UploadImageEmpty());
    }
  }

  Future<void> pickImage(String filename) async {
    try {
      emit(UploadImageLoading());
      // if (Platform.isAndroid &&
      //     (await DeviceInfoPlugin().androidInfo).version.sdkInt <= 32) {
      //   // Android <= 12, SAF auto-granted, skip permission
      // }
      // final granted = await requestGalleryPermission();
      // if (!granted) {
      //   emit(UploadImageFailure("Izin galeri ditolak"));
      //   return;
      // }

      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg'],
        allowMultiple: false,
      );

      if (result == null || result.files.single.path == null) {
        emit(UploadImageInitial());
        return;
      }

      final file = File(result.files.single.path!);
      final ext = p.extension(file.path).toLowerCase();

      if (ext != '.jpg' && ext != '.jpeg') {
        emit(UploadImageFailure("Hanya file JPG yang diperbolehkan"));
        return;
      }

      final customName =
          "${filename}_${DateTime.now().millisecondsSinceEpoch}$ext";
      final appDir = await getApplicationDocumentsDirectory();
      final savePath = p.join(appDir.path, customName);
      final savedFile = await file.copy(savePath);
      emit(UploadImageSuccess(savedFile));
    } catch (e) {
      emit(UploadImageFailure("Gagal memproses gambar: $e"));
    }
  }

  Future<bool> isUrlReachable(String url) async {
    try {
      final uri = Uri.parse(url);

      final request = await HttpClient().headUrl(uri);
      final response = await request.close();

      return response.statusCode >= 200 && response.statusCode < 400;
    } catch (e) {
      return false;
    }
  }

  Future<bool> requestGalleryPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.photos.request();
      return status.isGranted;
    }
    return true; // iOS auto-handle
  }
}
