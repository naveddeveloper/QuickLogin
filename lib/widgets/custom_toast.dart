import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


void showCustomToast(String message){
  Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_LONG, fontSize: 18, backgroundColor: Colors.purple, gravity: ToastGravity.BOTTOM);
}