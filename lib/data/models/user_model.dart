import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class UserModel extends Equatable {
  const UserModel({
    required this.email,
    required this.id,
    required this.name,
    required this.photo,
  });

  final String email;
  final String id;
  final String name;
  final String photo;

  static const empty = UserModel(email: '', id: '', name: '', photo: '');

  @override
  List<Object> get props => [email, id, name, photo];
}
