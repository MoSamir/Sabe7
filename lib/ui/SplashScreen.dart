import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/bloc/AuthenticationBloc.dart';
import 'package:task/bloc/UserCartBloc.dart';

import 'HomeScreen.dart';
import 'common/LoadingView.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  UserCartBloc userBloc = UserCartBloc();
  AuthenticationBloc authBloc = AuthenticationBloc();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    authBloc.add(AuthenticateUser());
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKey,
        body: MultiBlocListener(
          listeners: [
            BlocListener(
              listener: (context, state) {
                if (state is AuthenticationSuccessState) {
                  userBloc.add(LoadUserCartEvent());
                } else if (state is AuthenticationErrorState) {
                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text(state.failureReason.errorMessage),
                  ));
                }
              },
              bloc: authBloc,
            ),
            BlocListener(
              listener: (context, state) {
                if (state is UserDataLoaded) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => MultiBlocProvider(providers: [
                        BlocProvider<AuthenticationBloc>.value(value: authBloc),
                        BlocProvider<UserCartBloc>.value(value: userBloc)
                      ], child: HomeScreen()),
                    ),
                  );
                }
              },
              bloc: userBloc,
            )
          ],
          child: BlocBuilder(
            bloc: authBloc,
            builder: (context, state) {
              if (state is AnonymousUserState) {
                return Container(
                  child: Center(
                    child: FlatButton(
                      onPressed: () {
                        authBloc.add(Login());
                      },
                      child: Text('تم التأكد من البيانات'),
                    ),
                  ),
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
