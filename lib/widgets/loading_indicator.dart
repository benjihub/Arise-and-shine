import 'package:arise_and_shine/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Widget loadingIndicator({color = primaryColor}) {
  return Center(
    child: SpinKitChasingDots(
      color: color,
      size: 35,
    ),
  );
}
