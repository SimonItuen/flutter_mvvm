import 'package:advanced_course_flutter/app/functions.dart';
import 'package:advanced_course_flutter/data/network/failure.dart';
import 'package:advanced_course_flutter/data/request/request.dart';
import 'package:advanced_course_flutter/domain/model/model.dart';
import 'package:advanced_course_flutter/domain/repository/repository.dart';
import 'package:advanced_course_flutter/domain/usecase/base_usecase.dart';
import 'package:dartz/dartz.dart';

class ForgotPasswordUseCase implements BaseUseCase<String, String>{
  Repository _repository;
  ForgotPasswordUseCase(this._repository);

  @override
  Future<Either<Failure, String>> execute(String input) async{
    return await _repository.forgotPassword(input);
  }

}