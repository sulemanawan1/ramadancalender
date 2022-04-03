

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ramadancalender/App%20Config/app_config.dart';

class TextWidget extends StatelessWidget {

  final String? name;

  TextWidget({required  this.name}      );


  @override
  Widget build(BuildContext context) {
    return Text(
      name!,style: TextStyle(color: AppTheme.SecondaryColor,fontSize: 16,),textAlign: TextAlign.start,);
  }
}
