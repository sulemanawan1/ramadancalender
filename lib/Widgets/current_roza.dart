

import 'package:flutter/material.dart';
import 'package:ramadancalender/App%20Config/app_config.dart';

class CurrentRoza extends StatelessWidget {

  final String? name;

  CurrentRoza({required  this.name}      );


  @override
  Widget build(BuildContext context) {
    return Text(name!,style: TextStyle(color: Colors.white,fontSize: 16),);
  }
}
