import 'package:advanced_course_flutter/app/di.dart';
import 'package:advanced_course_flutter/presentation/forgot_password/forgot_password_viewmodel.dart';
import 'package:advanced_course_flutter/presentation/resources/assets_manager.dart';
import 'package:advanced_course_flutter/presentation/resources/strings_manager.dart';
import 'package:advanced_course_flutter/presentation/resources/values_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../common/state_renderer/state_renderer_impl.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final ForgotPasswordViewModel _viewModel = instance<ForgotPasswordViewModel>();
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  _bind (){
    _viewModel.start();
    _emailController.addListener(() {
      _viewModel.setEmail(_emailController.text);
    });
  }

  @override
  void initState() {
    _bind();
    super.initState();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<FlowState>(
        stream: _viewModel.outputState,
        builder: (context, snapshot) {
          return snapshot.data?.getScreenWidget(context, _getContentWidget(),
                  () {
                _viewModel.forgotPassword();
              }) ??
              _getContentWidget();
        },
      ),
    );
  }

  Widget _getContentWidget() {
    return Container(
      padding: EdgeInsets.only(top: AppPadding.p100),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Image(image: AssetImage(ImageAssets.splashLogo)),
              SizedBox(
                height: AppSize.s28,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: AppPadding.p28,
                  right: AppPadding.p28,
                ),
                child: StreamBuilder<bool>(
                  stream: _viewModel.outputIsEmailValid,
                  builder: (context, snapshot) {
                    return TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      decoration: InputDecoration(
                          hintText: AppStrings.emailHint.tr(),
                          labelText: AppStrings.emailHint.tr(),
                          errorText: (snapshot.data ?? true)
                              ? null
                              : AppStrings.invalidEmail.tr()),
                    );
                  },
                ),
              ),
              SizedBox(
                height: AppSize.s28,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: AppPadding.p28,
                  right: AppPadding.p28,
                ),
                child: StreamBuilder<bool>(
                  stream: _viewModel.outputIsAllInputValid,
                  builder: (context, snapshot) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: (snapshot.data ?? false)
                              ? () {
                            _viewModel.forgotPassword();
                          }
                              : null,
                          child: Text(AppStrings.login).tr()),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: AppPadding.p28,
                    top: AppPadding.p8,
                    right: AppPadding.p28),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () {
                          /*Navigator.pushReplacementNamed(
                              context, Routes);*/
                        },
                        child: Text(
                          AppStrings.resetPassword,
                          textAlign: TextAlign.end,
                          style: Theme.of(context).textTheme.subtitle2,
                        ).tr()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
