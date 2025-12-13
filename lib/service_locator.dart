import 'package:get_it/get_it.dart';
import 'data/repository/attandance/attandance_repository_impl.dart';
import 'data/repository/auth/auth_repository_impl.dart';
import 'data/repository/ekskul/ekskul_repository.dart';
import 'data/repository/news/news_repository.dart';
import 'data/repository/schedule/schedule_repository.dart';
import 'data/repository/students/students_repository.dart';
import 'data/repository/teacher/teacher_repository_impl.dart';
import 'data/sources/attandance/attandance_firebase_service.dart';
import 'data/sources/auth/auth_firebase_service.dart';
import 'data/sources/ekskul/ekskul_firebase_service.dart';
import 'data/sources/news/news_firebase_service.dart';
import 'data/sources/schedule/schedule_firebase_service.dart';
import 'data/sources/students/students_firebase_service.dart';
import 'data/sources/teacher/teacher_firebase_service.dart';
import 'domain/repository/attandance/attandance.dart';
import 'domain/repository/auth/auth.dart';
import 'domain/repository/ekskul/ekskul.dart';
import 'domain/repository/news/news.dart';
import 'domain/repository/schedule/schedule.dart';
import 'domain/repository/students/students.dart';
import 'domain/repository/teacher/teacher.dart';
import 'domain/usecases/attendance/add_student_attendance.dart';
import 'domain/usecases/attendance/add_teacher_attendance.dart';
import 'domain/usecases/attendance/delete_attendances_usecase.dart';
import 'domain/usecases/attendance/delete_month_attendances_usecase.dart';
import 'domain/usecases/attendance/get_attendance_all_teacher_usecase.dart';
import 'domain/usecases/attendance/get_attendance_name_usecase.dart';
import 'domain/usecases/attendance/get_attendance_student_usecase.dart';
import 'domain/usecases/attendance/get_attendance_students.dart';
import 'domain/usecases/attendance/get_attendance_teacher_usecase.dart';
import 'domain/usecases/attendance/get_list_attendances.dart';
import 'domain/usecases/auth/check_admin.dart';
import 'domain/usecases/auth/check_email_usecase.dart';
import 'domain/usecases/auth/check_register.dart';
import 'domain/usecases/auth/check_teacher_usecase.dart';
import 'domain/usecases/auth/get_user.dart';
import 'domain/usecases/auth/is_logged_in.dart';
import 'domain/usecases/auth/signin.dart';
import 'domain/usecases/auth/signup.dart';
import 'domain/usecases/ekskul/create_ekskul.dart';
import 'domain/usecases/ekskul/delete_ekskul.dart';
import 'domain/usecases/ekskul/get_ekskul.dart';
import 'domain/usecases/ekskul/update_ekskul.dart';
import 'domain/usecases/news/delete_news.dart';
import 'domain/usecases/news/get_news.dart';
import 'domain/usecases/news/update_news.dart';
import 'domain/usecases/schedule/create_activity_usecase.dart';
import 'domain/usecases/schedule/get_all_jadwal.dart';
import 'domain/usecases/students/accept_student_register_usecase.dart';
import 'domain/usecases/students/delete_all_student_account_usecase.dart';
import 'domain/usecases/students/delete_student_by_class.dart';
import 'domain/usecases/students/get_all_kelas_usecase.dart';
import 'domain/usecases/students/get_student_by_name.dart';
import 'domain/usecases/students/get_students_register.dart';
import 'domain/usecases/students/get_students_with_kelas.dart';
import 'domain/usecases/students/search_student_by_nisn.dart';
import 'domain/usecases/students/update_user.dart';
import 'domain/usecases/teacher/create_teacher.dart';
import 'domain/usecases/teacher/delete_role_usecase.dart';
import 'domain/usecases/teacher/delete_teacher.dart';
import 'domain/usecases/teacher/get_honor.dart';
import 'domain/usecases/teacher/get_kepala_sekolah.dart';
import 'domain/usecases/teacher/get_schedule_teacher_usecase.dart';
import 'domain/usecases/teacher/get_teacher.dart';
import 'domain/usecases/teacher/get_teacher_by_name.dart';
import 'domain/usecases/teacher/get_waka.dart';
import 'domain/usecases/teacher/update_teacher.dart';

import 'domain/usecases/auth/forgot_password_usecase.dart';
import 'domain/usecases/ekskul/add_anggota_usecase.dart';
import 'domain/usecases/ekskul/delete_anggota_usecase.dart';
import 'domain/usecases/ekskul/update_anggota_usecase.dart';
import 'domain/usecases/news/create_news.dart';
import 'domain/usecases/schedule/create_class_usecase.dart';
import 'domain/usecases/schedule/create_schedule_usecase.dart';
import 'domain/usecases/schedule/delete_activity_usecase.dart';
import 'domain/usecases/schedule/delete_jadwal_usecase.dart';
import 'domain/usecases/schedule/delete_kelas_usecase.dart';
import 'domain/usecases/schedule/get_activities_usecase.dart';
import 'domain/usecases/schedule/get_jadwal.dart';
import 'domain/usecases/schedule/update_schedule_usecase.dart';
import 'domain/usecases/students/delete_student.dart';
import 'domain/usecases/students/update_all_student_account_usecase.dart';
import 'domain/usecases/teacher/create_roles_usecase.dart';
import 'domain/usecases/teacher/get_roles_usecase.dart';

final sl = GetIt.instance;

Future<void> initializeDependecies() async {
  //service
  sl.registerSingleton<AuthFirebaseService>(
    AuthFirebaseServiceImpl(),
  );
  sl.registerSingleton<NewsFirebaseService>(
    NewsFirebaseServiceImpl(),
  );
  sl.registerSingleton<StudentsFirebaseService>(
    StudentsFirebaseServiceImpl(),
  );
  sl.registerSingleton<TeacherFirebaseService>(
    TeacherFirebaseServiceImpl(),
  );
  sl.registerSingleton<EkskulFirebaseService>(
    EkskulFirebaseServiceImpl(),
  );
  sl.registerSingleton<ScheduleFirebaseService>(
    ScheduleFirebaseServiceImpl(),
  );
  sl.registerSingleton<AttandanceFirebaseService>(
    AttandanceFirebaseServiceImpl(),
  );

  //repository
  sl.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(),
  );
  sl.registerSingleton<NewsRepository>(
    NewsRepositoryImpl(),
  );
  sl.registerSingleton<StudentRepository>(
    StudentsRepositoryImpl(),
  );
  sl.registerSingleton<TeacherRepository>(
    TeacherRepositoryImpl(),
  );
  sl.registerSingleton<EkskulRepository>(
    EkskulRepositoryImpl(),
  );
  sl.registerSingleton<ScheduleRepository>(
    ScheduleRepositoryImpl(),
  );
  sl.registerSingleton<AttandanceRepository>(
    AttandanceRepositoryImpl(),
  );

  //usecase

  //auth
  sl.registerSingleton<SignInUsecase>(
    SignInUsecase(),
  );
  sl.registerSingleton<GetUserUsecase>(
    GetUserUsecase(),
  );
  sl.registerSingleton<IsAdminUsecase>(
    IsAdminUsecase(),
  );
  sl.registerSingleton<CheckEmailUsecase>(
    CheckEmailUsecase(),
  );
  sl.registerSingleton<IsRegisterUsecase>(
    IsRegisterUsecase(),
  );
  sl.registerSingleton<SignUpUseCase>(
    SignUpUseCase(),
  );
  sl.registerSingleton<IsLoggedInUsecase>(
    IsLoggedInUsecase(),
  );
  sl.registerSingleton<ForgotPasswordUsecase>(
    ForgotPasswordUsecase(),
  );
  sl.registerSingleton<CheckTeacherUsecase>(
    CheckTeacherUsecase(),
  );

  //teacher
  sl.registerSingleton<CreateTeacherUseCase>(
    CreateTeacherUseCase(),
  );

  sl.registerSingleton<GetKepalaSekolah>(
    GetKepalaSekolah(),
  );
  sl.registerSingleton<GetWaka>(
    GetWaka(),
  );
  sl.registerSingleton<GetHonor>(
    GetHonor(),
  );
  sl.registerSingleton<GetTeacher>(
    GetTeacher(),
  );
  sl.registerSingleton<UpdateTeacherUsecase>(
    UpdateTeacherUsecase(),
  );
  sl.registerSingleton<DeleteTeacherUsecase>(
    DeleteTeacherUsecase(),
  );
  sl.registerSingleton<GetTeacherByNameUsecase>(
    GetTeacherByNameUsecase(),
  );
  sl.registerSingleton<CreateRolesUsecase>(
    CreateRolesUsecase(),
  );
  sl.registerSingleton<DeleteRoleUsecase>(
    DeleteRoleUsecase(),
  );
  sl.registerSingleton<GetRolesUsecase>(
    GetRolesUsecase(),
  );
  sl.registerSingleton<GetScheduleTeacherUsecase>(
    GetScheduleTeacherUsecase(),
  );

  //news
  sl.registerSingleton<CreateNewsUseCase>(
    CreateNewsUseCase(),
  );
  sl.registerSingleton<GetNewsUseCase>(
    GetNewsUseCase(),
  );
  sl.registerSingleton<DeleteNewsUsecase>(
    DeleteNewsUsecase(),
  );
  sl.registerSingleton<UpdateNewsUsecase>(
    UpdateNewsUsecase(),
  );

  //students
  sl.registerSingleton<GetStudentsWithKelas>(
    GetStudentsWithKelas(),
  );
  sl.registerSingleton<GetStudentsRegisterUsecase>(
    GetStudentsRegisterUsecase(),
  );
  sl.registerSingleton<UpdateStudentUsecase>(
    UpdateStudentUsecase(),
  );
  sl.registerSingleton<UpdateStudentRegisterUsecase>(
    UpdateStudentRegisterUsecase(),
  );
  sl.registerSingleton<UpdateAllStudentAccountUsecase>(
    UpdateAllStudentAccountUsecase(),
  );
  sl.registerSingleton<DeleteStudentUsecase>(
    DeleteStudentUsecase(),
  );
  sl.registerSingleton<SearchStudentByNisn>(
    SearchStudentByNisn(),
  );
  sl.registerSingleton<GetStudentByNameUsecase>(
    GetStudentByNameUsecase(),
  );

  sl.registerSingleton<GetAllKelasUsecase>(
    GetAllKelasUsecase(),
  );

  sl.registerSingleton<DeleteStudentByClassUsecase>(
    DeleteStudentByClassUsecase(),
  );

  sl.registerSingleton<DeleteAllStudentAccountUsecase>(
    DeleteAllStudentAccountUsecase(),
  );

  //ekskul
  sl.registerSingleton<CreateEkskulUseCase>(
    CreateEkskulUseCase(),
  );
  sl.registerSingleton<GetEkskulUsecase>(
    GetEkskulUsecase(),
  );
  sl.registerSingleton<UpdateEkskulUsecase>(
    UpdateEkskulUsecase(),
  );
  sl.registerSingleton<DeleteEkskulUsecase>(
    DeleteEkskulUsecase(),
  );
  sl.registerSingleton<AddAnggotaUsecase>(
    AddAnggotaUsecase(),
  );
  sl.registerSingleton<UpdateAnggotaUsecase>(
    UpdateAnggotaUsecase(),
  );
  sl.registerSingleton<DeleteAnggotaUsecase>(
    DeleteAnggotaUsecase(),
  );

  //attendances
  sl.registerSingleton<AddStudentAttendanceUseCase>(
    AddStudentAttendanceUseCase(),
  );
  sl.registerSingleton<GetListAttendancesUseCase>(
    GetListAttendancesUseCase(),
  );
  sl.registerSingleton<GetAttendanceStudentsUsecase>(
    GetAttendanceStudentsUsecase(),
  );
  sl.registerSingleton<GetAttendanceStudentUsecase>(
    GetAttendanceStudentUsecase(),
  );
  sl.registerSingleton<GetAttendanceNameUsecase>(
    GetAttendanceNameUsecase(),
  );
  sl.registerSingleton<DeleteAttendancesUsecase>(
    DeleteAttendancesUsecase(),
  );
  sl.registerSingleton<DeleteMonthAttendancesUsecase>(
    DeleteMonthAttendancesUsecase(),
  );
  sl.registerSingleton<AddTeacherAttendanceUseCase>(
    AddTeacherAttendanceUseCase(),
  );
  sl.registerSingleton<GetAttendanceTeacherUsecase>(
    GetAttendanceTeacherUsecase(),
  );
  sl.registerSingleton<GetAttendanceAllTeacherUsecase>(
    GetAttendanceAllTeacherUsecase(),
  );

  //schedule
  sl.registerSingleton<GetJadwalUsecase>(
    GetJadwalUsecase(),
  );
  sl.registerSingleton<GetAllJadwalUsecase>(
    GetAllJadwalUsecase(),
  );
  sl.registerSingleton<CreateClassUsecase>(
    CreateClassUsecase(),
  );
  sl.registerSingleton<CreateActivityUsecase>(
    CreateActivityUsecase(),
  );
  sl.registerSingleton<CreateScheduleUsecase>(
    CreateScheduleUsecase(),
  );
  sl.registerSingleton<GetActivitiesUsecase>(
    GetActivitiesUsecase(),
  );
  sl.registerSingleton<UpdateScheduleUsecase>(
    UpdateScheduleUsecase(),
  );
  sl.registerSingleton<DeleteJadwalUsecase>(
    DeleteJadwalUsecase(),
  );
  sl.registerSingleton<DeleteKelasUsecase>(
    DeleteKelasUsecase(),
  );
  sl.registerSingleton<DeleteActivityUsecase>(
    DeleteActivityUsecase(),
  );
}
