import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_tut/business_logic/cubit/maps/maps_cubit.dart';
import 'package:flutter_maps_tut/business_logic/cubit/phone_auth/phone_auth_cubit.dart';
import 'package:flutter_maps_tut/data/repository/maps_repo.dart';
import 'package:flutter_maps_tut/data/webservices/plases_web_services.dart';
import 'package:flutter_maps_tut/presentation/screens/map_screen.dart';
import 'package:flutter_maps_tut/presentation/screens/otp_screen.dart';
import 'constants/my_strings.dart';
import 'presentation/screens/login_screen.dart';

class AppRouter {
  PhoneAuthCubit? phoneAuthCubit;
  AppRouter() {
    phoneAuthCubit = PhoneAuthCubit();
  }
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case mapScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => MapsCubit(
              MapsRepository(
                plasesWebServices: PlasesWebServices(),
              ),
            ),
            child: MapScreen(),
          ),
        );
      case loginScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<PhoneAuthCubit>.value(
            value: phoneAuthCubit!,
            child: LoginScreen(),
          ),
        );
      case otpScreen:
        final phoneNumber = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => BlocProvider<PhoneAuthCubit>.value(
            value: phoneAuthCubit!,
            child: OtpScreen(phoneNumber: phoneNumber),
          ),
        );
    }
  }
}
