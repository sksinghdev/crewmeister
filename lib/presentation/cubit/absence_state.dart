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

  const AbsenceLoading({
    required this.absences,
    this.isFirstFetch = false,
  });

  @override
  List<Object?> get props => [absences, isFirstFetch];
}

class AbsenceLoaded extends AbsenceState {
  final List<Absence> absences;
  final bool hasMore;
  final int page;

  const AbsenceLoaded({
    required this.absences,
    required this.hasMore,
    required this.page,
  });

  @override
  List<Object?> get props => [absences, hasMore, page];
}

class AbsenceEmpty extends AbsenceState {}

class AbsenceError extends AbsenceState {
  final String message;

  const AbsenceError(this.message);

  @override
  List<Object?> get props => [message];
}

class AbsenceCountLoaded extends AbsenceState {
  final int count;

  const AbsenceCountLoaded(this.count);

  @override
  List<Object?> get props => [count];
}
