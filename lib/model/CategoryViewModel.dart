import 'ProductViewModel.dart';
import 'package:task/resources/Constants.dart';

class CategoryViewModel {
  String categoryName, categoryId, categoryImageURL;
  List<ProductViewModel> categoryProducts;

  CategoryViewModel(
      {this.categoryName,
      this.categoryId,
      this.categoryImageURL,
      this.categoryProducts});

  static fromJson(Map<String, dynamic> jsonObject) {
    List<dynamic> productsJsonList =
        jsonObject[JsonKeys.CATEGORY_PRODUCTS_LIST_KEY];
    List<ProductViewModel> categoryProductsList = [];
    productsJsonList.forEach((item) {
      categoryProductsList.add(ProductViewModel.fromJson(item));
    });
    return CategoryViewModel(
        categoryName: jsonObject[JsonKeys.CATEGORY_NAME_KEY],
        categoryId: jsonObject[JsonKeys.CATEGORY_ID_KEY].toString(),
        categoryImageURL:
            Constants.SERVER + jsonObject[JsonKeys.CATEGORY_URL_KEY],
        categoryProducts: categoryProductsList);
  }
}
