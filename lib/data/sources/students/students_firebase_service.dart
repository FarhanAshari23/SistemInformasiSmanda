import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

import '../../../common/helper/execute_crud.dart';
import '../../../common/helper/string_helper.dart';
import '../../../core/networks/network.dart';
import '../../../domain/entities/student/student.dart';
import '../../models/student/student.dart';

abstract class StudentsFirebaseService {
  Future<Either> getStudentsByClass(int kelasId);
  Future<Either> acceptStudentAccount(int studentId);
  Future<Either> acceptAllStudentAccount();
  Future<Either> deleteAllStudentAccount();
  Future<Either> getStudentByRegister();
  Future<Either> updateStudent(StudentEntity updateUserReq);
  Future<Either> deleteStudent(int studentId);
  Future<Either> searchStudentByNISN(String nisnStudent);
  Future<Either> deleteStudentByClass(String kelas);
  Future<Either> getStudentsByname(String name);
  Future<Either> createExcellForStudentData();
}

class StudentsFirebaseServiceImpl extends StudentsFirebaseService {
  @override
  Future<Either> getStudentsByClass(int kelasId) async {
    try {
      final response =
          await Network.apiClient.get("/students/findclass/$kelasId");
      if (response.statusCode == 500) {
        return left("Connection error: ${response.message}");
      }
      final dataList = response.data['data'] as List<dynamic>;
      return Right(dataList);
    } catch (e) {
      return Left("Something error: ${e.toString()}");
    }
  }

  @override
  Future<Either> updateStudent(StudentEntity updateUserReq) async {
    try {
      final model = StudentModelX.fromEntity(updateUserReq);
      final body = model.updateStudent();
      await Network.apiClient.put("/student/${updateUserReq.id}", body: body);
      if (updateUserReq.imageFile != null) {
        Network.apiClient.postMultipart(
          "/student/${updateUserReq.id}/photo",
          file: updateUserReq.imageFile!,
        );
      }
      return const Right('Update Data Student Success');
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> deleteStudent(int studentId) async {
    try {
      final response = await Network.apiClient.delete("/student/$studentId");

      if (response.statusCode == 500) {
        return left("Connection error: ${response.message}");
      }
      return const Right('Delete Data Student Success');
    } catch (e) {
      return Left(e.toString());
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
      return Left(e.toString());
    }
  }

  @override
  Future<Either> getStudentsByname(String name) async {
    try {
      final response = await Network.apiClient.get("/students/findname/$name");
      if (response.statusCode == 500) {
        return left("Connection error: ${response.message}");
      }
      final dataList = response.data['data'] as List<dynamic>;
      return Right(dataList);
    } catch (e) {
      return Left("Something error: ${e.toString()}");
    }
  }

  @override
  Future<Either> deleteStudentByClass(String kelas) async {
    final firestore = FirebaseFirestore.instance;
    final collection = firestore.collection('Students');
    String endpoint = ExecuteCRUD.deleteMultipleImageStudent();
    final List<Map<String, String>> studentsPayload = [];
    try {
      Uri? url;
      try {
        url = Uri.parse(endpoint);
      } catch (_) {
        return Left("URL tidak valid: $endpoint");
      }

      QuerySnapshot querySnapshot =
          await collection.where('kelas', isEqualTo: kelas).get();
      if (querySnapshot.docs.isEmpty) {
        return const Left(
          "Maaf, tidak ada data murid yang bisa dihapus",
        );
      }

      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;

        studentsPayload.add({
          "name": data["nama"],
          "nisn": data["nisn"],
        });
      }

      final response = await http
          .post(
            url,
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
            },
            body: jsonEncode({
              "students": studentsPayload,
            }),
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode != 200) {
        return Left("Upload gagal (status: ${response.statusCode})");
      }

      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
      return const Right('Delete Data Student Success');
    } on TimeoutException {
      return const Left(
          "Gagal terhubung dengan server, cobalah beberapa saat lagi");
    } on SocketException {
      return const Left("Tidak ada koneksi internet.");
    } on HttpException {
      return const Left("Kesalahan HTTP terjadi.");
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> getStudentByRegister() async {
    try {
      final response = await Network.apiClient.get("/students/unregister");
      if (response.statusCode == 500) {
        return left("Connection error: ${response.message}");
      }
      final dataList = response.data['data'] as List<dynamic>;
      return Right(dataList);
    } catch (e) {
      return Left("Something error: ${e.toString()}");
    }
  }

  @override
  Future<Either> acceptStudentAccount(int studentId) async {
    try {
      final response = await Network.apiClient.get("/student/$studentId");
      if (response.statusCode == 500) {
        return left("Connection error: ${response.message}");
      }
      final data = StudentModel.fromMap(response.data['data']);

      final key = encrypt.Key.fromUtf8('1234567890123456');
      final iv = encrypt.IV.fromBase64(data.iv);
      final encrypter = encrypt.Encrypter(encrypt.AES(key));
      final decryptedPassword = encrypter.decrypt64(data.password, iv: iv);

      final FirebaseApp secondaryApp = await Firebase.initializeApp(
        name: 'SecondaryApp',
        options: Firebase.app().options,
      );

      final FirebaseAuth secondaryAuth =
          FirebaseAuth.instanceFor(app: secondaryApp);

      await secondaryAuth.createUserWithEmailAndPassword(
        email: data.email,
        password: decryptedPassword,
      );

      final updateRegister =
          await Network.apiClient.put("/student/$studentId/register");
      if (updateRegister.statusCode == 500) {
        return left("Connection error: ${updateRegister.message}");
      }

      return const Right("Accept student account succes");
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
  Future<Either> acceptAllStudentAccount() async {
    try {
      final response = await Network.apiClient.get("/students/unregister");
      if (response.statusCode == 500) {
        return left("Connection error: ${response.message}");
      }

      if (response.statusCode == 404) {
        return const Right('No Students to Update');
      }

      final dataList = response.data['data'] as List<Map<String, dynamic>>;

      final FirebaseApp secondaryApp = await Firebase.initializeApp(
        name: 'SecondaryApp',
        options: Firebase.app().options,
      );

      final FirebaseAuth secondaryAuth = FirebaseAuth.instanceFor(
        app: secondaryApp,
      );

      final key = encrypt.Key.fromUtf8('1234567890123456');
      final encrypter = encrypt.Encrypter(encrypt.AES(key));

      for (final doc in dataList) {
        final data = StudentModel.fromMap(doc);

        try {
          final iv = encrypt.IV.fromBase64(data.iv);
          final decryptedPassword = encrypter.decrypt64(
            data.password,
            iv: iv,
          );

          await secondaryAuth.createUserWithEmailAndPassword(
            email: data.email,
            password: decryptedPassword,
          );
          final updateRegister =
              await Network.apiClient.put("/student/${data.id}/register");
          if (updateRegister.statusCode == 500) {
            return left("Connection error: ${updateRegister.message}");
          }
        } on FirebaseAuthException catch (e) {
          String message = '';
          if (e.code == "weak-password") {
            message = "Password is too weak";
          } else if (e.code == 'email-already-in-use') {
            message = "Email already in use";
          } else {
            message = "Firebase Auth Error: ${e.message}";
          }
          return Left(
            "Something error with register account ${data.email}: $message",
          );
        } catch (e) {
          return Left('Error on ${data.email}: $e');
        }
      }
      await secondaryApp.delete();
      return right('Accept All Student Success');
    } catch (e) {
      return Left('Something Wrong: $e');
    }
  }

  @override
  Future<Either> deleteAllStudentAccount() async {
    try {
      final responseDelete =
          await Network.apiClient.delete("/student/unregister");
      if (responseDelete.statusCode == 500) {
        return left("Connection error: ${responseDelete.message}");
      }
      return const Right('Semua data akun registrasi telah dihapus');
    } catch (e) {
      return Left('Something wrong: $e');
    }
  }

  @override
  Future<Either> createExcellForStudentData() async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    DateTime now = DateTime.now();
    String formatted = DateFormat('d MMMM yyyy HH:mm').format(now);
    try {
      var returnedData = await FirebaseFirestore.instance
          .collection("Students")
          .where("is_register", isEqualTo: true)
          .where("nama", isNotEqualTo: "admin")
          .orderBy('kelas')
          .get();
      List<Map<String, dynamic>> students =
          returnedData.docs.map((e) => e.data()).toList();

      sheet
          .getRangeByName('A1')
          .setText("Data diunduh pada tanggal: $formatted");
      sheet.getRangeByName('A2').setText('Nama');
      sheet.getRangeByName('B2').setText('Email');
      sheet.getRangeByName('C2').setText('Kelas');
      final headerStyle = workbook.styles.add('HeaderStyle');
      final defaultStyle = workbook.styles.add('DefaultStyle');
      headerStyle.bold = true;
      defaultStyle.bold = true;
      headerStyle.backColor = '#E0E0E0';
      sheet.getRangeByName('A1').cellStyle = defaultStyle;
      sheet.getRangeByName('A2:C2').cellStyle = headerStyle;

      for (var i = 0; i < students.length; i++) {
        sheet.getRangeByName('A${i + 3}').setText(students[i]['nama']);
        sheet
            .getRangeByName('B${i + 3}')
            .setText(StringHelper.maskEmail(students[i]['email']));
        sheet.getRangeByName('C${i + 3}').setText(students[i]['kelas']);
      }
      sheet.autoFitColumn(1);
      sheet.autoFitColumn(2);
      sheet.autoFitColumn(3);

      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();

      final String? selectedDirectory =
          await FilePicker.platform.getDirectoryPath(
        dialogTitle: 'Pilih folder untuk menyimpan Excel',
      );

      if (selectedDirectory == null) {
        return const Left("Pilihi directory dulu");
      }

      final String filePath = '$selectedDirectory/daftar_akun_siswa.xlsx';

      final File file = File(filePath);
      await file.writeAsBytes(bytes, flush: true);
      return Right("Data excel berhasil di simpan di: $filePath");
    } catch (e) {
      return Left(e.toString());
    }
  }
}
