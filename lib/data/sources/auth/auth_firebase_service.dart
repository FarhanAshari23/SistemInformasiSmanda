import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

import '../../../core/networks/network.dart';
import '../../../domain/entities/student/student.dart';
import '../../models/student/student.dart';

abstract class AuthFirebaseService {
  Future<Either> signin(StudentEntity signinUserReq);
  Future<Either> signUp(StudentEntity murid);
  Future<Either> forgotPassword(String email);
  Future<Either> checkEmailUsed(String email);
  Future<Either> profileTeacher(String email);
  Future<Either> profileStudent(String email);
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

      return const Right('Succes Login');
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'invalid-email') {
        message = 'Email tidak dapat ditemukan';
      } else if (e.code == 'invalid-credential') {
        message = 'Password tidak sesuai dengan email yang tertera';
      } else if (e.code == 'network-request-failed') {
        message = 'Anda sedang tidak terkoneksi dengan internet';
      }

      return Left(message);
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
  Future<Either> checkEmailUsed(String email) async {
    try {
      QuerySnapshot murid = await FirebaseFirestore.instance
          .collection('Students')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      if (murid.docs.isNotEmpty) {
        return const Left(
          'Email ini sudah digunakan. Kemungkinan akun anda sedang dalam proses pengecekan. Harap bersabar atau silakan hubungi admin',
        );
      } else {
        return const Right('Ini aman');
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return FirebaseAuth.instance.currentUser != null;
  }

  @override
  Future<Either> profileStudent(String email) async {
    try {
      final response = await Network.apiClient.get("/student/email/$email");
      if (response.statusCode == 500) {
        return left("Connection error: ${response.message}");
      }
      final dataList = response.data['data'] as Map<String, dynamic>;
      return Right(dataList);
    } catch (e) {
      return Left("Something error: ${e.toString()}");
    }
  }

  @override
  Future<Either> profileTeacher(String email) async {
    try {
      final response = await Network.apiClient.get("/teacher/email/$email");
      if (response.statusCode == 500) {
        return left("Connection error: ${response.message}");
      }
      final dataList = response.data['data'] as Map<String, dynamic>;
      return Right(dataList);
    } catch (e) {
      return Left("Something error: ${e.toString()}");
    }
  }
}
