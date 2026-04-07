import '../../core/constants/app_url.dart';

class DisplayImage {
  static String displayImageStudent(String url) {
    return '${AppUrl.storageStudent}/$url';
  }

  static String displayImageTeacher(String name, String nip) {
    return '${AppUrl.storageTeacher}/${name}_$nip.jpg';
  }

  static String displayImageStaff(String name) {
    return '${AppUrl.storageStudent}/$name.jpg';
  }
}
