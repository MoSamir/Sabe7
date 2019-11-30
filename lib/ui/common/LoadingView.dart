import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:task/resources/Constants.dart';

class LoadingPlaceHolderView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 100,
        width: 50,
        child: Center(
          child: SpinKitThreeBounce(
            size: 25,
            color: Constants.appThemeColor,
          ),
        ));
  }
}
