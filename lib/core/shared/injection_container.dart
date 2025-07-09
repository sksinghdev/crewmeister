import 'package:get_it/get_it.dart';
import '../../data/repositories/absence_repository_impl.dart';
 import '../../domain/repositories/absence_repository.dart';
import '../../presentation/cubit/absence_cubit.dart';
 
final sl = GetIt.instance;

Future<void> init() async {
  // Cubit
  sl.registerFactory(() => AbsenceCubit(sl()));

  // Repository
  sl.registerLazySingleton<AbsenceRepository>(() => AbsenceRepositoryImpl());


}
