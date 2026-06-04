import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

import '../../../core/networks/network.dart';
import '../../../domain/entities/student/student.dart';
import '../../models/student/student.dart';
import '../../models/teacher/teacher.dart';

abstract class AuthFirebaseService {
  Future<Either> signin(StudentEntity signinUserReq);
  Future<Either> signUp(StudentEntity murid);
  Future<Either> forgotPassword(String email);
  Future<Either> userValidation(String email);
  Future<Either> logout();
  Future<bool> isLoggedIn();
}

class AuthFirebaseServiceImpl extends AuthFirebaseService {
  @override
  Future<Either> signin(StudentEntity signinUserReq) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: signinUserReq.email!,
        password: signinUserReq.password!,
      );
    } on FirebaseAuthException catch (e) {
      String message = 'Terjadi kesalahan autentikasi';
      if (e.code == 'invalid-email') {
        message = 'Email tidak dapat ditemukan';
      } else if (e.code == 'invalid-credential') {
        message = 'Password tidak sesuai dengan email yang tertera';
      } else if (e.code == 'network-request-failed') {
        message = 'Anda sedang tidak terkoneksi dengan internet';
      }
      return Left(message);
    } catch (e) {
      return Left("Gagal masuk: ${e.toString()}");
    }

    final String email = signinUserReq.email!;
    try {
      final response = await Network.apiClient.get("/student/email/$email");
      if (response.statusCode == 500) {
        return Left("Connection error: ${response.message}");
      }
      if (response.statusCode == 200 && response.data['data'] != null) {
        final data = StudentModel.fromMap(response.data['data']).toEntity();
        return Right({
          "role": "student",
          "id": data.id,
        });
      }
    } catch (e) {
      // skip, lanjut ke teacher
    }

    // --- LANGKAH 3: HIT API TEACHER ---
    try {
      final response = await Network.apiClient.get("/teacher/email/$email");
      if (response.statusCode == 500) {
        return Left("Connection error: ${response.message}");
      }
      if (response.statusCode == 200 && response.data['data'] != null) {
        final data = TeacherModel.fromMap(response.data['data']).toEntity();
        return Right({
          "role": "teacher",
          "id": data.id,
        });
      }
    } catch (e) {
      // skip, lanjut ke admin
    }

    // --- LANGKAH 4: HIT API ADMIN ---
    try {
      final response = await Network.apiClient.get("/student/admin/$email");
      if (response.statusCode == 500) {
        return Left("Connection error: ${response.message}");
      }
      if (response.statusCode == 200 && response.data['data'] != null) {
        final data = StudentModel.fromMap(response.data['data']).toEntity();
        return Right({
          "role": "admin",
          "id": data.id,
        });
      }
      return const Left("Role tidak ditemukan");
    } catch (e) {
      return const Left(
        "Anda gagal login karena akun anda telah dihapus, silakan hubungi admin",
      );
    }
  }

  @override
  Future<Either> signUp(StudentEntity murid) async {
    try {
      final key = encrypt.Key.fromUtf8('1234567890123456');
      final iv = encrypt.IV.fromSecureRandom(16);
      final encrypter = encrypt.Encrypter(encrypt.AES(key));
      final encryptedPassword = encrypter.encrypt(murid.password!, iv: iv);

      final model = StudentModelX.fromEntity(
          murid.copyWith(password: encryptedPassword.base64, iv: iv.base64));

      final response =
          await Network.apiClient.post("/student", body: model.toMap());

      if (response.statusCode == 500) {
        return left("Connection error: ${response.message}");
      }

      final data = StudentModel.fromMap(response.data['data']);

      if (murid.imageFile != null) {
        Network.apiClient.postMultipart(
          "/student/${data.id}/photo",
          file: murid.imageFile!,
        );
      }

      return Right("Buat akun sukses: ${response.message}");
    } catch (e) {
      return Left("Something Error: $e");
    }
  }

  @override
  Future<Either> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      return const Right("Logout Succes");
    } on FirebaseAuthException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either> forgotPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return right("Forgot password success");
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'user-not-found') {
        message = 'Tidak ada akun terdaftar dengan email tersebut.';
      } else if (e.code == 'invalid-email') {
        message = 'Format email tidak valid.';
      } else {
        message = 'Terjadi kesalahan: ${e.message}';
      }
      return Left(message);
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    final user = await FirebaseAuth.instance.authStateChanges().first;
    return user != null;
  }

  @override
  Future<Either> userValidation(String email) async {
    try {
      final response = await Network.apiClient.get("/student/email/$email");
      if (response.statusCode == 500) {
        return left("Connection error: ${response.message}");
      }
      final data = StudentModel.fromMap(response.data['data']).toEntity();
      return Right({
        "role": "student",
        "id": data.id,
      });
    } catch (e) {
      //skip
    }
    try {
      final response = await Network.apiClient.get("/teacher/email/$email");
      if (response.statusCode == 500) {
        return left("Connection error: ${response.message}");
      }
      final data = TeacherModel.fromMap(response.data['data']).toEntity();
      return Right({
        "role": "teacher",
        "id": data.id,
      });
    } catch (e) {
      //skip
    }
    try {
      final response = await Network.apiClient.get("/student/admin/$email");
      if (response.statusCode == 500) {
        return left("Connection error: ${response.message}");
      }
      final data = StudentModel.fromMap(response.data['data']).toEntity();
      return Right({
        "role": "admin",
        "id": data.id,
      });
    } catch (e) {
      return const Left(
          "Anda gagal login karena akun anda telah dihapus, silakan hubungi admin");
    }
  }
}
