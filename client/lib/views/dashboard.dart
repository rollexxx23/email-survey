import 'dart:convert';

import 'package:client/checkout/checkout.dart';
import 'package:client/main.dart';
import 'package:client/models/survey_model.dart';
import 'package:client/provider/user.dart';
import 'package:client/views/add_question.dart';
import 'package:client/views/landing-page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/browser_client.dart';
import 'package:provider/provider.dart';

List<Survey> surveyList = [];
bool surveyLoading = true;

Future<void> logout() async {
  var client = BrowserClient()..withCredentials = true;
  http.Response response;
  print("LOgout");
  const url = "http://localhost:5000/api/logout";
  try {
    response = await client.get(
      Uri.parse(url),
    );
  } finally {
    client.close();
  }
}

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  void sortByDate() {
    surveyList.sort((a, b) => a.lastRes.compareTo(b.lastRes));
    setState(() {
      surveyList = surveyList;
    });
  }

  void getSurveyList() async {
    var client = BrowserClient()..withCredentials = true;
    http.Response response;
    const url = "http://localhost:5000/api/survey-list";

    try {
      setState(() {
        surveyList = [];
      });
      response = await client.get(
        Uri.parse(url),
      );
      print(response.body);
      var data = await jsonDecode(response.body);

      for (dynamic singleData in data) {
        surveyList.add(Survey(
            subject: singleData["subject"].toString(),
            body: singleData["body"].toString(),
            yes_cnt: singleData["yes"],
            no_cnt: singleData["no"],
            lastRes: singleData["lastResponded"] == null
                ? "---"
                : singleData["lastResponded"],
            pubDate: singleData["publishDate"].toString().substring(0, 10),
            title: singleData["title"]));
      }

      setState(() {
        surveyList = surveyList;
        surveyLoading = false;
        print(surveyList[0].lastRes);
      });
    } finally {
      client.close();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getSurveyList();
    surveyLoading = true;
    getCurrentUser(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF1F3F5),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddSurvey()));
        },
        backgroundColor: Color(0xffFF8B4A),
        child: const Icon(
          Icons.add_box,
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //const SizedBox(height: 10),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 01,
                color: Color(0xff00B1B9),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset("assets/images/02.png"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Credit: ${Provider.of<UserWrapper>(context, listen: false).userCredit.toString()}",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          const SizedBox(width: 15),
                          InkWell(
                            onTap: () {
                              print("ogghfhfhg");
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Webpayment(
                                            name: "1 Survey for 78 INR",
                                            image: "",
                                            price: 78 * 100,
                                          )));
                            },
                            child: Container(
                                height: 41,
                                width: 150,
                                decoration: BoxDecoration(
                                    color: Color(0xffFF8B4A),
                                    border: Border.all(
                                      color: Colors.transparent,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8))),
                                child: const Center(
                                  child: Text(
                                    "Add Credits",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                )),
                          ),
                          const SizedBox(width: 15),
                          InkWell(
                            onTap: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          LandingPage()),
                                  ModalRoute.withName('/'));
                              logout();
                            },
                            child: const Text(
                              "Logout",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 100),
            Text(
              "Welcome Back",
              style: GoogleFonts.mulish(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 100),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Your Past Surveys",
                          style: GoogleFonts.mulish(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddSurvey()));
                      },
                      child: Container(
                        width: 150,
                        height: 41,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.8),
                              offset: Offset(-4.0, -4.0),
                              blurRadius: 10.0,
                            ),
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              offset: Offset(4.0, 4.0),
                              blurRadius: 10.0,
                            ),
                          ],
                          color: Color(0xFFEFEEEE),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: Text("Create Survey",
                              style: GoogleFonts.mulish(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.1),
                child: (surveyList.isEmpty)
                    ? (surveyLoading)
                        ? const CircularProgressIndicator()
                        : const Text("No survey created")
                    : Expanded(
                        child: GridView.builder(
                        padding: const EdgeInsets.only(
                            left: 5.0, right: 5.0, top: 10, bottom: 10),
                        shrinkWrap: true,
                        //physics: NeverScrollableScrollPhysics(),
                        itemCount: surveyList.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: 25.0,
                                mainAxisSpacing: 25.0,
                                crossAxisCount: 2,
                                childAspectRatio: 2.5),
                        itemBuilder: (context, index) {
                          final Survey item = surveyList[index];
                          print(item.title);
                          return SurveyWidget(
                            context,
                            item.title,
                            item.subject,
                            item.body,
                            item.yes_cnt,
                            item.no_cnt,
                            item.pubDate,
                            item.lastRes,
                          );
                        },
                      ))),
            const SizedBox(height: 30),

            // Center(
            //   child: Text("No survey found",
            //       style: GoogleFonts.mulish(
            //           color: Colors.red,
            //           fontSize: 12,
            //           fontWeight: FontWeight.w700)),
            // )
          ],
        ),
      ),
    );
  }

  Widget SurveyWidget(BuildContext context, String title, String subject,
      String body, int yes_cnt, int no_cnt, String pubDate, String lastRes) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.35,
      height: 250,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.transparent,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: GoogleFonts.mulish(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  pubDate,
                  style: GoogleFonts.mulish(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Subject:",
                  style: GoogleFonts.mulish(
                      color: Color(0xff00B1B9),
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 3),
                Text(
                  subject,
                  style: GoogleFonts.mulish(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Body:   ",
                  style: GoogleFonts.mulish(
                      color: Color(0xff00B1B9),
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 3),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: Text(
                    body,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.mulish(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Center(
                child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.25,
              child: Divider(
                color: Color(0xffFBFBFB),
              ),
            )),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Last Responded",
                      style: GoogleFonts.mulish(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      (lastRes == "---") ? "---" : lastRes.substring(0, 10),
                      style: GoogleFonts.mulish(
                          color: Color(0xff00B1B9),
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                (lastRes == "---")
                    ? Text(
                        "No response Yet",
                        style: GoogleFonts.mulish(
                            color: Color(0xffFF8B4A),
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      )
                    : circularMeter(yes_cnt, no_cnt)
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget circularMeter(var yes, var no) {
    return SizedBox(
      height: 25,
      width: 25,
      child: CircularProgressIndicator(
        strokeWidth: 5,
        value: yes / (yes + no),
        color: Color(0xff00B1B9),
        backgroundColor: Color(0xffFF8B4A),
        // semanticsLabel: 'Linear progress indicator',
      ),
    );
  }
}
