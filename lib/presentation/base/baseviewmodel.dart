import 'dart:async';

import 'package:advanced_course_flutter/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:rxdart/rxdart.dart';

abstract class BaseViewModel extends BaseViewModelInput with BaseViewModelOutput{

  StreamController _inputStateSreamController = BehaviorSubject<FlowState>();

  @override
  void dispose() {
    _inputStateSreamController.close();
  }

  @override
  Sink get inputState => _inputStateSreamController.sink;

  @override
  Stream<FlowState> get outputState => _inputStateSreamController.stream.map((flowState)=> flowState);

  @override
  void start() {
    //view tells state renderer, please show the content of screen
    inputState.add(ContentState());
  }
//shared variables and functions that will be used through any view model
}

abstract class BaseViewModelInput{
  void start();//will ve called wile init of view model
  void dispose(); //will be used when view dies

Sink get inputState;
}
abstract class BaseViewModelOutput{
  Stream<FlowState> get outputState;
}