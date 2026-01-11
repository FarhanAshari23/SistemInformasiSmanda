import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/roles/get_roles_cubit.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/roles/get_roles_state.dart';
import 'package:new_sistem_informasi_smanda/common/widget/dialog/basic_dialog.dart';
import 'package:new_sistem_informasi_smanda/common/widget/dialog/input_dialog.dart';
import 'package:new_sistem_informasi_smanda/domain/usecases/teacher/create_roles_usecase.dart';

import '../../../common/bloc/button/button.cubit.dart';
import '../../../common/bloc/button/button_state.dart';
import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../common/widget/inkwell/custom_inkwell.dart';
import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/usecases/teacher/delete_role_usecase.dart';
import '../../../service_locator.dart';

class ManageJabatanViews extends StatefulWidget {
  const ManageJabatanViews({super.key});

  @override
  State<ManageJabatanViews> createState() => _ManageJabatanViewsState();
}

class _ManageJabatanViewsState extends State<ManageJabatanViews> {
  final TextEditingController _roleC = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _roleC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => GetRolesCubit()..displayRoles(),
          ),
          BlocProvider(
            create: (context) => ButtonStateCubit(),
          ),
        ],
        child: SafeArea(
          child: BlocListener<ButtonStateCubit, ButtonState>(
            listener: (context, state) {
              if (state is ButtonSuccessState) {
                context.read<GetRolesCubit>().displayRoles();
                var snackbar = const SnackBar(
                  content: Text("Tugas Tambahan baru berhasil ditambah"),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
                _roleC.clear();
                Navigator.of(context, rootNavigator: true).pop();
              }
              if (state is ButtonFailureState) {
                var snackbar = SnackBar(
                  content: Text("Gagal Mengubah Data: ${state.errorMessage}"),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BasicAppbar(
                  isBackViewed: true,
                  isProfileViewed: false,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 18),
                  child: Text(
                    'Daftar tugas tambahan:',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Expanded(
                  child: BlocBuilder<GetRolesCubit, GetRolesState>(
                    builder: (context, state) {
                      if (state is GetRolesLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is GetRolesLoaded) {
                        return ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            if (index == state.roles.length) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 16,
                                ),
                                child: CustomInkWell(
                                  borderRadius: 16,
                                  defaultColor: AppColors.primary,
                                  onTap: () {
                                    final outerContext = context;
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return InputDialog(
                                          height: height,
                                          title: 'Tambah tugas',
                                          controller: _roleC,
                                          hintText: "Nama Tugas",
                                          onTap: () {
                                            outerContext
                                                .read<ButtonStateCubit>()
                                                .execute(
                                                  usecase: CreateRolesUsecase(),
                                                  params: _roleC.text,
                                                );
                                          },
                                          buttonTitle: 'Tambah',
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            }
                            final activity = state.roles[index];
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: AppColors.primary,
                              ),
                              margin: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 16,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Text(
                                      activity.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.inversePrimary,
                                      ),
                                    ),
                                  ),
                                  CustomInkWell(
                                    right: 16,
                                    defaultColor: Colors.red,
                                    onTap: () async {
                                      final outerContext = context;
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return BasicDialog(
                                            width: height,
                                            height: height,
                                            splashImage: AppImages.splashDelete,
                                            mainTitle:
                                                "Apakah anda yakin ingin menghapus ${activity.name}",
                                            buttonTitle: "Hapus",
                                            onPressed: () async {
                                              var delete =
                                                  await sl<DeleteRoleUsecase>()
                                                      .call(
                                                          params:
                                                              activity.name);
                                              return delete.fold(
                                                (error) {
                                                  var snackbar = const SnackBar(
                                                    content: Text(
                                                        "Gagal Menghapus tugas tambahan, Coba Lagi"),
                                                  );
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackbar);
                                                },
                                                (r) {
                                                  Navigator.pop(context);
                                                  var snackbar = SnackBar(
                                                    content: Text(
                                                        "Data ${activity.name} Berhasil Dihapus"),
                                                  );
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackbar);
                                                  outerContext
                                                      .read<GetRolesCubit>()
                                                      .displayRoles();
                                                },
                                              );
                                            },
                                          );
                                        },
                                      );
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(12),
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                          itemCount: state.roles.length + 1,
                        );
                      }
                      return Container();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
