import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'upload_image_state.dart';

class UploadImageCubit extends Cubit<UploadImageState> {
  UploadImageCubit() : super(UploadImageInitial());

  final ImagePicker _picker = ImagePicker();

  void loadNetworkImage(String url) {
    emit(UploadImageNetwork(url));
  }

  void loadInitialImage(String? url) {
    if (url == null || url.isEmpty) {
      emit(UploadImageFailure("Tidak berhasil mendapatkan gambar"));
    } else {
      emit(UploadImageNetwork(url));
    }
  }

  Future<void> pickImage(String filename) async {
    try {
      emit(UploadImageLoading());

      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
      );

      if (picked == null) {
        emit(UploadImageInitial());
        return;
      }

      final tempFile = File(picked.path);
      final ext = p.extension(tempFile.path).toLowerCase();

      if (ext != ".jpg") {
        emit(UploadImageFailure("File harus berformat .jpg"));
        return;
      }

      final mime = lookupMimeType(tempFile.path);

      if (mime != "image/jpeg") {
        emit(UploadImageFailure("File harus berupa JPEG (.jpg)"));
        return;
      }

      final customName =
          "${filename}_${DateTime.now().millisecondsSinceEpoch}$ext";
      final appDir = await getApplicationDocumentsDirectory();
      final savePath = p.join(appDir.path, customName);
      final savedFile = await tempFile.copy(savePath);
      emit(UploadImageSuccess(savedFile));
    } catch (e) {
      emit(UploadImageFailure("Gagal memproses gambar: $e"));
    }
  }
}
