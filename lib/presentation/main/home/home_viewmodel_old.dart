import 'dart:async';

import 'package:advanced_course_flutter/domain/model/model.dart';
import 'package:advanced_course_flutter/domain/usecase/home_usecase.dart';
import 'package:advanced_course_flutter/presentation/base/baseviewmodel.dart';
import 'package:advanced_course_flutter/presentation/common/state_renderer/state_renderer.dart';
import 'package:advanced_course_flutter/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:rxdart/rxdart.dart';

class HomeViewModel extends BaseViewModel with HomeViewModelInputs, HomeViewModelOutputs {
  HomeUseCase _homeUseCase;

  StreamController _bannerStreamController = BehaviorSubject<List<BannerAd>>();
  StreamController _servicesStreamController = BehaviorSubject<List<Service>>();
  StreamController _storesStreamController = BehaviorSubject<List<Store>>();

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
     inputBanners.add(homeObject.data.banners);
     inputServices.add(homeObject.data.services);
     inputStores.add(homeObject.data.stores);
    });
  }

  @override
  void dispose() {
    _bannerStreamController.close();
    _servicesStreamController.close();
    _storesStreamController.close();
    super.dispose();
  }


  @override
  Sink get inputBanners => _bannerStreamController.sink;

  @override
  Sink get inputServices => _servicesStreamController.sink;

  @override
  Sink get inputStores => _storesStreamController.sink;


  //outputs
  @override
  Stream<List<BannerAd>> get outputBanners => _bannerStreamController.stream.map((banners) => banners);

  @override
  Stream<List<Service>> get outputServices => _servicesStreamController.stream.map((services) => services);

  @override
  Stream<List<Store>> get outputStores => _storesStreamController.stream.map((stores) => stores);
}

abstract class HomeViewModelInputs {
  Sink get inputStores;

  Sink get inputServices;

  Sink get inputBanners;
}

abstract class HomeViewModelOutputs {
  Stream<List<Store>> get outputStores;

  Stream<List<Service>> get outputServices;

  Stream<List<BannerAd>> get outputBanners;

}
