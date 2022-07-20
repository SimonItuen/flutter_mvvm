import 'dart:async';

import 'package:advanced_course_flutter/domain/model/model.dart';
import 'package:advanced_course_flutter/domain/usecase/home_usecase.dart';
import 'package:advanced_course_flutter/presentation/base/baseviewmodel.dart';
import 'package:advanced_course_flutter/presentation/common/state_renderer/state_renderer.dart';
import 'package:advanced_course_flutter/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:rxdart/rxdart.dart';

class HomeViewModel extends BaseViewModel with HomeViewModelInputs, HomeViewModelOutputs {
  HomeUseCase _homeUseCase;

  StreamController _dataStreamController = BehaviorSubject<HomeViewObject>();

  HomeViewModel(this._homeUseCase);

  //outputs
  @override
  void start() {
//hide content before you show data
  _getHome();
  }

  _getHome() async{
    inputState.add(LoadingState(stateRendererType: StateRendererType.FULL_SCREEN_LOADING_STATE));

    (await  _homeUseCase.execute(null)).fold((failure){
      inputState.add(ErrorState(StateRendererType.FULL_SCREEN_ERROR_STATE, failure.message));
    }, (homeObject) {
     inputState.add(ContentState());
     inputHomeData.add(HomeViewObject(homeObject.data.banners, homeObject.data.services, homeObject.data.stores));
    });
  }

  @override
  void dispose() {
    _dataStreamController.close();
    super.dispose();
  }


  @override
  Sink get inputHomeData => _dataStreamController.sink;



  //outputs
  @override
  Stream<HomeViewObject> get outputHomeData => _dataStreamController.stream.map((data) => data);


}

abstract class HomeViewModelInputs {
  Sink get inputHomeData;
}

abstract class HomeViewModelOutputs {
  Stream<HomeViewObject> get outputHomeData;

}

class HomeViewObject {
  List<Service> services;
  List<Store> stores;
  List<BannerAd> banners;

  HomeViewObject(this.banners,this.services, this.stores);
}

