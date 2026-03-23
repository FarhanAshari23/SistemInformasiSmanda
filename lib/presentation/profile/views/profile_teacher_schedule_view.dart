import 'package:flutter/material.dart';

class ProfileTeacherScheduleView extends StatelessWidget {
  const ProfileTeacherScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

// BlocBuilder<GetScheduleTeacherCubit, GetScheduleTeacherState>(
//       builder: (context, state) {
//         if (state is GetScheduleTeacherLoading) {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//         if (state is GetScheduleTeacherLoaded) {
//           if (state.teacherSchedule.isEmpty) {
//             return const Column(
//               mainAxisSize: MainAxisSize.min,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.event_busy_rounded,
//                   color: AppColors.primary,
//                   size: 48,
//                 ),
//                 SizedBox(height: 4),
//                 Text(
//                   'Tidak ada jadwal',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w900,
//                     color: AppColors.primary,
//                   ),
//                 ),
//               ],
//             );
//           } else {
//             List<ScheduleTeacherEntity> scheduleByDay = state.teacherSchedule
//                 .where((element) => element.hari == hari)
//                 .toList();
//             scheduleByDay.sort(
//               (a, b) {
//                 final startA = parseTimeSchedule(a.jam);
//                 final startB = parseTimeSchedule(b.jam);
//                 return startA.compareTo(startB);
//               },
//             );
//             if (scheduleByDay.isEmpty) {
//               return const Center(child: Text("Tidak mengajar di hari ini"));
//             } else {
//               return ListView.separated(
//                 scrollDirection: Axis.vertical,
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//                 itemBuilder: (context, index) {
//                   if (hari == "Jumat" && index == 0) {
//                     return Padding(
//                       padding: EdgeInsets.only(left: width * 0.85),
//                       child: CustomInkWell(
//                         borderRadius: 8,
//                         defaultColor: AppColors.primary,
//                         onTap: () {
//                           showDialog(
//                             barrierDismissible: false,
//                             context: context,
//                             builder: (context) {
//                               return Dialog(
//                                 alignment: Alignment.center,
//                                 backgroundColor: Colors.white,
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(16.0),
//                                   child: Column(
//                                     mainAxisSize: MainAxisSize.min,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       const Text(
//                                         "Catatan:",
//                                         style: TextStyle(
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.w900,
//                                           color: AppColors.primary,
//                                         ),
//                                       ),
//                                       const SizedBox(height: 8),
//                                       const Text(
//                                         Notes.noteFridayTeachers,
//                                         style: TextStyle(
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.bold,
//                                           color: AppColors.primary,
//                                         ),
//                                       ),
//                                       BasicButton(
//                                         onPressed: () => Navigator.pop(context),
//                                         title: "Saya Mengerti",
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             },
//                           );
//                         },
//                         child: const Center(
//                           child: Padding(
//                             padding: EdgeInsets.symmetric(vertical: 8.0),
//                             child: Icon(
//                               Icons.info,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   } else {
//                     final item =
//                         scheduleByDay[hari == "Jumat" ? index - 1 : index];
//                     return CardJadwal(
//                       jam: item.kelas,
//                       kegiatan: item.kegiatan,
//                       pelaksana: item.jam,
//                       urutan: index + (hari == "Jumat" ? 0 : 1),
//                       isTeacher: true,
//                     );
//                   }
//                 },
//                 separatorBuilder: (context, index) => SizedBox(
//                   height: height * 0.01,
//                 ),
//                 itemCount: hari == "Jumat"
//                     ? scheduleByDay.length + 1
//                     : scheduleByDay.length,
//               );
//             }
//           }
//         }
//         if (state is GetScheduleTeacherFailure) {
//           return Container();
//         }
