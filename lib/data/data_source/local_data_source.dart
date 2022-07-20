import 'package:advanced_course_flutter/data/network/error_handler.dart';
import 'package:advanced_course_flutter/data/responses/responses.dart';

const CACHE_HOME_KEY = "CACHE_HOME_KEY";
const CACHE_HOME_INTERVAL = 60*1000; //1 min in milliseconds
const CACHE_STORE_DETAILS_KEY = "CACHE_STORE_DETAILS_KEY";
const CACHE_STORE_DETAILS_INTERVAL = 60*1000; //1 min in milliseconds
abstract class LocalDataSource{
  Future<HomeResponse> getHome();

  Future<StoreDetailsResponse> getStoreDetails();

  Future<void> saveHomeToCache(HomeResponse homeResponse);

  Future<void> saveStoreDetailsToCache(StoreDetailsResponse storeDetailsResponse);

  void clearCache();

  void removeFromCache(String key);
}

class LocalDataSourceImplementer implements LocalDataSource{

  // apply concept of run time cache

  Map<String, CachedItem> cacheMap = Map();

  @override
  Future<HomeResponse> getHome() async{
    CachedItem? cachedItem = cacheMap[CACHE_HOME_KEY];
    if(cachedItem!=null && cachedItem.isValid(CACHE_HOME_INTERVAL)){
      //return the response from cache
      return cachedItem.data;
    }else{
      //return the error that cache is not valid
      throw ErrorHandler.handle(DataSource.CACHE_ERROR);
    }
  }

  @override
  Future<void> saveHomeToCache(HomeResponse homeResponse) async {
    cacheMap[CACHE_HOME_KEY] = CachedItem(homeResponse);
  }
  @override
  Future<void> saveStoreDetailsToCache(StoreDetailsResponse storeDetailsResponse) async {
    cacheMap[CACHE_STORE_DETAILS_KEY] = CachedItem(storeDetailsResponse);

  }

  @override
  void clearCache() {
   cacheMap.clear();
  }

  @override
  void removeFromCache(String key) {
   cacheMap.remove(key);
  }

  @override
  Future<StoreDetailsResponse> getStoreDetails() async{
    CachedItem? cachedItem = cacheMap[CACHE_STORE_DETAILS_KEY];
    if(cachedItem!=null && cachedItem.isValid(CACHE_STORE_DETAILS_INTERVAL)){
      //return the response from cache
      return cachedItem.data;
    }else{
      //return the error that cache is not valid
      throw ErrorHandler.handle(DataSource.CACHE_ERROR);
    }
  }

}

class CachedItem{
  dynamic data;
  int cacheTime = DateTime.now().millisecondsSinceEpoch;

  CachedItem(this.data);
}

extension CachedItemExtension on CachedItem{
  bool isValid(int expirationTime){ //expirationTime is 60 secs
    int currentTimeInMillis = DateTime.now().millisecondsSinceEpoch;//time now is 1:00:00p,
    bool isCacheValid = currentTimeInMillis - expirationTime < cacheTime; //cache time was in 12:59:30
    //false if current time > 1:00:30
    //true if current time < 1:00:30
    return isCacheValid;
  }
}