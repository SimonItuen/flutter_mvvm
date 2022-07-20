import 'package:advanced_course_flutter/app/di.dart';
import 'package:advanced_course_flutter/domain/model/model.dart';
import 'package:advanced_course_flutter/presentation/onboarding/onboarding_viewmodel.dart';
import 'package:advanced_course_flutter/presentation/resources/assets_manager.dart';
import 'package:advanced_course_flutter/presentation/resources/color_manager.dart';
import 'package:advanced_course_flutter/presentation/resources/routes_manager.dart';
import 'package:advanced_course_flutter/presentation/resources/strings_manager.dart';
import 'package:advanced_course_flutter/presentation/resources/values_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/app_prefs.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({Key? key}) : super(key: key);

  @override
  _OnBoardingViewState createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  AppPreferences _appPreferences = instance<AppPreferences>();
  PageController _pageController = PageController();
  OnBoardingViewModel _viewModel = OnBoardingViewModel();

  _bind() {
    _appPreferences.setOnBoardingScreenViewed();
    _viewModel.start();
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
    return StreamBuilder<SliderViewObject>(
      stream: _viewModel.outputSliderViewObject,
      builder: (context, snapshot){
        return _getContentWidget(snapshot.data);
    }
    );
  }

  Widget _getContentWidget(SliderViewObject? sliderViewObject) {

        if(sliderViewObject == null){
          return Container();
        }else {
          return Scaffold(
            backgroundColor: ColorManager.white,
            appBar: AppBar(
              backgroundColor: ColorManager.white,
              elevation: AppSize.s0,
              systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: ColorManager.white,
                  statusBarBrightness: Brightness.dark,
                  statusBarIconBrightness: Brightness.dark),
            ),
            body: PageView.builder(
              controller: _pageController,
              itemCount: sliderViewObject.numOfSlides,
              itemBuilder: (context, index) {
                return OnBoardingPage(sliderViewObject.sliderObject);
              },
              onPageChanged: (index) {
                _viewModel.onPageChanged(index);
              },
            ),
            bottomSheet: Container(
              color: ColorManager.white,
              height: AppSize.s100,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, Routes.loginRoute);
                        },
                        child: Text(
                          AppStrings.skip,
                          textAlign: TextAlign.end,
                          style: Theme
                              .of(context)
                              .textTheme
                              .subtitle2,
                        ).tr()),
                  ),
                  _getBottomSheetWidget(sliderViewObject)
                ],
              ),
            ),
          );
        }
  }
  Widget _getBottomSheetWidget(SliderViewObject sliderViewObject) {
    return Container(
      color: ColorManager.primary,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Padding(
            padding: EdgeInsets.all(AppPadding.p14),
            child: GestureDetector(
              child: SizedBox(
                height: AppSize.s20,
                width: AppSize.s20,
                child: SvgPicture.asset(ImageAssets.leftArrowIc),
              ),
              onTap: () {
                _pageController.animateToPage(_viewModel.goPrevious(), duration: Duration(milliseconds:DurationConstants.d300), curve: Curves.bounceInOut);
              },
            )),
        Row(
          children: [
            for (int i = 0; i < sliderViewObject.numOfSlides; i++)
              Padding(
                padding: EdgeInsets.all(AppPadding.p8),
                child: _getProperCircle(i, sliderViewObject.currentIndex),
              )
          ],
        ),
        Padding(
            padding: EdgeInsets.all(AppPadding.p14),
            child: GestureDetector(
              child: SizedBox(
                height: AppSize.s20,
                width: AppSize.s20,
                child: SvgPicture.asset(ImageAssets.rightArrowIc),
              ),
              onTap: () {
                _pageController.animateToPage(_viewModel.goNext(), duration: Duration(milliseconds:DurationConstants.d300), curve: Curves.bounceInOut);
              },
            )),
      ]),
    );
  }


  Widget _getProperCircle(int index, int _currentIndex) {
    if (index == _currentIndex) {
      return SvgPicture.asset(ImageAssets.hollowCircleIc);
    } else {
      return SvgPicture.asset(ImageAssets.solidCircleIc);
    }
  }
}

class OnBoardingPage extends StatelessWidget {
  SliderObject _sliderObject;

  OnBoardingPage(this._sliderObject, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: AppSize.s40),
        Padding(
          padding: const EdgeInsets.all(AppPadding.p8),
          child: Text(
            _sliderObject.title,
            textAlign: TextAlign.center,
            style: Theme
                .of(context)
                .textTheme
                .headline1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppPadding.p8),
          child: Text(
            _sliderObject.subTitle,
            textAlign: TextAlign.center,
            style: Theme
                .of(context)
                .textTheme
                .subtitle1,
          ),
        ),
        SizedBox(height: AppSize.s40),
        SvgPicture.asset(_sliderObject.image),
      ],
    );
  }
}


