import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:new_sistem_informasi_smanda/data/models/auth/signin_user_req.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

import '../../../core/networks/network.dart';
import '../../../domain/entities/auth/user_golang.dart';
import '../../models/auth/user_golang.dart';

abstract class AuthFirebaseService {
  Future<Either> signin(SignInUserReq signinUserReq);
  Future<Either> signUp(UserGolang murid);
  Future<Either> forgotPassword(String email);
  Future<Either> checkEmailUsed(String email);
  Future<Either> logout();
  Future<Either> getUser(String user);
  Future<bool> isLoggedIn();
  Future<Either> isAdmin();
  Future<Either> isRegister();
  Future<Either> isTeacher();
}

class AuthFirebaseServiceImpl extends AuthFirebaseService {
  @override
  Future<Either> signin(SignInUserReq signinUserReq) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: signinUserReq.email,
        password: signinUserReq.passwword,
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
  Future<Either> isAdmin() async {
    try {
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      final query = await firebaseFirestore
          .collection('Students')
          .where('uid', isEqualTo: firebaseAuth.currentUser?.uid)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        return const Left("Admin not found");
      }
      final userData = query.docs.first.data();
      final isAdmin = userData['isAdmin'] ?? false;
      return right(isAdmin);
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Either> getUser(String user) async {
    try {
      var currentUser = FirebaseAuth.instance.currentUser;
      var userData = await FirebaseFirestore.instance
          .collection(user)
          .where('uid', isEqualTo: currentUser?.uid)
          .limit(1)
          .get()
          .then((value) => value.docs.first.data());
      return Right(userData);
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Either> signUp(UserGolang murid) async {
    try {
      final key = encrypt.Key.fromUtf8('1234567890123456');
      final iv = encrypt.IV.fromSecureRandom(16);
      final encrypter = encrypt.Encrypter(encrypt.AES(key));
      final encryptedPassword = encrypter.encrypt(murid.password!, iv: iv);

      final model = UserGolangModelX.fromEntity(
          murid.copyWith(password: encryptedPassword.base64, iv: iv.base64));

      final response =
          await Network.apiClient.post("/student", body: model.toMap());

      if (response.statusCode == 500) {
        return left("Connection error: ${response.message}");
      }

      final data = UserGolangModel.fromMap(response.data['data']);

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
  Future<Either> isRegister() async {
    try {
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      final query = await firebaseFirestore
          .collection('Students')
          .where('uid', isEqualTo: firebaseAuth.currentUser?.uid)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        return const Left("User Register not found");
      }
      final userData = query.docs.first.data();
      final isRegister = userData['is_register'] ?? false;
      return right(isRegister);
    } catch (e) {
      return left(
        'Akun anda belum terdaftar. Jika merasa sudah mendaftar, harap tunggu admin mengkonfirmasi pendaftaran anda.',
      );
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
  Future<Either> isTeacher() async {
    try {
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      final query = await firebaseFirestore
          .collection('Teachers')
          .where('uid', isEqualTo: firebaseAuth.currentUser?.uid)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        return const Left("Teacher not found");
      }
      final userData = query.docs.first.data();
      final isTeacher = userData['mengajar'] != null;
      return right(isTeacher);
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return FirebaseAuth.instance.currentUser != null;
  }
}
