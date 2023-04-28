import 'package:flutter/material.dart';

// textInputDecoration created here for TextFormFields in login and sign-up screens
const textInputDecoration = InputDecoration(
  labelStyle: TextStyle(color: Colors.black),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color.fromRGBO(228, 119,	102, 1), width: 2),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color.fromRGBO(228, 119,	102, 1), width: 2),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color.fromRGBO(228, 119,	102, 1), width: 2),
  ),
);