// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'login_response.model.dart';

class LoginResponseMapper extends ClassMapperBase<LoginResponse> {
  LoginResponseMapper._();

  static LoginResponseMapper? _instance;
  static LoginResponseMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = LoginResponseMapper._());
      UserDtoMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'LoginResponse';

  static String _$token(LoginResponse v) => v.token;
  static const Field<LoginResponse, String> _f$token = Field('token', _$token);
  static UserDto _$user(LoginResponse v) => v.user;
  static const Field<LoginResponse, UserDto> _f$user = Field('user', _$user);

  @override
  final MappableFields<LoginResponse> fields = const {
    #token: _f$token,
    #user: _f$user,
  };

  static LoginResponse _instantiate(DecodingData data) {
    return LoginResponse(token: data.dec(_f$token), user: data.dec(_f$user));
  }

  @override
  final Function instantiate = _instantiate;

  static LoginResponse fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<LoginResponse>(map);
  }

  static LoginResponse fromJson(String json) {
    return ensureInitialized().decodeJson<LoginResponse>(json);
  }
}

mixin LoginResponseMappable {
  String toJson() {
    return LoginResponseMapper.ensureInitialized()
        .encodeJson<LoginResponse>(this as LoginResponse);
  }

  Map<String, dynamic> toMap() {
    return LoginResponseMapper.ensureInitialized()
        .encodeMap<LoginResponse>(this as LoginResponse);
  }

  LoginResponseCopyWith<LoginResponse, LoginResponse, LoginResponse>
      get copyWith => _LoginResponseCopyWithImpl(
          this as LoginResponse, $identity, $identity);
  @override
  String toString() {
    return LoginResponseMapper.ensureInitialized()
        .stringifyValue(this as LoginResponse);
  }

  @override
  bool operator ==(Object other) {
    return LoginResponseMapper.ensureInitialized()
        .equalsValue(this as LoginResponse, other);
  }

  @override
  int get hashCode {
    return LoginResponseMapper.ensureInitialized()
        .hashValue(this as LoginResponse);
  }
}

extension LoginResponseValueCopy<$R, $Out>
    on ObjectCopyWith<$R, LoginResponse, $Out> {
  LoginResponseCopyWith<$R, LoginResponse, $Out> get $asLoginResponse =>
      $base.as((v, t, t2) => _LoginResponseCopyWithImpl(v, t, t2));
}

abstract class LoginResponseCopyWith<$R, $In extends LoginResponse, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  UserDtoCopyWith<$R, UserDto, UserDto> get user;
  $R call({String? token, UserDto? user});
  LoginResponseCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _LoginResponseCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, LoginResponse, $Out>
    implements LoginResponseCopyWith<$R, LoginResponse, $Out> {
  _LoginResponseCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<LoginResponse> $mapper =
      LoginResponseMapper.ensureInitialized();
  @override
  UserDtoCopyWith<$R, UserDto, UserDto> get user =>
      $value.user.copyWith.$chain((v) => call(user: v));
  @override
  $R call({String? token, UserDto? user}) => $apply(FieldCopyWithData(
      {if (token != null) #token: token, if (user != null) #user: user}));
  @override
  LoginResponse $make(CopyWithData data) => LoginResponse(
      token: data.get(#token, or: $value.token),
      user: data.get(#user, or: $value.user));

  @override
  LoginResponseCopyWith<$R2, LoginResponse, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _LoginResponseCopyWithImpl($value, $cast, t);
}

class UserDtoMapper extends ClassMapperBase<UserDto> {
  UserDtoMapper._();

  static UserDtoMapper? _instance;
  static UserDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UserDtoMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'UserDto';

  static String _$id(UserDto v) => v.id;
  static const Field<UserDto, String> _f$id = Field('id', _$id);
  static String _$email(UserDto v) => v.email;
  static const Field<UserDto, String> _f$email = Field('email', _$email);
  static String _$name(UserDto v) => v.name;
  static const Field<UserDto, String> _f$name = Field('name', _$name);

  @override
  final MappableFields<UserDto> fields = const {
    #id: _f$id,
    #email: _f$email,
    #name: _f$name,
  };

  static UserDto _instantiate(DecodingData data) {
    return UserDto(
        id: data.dec(_f$id),
        email: data.dec(_f$email),
        name: data.dec(_f$name));
  }

  @override
  final Function instantiate = _instantiate;

  static UserDto fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UserDto>(map);
  }

  static UserDto fromJson(String json) {
    return ensureInitialized().decodeJson<UserDto>(json);
  }
}

mixin UserDtoMappable {
  String toJson() {
    return UserDtoMapper.ensureInitialized()
        .encodeJson<UserDto>(this as UserDto);
  }

  Map<String, dynamic> toMap() {
    return UserDtoMapper.ensureInitialized()
        .encodeMap<UserDto>(this as UserDto);
  }

  UserDtoCopyWith<UserDto, UserDto, UserDto> get copyWith =>
      _UserDtoCopyWithImpl(this as UserDto, $identity, $identity);
  @override
  String toString() {
    return UserDtoMapper.ensureInitialized().stringifyValue(this as UserDto);
  }

  @override
  bool operator ==(Object other) {
    return UserDtoMapper.ensureInitialized()
        .equalsValue(this as UserDto, other);
  }

  @override
  int get hashCode {
    return UserDtoMapper.ensureInitialized().hashValue(this as UserDto);
  }
}

extension UserDtoValueCopy<$R, $Out> on ObjectCopyWith<$R, UserDto, $Out> {
  UserDtoCopyWith<$R, UserDto, $Out> get $asUserDto =>
      $base.as((v, t, t2) => _UserDtoCopyWithImpl(v, t, t2));
}

abstract class UserDtoCopyWith<$R, $In extends UserDto, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? id, String? email, String? name});
  UserDtoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _UserDtoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UserDto, $Out>
    implements UserDtoCopyWith<$R, UserDto, $Out> {
  _UserDtoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UserDto> $mapper =
      UserDtoMapper.ensureInitialized();
  @override
  $R call({String? id, String? email, String? name}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (email != null) #email: email,
        if (name != null) #name: name
      }));
  @override
  UserDto $make(CopyWithData data) => UserDto(
      id: data.get(#id, or: $value.id),
      email: data.get(#email, or: $value.email),
      name: data.get(#name, or: $value.name));

  @override
  UserDtoCopyWith<$R2, UserDto, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _UserDtoCopyWithImpl($value, $cast, t);
}
