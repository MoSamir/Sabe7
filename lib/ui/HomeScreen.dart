import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/bloc/HomeBloc.dart';
import 'package:task/bloc/UserCartBloc.dart';
import 'package:task/model/ProductViewModel.dart';
import 'package:task/resources/Constants.dart';
import 'package:task/resources/Repository.dart';
import 'package:task/ui/ShoppingCartScreen.dart';
import 'package:task/ui/common/LoadingView.dart';
import 'package:task/ui/list_items/ProductItem.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int currentTabIndex = 0;
  HomeBloc _homeBloc = HomeBloc();
  UserCartBloc _cartBloc;
  double cartButtonHeight = 50;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _homeBloc.add(LoadApplicationData(appContext: context));
  }

  @override
  Widget build(BuildContext context) {
    _cartBloc = BlocProvider.of<UserCartBloc>(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        drawer: Drawer(),
        key: _scaffoldKey,
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
            Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: IconButton(
                    icon: Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StreamBuilder<int>(
                    stream: _cartBloc.cartSize,
                    initialData: _cartBloc.userFavouritesList.length,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data > 0) {
                          return Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.orange,
                                ),
                                child: Center(
                                    child: Text(snapshot.data.toString()))),
                          );
                        } else
                          return Container();
                      } else
                        return Container();
                    },
                  ),
                ),
              ],
            ),
          ],
          backgroundColor: Constants.appThemeColor,
          title: Text(Constants.APP_NAME),
          elevation: 0,
        ),
        body: BlocListener(
          bloc: _homeBloc,
          listener: (context, state) {
            if (state is HomeScreenLoadingError) {
              _scaffoldKey.currentState.showSnackBar(
                SnackBar(
                  content: Text(state.errorReason.errorMessage),
                ),
              );
            }
          },
          child: BlocBuilder(
            bloc: _homeBloc,
            builder: (context, state) {
              if (state is HomeScreenLoaded) {
                return Column(
                  children: <Widget>[
                    Container(
                      height: 70,
                      alignment: Alignment.bottomCenter,
                      width: MediaQuery.of(context).size.width,
                      color: Constants.appThemeColor,
                      child: TabBar(
                        tabs: state.applicationCategories.map((item) {
                          return Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(item.categoryImageURL),
                                fit: BoxFit.contain,
                              ),
                            ),
                          );
                        }).toList(),
                        controller: TabController(
                          length: state.applicationCategories.length,
                          vsync: this,
                          initialIndex: currentTabIndex,
                        ),
                        isScrollable: true,
                        indicatorColor: Colors.orange,
                        onTap: (index) {
                          currentTabIndex = index;
                          setState(() {});
                        },
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.topCenter,
                            padding: EdgeInsets.only(bottom: cartButtonHeight),
                            child: GridView(
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      mainAxisSpacing: 5,
                                      crossAxisSpacing: 5,
                                      childAspectRatio:
                                          MediaQuery.of(context).orientation ==
                                                  Orientation.portrait
                                              ? .65
                                              : 1),
                              children: state
                                  .applicationCategories[currentTabIndex]
                                  .categoryProducts
                                  .map((item) {
                                return ProductItem(
                                  productViewModel: item,
                                  userCartBloc: _cartBloc,
                                );
                              }).toList(),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: ButtonTheme(
                              padding: EdgeInsets.all(0),
                              height: cartButtonHeight,
                              minWidth: MediaQuery.of(context).size.width,
                              child: FlatButton(
                                padding: EdgeInsets.all(0),
                                color: Colors.orange,
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ShoppingCartScreen(
                                            cartBloc: _cartBloc,
                                          )));
                                },
                                child: Text(
                                  Constants.SHOPPING_AREA_BUTTON_LABEL,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return Container(
                  child: Center(
                    child: LoadingPlaceHolderView(),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
