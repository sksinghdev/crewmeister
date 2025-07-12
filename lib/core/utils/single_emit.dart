import 'package:bloc/bloc.dart';

extension BlocExtension<T> on BlocBase<T>{
  void emitSingleTop(T singlState){
    final currentState = state;
    emit(singlState);
    emit(currentState);
  }
}