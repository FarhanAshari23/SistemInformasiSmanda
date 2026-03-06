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
import '../../../core/networks/network.dart';
import '../../../domain/entities/teacher/role.dart';
import '../../../domain/entities/teacher/teacher.dart';
import '../../../domain/entities/teacher/teacher_golang.dart';
import '../../models/teacher/schedule_teacher.dart';
import '../../models/teacher/teacher_golang.dart';

abstract class TeacherFirebaseService {
  Future<Either> createTeacher(TeacherGolangEntity teacherCreationReq);
  Future<Either> updateTeacher(TeacherEntity teacherReq);
  Future<Either> deleteTeacher(int teacherId);
  Future<Either> getTeacherByName(String name);
  Future<Either> getScheduleTeacher(String name);
  Future<Either> createRoles(String role);
  Future<Either> deleteRole(int idRole);
  Future<Either> updateRoles(RoleEntity role);
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
      final response = await Network.apiClient.get("/teachers");
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
  Future<Either> createTeacher(TeacherGolangEntity teacherCreationReq) async {
    try {
      final secondaryApp = await Firebase.initializeApp(
        name: 'SecondaryApp',
        options: Firebase.app().options,
      );

      final secondaryAuth = FirebaseAuth.instanceFor(app: secondaryApp);

      await secondaryAuth.createUserWithEmailAndPassword(
        email: teacherCreationReq.email!,
        password: teacherCreationReq.password!,
      );

      final model = TeacherGolangModelX.fromEntity(teacherCreationReq);
      final response =
          await Network.apiClient.post("/teacher", body: model.toMap());

      if (response.statusCode == 500) {
        return left("Connection error: ${response.message}");
      }

      final data = TeacherGolangModel.fromMap(response.data['data']);

      if (teacherCreationReq.imageFile != null) {
        Uri? url;
        String endpoint =
            "http://192.168.18.3:3000/api/teacher/${data.id}/photo";
        try {
          url = Uri.parse(endpoint);
        } catch (_) {
          throw Exception("URL tidak valid: $endpoint");
        }

        final request = http.MultipartRequest("POST", url);

        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            teacherCreationReq.imageFile?.path ?? '',
            filename: basename(teacherCreationReq.imageFile?.path ?? ''),
          ),
        );

        request.headers.addAll({
          "Accept": "application/json",
          "Content-Type": "multipart/form-data",
          "x-api-key": "RAHASIA"
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

      return const Right("Buat akun guru sukses");
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
      return Left("Something Error: $e");
    }
  }

  @override
  Future<Either> deleteTeacher(int teacherId) async {
    try {
      final responseGet = await Network.apiClient.delete("/teacher/$teacherId");
      if (responseGet.statusCode == 500) {
        return left("Connection error: ${responseGet.data}");
      }
      return const Right('Delete Data Teacher Success');
    } catch (e) {
      return Left(e.toString());
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
      final response = await Network.apiClient.get("/teachersName/$name");
      if (response.statusCode == 500) {
        return left("Connection error: ${response.message}");
      }
      final dataList = response.data['data'] as List<Map<String, dynamic>>;
      return Right(dataList);
    } catch (e) {
      return Left("Something error: ${e.toString()}");
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
      final response =
          await Network.apiClient.post("/task", body: {"name": role});
      if (response.statusCode == 500) {
        return left("Connection error: ${response.message}");
      }
      return const Right("Tugas tambahan berhasil dibuat");
    } catch (e) {
      return Left("Something error: ${e.toString()}");
    }
  }

  @override
  Future<Either> deleteRole(int idRole) async {
    try {
      final response = await Network.apiClient.delete("/task/$idRole");
      if (response.statusCode == 500) {
        return left("Connection error: ${response.message}");
      }
      return const Right("Tugas tambahan berhasil dihapus");
    } catch (e) {
      return Left("Something error: ${e.toString()}");
    }
  }

  @override
  Future<Either> getRoles() async {
    try {
      final response = await Network.apiClient.get("/tasks");
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

  @override
  Future<Either> updateRoles(RoleEntity role) async {
    try {
      final response = await Network.apiClient
          .put("/task/${role.id}", body: {"name": role.name});
      if (response.statusCode == 500) {
        return left("Connection error: ${response.message}");
      }
      return const Right("Tugas tambahan berhasil diubah");
    } catch (e) {
      return Left("Something error: ${e.toString()}");
    }
  }
}
