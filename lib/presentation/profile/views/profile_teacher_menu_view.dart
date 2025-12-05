import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/bloc/button/button.cubit.dart';
import '../../../common/bloc/button/button_state.dart';
import '../../../common/helper/app_navigation.dart';
import '../../../common/widget/card/card_basic.dart';
import '../../../common/widget/landing/succes.dart';
import '../../../core/configs/assets/app_images.dart';
import '../../../domain/entities/teacher/teacher.dart';
import '../../../domain/usecases/attendance/add_teacher_attendance.dart';
import '../../../domain/usecases/attendance/add_teacher_completion_usecase.dart';
import '../bloc/get_distace_state.dart';
import '../bloc/get_distance_cubit.dart';

class ProfileTeacherMenuView extends StatelessWidget {
  final TeacherEntity teacher;
  const ProfileTeacherMenuView({
    super.key,
    required this.teacher,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetDistanceCubit(),
        ),
        BlocProvider(
          create: (context) => ButtonStateCubit(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<GetDistanceCubit, GetDistanceState>(
            listener: (context, state) {
              if (state is GetDistanceLoading) {
                var snackbar = const SnackBar(
                  content: Text("Sedang mengecek lokasi..."),
                  behavior: SnackBarBehavior.floating,
                );
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
              }
            },
          ),
          BlocListener<ButtonStateCubit, ButtonState>(
            listener: (context, state) {
              if (state is ButtonSuccessState) {
                AppNavigator.push(
                  context,
                  const SuccesPage(
                    page: SizedBox(),
                    title: "Proses absen berhasil dilakukan",
                    isPop: true,
                  ),
                );
              }
              if (state is ButtonFailureState) {
                var snackbar = SnackBar(
                  content: Text(state.errorMessage),
                  behavior: SnackBarBehavior.floating,
                );
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
              }
            },
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(builder: (context) {
                    return CardBasic(
                      image: AppImages.attendance,
                      onpressed: () async {
                        final distanceCubit = context.read<GetDistanceCubit>();
                        final buttonCubit = context.read<ButtonStateCubit>();
                        final messenger = ScaffoldMessenger.of(context);

                        await distanceCubit.getDistance();
                        final state = distanceCubit.state;

                        if (state is GetDistanceLoaded && state.isNear) {
                          buttonCubit.execute(
                            usecase: AddTeacherAttendanceUseCase(),
                            params: teacher,
                          );
                        } else {
                          messenger.showSnackBar(
                            const SnackBar(
                              content: Text(
                                  "Anda tidak berada di lingkungan SMA N 2 Metro, harap melakukan absen di sekolah"),
                            ),
                          );
                        }
                      },
                      title: 'Absen Masuk',
                    );
                  }),
                  Builder(builder: (context) {
                    return CardBasic(
                      image: AppImages.attendance,
                      onpressed: () async {
                        final distanceCubit = context.read<GetDistanceCubit>();
                        final buttonCubit = context.read<ButtonStateCubit>();
                        final messenger = ScaffoldMessenger.of(context);

                        await distanceCubit.getDistance();
                        final state = distanceCubit.state;

                        if (state is GetDistanceLoaded && state.isNear) {
                          buttonCubit.execute(
                            usecase: AddTeacherCompletionUseCase(),
                            params: teacher,
                          );
                        } else {
                          messenger.showSnackBar(
                            const SnackBar(
                              content: Text(
                                  "Anda tidak berada di lingkungan SMA N 2 Metro, harap melakukan absen di sekolah"),
                            ),
                          );
                        }
                      },
                      title: 'Absen Pulang',
                    );
                  }),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CardBasic(
                    image: AppImages.verification,
                    onpressed: () {},
                    title: 'Data Absen Masuk',
                  ),
                  CardBasic(
                    image: AppImages.verification,
                    onpressed: () {},
                    title: 'Data Absen Pulang',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
