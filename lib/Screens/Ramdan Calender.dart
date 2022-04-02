import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:ramadancalender/Widgets/current_roza.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ramadancalender/App%20Config/app_config.dart';
import 'package:ramadancalender/Widgets/Text.dart';
import 'package:ramadancalender/Widgets/text_headings.dart';
import 'package:screenshot/screenshot.dart';
import '../Models/Calender/calender_model.dart';
import '../Services/Api Service/api_service.dart';

class RamadanCalender extends StatefulWidget {
  const RamadanCalender({Key? key}) : super(key: key);

  @override
  _RamadanCalenderState createState() => _RamadanCalenderState();
}

class _RamadanCalenderState extends State<RamadanCalender> {
  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Screenshot(
          controller: _screenshotController,
          child: Scaffold(
              appBar: AppBar(
                backgroundColor: AppTheme.PrimaryColor,
                actions: [
                  InkWell(
                      onTap: () async {
                        final image = await _screenshotController.capture();
                        if (image == null) return;
                        await [Permission.storage].request();
                        String? screenShot = "Calender";
                        DateTime date = DateTime.now();
                        String dtime = date.toString().split(" ")[0].toString();
                        String imgname = screenShot + "_" + dtime;
                        final result = await ImageGallerySaver.saveImage(image,
                            name: imgname);

                        Directory dir =
                            await getApplicationDocumentsDirectory();
                        final images = File('${dir.path}/flutter.png');
                        images.writeAsBytes(image);
                        Share.shareFiles([images.path]);
                      },
                      child: Icon(Icons.share)),
                  SizedBox(
                    width: 10,
                  )
                ],
              ),
              body: FutureBuilder<CalenderModel>(
                  future: getdata(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                        color: AppTheme.PrimaryColor,
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  width: 400,
                                  height: 150,
                                  decoration: const BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'images/mosquebackground.jpeg'),
                                          fit: BoxFit.cover)),
                                ),
                                Positioned.fill(
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 2.0, sigmaY: 2.0),
                                    child: Container(
                                      color: Colors.black.withOpacity(0.10),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 30,
                                  left: 150,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: const SizedBox(
                                        width: 80,
                                        height: 80,
                                        child: Image(
                                          color: Colors.white,
                                          image: AssetImage(
                                            "images/mosque.png",
                                          ),
                                        )),
                                  ),
                                ),
                                const Positioned(
                                  left: 100,
                                  top: 100,
                                  child: Text(
                                    "Ramadan Mubarak",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 23),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
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
                                      child: Column(
                                        children: [
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
                                        ],
                                      ),
                                    );
                                  }),
                            )
                          ],
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return const Icon(Icons.error_outline);
                    } else {
                      return const CircularProgressIndicator();
                    }
                  })),
        ));
  }
}
