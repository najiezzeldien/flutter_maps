// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_tut/business_logic/cubit/phone_auth/phone_auth_cubit.dart';
import 'package:flutter_maps_tut/constants/my_color.dart';
import 'package:flutter_maps_tut/constants/my_strings.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final GlobalKey<FormState> _phoneFormKey = GlobalKey();

  late String phoneNumber;

  Widget _buildIntroTexts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "What is your phone number? ",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          child: const Text(
            "Pleas enter your phone number to verfiy your account",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildPhoneFormField() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: MyColors.lightGrey,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(6),
              ),
            ),
            child: Text(
              '${generateCountryFlag()} +20',
              style: const TextStyle(
                fontSize: 18,
                letterSpacing: 2.0,
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        Expanded(
          flex: 2,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: MyColors.blue,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(6),
              ),
            ),
            child: TextFormField(
              autofocus: true,
              style: const TextStyle(
                fontSize: 18,
                letterSpacing: 2.0,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              cursorColor: Colors.black,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Pleas enter your phone number";
                } else if (value.length < 11) {
                  return "Too short for phone number";
                }
                return null;
              },
              onSaved: (newValue) {
                phoneNumber = newValue!;
              },
            ),
          ),
        ),
      ],
    );
  }

  String generateCountryFlag() {
    String countryCode = "eg";
    String flag = countryCode.toUpperCase().replaceAllMapped(RegExp(r'[A-Z]'),
        (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397));
    return flag;
  }

  Future<void> _register(BuildContext context) async {
    if (!_phoneFormKey.currentState!.validate()) {
      Navigator.pop(context);
      return;
    } else {
      Navigator.pop(context);
      _phoneFormKey.currentState!.save();
      BlocProvider.of<PhoneAuthCubit>(context).submitPhoneNumber(phoneNumber);
    }
  }

  Widget _buildNextButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(110, 50),
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: const Text(
          "Next",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        onPressed: () {
          showProgressIndicator(context);
          _register(context);
        },
      ),
    );
  }

  Widget _buildPhoneNumbersubmittedBloc() {
    return BlocListener<PhoneAuthCubit, PhoneAuthState>(
      listenWhen: (previous, current) {
        return previous != current;
      },
      listener: (context, state) {
        if (state is Loading) {
          showProgressIndicator(context);
        }

        if (state is PhoneNumbersubmitted) {
          Navigator.pop(context);
          Navigator.of(context).pushNamed(
            otpScreen,
            arguments: phoneNumber,
          );
        }
        if (state is ErrorOccurred) {
          String errorMsg = (state).errorMsg;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMsg),
              backgroundColor: Colors.black,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      child: const SizedBox(),
    );
  }

  void showProgressIndicator(BuildContext context) {
    AlertDialog alertDialog = const AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.black),
      ),
    );
    showDialog(
      barrierColor: Colors.white.withOpacity(0),
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return alertDialog;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Form(
          key: _phoneFormKey,
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 88,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildIntroTexts(),
                  const SizedBox(
                    height: 110,
                  ),
                  _buildPhoneFormField(),
                  const SizedBox(
                    height: 70,
                  ),
                  _buildNextButton(context),
                  _buildPhoneNumbersubmittedBloc(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
