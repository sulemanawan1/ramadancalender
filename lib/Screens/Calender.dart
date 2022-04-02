import 'package:flutter/material.dart';
import 'package:ramadancalender/Services/Api%20Service/api_service.dart';

import '../App Config/app_config.dart';
import '../Models/Calender/calender_model.dart';
import '../Widgets/Text.dart';
import '../Widgets/current_roza.dart';
import '../Widgets/text_headings.dart';

class Calender extends StatefulWidget {
  const Calender({Key? key}) : super(key: key);

  @override
  _CalenderState createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder <CalenderModel>(
        future: getdata(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return   Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.data!.length,
                  itemBuilder:
                      (BuildContext context, int index) {
                    String sehr = snapshot
                        .data!.data![index].timings!.fajr
                        .toString()
                        .split(" ")[0]
                        .toString()
                        .replaceAll(RegExp(r'^0+(?=.)'), '');
                    String iftaar = snapshot
                        .data!.data![index].timings!.sunset
                        .toString()
                        .split("(")[0]
                        .trim();
                    String month = snapshot.data!.data![index]
                        .date!.gregorian!.month!.en
                        .toString();
                    String day = snapshot
                        .data!.data![index].date!.gregorian!.day
                        .toString()
                        .replaceAll(RegExp(r'^0+(?=.)'), '');
                    String week = snapshot.data!.data![index]
                        .date!.gregorian!.weekday!.en
                        .toString();
                    int ind = index;

                    var weeks = week.split("");

                    String fweek =
                        weeks[0] + weeks[1] + weeks[2];

                    var months = month.split("");
                    String fmonth =
                        months[0] + months[1] + month[2];

                    var ift = iftaar.split(":");
                    int iftHour = int.parse(ift[0]);
                    int iftMin = int.parse(ift[1]);

                    int? iftr;
                    if (iftHour > 12) {
                      iftr = iftHour - 12;
                    } else if (iftHour == 00) {
                      iftr = 12;
                    }
                    String ifttime = iftr.toString() +
                        ":" +
                        iftMin.toString();

                    DateTime d = DateTime.now();
                    var mydate = d.toString().split(" ");
                    var datee = mydate[0];
                    int ramzan_current_day = int.parse(
                        datee.toString().split('-')[2]);
                    int current_month = int.parse(
                        datee.toString().split("-")[1]);
                    int mon = int.parse(snapshot
                        .data!
                        .data![index]
                        .date!
                        .gregorian!
                        .month!
                        .number
                        .toString());
                    print(mydate[0]);
                    print(current_month);
                    print(mon);

                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child:
                          ClipRRect(
                            borderRadius:
                            BorderRadius.circular(10.0),
                            child: Container(
                                decoration: const BoxDecoration(
                                    gradient:
                                    LinearGradient(colors: [
                                      AppTheme.PrimaryColor,
                                      AppTheme.PrimaryLightColor,
                                    ])),
                                width: 400,
                                height: 20,
                                child: index == 0
                                    ? Container(
                                  width: 400,
                                  height: 30,
                                  color: AppTheme
                                      .PrimaryColor,
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceEvenly,
                                    children: [
                                      TextHeading(
                                          name:
                                          "Ramadan"),
                                      TextHeading(
                                          name: "Day"),
                                      TextHeading(
                                          name: "Date"),
                                      TextHeading(
                                          name: "Seher"),
                                      TextHeading(
                                          name: "Iftaar"),
                                    ],
                                  ),
                                )
                                    : Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceEvenly,
                                  children: [
                                    TextWidget(
                                        name:
                                        ind.toString() +
                                            "      " +
                                            "   "),
                                    TextWidget(
                                        name: fweek),
                                    int.parse(day) == ramzan_current_day &&
                                        mon ==
                                            current_month
                                        ? Row(
                                      children: [
                                        CurrentRoza(name:ind.toString() +
                                            "      " +
                                            "   " ),
                                        CurrentRoza(name:fweek),
                                        CurrentRoza(
                                            name:
                                            day)
                                      ],
                                    )
                                        : Row(
                                      children: [
                                        TextWidget(
                                          name: day +
                                              " " +
                                              fmonth,
                                        ),
                                      ],
                                    ),
                                    TextWidget(
                                        name:
                                        sehr.trim()),
                                    TextWidget(
                                        name: ifttime
                                            .trim()),
                                  ],
                                )),
                          ),

                    );
                  }),
            );
          } else if (snapshot.hasError) {
            return Icon(Icons.error_outline);
          } else {
            return CircularProgressIndicator();
          }
        });


  }
}
