import 'package:get_it/get_it.dart';
import '../../data/repositories/absence_repository_impl.dart';
import '../../domain/repositories/absence_repository.dart';
import '../../domain/usecases/filter_absences.dart';
import '../../domain/usecases/generate_and_share_ical.dart';
import '../../domain/usecases/get_absence_count.dart';
import '../../domain/usecases/get_absences.dart';
import '../../presentation/cubit/absence_cubit.dart';
import '../shared/ical/ical_generator.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton<AbsenceRepository>(
      () => AbsenceRepositoryImpl(sl()));

  sl.registerLazySingleton(() => GetAbsencesUseCase(sl()));
  sl.registerLazySingleton(() => GetAbsenceCountUseCase(sl()));
  sl.registerLazySingleton(() => FilterAbsencesUseCase(sl()));
  sl.registerFactory(() => AbsenceCubit(
        getAbsencesUseCase: sl(),
        getAbsenceCountUseCase: sl(),
        filterAbsencesUseCase: sl(),
        generateICalUseCase: sl(),
      ));

  sl.registerLazySingleton(() => GenerateAndShareICal(sl()));
  sl.registerLazySingleton<ICalGenerator>(() => ICalGenerator());
}
  