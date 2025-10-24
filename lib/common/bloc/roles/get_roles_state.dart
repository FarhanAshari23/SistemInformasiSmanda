import 'package:new_sistem_informasi_smanda/domain/entities/schedule/role.dart';

abstract class GetRolesState {}

class GetRolesLoading extends GetRolesState {}

class GetRolesLoaded extends GetRolesState {
  final List<RoleEntity> roles;
  final String? selected;

  GetRolesLoaded({required this.roles, this.selected});

  GetRolesLoaded copyWith({
    List<RoleEntity>? roles,
    String? selected,
  }) {
    return GetRolesLoaded(
      roles: roles ?? this.roles,
      selected: selected ?? this.selected,
    );
  }
}

class GetRolesFailure extends GetRolesState {
  final String errorMessage;
  GetRolesFailure({required this.errorMessage});
}
