import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/bloc/UserCartBloc.dart';
import 'package:task/model/ProductViewModel.dart';
import 'package:task/resources/Constants.dart';
import 'package:task/ui/common/LoadingView.dart';

class ProductItem extends StatefulWidget {
  final ProductViewModel productViewModel;
  final UserCartBloc userCartBloc;
  ProductItem({this.productViewModel, this.userCartBloc});

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  UserCartBloc _bloc;
  bool isCartItem = false;

  @override
  void initState() {
    _bloc = widget.userCartBloc;
    _bloc.listen((state) {
      if (state is UserDataLoaded) {
        setState(() {
          isCartItem = _bloc.isFavourite(widget.productViewModel);
        });
      }

      if (state is UserLoadingFailed) {}
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//    _bloc = BlocProvider.of<UserCartBloc>(context);
    isCartItem = _bloc.isFavourite(widget.productViewModel);

    return Material(
      elevation: 1,
      child: Container(
        color: Colors.white,
        height: 150,
        width: 100,
        child: Column(
          children: <Widget>[
            CachedNetworkImage(
              height: 120,
              imageUrl: Constants.SERVER + widget.productViewModel.productURL,
              fit: BoxFit.contain,
              placeholder: (context, _) => LoadingPlaceHolderView(),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                    flex: 2, child: Text(widget.productViewModel.productName)),
                Flexible(
                  flex: 1,
                  child: IconButton(
                    icon: isCartItem
                        ? Icon(Icons.favorite)
                        : Icon(Icons.favorite_border),
//                  icon: Icon(Icons.favorite),
                    onPressed: () {
                      _bloc.add(ItemClickedEvent(
                          productModel: widget.productViewModel));
//                      setState(() {
//                        isCartItem = _bloc.isFavourite(widget.productViewModel);
//                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
