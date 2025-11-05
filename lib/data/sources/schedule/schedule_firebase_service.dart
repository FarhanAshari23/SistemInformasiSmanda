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
  Future<Either> createActivities(String kegiatan);
  Future<Either> updateJadwal(ScheduleEntity scheduleReq);
  Future<Either> deleteJadwal(String kelas);
  Future<Either> deleteKelas(String kelas);
  Future<Either> deleteActivity(String activity);
}

class ScheduleFirebaseServiceImpl extends ScheduleFirebaseService {
  @override
  Future<Either> getJadwal() async {
    try {
      var currentUser = FirebaseAuth.instance.currentUser;
      var querySnapshot = await FirebaseFirestore.instance
          .collection('Students')
          .where('uid', isEqualTo: currentUser?.uid)
          .limit(1)
          .get();
      if (querySnapshot.docs.isEmpty) {
        return const Left('User not found');
      }
      Map<String, dynamic> data = querySnapshot.docs.first.data();
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
      final firestore = FirebaseFirestore.instance;
      final batch = firestore.batch();

      final kelasSnapshot = await firestore
          .collection('Kelas')
          .where('class', isEqualTo: scheduleReq.oldNamaKelas)
          .get();
      if (kelasSnapshot.docs.isNotEmpty) {
        final docId = kelasSnapshot.docs.first.id;
        await firestore.collection('Kelas').doc(docId).update({
          'class': scheduleReq.kelas,
        });
      }
      final jadwalSnapshot = await firestore
          .collection('Jadwals')
          .where('kelas', isEqualTo: scheduleReq.oldNamaKelas)
          .get();
      if (jadwalSnapshot.docs.isNotEmpty) {
        final docId = jadwalSnapshot.docs.first.id;
        await firestore.collection('Jadwals').doc(docId).update({
          'kelas': scheduleReq.kelas,
          ...scheduleReq.hari.map(
            (key, value) => MapEntry(key, value.map((e) => e.toMap()).toList()),
          ),
        });
      }
      final muridSnapshot = await firestore
          .collection('Students')
          .where('kelas', isEqualTo: scheduleReq.oldNamaKelas)
          .get();
      for (final doc in muridSnapshot.docs) {
        batch.update(doc.reference, {'kelas': scheduleReq.kelas});
      }
      await batch.commit();
      if (kelasSnapshot.docs.isEmpty && jadwalSnapshot.docs.isEmpty) {
        return const Right('No matching data found');
      }
      return const Right('Update success');
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

  @override
  Future<Either> createActivities(String kegiatan) async {
    try {
      final kelasRef = FirebaseFirestore.instance.collection('Activities');
      await kelasRef.add({
        'kegiatan': kegiatan,
      });

      return const Right('Data kegiatan berhasil ditambahkan');
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> deleteKelas(String kelas) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('Kelas');
      QuerySnapshot querySnapshot =
          await users.where('kelas', isEqualTo: kelas).get();
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
      return const Right('Delete Data kelas Success');
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> deleteActivity(String activity) async {
    try {
      CollectionReference item =
          FirebaseFirestore.instance.collection('Activities');
      QuerySnapshot querySnapshot =
          await item.where('kegiatan', isEqualTo: activity).get();
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
      return const Right('Delete Data Kegiatan Success');
    } catch (e) {
      return Left('Something wrong: $e');
    }
  }
}
