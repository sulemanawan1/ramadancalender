
import 'package:flutter/material.dart';

import 'package:ramadancalender/App%20Config/app_config.dart';

AppTheme appTheme=AppTheme();
class TextHeading extends StatelessWidget {

  final String? name;

 TextHeading({required this.name}) ;

  @override
  Widget build(BuildContext context) {
    return Text(name!,style: TextStyle(color: AppTheme.SecondaryColor,
        fontWeight:FontWeight.bold,fontSize: 15
    ),);
  }
}
