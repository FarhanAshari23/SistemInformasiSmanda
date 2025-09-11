import 'package:new_sistem_informasi_smanda/domain/entities/schedule/activity.dart';

abstract class GetActivitiesState {}

class GetActivitiesLoading extends GetActivitiesState {}

class GetActivitiesLoaded extends GetActivitiesState {
  final List<ActivityEntity> activities;
  final String? selected;

  GetActivitiesLoaded({required this.activities, this.selected});

  GetActivitiesLoaded copyWith({
    List<ActivityEntity>? activities,
    String? selected,
  }) {
    return GetActivitiesLoaded(
      activities: activities ?? this.activities,
      selected: selected ?? this.selected,
    );
  }
}

class GetActivitiesFailure extends GetActivitiesState {
  final String errorMessage;
  GetActivitiesFailure({required this.errorMessage});
}
