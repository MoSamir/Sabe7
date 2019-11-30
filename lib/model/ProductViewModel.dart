import 'package:task/resources/Constants.dart';

class ProductViewModel with Comparable {
  String productId, productName, productURL;
  ProductViewModel({this.productId, this.productName, this.productURL});

  static ProductViewModel fromJson(Map<String, dynamic> responseJson) {
    return ProductViewModel(
      productId: responseJson[JsonKeys.PRODUCT_ID_KEY].toString(),
      productName: responseJson[JsonKeys.PRODUCT_NAME_KEY],
      productURL: responseJson[JsonKeys.PRODUCT_URL_KEY],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      JsonKeys.PRODUCT_ID_KEY: productId,
      JsonKeys.PRODUCT_NAME_KEY: productName,
      JsonKeys.PRODUCT_URL_KEY: productURL,
    };
  }

  @override
  int compareTo(other) {
    if (int.parse(other.productId) == int.parse(this.productId)) return 0;
  }

  @override
  int get hashCode => super.hashCode;

  @override
  bool operator ==(other) {
    // TODO: implement ==
    return int.parse(other.productId) == int.parse(this.productId);
  }
}
