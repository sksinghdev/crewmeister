import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import '../../core/di/injection_container.dart';
import '../cubit/absence_cubit.dart';
import '../widgets/absence_listview.dart';

@RoutePage()
class AbsenceListPage extends StatelessWidget {
  const AbsenceListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AbsenceCubit>()..loadAbsences(),
      child: AbsenceListView(),
    );
  }
}
