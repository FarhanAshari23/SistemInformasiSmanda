import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

import '../../../domain/entities/auth/user.dart';
import '../../models/auth/update_user.dart';

abstract class StudentsFirebaseService {
  Future<Either> getStudent();
  Future<Either> getStudentsByClass(String kelas);
  Future<Either> acceptStudentAccount(UserEntity student);
  Future<Either> acceptAllStudentAccount();
  Future<Either> getAllKelas();
  Future<Either> getStudentByRegister();
  Future<Either> updateStudent(UpdateUserReq updateUserReq);
  Future<Either> deleteStudent(String nisnStudent);
  Future<Either> searchStudentByNISN(String nisnStudent);
  Future<Either> deleteStudentByClass(String kelas);
  Future<Either> getStudentsByname(String name);
}

class StudentsFirebaseServiceImpl extends StudentsFirebaseService {
  @override
  Future<Either> getStudentsByClass(String kelas) async {
    try {
      var returnedData = await FirebaseFirestore.instance
          .collection("Students")
          .where("kelas", isEqualTo: kelas)
          .orderBy('nama')
          .get();
      return Right(returnedData.docs.map((e) => e.data()).toList());
    } catch (e) {
      return const Left("Error get data, please try again later");
    }
  }

  @override
  Future<Either> getStudent() async {
    try {
      var currentUser = FirebaseAuth.instance.currentUser;
      var userData = await FirebaseFirestore.instance
          .collection('Students')
          .doc(currentUser?.uid)
          .get()
          .then((value) => value.data());
      return Right(userData);
    } catch (e) {
      return const Left('Please Try Again');
    }
  }

  @override
  Future<Either> updateStudent(updateUserReq) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('Students');
      QuerySnapshot querySnapshot =
          await users.where('nisn', isEqualTo: updateUserReq.nisn).get();
      if (querySnapshot.docs.isNotEmpty) {
        String docId = querySnapshot.docs[0].id;
        await users.doc(docId).update({
          "nama": updateUserReq.nama,
          "nisn": updateUserReq.nisn,
          "kelas": updateUserReq.kelas,
          "tanggal_lahir": updateUserReq.tanggalLahir,
          "No_HP": updateUserReq.noHp,
          "alamat": updateUserReq.alamat,
          "ekskul": updateUserReq.ekskul,
          "gender": updateUserReq.gender,
          "agama": updateUserReq.agama,
        });
        return right('Update Data Student Success');
      }
      return const Right('Update Data Student Success');
    } catch (e) {
      return const Left('Something Wrong');
    }
  }

  @override
  Future<Either> deleteStudent(String nisnStudent) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('Students');
      QuerySnapshot querySnapshot =
          await users.where('nisn', isEqualTo: nisnStudent).get();
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
      return const Right('Delete Data Student Success');
    } catch (e) {
      return const Left('Something Wrong');
    }
  }

  @override
  Future<Either> searchStudentByNISN(String nisnStudent) async {
    try {
      QuerySnapshot returnedData = await FirebaseFirestore.instance
          .collection("Students")
          .where("nisn", isEqualTo: nisnStudent)
          .get();
      if (returnedData.docs.isNotEmpty) {
        return Right(returnedData.docs.first.data() as Map<String, dynamic>);
      }
      return const Left("Data cant be found");
    } catch (e) {
      return const Left("Error get data, please try again later");
    }
  }

  @override
  Future<Either> getStudentsByname(String name) async {
    try {
      String nameCapital = toBeginningOfSentenceCase(name);
      var returnedData = await FirebaseFirestore.instance
          .collection("Students")
          .where("nama", isGreaterThanOrEqualTo: nameCapital)
          .where('isAdmin', isEqualTo: false)
          .where('nama', isLessThan: '${nameCapital}z')
          .get();
      return Right(returnedData.docs.map((e) => e.data()).toList());
    } catch (e) {
      return const Left("Error get data, please try again later");
    }
  }

  @override
  Future<Either> deleteStudentByClass(String kelas) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('Students');
      QuerySnapshot querySnapshot =
          await users.where('kelas', isEqualTo: kelas).get();
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
      return const Right('Delete Data Student Success');
    } catch (e) {
      return const Left('Something Wrong');
    }
  }

  @override
  Future<Either> getStudentByRegister() async {
    try {
      var returnedData = await FirebaseFirestore.instance
          .collection("Students")
          .where("is_register", isEqualTo: false)
          .orderBy(FieldPath.documentId, descending: true)
          .get();
      return Right(returnedData.docs.map((e) => e.data()).toList());
    } catch (e) {
      return const Left("Error get data, please try again later");
    }
  }

  @override
  Future<Either> acceptStudentAccount(UserEntity student) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('Students');
      QuerySnapshot querySnapshot =
          await users.where('nisn', isEqualTo: student.nisn).get();
      if (querySnapshot.docs.isEmpty) {
        return const Left('Student not found');
      }
      final doc = querySnapshot.docs.first;
      final data = doc.data() as Map<String, dynamic>;

      final key = encrypt.Key.fromUtf8(
          '1234567890123456'); // sama dengan key di signUp()
      final iv = encrypt.IV.fromBase64(data['iv']);
      final encrypter = encrypt.Encrypter(encrypt.AES(key));
      final decryptedPassword = encrypter.decrypt64(data['password'], iv: iv);

      final FirebaseApp secondaryApp = await Firebase.initializeApp(
        name: 'SecondaryApp',
        options: Firebase.app().options,
      );

      final FirebaseAuth secondaryAuth =
          FirebaseAuth.instanceFor(app: secondaryApp);

      await secondaryAuth.createUserWithEmailAndPassword(
        email: data['email'],
        password: decryptedPassword,
      );

      await users.doc(doc.id).update({
        "is_register": true,
        'password': FieldValue.delete(),
        'iv': FieldValue.delete(),
      });

      await secondaryApp.delete();

      return right('Update Student Account Success');
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == "weak-password") {
        message = "Password is too weak";
      } else if (e.code == 'email-already-in-use') {
        message = "Email already in use";
      } else {
        message = "Firebase Auth Error: ${e.message}";
      }
      return Left(message);
    } catch (e) {
      return Left('Something Wrong: $e');
    }
  }

  @override
  Future<Either> getAllKelas() async {
    try {
      var returnedData = await FirebaseFirestore.instance
          .collection('Kelas')
          .orderBy('degree')
          .orderBy('order')
          .get();
      return Right(returnedData.docs.map((e) => e.data()).toList());
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> acceptAllStudentAccount() async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('Students');
      QuerySnapshot querySnapshot =
          await users.where('is_register', isEqualTo: false).get();

      if (querySnapshot.docs.isNotEmpty) {
        WriteBatch batch = FirebaseFirestore.instance.batch();
        for (var doc in querySnapshot.docs) {
          batch.update(doc.reference, {"is_register": true});
        }
        await batch.commit();
        return right('Update All Unregistered Students Success');
      }
      return right('No Students Found to Update');
    } catch (e) {
      return Left('Something Wrong: $e');
    }
  }
}
