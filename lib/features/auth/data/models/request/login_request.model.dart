import "package:dart_mappable/dart_mappable.dart";

part "login_request.model.mapper.dart";

@MappableClass()
class LoginRequest with LoginRequestMappable {
  const LoginRequest({required this.email, required this.password});

  final String email;
  final String password;

  static const fromMap = LoginRequestMapper.fromMap;
  static const fromJson = LoginRequestMapper.fromJson;
}
