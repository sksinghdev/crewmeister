part of 'absence_cubit.dart';

abstract class AbsenceState extends Equatable {
  const AbsenceState();

  @override
  List<Object?> get props => [];
}

class AbsenceInitial extends AbsenceState {}

class AbsenceLoading extends AbsenceState {
  final List<Absence> absences;
  final bool isFirstFetch;

  const AbsenceLoading({required this.absences, required this.isFirstFetch});

  @override
  List<Object?> get props => [absences, isFirstFetch];
}

class AbsenceLoaded extends AbsenceState {
  final List<Absence> absences;
  final bool hasMore;

  const AbsenceLoaded({required this.absences, required this.hasMore});

  @override
  List<Object?> get props => [absences, hasMore];
}

class AbsenceEmpty extends AbsenceState {}

class AbsenceError extends AbsenceState {
  final String message;

  const AbsenceError(this.message);

  @override
  List<Object?> get props => [message];
}
