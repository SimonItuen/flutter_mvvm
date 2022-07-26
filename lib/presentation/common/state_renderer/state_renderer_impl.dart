import 'package:advanced_course_flutter/data/mapper/mapper.dart';
import 'package:advanced_course_flutter/presentation/common/state_renderer/state_renderer.dart';
import 'package:advanced_course_flutter/presentation/resources/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

abstract class FlowState {
  StateRendererType getStateRendererType();

  String getMessage();
}

// Loading state (POPUP, FULL SCREEN)

class LoadingState extends FlowState {
  StateRendererType stateRendererType;
  String message;

  LoadingState({required this.stateRendererType, String? message})
      : message = message ?? AppStrings.loading.tr();

  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() => stateRendererType;
}

// error state (POPUP, FULL LOADING)
class ErrorState extends FlowState {
  StateRendererType stateRendererType;
  String message;

  ErrorState(this.stateRendererType, this.message);

  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() => stateRendererType;
}

// CONTENT STATE
class ContentState extends FlowState {
  ContentState();

  @override
  String getMessage() => empty;

  @override
  StateRendererType getStateRendererType() =>
      StateRendererType.CONTENT_SCREEN_STATE;
}

// EMPTY STATE
class EmptyState extends FlowState {
  String message;

  EmptyState(this.message);

  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() =>
      StateRendererType.EMPTY_SCREEN_STATE;
}

class SuccessState extends FlowState {
  String message;

  SuccessState(this.message);

  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() =>
      StateRendererType.POPUP_SUCCESS;
}

extension FlowStateExtension on FlowState {
  Widget getScreenWidget(BuildContext context, Widget contentScreenWidget,
      Function retryActionFunction) {
    switch (this.runtimeType) {
      case LoadingState:
        {
          if (getStateRendererType() == StateRendererType.POPUP_LOADING_STATE) {
            //showing popup dialog
            showPopUp(context, getStateRendererType(), getMessage());

            return contentScreenWidget;

            //return the content ui of the screen

          } else //StateRendererType.FULL_SCREEN_LOADING_STATE
          {
            return StateRenderer(
                stateRendererType: getStateRendererType(),
                message: getMessage(),
                retryActionFunction: retryActionFunction);
          }
        }
      case ErrorState:
        dismissDialog(context);
        if (getStateRendererType() == StateRendererType.POPUP_ERROR_STATE) {
          //showing popup dialog
          showPopUp(context, getStateRendererType(), getMessage());

          return contentScreenWidget;

          //return the content ui of the screen

        } else //StateRendererType.FULL_SCREEN_ERROR_STATE
            {
          return StateRenderer(
              stateRendererType: getStateRendererType(),
              message: getMessage(),
              retryActionFunction: retryActionFunction);
        }
      case ContentState:
        {
          dismissDialog(context);
          return contentScreenWidget;
        }
      case EmptyState:
        {
          return StateRenderer(
              stateRendererType: getStateRendererType(),
              message: getMessage(),
              retryActionFunction: retryActionFunction);
        }
        case SuccessState:

          dismissDialog(context);
            //showing popup dialog
            showPopUp(context, getStateRendererType(), getMessage(),
            title: AppStrings.success.tr());

            return contentScreenWidget;

            //return the content ui of the screen

      default:
        {
          return contentScreenWidget;
        }
    }
  }

  dismissDialog(BuildContext context){
      if(_isThereCurrentDialogShowing(context)){
        Navigator.of(context, rootNavigator: true).pop(true);
      }
  }

  _isThereCurrentDialogShowing(BuildContext context) => ModalRoute.of(context)?.isCurrent !=true;

  showPopUp(BuildContext context, StateRendererType stateRendererType,
      String message, {String title = empty}) {
    WidgetsBinding.instance.addPostFrameCallback((_) => showDialog(
        context: context,
        builder: (BuildContext context) => StateRenderer(
              stateRendererType: stateRendererType,
              message: message,
              title: title,
              retryActionFunction: () {},
            )));
  }
}
