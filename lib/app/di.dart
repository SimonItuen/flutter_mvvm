import 'package:advanced_course_flutter/app/app_prefs.dart';
import 'package:advanced_course_flutter/data/data_source/local_data_source.dart';
import 'package:advanced_course_flutter/data/data_source/remote_data_source.dart';
import 'package:advanced_course_flutter/data/network/app_api.dart';
import 'package:advanced_course_flutter/data/network/dio_factory.dart';
import 'package:advanced_course_flutter/data/network/network_info.dart';
import 'package:advanced_course_flutter/data/repository/repository_impl.dart';
import 'package:advanced_course_flutter/domain/repository/repository.dart';
import 'package:advanced_course_flutter/domain/usecase/forgot_password_usecase.dart';
import 'package:advanced_course_flutter/domain/usecase/login_usecase.dart';
import 'package:advanced_course_flutter/domain/usecase/store_details_usecase.dart';
import 'package:advanced_course_flutter/presentation/forgot_password/forgot_password_viewmodel.dart';
import 'package:advanced_course_flutter/presentation/login/login_viewmodel.dart';
import 'package:advanced_course_flutter/presentation/register/register_viewmodel.dart';
import 'package:advanced_course_flutter/presentation/store_details/store_details_viewmodel.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/usecase/home_usecase.dart';
import '../domain/usecase/register_usecase.dart';
import '../presentation/main/home/home_viewmodel.dart';

final instance = GetIt.instance;

Future<void> initAppModule() async {
  final sharedPrefs = await SharedPreferences.getInstance();

  // shared prefs instance
  instance.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

  instance.registerLazySingleton<AppPreferences>(
      () => AppPreferences(instance())); //checks and matches automatically

  //network info
  instance.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(DataConnectionChecker()));

  //dio factory
  instance.registerLazySingleton<DioFactory>(
      () => DioFactory(instance())); //app Prefs as parameter

  //app service client
  final dio = await instance<DioFactory>().getDio();
  instance.registerLazySingleton<AppServiceClient>(() => AppServiceClient(dio));

  //remote data source
  instance.registerLazySingleton<RemoteDataSource>(() =>
      RemoteDataSourceImplementer(instance())); // appServiceClient as parameter

  // local data source
   instance.registerLazySingleton<LocalDataSource>(() =>
      LocalDataSourceImplementer()); // appServiceClient as parameter

  instance.registerLazySingleton<Repository>(() => RepositoryImpl(
      instance(), instance(), instance())); //remoteDataSource and networkInfo as Params
}

initLoginModule() {
  if (!GetIt.I.isRegistered<LoginUseCase>()) {
    instance.registerFactory<LoginUseCase>(
        () => LoginUseCase(instance())); //Repository
    instance.registerFactory<LoginViewModel>(
        () => LoginViewModel(instance())); //LoginUseCase as params
  }
}

initForgotPasswordModule() {
  if (!GetIt.I.isRegistered<ForgotPasswordUseCase>()) {
    instance.registerFactory<ForgotPasswordUseCase>(
        () => ForgotPasswordUseCase(instance())); //Repository
    instance.registerFactory<ForgotPasswordViewModel>(
        () => ForgotPasswordViewModel(instance())); //LoginUseCase as params
  }
}

initRegisterModule() {
  if (!GetIt.I.isRegistered<RegisterUseCase>()) {
    instance.registerFactory<RegisterUseCase>(
        () => RegisterUseCase(instance())); //Repository
    instance.registerFactory<RegisterViewModel>(
        () => RegisterViewModel(instance())); //RegisterUseCase as params
     instance.registerFactory<ImagePicker>(
        () => ImagePicker());
  }
}

initHomeModule() {
  if (!GetIt.I.isRegistered<HomeUseCase>()) {
    instance.registerFactory<HomeUseCase>(
        () => HomeUseCase(instance())); //Repository
    instance.registerFactory<HomeViewModel>(
        () => HomeViewModel(instance())); //LoginUseCase as params
  }
}

initStoreDetailsModule() {
  if (!GetIt.I.isRegistered<StoreDetailsUseCase>()) {
    instance.registerFactory<StoreDetailsUseCase>(
        () => StoreDetailsUseCase(instance())); //Repository
    instance.registerFactory<StoreDetailsViewModel>(
        () => StoreDetailsViewModel(instance())); //LoginUseCase as params
  }
}

resetAllModules(){
  instance.reset(dispose: false);
  initAppModule();
  initRegisterModule();
  initLoginModule();
  initHomeModule();
  initForgotPasswordModule();
  initStoreDetailsModule();
}
