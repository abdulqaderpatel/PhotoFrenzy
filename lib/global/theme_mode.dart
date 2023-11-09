
import 'package:flutter/material.dart';



   isDark(BuildContext context) {

    return MediaQuery.of(context).platformBrightness == Brightness.dark ? true:false;
  }


