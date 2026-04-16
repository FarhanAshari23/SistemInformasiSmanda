import '../../core/constants/app_url.dart';

class DisplayImage {
  static String displayImageStudent(String url) {
    return '${AppUrl.storageStudent}/$url';
  }

  static String displayImageTeacher(String url) {
    return '${AppUrl.storageTeacher}/$url';
  }
}
