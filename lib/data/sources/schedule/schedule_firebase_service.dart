// ignore_for_file: unrelated_type_equality_checks

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../domain/entities/kelas/kelas.dart';
import '../../../domain/entities/schedule/schedule.dart';

abstract class ScheduleFirebaseService {
  Future<Either> getJadwal();
  Future<Either> getAllJadwal();
  Future<Either> getActivities();
  Future<Either> createClass(KelasEntity kelasReq);
  Future<Either> createSchedule(ScheduleEntity scheduleReq);
  Future<Either> updateJadwal(ScheduleEntity scheduleReq);
  Future<Either> deleteJadwal(String kelas);
}

class ScheduleFirebaseServiceImpl extends ScheduleFirebaseService {
  @override
  Future<Either> getJadwal() async {
    try {
      var currentUser = FirebaseAuth.instance.currentUser;
      CollectionReference users =
          FirebaseFirestore.instance.collection('Students');
      DocumentSnapshot snapshot = await users.doc(currentUser?.uid).get();
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      var returnedData = await FirebaseFirestore.instance
          .collection("Jadwals")
          .where("kelas", isEqualTo: data['kelas'])
          .get();
      return Right(returnedData.docs.map((e) => e.data()).toList());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> getAllJadwal() async {
    try {
      var returnedData = await FirebaseFirestore.instance
          .collection("Jadwals")
          .orderBy('degree')
          .orderBy('order')
          .get();
      return Right(returnedData.docs.map((e) => e.data()).toList());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> createClass(KelasEntity kelasReq) async {
    try {
      final kelasRef = FirebaseFirestore.instance.collection('Kelas');
      final firstPart = kelasReq.kelas.trim().split(' ').first;
      final tingkat = int.tryParse(firstPart) ?? 0;
      if (tingkat == 0) {
        throw Exception(
            "Format nama kelas tidak valid. Awalan harus angka (contoh: '10 IPA 1').");
      }
      final snapshot = await kelasRef
          .where('degree', isEqualTo: tingkat)
          .orderBy('order', descending: true)
          .limit(1)
          .get();

      int lastUrutan = 0;

      if (snapshot.docs.isNotEmpty) {
        lastUrutan = snapshot.docs.first['order'] as int;
      }

      await kelasRef.add({
        'class': kelasReq.kelas,
        'degree': tingkat,
        'order': lastUrutan + 1,
      });

      return const Right('Data kelas berhasil ditambahkan');
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> getActivities() async {
    try {
      var returnedData =
          await FirebaseFirestore.instance.collection('Activities').get();
      return Right(returnedData.docs.map((e) => e.data()).toList());
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> createSchedule(ScheduleEntity scheduleReq) async {
    try {
      final scheduleRef = FirebaseFirestore.instance.collection('Jadwals');
      final firstPart = scheduleReq.kelas.trim().split(' ').first;
      final tingkat = int.tryParse(firstPart) ?? 0;
      if (tingkat == 0) {
        throw Exception(
            "Format nama kelas tidak valid. Awalan harus angka (contoh: '10 IPA 1').");
      }
      final snapshot = await scheduleRef
          .where('degree', isEqualTo: tingkat)
          .orderBy('order', descending: true)
          .limit(1)
          .get();

      int lastUrutan = 0;

      if (snapshot.docs.isNotEmpty) {
        lastUrutan = snapshot.docs.first['order'] as int;
      }
      await FirebaseFirestore.instance.collection('Jadwals').add({
        "kelas": scheduleReq.kelas,
        "degree": tingkat,
        "order": lastUrutan + 1,
        ...scheduleReq.hari.map(
          (key, value) => MapEntry(key, value.map((e) => e.toMap()).toList()),
        )
      });
      return const Right("Success add schedule data");
    } catch (e) {
      return Left('Something error: $e');
    }
  }

  @override
  Future<Either> updateJadwal(ScheduleEntity scheduleReq) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('Jadwals');
      QuerySnapshot querySnapshot =
          await users.where('kelas', isEqualTo: scheduleReq.kelas).get();
      if (querySnapshot.docs.isNotEmpty) {
        String docId = querySnapshot.docs[0].id;
        await users.doc(docId).update({
          "kelas": scheduleReq.kelas,
          ...scheduleReq.hari.map(
            (key, value) => MapEntry(key, value.map((e) => e.toMap()).toList()),
          )
        });
        return right('Update Data Schedule Success');
      }
      return const Right('Update Data Schedule Success');
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> deleteJadwal(String kelas) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('Jadwals');
      QuerySnapshot querySnapshot =
          await users.where('kelas', isEqualTo: kelas).get();
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
      return const Right('Delete Data Schedule Success');
    } catch (e) {
      return Left(e.toString());
    }
  }
}
