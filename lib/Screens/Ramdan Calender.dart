
import 'dart:io';

import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ramadancalender/Widgets/current_roza.dart';

import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:ramadancalender/App%20Config/app_config.dart';
import 'package:ramadancalender/Widgets/Text.dart';
import 'package:ramadancalender/Widgets/text_headings.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import '../Models/Calender/calender_model.dart';
import '../Services/Api Service/api_service.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
class RamadanCalender extends StatefulWidget {
  const RamadanCalender({Key? key}) : super(key: key);

  @override
  _RamadanCalenderState createState() => _RamadanCalenderState();
}

class _RamadanCalenderState extends State<RamadanCalender> {
  final ScreenshotController _screenshotController = ScreenshotController();
  final ApiService _apiService =ApiService();
  String dua="";



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
          child: SafeArea(
            child: Scaffold(

                body: FutureBuilder<CalenderModel>(
                    future:_apiService. getdata(),
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
                                  ), Positioned(
                                    left: 120,
                                    top: 100,
                                    child: CurrentRoza(name: "RAMADAN MUBARIK",)
                                  ),   Positioned(
                                    left: 160,top: 130,
                                    child: Text("${_apiService.city}",style: TextStyle(color: Colors.white),),
                                  ),
Positioned(left: 10,top: 10,
  child:   ClipRRect(

    borderRadius: BorderRadius.circular(360),

    child:   InkWell(
      onTap: () async{

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
      child: Container(width: 40,height: 40,



          decoration: BoxDecoration(color:AppTheme.PrimaryColor),



          child: Icon(Icons.share ,color:Colors.white,)),
    ),

  ),
)
                                ],
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.bottomCenter,
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
                                        String monthStr = snapshot.data!.data![index]
                                            .date!.gregorian!.month!.en
                                            .toString();
                                        String day = snapshot.data!.data![index]
                                            .date!.gregorian!.day
                                            .toString()
                                            .replaceAll(RegExp(r'^0+(?=.)'), '');
                                        String weekDay = snapshot.data!.data![index]
                                            .date!.gregorian!.weekday!.en
                                            .toString(); // Sunday

                                        var weeks = weekDay.split("");
                                        String weekInThreeChar = weeks[0] + weeks[1] + weeks[2]; // Sun ,Mon

                                        var months = monthStr.split(""); // April
                                        String monthInThreeChar =
                                            months[0] + months[1] + monthStr[2]; //Apr

                                        var ift = iftaar.split(":");
                                        int iftHour = int.parse(ift[0]);
                                        int iftMin = int.parse(ift[1]);
                                       int roza =int.parse(snapshot
                                      .data!
                                      .data![index]
                                      .date!
                                      .hijri!
                                      .day.toString());

                                       String? fullDate= snapshot.data!.data![index].date!.gregorian!.date;


                                       ;
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

                                        if (roza>=1 && roza<=10&& current_month==4 )

                                        {
                                          dua="رَبِّ اغْفِرْ وَارْحَمْ وَأَنْتَ خَيْرُ الرَّاحِمِينَ";


                                        }
                                        if ( roza>10 && roza<=20 && current_month==4)

                                        {


                                          dua="اَسْتَغْفِرُ اللہَ رَبِّی مِنْ کُلِّ زَنْبٍ وَّ اَتُوْبُ اِلَیْہِ";
                                        }
                                        if ( roza>20 && roza<=30 && current_month==4)

                                        {

                                            dua="اَللَّهُمَّ أَجِرْنِي مِنَ النَّارِ";


                                        }





                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              index==0?
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  SizedBox(width: 2,),
                                                  Expanded(

                                                    child: TextHeading(
                                                        name: "Ramazan" ),
                                                  ),
                                                  SizedBox(width: 5,),
                                                  Expanded(
                                                    child: TextHeading(
                                                        name:
                                                        "Day"),
                                                  ),
                                                  Expanded(
                                                    child: TextHeading
                                                      (
                                                        name: "Date"),
                                                  ),
                                                  Expanded(
                                                    child: TextHeading(
                                                      name: "Sehr",
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: TextHeading(
                                                      
                                                        name:
                                                        "Iftaar"),
                                                  ),
                                                  SizedBox(width: 2,),
                                                ],
                                              )
                                                  :
                                                  index==1?
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      SizedBox(width: 2,),
                                                      Expanded(

                                                        child: TextHeading(
                                                            name: "---" ),
                                                      ),
                                                      SizedBox(width: 5,),
                                                      Expanded(
                                                        child: TextHeading(
                                                            name:
                                                            "---"),
                                                      ),
                                                      Expanded(
                                                        child: TextHeading
                                                          (
                                                            name: "---"),
                                                      ),
                                                      Expanded(
                                                        child: TextHeading(
                                                          name: "---",
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: TextHeading(

                                                            name:
                                                            "---"),
                                                      ),
                                                      SizedBox(width: 2,),
                                                    ],
                                                  )


                                                      :

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
                                                  child: Column(
                                                    children: [
                                                      mon == current_month &&
                                                              int.parse(
                                                                      day) ==
                                                                  ramzan_current_day
                                                          ? Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: [

                                                                SizedBox(width: 2,),
                                                                TextWidget(
                                                                    name: (snapshot
                                                                            .data!
                                                                            .data![index]
                                                                            .date!
                                                                            .hijri!
                                                                            .day)
                                                                        .toString()),
                                                                SizedBox(width: 5,),
                                                                TextWidget(
                                                                    name:
                                                                        weekInThreeChar),


                                                                TextWidget(name: fullDate),
                                                                TextWidget(
                                                                    name:
                                                                        sehr+" am "),
                                                                TextWidget(
                                                                    name:
                                                                        ifttime+" pm "),
                                                                SizedBox(width: 2,),
                                                              ],
                                                            )
                                                          : Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: [
                                                                SizedBox(width: 2,),
                                                                CurrentRoza(
                                                                    name: (snapshot
                                                                            .data!
                                                                            .data![index]
                                                                            .date!
                                                                            .hijri!
                                                                            .day)
                                                                        .toString()),
                                                                SizedBox(width: 5,),
                                                                CurrentRoza(
                                                                    name: weekInThreeChar
                                                                        .toString()),

                                                                CurrentRoza(name: fullDate),
                                                                CurrentRoza(
                                                                    name:
                                                                        sehr+" am "),
                                                                CurrentRoza(
                                                                    name:
                                                                        ifttime+" pm "),
                                                                SizedBox(width: 2,),
                                                              ],
                                                            )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return const Icon(Icons.error_outline);
                      } else {
                        return Center(child: const Text("Fetching your Location...."));
                      }
                    })),
          ),
        ));
  }
}
