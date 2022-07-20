import 'dart:async';

import 'package:advanced_course_flutter/domain/model/model.dart';
import 'package:advanced_course_flutter/domain/usecase/store_details_usecase.dart';
import 'package:advanced_course_flutter/presentation/base/baseviewmodel.dart';
import 'package:advanced_course_flutter/presentation/common/state_renderer/state_renderer.dart';
import 'package:advanced_course_flutter/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:rxdart/rxdart.dart';

class StoreDetailsViewModel extends BaseViewModel with StoreDetailsViewModelInputs, StoreDetailsViewModelOutputs {
  StoreDetailsUseCase _storeDetailsUseCase;

  StreamController _dataStreamController = BehaviorSubject<StoreDetails>();

  StoreDetailsViewModel(this._storeDetailsUseCase);

  //outputs
  @override
  void start() {
//hide content before you show data
  _loadData();
  }

  _loadData() async{
    inputState.add(LoadingState(stateRendererType: StateRendererType.FULL_SCREEN_LOADING_STATE));

    (await  _storeDetailsUseCase.execute(null)).fold((failure){
      inputState.add(ErrorState(StateRendererType.FULL_SCREEN_ERROR_STATE, failure.message));
    }, (storeDetailsObject) {
     inputState.add(ContentState());
     inputStoreDetailsData.add(storeDetailsObject);
    });
  }

  @override
  void dispose() {
    _dataStreamController.close();
    super.dispose();
  }


  @override
  Sink get inputStoreDetailsData => _dataStreamController.sink;



  //outputs
  @override
  Stream<StoreDetails> get outputStoreDetailsData => _dataStreamController.stream.map((data) => data);


}

abstract class StoreDetailsViewModelInputs {
  Sink get inputStoreDetailsData;
}

abstract class StoreDetailsViewModelOutputs {
  Stream<StoreDetails> get outputStoreDetailsData;

}


