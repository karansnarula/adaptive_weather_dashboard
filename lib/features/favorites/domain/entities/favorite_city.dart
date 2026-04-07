import 'package:equatable/equatable.dart';

class FavoriteCity extends Equatable {
  final String name;

  const FavoriteCity({required this.name});

  @override
  List<Object> get props => [name];
}