import "package:dart_mappable/dart_mappable.dart";

part "login_response.model.mapper.dart";

@MappableClass()
class LoginResponse with LoginResponseMappable {
  const LoginResponse({required this.token, required this.user});

  final String token;
  final UserDto user;

  static const fromMap = LoginResponseMapper.fromMap;
  static const fromJson = LoginResponseMapper.fromJson;
}

@MappableClass()
class UserDto with UserDtoMappable {
  const UserDto({required this.id, required this.email, required this.name});

  final String id;
  final String email;
  final String name;

  static const fromMap = UserDtoMapper.fromMap;
  static const fromJson = UserDtoMapper.fromJson;
}
