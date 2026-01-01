import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'package:new_sistem_informasi_smanda/domain/entities/teacher/schedule_teacher.dart';
import 'package:path/path.dart';

import '../../../common/helper/execute_crud.dart';
import '../../../common/helper/generate_keyword.dart';
import '../../../domain/entities/teacher/teacher.dart';
import '../../models/teacher/schedule_teacher.dart';

abstract class TeacherFirebaseService {
  Future<Either> createTeacher(TeacherEntity teacherCreationReq);
  Future<Either> updateTeacher(TeacherEntity teacherReq);
  Future<Either> deleteTeacher(TeacherEntity teacherReq);
  Future<Either> getTeacherByName(String name);
  Future<Either> getScheduleTeacher(String name);
  Future<Either> createRoles(String role);
  Future<Either> deleteRole(String role);
  Future<Either> getRoles();
  Future<Either> getKepalaSekolah();
  Future<Either> getWaka();
  Future<Either> getTeacher();
  Future<Either> getHonor();
}

class TeacherFirebaseServiceImpl extends TeacherFirebaseService {
  @override
  Future<Either> getKepalaSekolah() async {
    try {
      var returnedData = await FirebaseFirestore.instance
          .collection("Teachers")
          .where("jabatan_tambahan", isEqualTo: 'Kepala Sekolah')
          .get();
      return Right(returnedData.docs.map((e) => e.data()).toList());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> getWaka() async {
    try {
      var returnedData =
          await FirebaseFirestore.instance.collection("Teachers").get();

      final result = returnedData.docs
          .where((doc) {
            final jabatan = (doc.data()["jabatan_tambahan"] ?? "").toString();
            return jabatan.contains("Wakil Kepala Sekolah");
          })
          .map((doc) => doc.data())
          .toList();
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> getTeacher() async {
    try {
      var returnedData = await FirebaseFirestore.instance
          .collection("Teachers")
          .where('mengajar', isNotEqualTo: 'Tenaga Kependidikan')
          .orderBy('nama')
          .get();
      return Right(returnedData.docs.map((e) => e.data()).toList());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> createTeacher(TeacherEntity teacherCreationReq) async {
    String endpoint = ExecuteCRUD.uploadImageTeacher();
    try {
      if (teacherCreationReq.image != null) {
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
            teacherCreationReq.image?.path ?? '',
            filename: basename(teacherCreationReq.image?.path ?? ''),
          ),
        );

        request.headers.addAll({
          "Accept": "application/json",
          "Content-Type": "multipart/form-data",
        });

        final streamedResponse = await request.send().timeout(
          const Duration(seconds: 5),
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
      final FirebaseApp secondaryApp = await Firebase.initializeApp(
        name: 'SecondaryApp',
        options: Firebase.app().options,
      );

      final FirebaseAuth secondaryAuth =
          FirebaseAuth.instanceFor(app: secondaryApp);

      final userCredential = await secondaryAuth.createUserWithEmailAndPassword(
        email: teacherCreationReq.email ?? '',
        password: teacherCreationReq.password ?? '',
      );

      final newUid = userCredential.user?.uid;

      final keywords = generateKeywords(teacherCreationReq.nama);
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      await firebaseFirestore.collection("Teachers").doc(newUid).set({
        "nama": teacherCreationReq.nama,
        "NIP": teacherCreationReq.nip,
        "email": teacherCreationReq.email,
        "mengajar": teacherCreationReq.mengajar,
        "tanggal_lahir": teacherCreationReq.tanggalLahir,
        "wali_kelas": teacherCreationReq.waliKelas,
        "jabatan_tambahan": teacherCreationReq.jabatan,
        "gender": teacherCreationReq.gender,
        "keywords": keywords,
        "uid": newUid,
      });

      return const Right("Upload Teacher was succesfull");
    } on TimeoutException {
      return const Left(
          "Gagal terhubung dengan server, cobalah beberapa saat lagi");
    } on SocketException {
      throw Exception("Tidak ada koneksi internet.");
    } on HttpException {
      throw Exception("Kesalahan HTTP terjadi.");
    } on FormatException {
      throw Exception("Format data tidak valid.");
    } catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either> deleteTeacher(TeacherEntity teacherReq) async {
    String endpoint = ExecuteCRUD.deleteImageTeacher();
    try {
      Uri? url;
      try {
        url = Uri.parse(endpoint);
      } catch (_) {
        return Left("URL tidak valid: $endpoint");
      }

      final response = await http.post(url, body: {
        "name": teacherReq.nama,
        "nip": teacherReq.nip != '-' ? teacherReq.nip : teacherReq.tanggalLahir,
      }).timeout(const Duration(seconds: 5));

      if (response.statusCode != 200 && response.statusCode != 404) {
        return Left("Upload gagal (status: ${response.statusCode})");
      }

      CollectionReference users =
          FirebaseFirestore.instance.collection('Teachers');
      QuerySnapshot querySnapshot = await users
          .where(
            teacherReq.nip == '-' ? "nama" : "NIP",
            isEqualTo: teacherReq.nip == '-' ? teacherReq.nama : teacherReq.nip,
          )
          .get();
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
      return const Right('Delete Data Teacher Success');
    } on TimeoutException {
      return const Left(
          "Gagal terhubung dengan server, cobalah beberapa saat lagi");
    } on SocketException {
      return const Left("Tidak ada koneksi internet.");
    } on HttpException {
      return const Left("Kesalahan HTTP terjadi.");
    } catch (e) {
      return Left('Something Wrong : $e');
    }
  }

  @override
  Future<Either> updateTeacher(TeacherEntity teacherReq) async {
    String endpoint = ExecuteCRUD.updateImageTeacher();
    try {
      if (teacherReq.image != null) {
        Uri? url;
        try {
          url = Uri.parse(endpoint);
        } catch (_) {
          throw Exception("URL tidak valid: $endpoint");
        }

        final request = http.MultipartRequest("POST", url);

        request.fields['name'] = teacherReq.nama;
        request.fields['nip'] = teacherReq.nip != '-'
            ? teacherReq.nip
            : teacherReq.tanggalLahir.toString();

        request.files.add(
          await http.MultipartFile.fromPath(
            "photo",
            teacherReq.image?.path ?? '',
            filename: basename(teacherReq.image?.path ?? ''),
            contentType: http.MediaType("image", "jpg"),
          ),
        );

        request.headers.addAll({
          "Accept": "application/json",
          "Content-Type": "multipart/form-data",
        });

        final streamedResponse = await request.send().timeout(
          const Duration(seconds: 5),
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

      final docRef =
          FirebaseFirestore.instance.collection('Teachers').doc(teacherReq.uid);

      final docSnap = await docRef.get();
      if (!docSnap.exists) {
        throw Left(
            'Dokumen teacher dengan UID ${teacherReq.uid} tidak ditemukan!');
      }

      final keywords = generateKeywords(teacherReq.nama);

      await docRef.update({
        "NIP": teacherReq.nip,
        "jabatan_tambahan": teacherReq.jabatan,
        "mengajar": teacherReq.mengajar,
        "tanggal_lahir": teacherReq.tanggalLahir,
        "nama": teacherReq.nama,
        "wali_kelas": teacherReq.waliKelas,
        "keywords": keywords,
      });

      return const Right('Update Data Teacher Success');
    } on TimeoutException {
      return const Left(
          "Gagal terhubung dengan server, cobalah beberapa saat lagi");
    } on SocketException {
      throw Exception("Tidak ada koneksi internet.");
    } on HttpException {
      throw Exception("Kesalahan HTTP terjadi.");
    } on FormatException {
      throw Exception("Format data tidak valid.");
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> getTeacherByName(String name) async {
    try {
      var returnedData = await FirebaseFirestore.instance
          .collection("Teachers")
          .where("keywords", arrayContains: name)
          .get();
      return Right(returnedData.docs.map((e) => e.data()).toList());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> getHonor() async {
    try {
      var returnedData = await FirebaseFirestore.instance
          .collection("Teachers")
          .where("mengajar", isEqualTo: 'Tenaga Kependidikan')
          .get();
      return Right(returnedData.docs.map((e) => e.data()).toList());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> createRoles(String role) async {
    try {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      await firebaseFirestore.collection("Roles").add(
        {
          "role": role,
        },
      );
      return const Right("Upload role was succesfull");
    } catch (e) {
      return Left('Something Wrong: $e');
    }
  }

  @override
  Future<Either> deleteRole(String role) async {
    try {
      CollectionReference item = FirebaseFirestore.instance.collection('Roles');
      QuerySnapshot querySnapshot =
          await item.where('role', isEqualTo: role).get();
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
      return const Right('Delete Data Role Success');
    } catch (e) {
      return Left('Something wrong: $e');
    }
  }

  @override
  Future<Either> getRoles() async {
    try {
      var returnedData = await FirebaseFirestore.instance
          .collection('Roles')
          .orderBy('role', descending: false)
          .get();
      return Right(returnedData.docs.map((e) => e.data()).toList());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> getScheduleTeacher(String name) async {
    final firestore = FirebaseFirestore.instance;
    try {
      final schedules = await firestore.collection("Jadwals").get();
      List<ScheduleTeacherEntity> result = [];
      for (var doc in schedules.docs) {
        final data = doc.data();
        List<String> days = ["Senin", "Selasa", "Rabu", "Kamis", "Jumat"];
        for (var day in days) {
          if (data[day] != null && data[day] is List) {
            for (var item in data[day]) {
              if (item['pelaksana'] == name) {
                final mapped = {
                  "hari": day,
                  "jam": item['jam'],
                  "kegiatan": item['kegiatan'],
                  "kelas": data['kelas']
                };
                final model = ScheduleTeacherModel.fromMap(mapped);
                result.add(model.toEntity());
              }
            }
          }
        }
      }
      return Right(result);
    } catch (e) {
      return Left("Something wrong: $e");
    }
  }
}
