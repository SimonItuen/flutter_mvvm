import 'dart:async';

import 'package:advanced_course_flutter/domain/usecase/forgot_password_usecase.dart';
import 'package:advanced_course_flutter/presentation/base/baseviewmodel.dart';
import 'package:advanced_course_flutter/presentation/common/state_renderer/state_renderer.dart';
import 'package:advanced_course_flutter/presentation/common/state_renderer/state_renderer_impl.dart';

class ForgotPasswordViewModel extends BaseViewModel
    with ForgotPasswordViewModelInputs, ForgotPasswordViewModelOutputs {
  StreamController _emailStreamController =
      StreamController<String>.broadcast();
  StreamController _isAllInputValidStreamController =
      StreamController<void>.broadcast();

  final ForgotPasswordUseCase _forgotPasswordUseCase;

  ForgotPasswordViewModel(this._forgotPasswordUseCase);
  @override
  void dispose() {
    _emailStreamController.close();
    _isAllInputValidStreamController.close();
  }

  @override
  void start() {
    inputState.add(ContentState());
  }

  String email='';
  @override
  // TODO: implement emailIsValid
  Stream<bool> get outputIsEmailValid =>
      _emailStreamController.stream.map((email) => isEmailValid(email));

  Stream<bool> get outputIsAllInputValid =>
      _isAllInputValidStreamController.stream.map((isAllInputValid) => _isAllInputValid());

  _validate() {
    inputIsAllInputValid.add(null);
  }

  @override
  // TODO: implement inputEmail
  Sink get inputEmail => _emailStreamController.sink;

  @override
  // TODO: implement inputEmail
  Sink get inputIsAllInputValid => _isAllInputValidStreamController.sink;

  bool isEmailValid(String email) {
    return email.isNotEmpty;
  }

  bool _isAllInputValid(){
    return isEmailValid(email);
  }

  @override
  setEmail(String email) {
    // TODO: implement setEmail
    inputEmail.add(email);
    this.email = email;
    _validate();
  }

  @override
  forgotPassword() async{
    inputState.add(LoadingState(stateRendererType: StateRendererType.POPUP_LOADING_STATE));
    (await _forgotPasswordUseCase.execute(email)).fold((failure){
      inputState.add(ErrorState(StateRendererType.POPUP_ERROR_STATE, failure.message));
    }, (supportMessage) {
      inputState.add(SuccessState(supportMessage));
    });
  }
}

abstract class ForgotPasswordViewModelInputs {
  setEmail(String email);

  forgotPassword();

  Sink get inputEmail;
  Sink get inputIsAllInputValid;
}

abstract class ForgotPasswordViewModelOutputs {
  Stream<bool> get outputIsEmailValid;
  Stream<bool> get outputIsAllInputValid;
}
