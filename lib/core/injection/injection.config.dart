// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:talker/talker.dart' as _i993;
import 'package:wink_dupe/core/injection/module.dart' as _i998;
import 'package:wink_dupe/core/routing/router.dart' as _i886;
import 'package:wink_dupe/core/storage/storage.service.dart' as _i857;
import 'package:wink_dupe/features/auth/data/datasources/auth_remote.datasource.dart'
    as _i495;
import 'package:wink_dupe/features/auth/data/repositories/auth.implementation.dart'
    as _i571;
import 'package:wink_dupe/features/auth/domain/repositories/auth.repository.dart'
    as _i800;
import 'package:wink_dupe/features/auth/domain/usecases/login.usecase.dart'
    as _i773;
import 'package:wink_dupe/features/auth/presentation/state/login.state.dart'
    as _i282;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.sharedPreferences,
      preResolve: true,
    );
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i886.AppRouter>(() => registerModule.router);
    gh.lazySingleton<_i993.Talker>(() => registerModule.logger);
    gh.lazySingleton<_i857.StorageService>(
        () => _i857.StorageService(gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i495.AuthRemoteDataSource>(
        () => _i495.AuthRemoteDataSourceImpl(gh<_i361.Dio>()));
    gh.lazySingleton<_i800.AuthRepository>(
        () => _i571.AuthRepositoryImpl(gh<_i495.AuthRemoteDataSource>()));
    gh.factory<_i773.LoginUseCase>(
        () => _i773.LoginUseCase(gh<_i800.AuthRepository>()));
    gh.factory<_i282.LoginState>(
        () => _i282.LoginState(gh<_i773.LoginUseCase>()));
    return this;
  }
}

class _$RegisterModule extends _i998.RegisterModule {}
