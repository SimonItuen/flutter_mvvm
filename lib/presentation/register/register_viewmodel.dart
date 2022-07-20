import 'dart:async';
import 'dart:io';

import 'package:advanced_course_flutter/app/functions.dart';
import 'package:advanced_course_flutter/domain/usecase/register_usecase.dart';
import 'package:advanced_course_flutter/presentation/base/baseviewmodel.dart';
import 'package:advanced_course_flutter/presentation/common/freezed_data_classes.dart';
import 'package:advanced_course_flutter/presentation/common/state_renderer/state_renderer_impl.dart';

import '../common/state_renderer/state_renderer.dart';

class RegisterViewModel extends BaseViewModel
    with RegisterViewModelInput, RegisterViewModelOutput {
  StreamController _userNameStreamController =
  StreamController<String>.broadcast();
  StreamController _mobileNumberStreamController =
  StreamController<String>.broadcast();
  StreamController _emailStreamController =
  StreamController<String>.broadcast();
  StreamController _passwordStreamController =
  StreamController<String>.broadcast();
  StreamController _profilePictureStreamController =
  StreamController<File>.broadcast();
  StreamController _isAllInputsValidStreamController =
  StreamController<void>.broadcast();
  StreamController isUserLoggedInSuccessfullyStreamController = StreamController<bool>();
  RegisterUseCase _registerUseCase;

  var registerViewObject = RegisterObject("", "", "", "", "", "");

  RegisterViewModel(this._registerUseCase);


  // --inputs
  @override
  void start() {
    inputState.add(ContentState());
  }

  @override
  register() async{
    inputState.add(
        LoadingState(stateRendererType: StateRendererType.POPUP_LOADING_STATE));
    (await _registerUseCase.execute(
        RegisterUseCaseInput(registerViewObject.countryMobileCode,registerViewObject.userName,registerViewObject.email,registerViewObject.password,registerViewObject.mobileNumber,registerViewObject.profilePicture)))
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

        });
  }
  @override
  void dispose() {
    _isAllInputsValidStreamController.close();
    _userNameStreamController.close();
    _mobileNumberStreamController.close();
    _emailStreamController.close();
    _passwordStreamController.close();
    _profilePictureStreamController.close();
    isUserLoggedInSuccessfullyStreamController.close();
    super.dispose();
  }

  @override
  setCountryCode(String countryCode) {
    if (countryCode.isNotEmpty) {
      // update register view object with username valid
      registerViewObject = registerViewObject.copyWith(
          countryMobileCode: countryCode); // using data class like kotlin
    } else {
      // reset username value in register view object
      registerViewObject = registerViewObject.copyWith(
          countryMobileCode: ""); // using data class like kotlin
    }
    _validate();
  }

  @override
  setEmail(String email) {
    inputEmail.add(email);
    if (isEmailValid(email)) {
      // update register view object with email valid
      registerViewObject = registerViewObject.copyWith(
          email: email); // using data class like kotlin
    } else {
      // reset email value in register view object
      registerViewObject = registerViewObject.copyWith(
          email: ""); // using data class like kotlin
    }
    _validate();
  }

  @override
  setMobileNumber(String mobileNumber) {
    inputMobileNumber.add(mobileNumber);
    if (_isMobileNumberValid(mobileNumber)) {
      // update register view object with mobile number valid
      registerViewObject = registerViewObject.copyWith(
          mobileNumber: mobileNumber); // using data class like kotlin
    } else {
      // reset mobile number value in register view object
      registerViewObject = registerViewObject.copyWith(
          mobileNumber: ""); // using data class like kotlin
    }
    _validate();
  }

  @override
  setPassword(String password) {
    inputPassword.add(password);
    if (_isPasswordValid(password)) {
      // update register view object with password valid
      registerViewObject = registerViewObject.copyWith(
          password: password); // using data class like kotlin
    } else {
      // reset password value in register view object
      registerViewObject = registerViewObject.copyWith(
          password: ""); // using data class like kotlin
    }
    _validate();
  }

  @override
  setProfilePicture(File file) {
    inputProfilePicture.add(file);
    if (file.path.isNotEmpty) {
      // update register view object with username valid
      registerViewObject = registerViewObject.copyWith(
          profilePicture: file.path); // using data class like kotlin
    } else {
      // reset username value in register view object
      registerViewObject = registerViewObject.copyWith(
          profilePicture: ""); // using data class like kotlin
    }
    _validate();
  }

  @override
  setUserName(String userName) {
    inputUserName.add(userName);
    if (_isUserNameValid(userName)) {
      // update register view object with username valid
      registerViewObject = registerViewObject.copyWith(
          userName: userName); // using data class like kotlin
    } else {
      // reset username value in register view object
      registerViewObject = registerViewObject.copyWith(
          userName: ""); // using data class like kotlin
    }
    _validate();
  }



  @override
  // TODO: implement inputEmail
  Sink get inputEmail => _emailStreamController.sink;

  @override
  // TODO: implement inputMobileNumber
  Sink get inputMobileNumber => _mobileNumberStreamController.sink;

  @override
  // TODO: implement inputPassword
  Sink get inputPassword => _passwordStreamController.sink;

  @override
  // TODO: implement inputProfilePicture
  Sink get inputProfilePicture => _profilePictureStreamController.sink;

  @override
  // TODO: implement inputUserName
  Sink get inputUserName => _userNameStreamController.sink;


  @override
  // TODO: implement inputAllInputsValid
  Sink get inputAllInputsValid => _isAllInputsValidStreamController.sink;

  // --outputs

  @override
  // TODO: implement outputIsUserNameValid
  Stream<bool> get outputIsUserNameValid =>
      _userNameStreamController.stream
          .map((userName) => _isUserNameValid(userName));

  @override
  // TODO: implement outputErrorUserName
  Stream<String?> get outputErrorUserName =>
      outputIsUserNameValid
          .map((isUserNameValid) =>
      isUserNameValid
          ? null
          : "Invalid username");

  @override
  // TODO: implement outputIsEmailValid
  Stream<bool> get outputIsEmailValid =>
      _emailStreamController.stream.map((email) => isEmailValid(email));

  @override
  // TODO: implement outputErrorEmail
  Stream<String?> get outputErrorEmail =>
      outputIsEmailValid
          .map((isEmailValid) => isEmailValid ? null : "Invalid Email");

  @override
  // TODO: implement outputIsMobileNumberValid
  Stream<bool> get outputIsMobileNumberValid =>
      _mobileNumberStreamController.stream
          .map((mobileNumber) => _isMobileNumberValid(mobileNumber));

  @override
  // TODO: implement outputErrorMobileNumber
  Stream<String?> get outputErrorMobileNumber =>
      outputIsMobileNumberValid.map((isMobileNumberValid) =>
      isMobileNumberValid ? null : "Invalid Mobile Number");

  @override
  // TODO: implement outputIsPasswordValid
  Stream<bool> get outputIsPasswordValid =>
      _passwordStreamController.stream
          .map((password) => _isPasswordValid(password));

  @override
  // TODO: implement outputErrorPassword
  Stream<String?> get outputErrorPassword =>
      outputIsPasswordValid
          .map((isPasswordValid) =>
      isPasswordValid
          ? null
          : "Invalid Password");

  @override
  // TODO: implement outputIsProfilePictureInvalid
  Stream<File?> get outputProfilePicture =>
      _profilePictureStreamController.stream.map((file) => file);

  @override
  // TODO: implement outputIsAllInputsValid
  Stream<bool> get outputIsAllInputsValid =>
      _isAllInputsValidStreamController.stream.map((_) => _validateAllInputs());



  // -- private methods
  bool _isUserNameValid(String userName) {
    return userName.length >= 8;
  }

  bool _isMobileNumberValid(String mobileNumber) {
    return mobileNumber.length >= 8;
  }

  bool _isPasswordValid(String password) {
    return password.length >= 8;
  }

  bool _validateAllInputs() {
    return registerViewObject.profilePicture.isNotEmpty &&
        registerViewObject.email.isNotEmpty &&
        registerViewObject.password.isNotEmpty &&
        registerViewObject.mobileNumber.isNotEmpty &&
        registerViewObject.userName.isNotEmpty &&
        registerViewObject.countryMobileCode.isNotEmpty;
  }
  _validate(){
    inputAllInputsValid.add(null);
  }


}

abstract class RegisterViewModelInput {
  register();

  setUserName(String userName);

  setMobileNumber(String mobileNumber);

  setCountryCode(String countryCode);

  setEmail(String email);

  setPassword(String password);

  setProfilePicture(File file);

  Sink get inputUserName;

  Sink get inputMobileNumber;

  Sink get inputEmail;

  Sink get inputPassword;

  Sink get inputProfilePicture;

  Sink get inputAllInputsValid;
}

abstract class RegisterViewModelOutput {
  Stream<bool> get outputIsUserNameValid;

  Stream<String?> get outputErrorUserName;

  Stream<bool> get outputIsMobileNumberValid;

  Stream<String?> get outputErrorMobileNumber;

  Stream<bool> get outputIsEmailValid;

  Stream<String?> get outputErrorEmail;

  Stream<bool> get outputIsPasswordValid;

  Stream<String?> get outputErrorPassword;

  Stream<File?> get outputProfilePicture;

  Stream<bool> get outputIsAllInputsValid;
}
