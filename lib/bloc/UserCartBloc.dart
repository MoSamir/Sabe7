import 'package:rxdart/rxdart.dart';
import 'package:task/model/ErrorViewModel.dart';
import 'package:task/model/ProductViewModel.dart';
import 'package:bloc/bloc.dart';
import 'package:task/resources/Constants.dart';
import 'package:task/resources/NetworkHelper.dart';
import 'package:task/resources/Repository.dart';

class UserCartBloc extends Bloc<UserCartEvent, UserCartStates> {
  List<ProductViewModel> userFavouritesList = [];

  BehaviorSubject<int> _cartItemsCount = BehaviorSubject<int>();
  Stream<int> get cartSize => _cartItemsCount.stream;

  bool isFavourite(ProductViewModel productVM) {
    return userFavouritesList.contains(productVM);
  }

  @override
  UserCartStates get initialState => LoadingUserDataState();

  @override
  Stream<UserCartStates> mapEventToState(UserCartEvent event) async* {
    bool isUserConnected = await NetworkHelper.isNetworkAvailable();
    if (isUserConnected == false) {
      yield UserLoadingFailed(
          errorViewModel: ErrorViewModel(
              errorCode: 0, errorMessage: Constants.NETWORK_ERROR_MESSAGE));
      return;
    }
    try {
      if (event is LoadUserCartEvent) {
        yield LoadingUserDataState();
        userFavouritesList = await Repository.loadUserFavourites();
        print('User Cache');
        for (int i = 0; i < userFavouritesList.length; i++) {
          print(userFavouritesList[i].productId);
        }

        yield UserDataLoaded(
          userFavourites: userFavouritesList,
        );
        return;
      } else if (event is ItemClickedEvent) {
        ProductViewModel clickedItem = event.productModel;
        if (userFavouritesList.contains(clickedItem)) {
          add(RemoveFromCartEvent(productModel: clickedItem));
        } else {
          add(AddToCartEvent(productModel: clickedItem));
        }
      } else if (event is AddToCartEvent) {
        yield LoadingUserDataState();
        bool isSuccess =
            await Repository.addToCart(itemModel: event.productModel);
        if (isSuccess) {
          userFavouritesList.add(event.productModel);
          _cartItemsCount.sink.add(userFavouritesList.length);

          yield UserDataLoaded(userFavourites: userFavouritesList);
        } else {
          yield UserLoadingFailed(
              errorViewModel: ErrorViewModel(
                  errorCode: 0,
                  errorMessage: Constants.UNEXPECTED_ERROR_MESSAGE));
        }
      } else if (event is RemoveFromCartEvent) {
        yield LoadingUserDataState();
        bool isSuccess =
            await Repository.removeFromCart(itemModel: event.productModel);
        if (isSuccess) {
          userFavouritesList.remove(event.productModel);
          _cartItemsCount.sink.add(userFavouritesList.length);
          yield UserDataLoaded(userFavourites: userFavouritesList);
        } else {
          yield UserLoadingFailed(
              errorViewModel: ErrorViewModel(
                  errorCode: 0,
                  errorMessage: Constants.UNEXPECTED_ERROR_MESSAGE));
        }
      }
    } catch (exception) {
      if (exception is ErrorViewModel) {
        yield UserLoadingFailed(errorViewModel: exception);
      } else
        yield UserLoadingFailed(
            errorViewModel: ErrorViewModel(
                errorCode: 0,
                errorMessage: Constants.UNEXPECTED_ERROR_MESSAGE));
    }
  }

  @override
  void close() {
    _cartItemsCount.close();
    // TODO: implement close
    super.close();
  }
}

//----------Events----------------

abstract class UserCartEvent {}

class LoadUserCartEvent extends UserCartEvent {}

class AddToCartEvent extends UserCartEvent {
  final ProductViewModel productModel;
  AddToCartEvent({this.productModel});
}

class RemoveFromCartEvent extends UserCartEvent {
  final ProductViewModel productModel;
  RemoveFromCartEvent({this.productModel});
}

class ItemClickedEvent extends UserCartEvent {
  final ProductViewModel productModel;
  ItemClickedEvent({this.productModel});
}

//----------States----------------

abstract class UserCartStates {}

class LoadingUserDataState extends UserCartStates {}

class UserDataLoaded extends UserCartStates {
  final List<ProductViewModel> userFavourites;
  UserDataLoaded({this.userFavourites});
}

class UserLoadingFailed extends UserCartStates {
  final ErrorViewModel errorViewModel;
  UserLoadingFailed({this.errorViewModel});
}
