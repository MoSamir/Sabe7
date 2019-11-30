import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:task/model/CategoryViewModel.dart';
import 'package:task/model/ErrorViewModel.dart';
import 'package:bloc/bloc.dart';
import 'package:task/resources/Constants.dart';
import 'package:task/resources/NetworkHelper.dart';
import 'package:task/resources/Repository.dart';

class HomeBloc extends Bloc<HomeEvents, HomeStates> {
  List<CategoryViewModel> appData = [];

  @override
  // TODO: implement initialState
  HomeStates get initialState => HomeScreenLoading();

  @override
  Stream<HomeStates> mapEventToState(HomeEvents event) async* {
    bool isUserConnected = await NetworkHelper.isNetworkAvailable();
    if (!isUserConnected) {
      yield HomeScreenLoadingError(
        errorReason: ErrorViewModel(
          errorCode: 0,
          errorMessage: Constants.NETWORK_ERROR_MESSAGE,
        ),
      );
      return;
    } else if (event is LoadApplicationData) {
//      yield HomeScreenLoading();
      List<CategoryViewModel> categories =
          await Repository.loadSystemProducts(event.appContext);
      if (categories != null) {
        appData = categories;
        yield HomeScreenLoaded(
          applicationCategories: categories,
        );
      } else {
        yield HomeScreenLoadingError(
          errorReason: ErrorViewModel(
            errorCode: 0,
            errorMessage: Constants.UNEXPECTED_ERROR_MESSAGE,
          ),
        );
      }
    }
  }
}

//-------------------- Home Events ----------------
abstract class HomeEvents {}

class LoadApplicationData extends HomeEvents {
  final BuildContext appContext;
  LoadApplicationData({this.appContext});
}

abstract class HomeStates {}

class HomeScreenLoading extends HomeStates {}

class HomeScreenLoaded extends HomeStates {
  final List<CategoryViewModel> applicationCategories;
  HomeScreenLoaded({this.applicationCategories});
}

class HomeScreenLoadingError extends HomeStates {
  final ErrorViewModel errorReason;
  HomeScreenLoadingError({this.errorReason});
}
