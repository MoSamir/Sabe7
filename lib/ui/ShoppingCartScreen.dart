import 'package:flutter/material.dart';
import 'package:task/bloc/UserCartBloc.dart';
import 'package:task/resources/Constants.dart';

import 'list_items/ProductItem.dart';

class ShoppingCartScreen extends StatelessWidget {
  final UserCartBloc cartBloc;
  ShoppingCartScreen({this.cartBloc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.appThemeColor,
        title: Text(Constants.SHOPPING_AREA_BUTTON_LABEL),
        elevation: 0,
      ),
      body: StreamBuilder<int>(
          stream: cartBloc.cartSize,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data > 0) {
              return GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                    childAspectRatio: MediaQuery.of(context).orientation ==
                            Orientation.portrait
                        ? .65
                        : 1),
                children: cartBloc.userFavouritesList.map((item) {
                  return ProductItem(
                    productViewModel: item,
                    userCartBloc: cartBloc,
                  );
                }).toList(),
              );
            } else {
              return Container(
                child: Center(
                  child: Text(Constants.EMPTY_CART),
                ),
              );
            }
          }),
    );
  }
}
