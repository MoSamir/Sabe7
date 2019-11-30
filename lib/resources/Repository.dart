import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:task/model/CategoryViewModel.dart';
import 'package:task/model/ProductViewModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task/resources/Constants.dart';

class Repository {
  static Future<List<ProductViewModel>> loadUserFavourites() async {
    try {
      var preference = await SharedPreferences.getInstance();
      if (preference.containsKey(PreferenceKeys.USER_CART_SHARED_KEY)) {
        List<dynamic> userJson =
            json.decode(preference.get(PreferenceKeys.USER_CART_SHARED_KEY));
        List<ProductViewModel> userProducts = [];
        userJson.forEach((item) {
          userProducts.add(ProductViewModel.fromJson(item));
        });

        if (userProducts != null)
          return userProducts;
        else {
          return [];
        }
      }
    } catch (ex) {
      return [];
    }
    return [];
  }

  static addToCart({ProductViewModel itemModel}) async {
    try {
      var preference = await SharedPreferences.getInstance();

      if (preference.containsKey(PreferenceKeys.USER_CART_SHARED_KEY)) {
        var objects = preference.get(PreferenceKeys.USER_CART_SHARED_KEY);
        List<dynamic> objectsList = json.decode(objects);

        objectsList.add(itemModel.toJson());

        preference.setString(
            PreferenceKeys.USER_CART_SHARED_KEY, json.encode(objectsList));
        return true;
      } else {
        preference.setString(PreferenceKeys.USER_CART_SHARED_KEY,
            json.encode([itemModel.toJson()]));
        return true;
      }
    } catch (ex) {
      return false;
    }
  }

  static Future<bool> removeFromCart({ProductViewModel itemModel}) async {
    try {
      var preference = await SharedPreferences.getInstance();

      if (preference.containsKey(PreferenceKeys.USER_CART_SHARED_KEY)) {
        var objects = preference.get(PreferenceKeys.USER_CART_SHARED_KEY);
        List<dynamic> objectsList = json.decode(objects);
        objectsList.remove(itemModel.toJson());
        preference.setString(
            PreferenceKeys.USER_CART_SHARED_KEY, json.encode(objectsList));
        return true;
      }
    } catch (ex) {
      return false;
    }
  }

  static loadSystemProducts(BuildContext context) async {
    List<dynamic> jsonResponse = json.decode(
        (await DefaultAssetBundle.of(context)
            .loadString(Assets.JSON_RESPONSE)));
    List<CategoryViewModel> appData = [];
    jsonResponse.forEach((item) {
      appData.add(CategoryViewModel.fromJson(item));
    });
    return appData;
  }

  static authenticateUser() async {
    var preference = await SharedPreferences.getInstance();
    return (preference.containsKey(PreferenceKeys.USER_LOGGED_IN_KEY) &&
        preference.getBool(PreferenceKeys.USER_LOGGED_IN_KEY));
  }

  static loginUser() async {
    var preference = await SharedPreferences.getInstance();
    preference.setBool(PreferenceKeys.USER_LOGGED_IN_KEY, true);
    return true;
  }

  static logoutUser() async {
    var preference = await SharedPreferences.getInstance();
    preference.remove(PreferenceKeys.USER_LOGGED_IN_KEY);
    preference.remove(PreferenceKeys.USER_CART_SHARED_KEY);
    return true;
  }
}
