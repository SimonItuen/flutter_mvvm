import 'dart:async';

import 'package:advanced_course_flutter/domain/model/model.dart';
import 'package:advanced_course_flutter/presentation/base/baseviewmodel.dart';
import 'package:advanced_course_flutter/presentation/resources/assets_manager.dart';
import 'package:advanced_course_flutter/presentation/resources/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';

class OnBoardingViewModel extends BaseViewModel  with OnBoardingViewModelInputs, OnBoardingViewModelOutputs{
  StreamController _streamController = StreamController<SliderViewObject>();
  late final List<SliderObject> _list;
  int _currentIndex = 0;

  @override
  void dispose() {
    _streamController.close();
    // TODO: implement dispose
  }

  @override
  void start() {
    _list = _getSliderData();
    // TODO: implement start
    _postDataToView();
  }

  @override
  int goNext() {
    int nextIndex = _currentIndex++;
    if(nextIndex >=_list.length){
    _currentIndex=0;
    }
    return _currentIndex;
  }

  @override
  int goPrevious() {
    int previousIndex = _currentIndex--;
    if(previousIndex >=-1){
      _list.length-1;
    }


    return _currentIndex;
  }

  @override
  void onPageChanged(int index) {
    _currentIndex= index;
    _postDataToView();
  }

  @override
  // TODO: implement inputSliderViewObject
  Sink get inputSliderViewObject => _streamController.sink;

  @override
  // TODO: implement outputSliderViewObject
  Stream<SliderViewObject> get outputSliderViewObject => _streamController.stream.map((sliderViewObject)=> sliderViewObject);


  List<SliderObject> _getSliderData() => [
    SliderObject(AppStrings.onBoardingTitle1.tr(), AppStrings.onBoardingSubTitle1.tr(),
        ImageAssets.onboardingLogo1),
    SliderObject(AppStrings.onBoardingTitle2.tr(), AppStrings.onBoardingSubTitle2.tr(),
        ImageAssets.onboardingLogo2),
    SliderObject(AppStrings.onBoardingTitle3.tr(), AppStrings.onBoardingSubTitle3.tr(),
        ImageAssets.onboardingLogo3),
    SliderObject(AppStrings.onBoardingSubTitle4.tr(), AppStrings.onBoardingSubTitle4.tr(),
        ImageAssets.onboardingLogo4),
  ];
  void _postDataToView() {
    inputSliderViewObject.add(SliderViewObject(_list[_currentIndex], _list.length, _currentIndex));
  }
}




// this collects input command from the view
abstract class OnBoardingViewModelInputs {
  void goNext();

  void goPrevious();

  void onPageChanged(int index);

  Sink get inputSliderViewObject;
}

// this outputs data or results that would be sent from our view
abstract class OnBoardingViewModelOutputs {
  Stream<SliderViewObject> get outputSliderViewObject;
}

class SliderViewObject {
  SliderObject sliderObject;
  int numOfSlides;
  int currentIndex;

  SliderViewObject(this.sliderObject, this.numOfSlides, this.currentIndex);
}
