import 'package:equatable/equatable.dart';

class Member extends Equatable {
  final int userId;
  final String name;
  final String image;

  const Member({
    required this.userId,
    required this.name,
    required this.image,
  });

  @override
  List<Object?> get props => [userId, name, image];
}
