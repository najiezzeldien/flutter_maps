// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'phone_auth_cubit.dart';

abstract class PhoneAuthState {}

class PhoneAuthInitial extends PhoneAuthState {}

class Loading extends PhoneAuthState {}

class ErrorOccurred extends PhoneAuthState {
  final String errorMsg;
  ErrorOccurred({
    required this.errorMsg,
  });
}

class PhoneNumbersubmitted extends PhoneAuthState {}

class PhoneOTPVerified extends PhoneAuthState {}
