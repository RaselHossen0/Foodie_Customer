import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pizza/constants.dart';
import 'package:pizza/services/helper.dart';
import 'package:pizza/ui/dineInScreen/HistoryTableBooking.dart';
import 'package:pizza/ui/dineInScreen/UpComingTableBooking.dart';

class MyBookingScreen extends StatefulWidget {
  const MyBookingScreen({Key? key}) : super(key: key);

  @override
  State<MyBookingScreen> createState() => _MyBookingScreenState();
}

class _MyBookingScreenState extends State<MyBookingScreen> {
  List<Widget> list = [
    Tab(text: ("Upcoming".tr())),
    Tab(text: ("History".tr())),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor:
              isDarkMode(context) ? Color(DARK_COLOR) : Color(0xffFFFFFF),
          appBar: TabBar(
            labelColor: Color(COLOR_PRIMARY),
            indicatorColor: Color(COLOR_PRIMARY),
            unselectedLabelColor: Color(GREY_TEXT_COLOR),
            indicatorSize: TabBarIndicatorSize.label,
            tabs: list,
          ),
          body: TabBarView(children: [
            UpComingTableBooking(),
            HistoryTableBooking(),
          ])),
    );
  }
}
