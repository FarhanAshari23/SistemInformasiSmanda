import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class ScheduleFirebaseService {
  Future<Either> getJadwal();
  Future<Either> getAllJadwal();
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
      return Left(e);
    }
  }

  @override
  Future<Either> getAllJadwal() async {
    try {
      var returnedData =
          await FirebaseFirestore.instance.collection("Jadwals").get();
      return Right(returnedData.docs.map((e) => e.data()).toList());
    } catch (e) {
      return const Left("Error get data, please try again later");
    }
  }
}
