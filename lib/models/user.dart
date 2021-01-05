import 'package:equatable/equatable.dart';

class User extends Equatable {
  final id;
  final name;
  final fullName;
  final password;
  final gender;
  final birthday;
  final dateCreate;
  final avatar;
  final review;
  final point;
  final admin;

  User(
      {this.id,
      this.name,
      this.fullName,
      this.password,
      this.gender,
      this.birthday,
      this.dateCreate,
      this.avatar,
      this.review,
      this.point,
      this.admin});

  @override
  // TODO: implement props
  List<Object> get props => [];
}