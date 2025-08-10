import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/widget/appbar/basic_appbar.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageAttendance/bloc/display_date_cubit.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageAttendance/bloc/display_date_state.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageAttendance/widgets/card_date.dart';

class SeeDataAttandance extends StatelessWidget {
  const SeeDataAttandance({super.key});

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: BlocProvider(
        create: (context) => DisplayDateCubit()..displayAttendances(),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BasicAppbar(isBackViewed: true, isProfileViewed: false),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    BlocBuilder<DisplayDateCubit, DisplayDateState>(
                      builder: (context, state) {
                        if (state is DisplayDateLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state is DisplayDateLoaded) {
                          return SizedBox(
                            width: double.infinity,
                            height: height * 0.75,
                            child: ListView.separated(
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                return CardDate(
                                  date: state.attendances[index].createdAt,
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: height * 0.02),
                              itemCount: state.attendances.length,
                            ),
                          );
                        }
                        return Container();
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
