// to convert the response into non nullable object

import 'package:advanced_course_flutter/app/extensions.dart';
import 'package:advanced_course_flutter/data/responses/responses.dart';
import 'package:advanced_course_flutter/domain/model/model.dart';

const empty = "";
const zero = 0;

extension CustomerResponseMapper on CustomerResponse? {
  Customer toDomain() {
    //convert response from data layer to domain layer
    return Customer(
        this?.id?.orEmpty() ?? empty,
        this?.name?.orEmpty() ?? empty,
        this?.numOfNotifications?.orZero() ?? zero);
  }
}

extension ContactsResponseMapper on ContactsResponse? {
  Contacts toDomain() {
    //convert response from data layer to domain layer
    return Contacts(this?.email?.orEmpty() ?? empty,
        this?.phone?.orEmpty() ?? empty, this?.link?.orEmpty() ?? empty);
  }
}

extension AuthenticationResponseMapper on AuthenticationResponse? {
  Authentication toDomain() {
    //convert response from data layer to domain layer
    return Authentication(
        this?.customer?.toDomain(), this?.contacts?.toDomain());
  }
}

extension ForgotPasswordResponseMapper on ForgotPasswordResponse? {
  String toDomain() {
    return this?.support?.orEmpty() ?? empty;
  }
}

extension ServiceResponseMapper on ServiceResponse? {
  Service toDomain() {
    return Service(this?.id?.orZero() ?? zero, this?.title?.orEmpty() ?? empty,
        this?.image?.orEmpty() ?? empty);
  }
}

extension StoreResponseMapper on StoreResponse? {
  Store toDomain() {
    return Store(this?.id?.orZero() ?? zero, this?.title?.orEmpty() ?? empty,
        this?.image?.orEmpty() ?? empty);
  }
}

extension BannerResponseMapper on BannerResponse? {
  BannerAd toDomain() {
    return BannerAd(this?.id?.orZero() ?? zero, this?.title?.orEmpty() ?? empty,
        this?.image?.orEmpty() ?? empty, this?.link?.orEmpty() ?? empty);
  }
}

extension HomeResponseMapper on HomeResponse? {
  HomeObject toDomain() {
    List<Service> mappedServices =
        (this?.data?.services?.map((service) => service.toDomain()) ??
                const Iterable.empty())
            .cast<Service>()
            .toList();
    List<Store> mappedStores =
        (this?.data?.stores?.map((store) => store.toDomain()) ??
                const Iterable.empty())
            .cast<Store>()
            .toList();
    List<BannerAd> mappedBanners =
        (this?.data?.banners?.map((bannerAd) => bannerAd.toDomain()) ??
                const Iterable.empty())
            .cast<BannerAd>()
            .toList();

    var data = HomeData(mappedServices, mappedStores, mappedBanners);
    return HomeObject(data);
  }
}

extension StoreDetailsResponseMapper on StoreDetailsResponse? {
  StoreDetails toDomain() {
    return StoreDetails(
        this?.id?.orZero() ?? zero,
        this?.title?.orEmpty() ?? empty,
        this?.image?.orEmpty() ?? empty,
        this?.details?.orEmpty() ?? empty,
        this?.services?.orEmpty() ?? empty,
        this?.about?.orEmpty() ?? empty);
  }
}
