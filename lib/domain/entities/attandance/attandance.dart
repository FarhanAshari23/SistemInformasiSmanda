import 'package:cloud_firestore/cloud_firestore.dart';

class AttandanceEntity {
  final String createdAt;
  final Timestamp timestamp;

  AttandanceEntity({
    required this.createdAt,
    required this.timestamp,
  });
}
