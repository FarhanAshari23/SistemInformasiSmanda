import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/activities/get_activities_state.dart';
import 'package:new_sistem_informasi_smanda/common/widget/inkwell/custom_inkwell.dart';
import 'package:new_sistem_informasi_smanda/domain/usecases/schedule/create_activity_usecase.dart';
import 'package:new_sistem_informasi_smanda/domain/usecases/schedule/delete_activity_usecase.dart';

import '../../../common/bloc/activities/get_activities_cubit.dart';
import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../service_locator.dart';

class ManageActivityView extends StatefulWidget {
  const ManageActivityView({super.key});

  @override
  State<ManageActivityView> createState() => _ManageActivityViewState();
}

class _ManageActivityViewState extends State<ManageActivityView> {
  final TextEditingController _kegiatanC = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _kegiatanC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: BlocProvider(
        create: (context) => GetActivitiesCubit()..displayActivites(),
        child: SafeArea(
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
                  'Daftar kegiatan:',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Expanded(
                child: BlocBuilder<GetActivitiesCubit, GetActivitiesState>(
                  builder: (context, state) {
                    if (state is GetActivitiesLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is GetActivitiesLoaded) {
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          if (index == state.activities.length) {
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
                                      return Dialog(
                                        backgroundColor:
                                            AppColors.inversePrimary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        child: SingleChildScrollView(
                                          child: SizedBox(
                                            height: height * 0.25,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 20,
                                                horizontal: 16,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Center(
                                                    child: Text(
                                                      'Tambah kegiatan',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color:
                                                            AppColors.primary,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height: height * 0.02),
                                                  TextField(
                                                    controller: _kegiatanC,
                                                    autocorrect: false,
                                                    decoration:
                                                        const InputDecoration(
                                                      hintText: 'Nama kegiatan',
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height: height * 0.02),
                                                  GestureDetector(
                                                    onTap: () async {
                                                      var result = await sl<
                                                              CreateActivityUsecase>()
                                                          .call(
                                                              params: _kegiatanC
                                                                  .text);
                                                      result.fold(
                                                        (error) {
                                                          var snackbar =
                                                              SnackBar(
                                                            content: Text(
                                                                "Gagal Mengubah Data: $error"),
                                                          );
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  snackbar);
                                                        },
                                                        (r) {
                                                          outerContext
                                                              .read<
                                                                  GetActivitiesCubit>()
                                                              .displayActivites();
                                                          var snackbar =
                                                              const SnackBar(
                                                            content: Text(
                                                                "Kegiatan baru berhasil ditambah"),
                                                          );
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  snackbar);
                                                          Navigator.of(context,
                                                                  rootNavigator:
                                                                      true)
                                                              .pop();
                                                        },
                                                      );
                                                    },
                                                    child: Container(
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 16),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        color:
                                                            AppColors.secondary,
                                                      ),
                                                      child: const Center(
                                                        child: Text(
                                                          'Tambah',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            color: AppColors
                                                                .inversePrimary,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
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
                          final activity = state.activities[index];
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () async {
                                      var delete =
                                          await sl<DeleteActivityUsecase>()
                                              .call(params: activity.name);
                                      return delete.fold(
                                        (error) {
                                          var snackbar = const SnackBar(
                                            content: Text(
                                                "Gagal Menghapus kegiatan, Coba Lagi"),
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackbar);
                                        },
                                        (r) {
                                          var snackbar = const SnackBar(
                                            content:
                                                Text("Data Berhasil Dihapus"),
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackbar);
                                          context
                                              .read<GetActivitiesCubit>()
                                              .displayActivites();
                                        },
                                      );
                                    },
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(16),
                                      bottomRight: Radius.circular(16),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(16),
                                          bottomRight: Radius.circular(16),
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                        itemCount: state.activities.length + 1,
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
    );
  }
}
