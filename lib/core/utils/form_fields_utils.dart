import 'package:flutter/material.dart';

class FormFieldsUtilities {
  static void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static String? validateTextField(
    String? value,
    BuildContext context, {
    String? fieldName,
  }) {
    if (value == null || value.isEmpty) {
      return fieldName != null
          ? "$fieldName is Required."
          : "This Field is Required.";
    } else {
      return null;
    }
  }

  static String? validateName(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return "Name is Required.";
    } else {
      // Basic name validation pattern:
      // - Allows letters (upper and lowercase)
      // - Allows spaces and hyphens
      // - Requires at least two characters (to exclude single initials)
      String pattern = r"^[a-zA-Z]+[a-zA-Z0-9\s-]*$";
      RegExp regExp = RegExp(pattern);

      if (!regExp.hasMatch(value)) {
        return "Invalid Name";
      } else {
        return null;
      }
    }
  }

  static String? validateEmail(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return "Email is Required.";
    } else {
      // Define a regular expression for validating email addresses
      String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
      RegExp regExp = RegExp(emailPattern);
      bool isEmailValid = regExp.hasMatch(value);
      if (isEmailValid) {
        return null;
      } else {
        return "Invalid Email";
      }
    }
  }

  static String? validatePassword(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    } else if (value.length < 8) {
      return "Password must be at least 8 characters";
    } else {
      return null;
    }
  }

  static String? validateConfirmPasswordTextField(
    String? value,
    String? password,
    BuildContext context,
  ) {
    if (value == null ||
        value.isEmpty ||
        password == null ||
        password.isEmpty) {
      return "Password is required";
    } else if (value != password) {
      return "Passwords does not match";
    } else {
      return null;
    }
  }
}
