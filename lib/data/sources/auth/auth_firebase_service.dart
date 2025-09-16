import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:new_sistem_informasi_smanda/data/models/auth/signin_user_req.dart';

import '../../../common/helper/generate_keyword.dart';
import '../../models/auth/user_creation_req.dart';

abstract class AuthFirebaseService {
  Future<Either> signin(SignInUserReq signinUserReq);
  Future<Either> signUp(UserCreationReq murid);
  Future<Either> logout();
  Future<bool> isLoggedIn();
  Future<Either> getUser();
  Future<Either> isAdmin();
  Future<Either> isRegister();
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

      var user = await firebaseFirestore
          .collection('Students')
          .doc(firebaseAuth.currentUser?.uid)
          .get();

      bool isAdmin = user.get('isAdmin');

      return right(isAdmin);
    } catch (e) {
      return left('An Error Occured');
    }
  }

  @override
  Future<Either> getUser() async {
    try {
      var currentUser = FirebaseAuth.instance.currentUser;
      var userData = await FirebaseFirestore.instance
          .collection('Students')
          .doc(currentUser?.uid)
          .get()
          .then((value) => value.data());
      return Right(userData);
    } catch (e) {
      return left('An Error Occured');
    }
  }

  @override
  Future<Either> signUp(UserCreationReq murid) async {
    final keywords = generateKeywords(murid.nama ?? '');
    try {
      var returnedData =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: murid.email!,
        password: murid.password!,
      );
      await FirebaseFirestore.instance
          .collection('Students')
          .doc(returnedData.user!.uid)
          .set(
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
          'is_register': murid.isRegister,
          'keywords': keywords,
        },
      );
      await FirebaseAuth.instance.signOut();
      return const Right('Signup was succesfull');
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == "weak-password") {
        message = "Your password is to weak";
      } else if (e.code == 'email-already-in-use') {
        message = "This email already used";
      }
      return Left(message);
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

      var user = await firebaseFirestore
          .collection('Students')
          .doc(firebaseAuth.currentUser?.uid)
          .get();

      bool isRegister = user.get('is_register');

      return right(isRegister);
    } catch (e) {
      return left(
        'Akun anda belum terdaftar. Jika merasa sudah mendaftar, harap tunggu admin mengkonfirmasi pendaftaran anda.',
      );
    }
  }
}
