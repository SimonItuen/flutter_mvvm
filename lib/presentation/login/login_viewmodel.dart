import 'dart:async';

import 'package:advanced_course_flutter/data/data_source/remote_data_source.dart';
import 'package:advanced_course_flutter/data/repository/repository_impl.dart';
import 'package:advanced_course_flutter/domain/repository/repository.dart';
import 'package:advanced_course_flutter/domain/usecase/login_usecase.dart';
import 'package:advanced_course_flutter/presentation/base/baseviewmodel.dart';
import 'package:advanced_course_flutter/presentation/common/freezed_data_classes.dart';
import 'package:advanced_course_flutter/presentation/common/state_renderer/state_renderer.dart';
import 'package:advanced_course_flutter/presentation/common/state_renderer/state_renderer_impl.dart';

class LoginViewModel extends BaseViewModel
    with LoginViewModelInputs, LoginViewModelOutputs {
  StreamController _usernameStreamController = StreamController<
      String>.broadcast(); //many subscribers can listen to it due to th broadcast method
  StreamController _passwordStreamController = StreamController<
      String>.broadcast(); //many subscribers can listen to it due to th broadcast method

  StreamController _isAllInputsValidStreamController = StreamController<
      void>.broadcast(); //many subscribers can listen to it due to th broadcast method

  StreamController isUserLoggedInSuccessfullyStreamController = StreamController<String>();
  var loginObject = LoginObject("", "");

  LoginUseCase _loginUseCase;

  LoginViewModel(this._loginUseCase);

  @override
  void dispose() {
    _usernameStreamController.close();
    _passwordStreamController.close();
    _isAllInputsValidStreamController.close();
    isUserLoggedInSuccessfullyStreamController.close();
  }

  @override
  void start() {
    // TODO: implement start
  }

  @override
  // TODO: implement inputPassword
  Sink get inputPassword => _passwordStreamController.sink;

  @override
  // TODO: implement inputUserName
  Sink get inputUserName => _usernameStreamController.sink;

  @override
  // TODO: implement inputIsAllInputValid
  Sink get inputIsAllInputValid => _isAllInputsValidStreamController.sink;

  @override
  login() async {
    inputState.add(
        LoadingState(stateRendererType: StateRendererType.POPUP_LOADING_STATE));
    (await _loginUseCase.execute(
            LoginUseCaseInput(loginObject.username, loginObject.password)))
        .fold(
            (failure) => {
                  //left -> failure
                  /*print(failure.message)*/
                  inputState.add(ErrorState(
                      StateRendererType.POPUP_ERROR_STATE, failure.message))
                },
            (data)  {
                  //right -> success
                  /*print(data.customer?.name)*/
                  inputState.add(ContentState());

                  //navigate to main screen after the login
              isUserLoggedInSuccessfullyStreamController.add("ABCDEFGH");
                });
  }

  @override
  // TODO: implement outputIsPasswordValid
  Stream<bool> get outputIsPasswordValid => _passwordStreamController.stream
      .map((password) => _isPasswordValid(password));

  @override
  // TODO: implement outputIsUsernameValid
  Stream<bool> get outputIsUsernameValid => _usernameStreamController.stream
      .map((username) => _isUsernameValid(username));

  @override
  // TODO: implement outputIsAllInputsValid
  Stream<bool> get outputIsAllInputsValid =>
      _isAllInputsValidStreamController.stream.map((_) => _isAllInputsValid());

  // private functions
  _validate() {
    inputIsAllInputValid.add(null);
  }

  bool _isPasswordValid(String password) {
    return password.isNotEmpty;
  }

  bool _isUsernameValid(String username) {
    return username.isNotEmpty;
  }

  bool _isAllInputsValid() {
    return _isPasswordValid(loginObject.password) &&
        _isUsernameValid(loginObject.username);
  }

  @override
  setPassword(String password) {
    inputPassword.add(password);
    loginObject = loginObject.copyWith(
        password: password); //data class operation same as kotlin
    _validate();
  }

  @override
  setUserName(String username) {
    // TODO: implement setUserName
    inputUserName.add(username);
    loginObject = loginObject.copyWith(
        username: username); //data class operation same as kotlin
    _validate();
  }
}

abstract class LoginViewModelInputs {
  //three functions
  setUserName(String username);

  setPassword(String password);

  login();

  //.. two sinks
  Sink get inputUserName;

  Sink get inputPassword;

  Sink get inputIsAllInputValid;
}

abstract class LoginViewModelOutputs {
  Stream<bool> get outputIsUsernameValid;

  Stream<bool> get outputIsPasswordValid;

  Stream<bool> get outputIsAllInputsValid;
}
