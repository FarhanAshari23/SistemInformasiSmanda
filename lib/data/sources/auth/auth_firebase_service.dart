import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:new_sistem_informasi_smanda/data/models/auth/signin_user_req.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

import '../../../common/helper/execute_crud.dart';
import '../../../common/helper/generate_keyword.dart';
import '../../models/auth/user_creation_req.dart';

abstract class AuthFirebaseService {
  Future<Either> signin(SignInUserReq signinUserReq);
  Future<Either> signUp(UserCreationReq murid);
  Future<Either> forgotPassword(String email);
  Future<Either> checkEmailUsed(String email);
  Future<Either> logout();
  Future<bool> isLoggedIn();
  Future<Either> getUser(String user);
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
  Future<Either> signUp(UserCreationReq murid) async {
    final keywords = generateKeywords(murid.nama ?? '');
    String endpoint = ExecuteCRUD.uploadImageStudent();
    DocumentReference? studentRef;
    try {
      if (murid.imageFile != null) {
        Uri? url;
        try {
          url = Uri.parse(endpoint);
        } catch (_) {
          throw Exception("URL tidak valid: $endpoint");
        }

        final request = http.MultipartRequest("POST", url);

        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            murid.imageFile?.path ?? '',
            filename: basename(murid.imageFile?.path ?? ''),
          ),
        );

        request.headers.addAll({
          "Accept": "application/json",
          "Content-Type": "multipart/form-data",
        });

        final streamedResponse = await request.send().timeout(
          const Duration(seconds: 15),
          onTimeout: () {
            throw Exception("Timeout: Server tidak merespon.");
          },
        );

        final responseBody = await streamedResponse.stream.bytesToString();

        if (streamedResponse.statusCode != 200) {
          throw Exception(
            "Upload gagal (status: ${streamedResponse.statusCode}). "
            "Response: $responseBody",
          );
        }

        try {
          jsonDecode(responseBody);
        } catch (_) {
          throw Exception("Response server bukan JSON valid: $responseBody");
        }
      }

      //create in firebase
      final key = encrypt.Key.fromUtf8('1234567890123456');
      final iv = encrypt.IV.fromSecureRandom(16);
      final encrypter = encrypt.Encrypter(encrypt.AES(key));
      final encryptedPassword = encrypter.encrypt(murid.password!, iv: iv);
      studentRef = await FirebaseFirestore.instance.collection('Students').add(
        {
          'email': murid.email,
          'nama': murid.nama,
          'kelas': murid.kelas,
          'nisn': murid.nisn,
          'tanggal_lahir': murid.tanggalLahir,
          'No_HP': murid.noHP,
          'alamat': murid.address,
          'ekskul': murid.ekskul,
          'gender': murid.gender,
          'isAdmin': murid.isAdmin,
          'agama': murid.agama,
          'password': encryptedPassword.base64,
          'is_register': murid.isRegister,
          'keywords': keywords,
          'iv': iv.base64,
        },
      );

      return Right('Signup was succesfull, $json');
    } on SocketException {
      if (studentRef != null) await studentRef.delete();
      throw Exception("Tidak ada koneksi internet.");
    } on HttpException {
      if (studentRef != null) await studentRef.delete();
      throw Exception("Kesalahan HTTP terjadi.");
    } on FormatException {
      if (studentRef != null) await studentRef.delete();
      throw Exception("Format data tidak valid.");
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
  Future<bool> isLoggedIn() async {
    if (FirebaseAuth.instance.currentUser != null) {
      return true;
    } else {
      return false;
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
          'Email ini sudah dipakai, silakan akses lupa password untuk mengganti password anda',
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
}
