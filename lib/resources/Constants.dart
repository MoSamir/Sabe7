import 'dart:ui';

class Constants {
  static const appThemeColor = Color(0xFF00cc66);
  static const NETWORK_ERROR_MESSAGE = "يرجي التحقق من اتصال بالانترنت";
  static const UNEXPECTED_ERROR_MESSAGE = "حدث خطأ يرجي المحاوله مره اخري";
  static const SERVER = "http://sabehapp.com";
  static const SHOPPING_AREA_BUTTON_LABEL = "منظقه التسوق";
  static const APP_NAME = "صبايح";

  static const EMPTY_CART = "لا يوجد منتجات في السله";
}

class JsonKeys {
  static const PRODUCT_ID_KEY = "id";
  static const PRODUCT_NAME_KEY = "name";
  static const PRODUCT_URL_KEY = "picture";
//--------------------------------
  static const CATEGORY_ID_KEY = "id";
  static const CATEGORY_NAME_KEY = "name";
  static const CATEGORY_URL_KEY = "picture";
  static const CATEGORY_PRODUCTS_LIST_KEY = "products";
}

class PreferenceKeys {
  static const USER_CART_SHARED_KEY = "shared_preference_user_cart";
  static const USER_LOGGED_IN_KEY = "is_user_loggedIn";
}

class Assets {
  static const JSON_RESPONSE = "assets/response.json";
}
