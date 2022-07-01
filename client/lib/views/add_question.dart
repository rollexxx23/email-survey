import 'package:client/provider/user.dart';
import 'package:client/views/dashboard.dart';
import 'package:client/views/landing-page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:http/browser_client.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

int curr = 1;

TextEditingController titleController = TextEditingController();
TextEditingController subjectController = TextEditingController();
TextEditingController bodyController = TextEditingController();
TextEditingController recipientsController = TextEditingController();
String titleErrorMessage = "";
String subjectErrorMessage = "";
String bodyErrorMessage = "";
String recipientsErrorMessage = "";

class AddSurvey extends StatefulWidget {
  const AddSurvey({Key? key}) : super(key: key);

  @override
  State<AddSurvey> createState() => _AddSurveyState();
}

class _AddSurveyState extends State<AddSurvey> {
  void createSurvey() async {
    Map<String, String> body = {
      "title": titleController.text,
      "subject": subjectController.text,
      "body": bodyController.text,
      "recipients": recipientsController.text
    };
    var client = BrowserClient()..withCredentials = true;
    http.Response response;
    const url = "http://localhost:5000/api/surveys";
    print(body);
    try {
      response = await client.post(Uri.parse(url),
          headers: {"content-type": "application/json"},
          body: jsonEncode(body));
      var credits = Provider.of<UserWrapper>(context, listen: false).userCredit;
      Provider.of<UserWrapper>(context, listen: false)
          .updateCredits(credits - 1);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => DashBoard()),
          ModalRoute.withName('/'));
    } finally {
      client.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
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
                        Container(
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
                            style: TextStyle(color: Colors.white, fontSize: 12),
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
            "Create Survey",
            style: GoogleFonts.mulish(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: StepProgressIndicator(
              totalSteps: 2,
              currentStep: curr,
              unselectedColor: Color(0xffFF8B4A),
              selectedColor: Color(0xff00B1B9),
            ),
          ),
          const SizedBox(height: 30),
          (curr == 1) ? FormSection(context) : ReviewSection()
        ]),
      ),
    );
  }

  Widget FormSection(BuildContext context) {
    return Material(
      elevation: 2.0,
      child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          height: 600,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 42,
                        width: 98,
                        margin: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Color(0xFFDBDBDB))),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Icon(Icons.arrow_back_ios_new,
                                  size: 12, color: Color(0xffB0B0B0)),
                              SizedBox(width: 3),
                              Padding(
                                padding: EdgeInsets.only(top: 2.5),
                                child: Text(
                                  "Back",
                                  style: TextStyle(
                                      fontFamily: 'SharpSans',
                                      color: Color(0xffB0B0B0),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Text(
                        "Enter Required Details",
                        style: GoogleFonts.mulish(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 42,
                        width: 98,
                      )
                    ]),
                const SizedBox(height: 10),
                FormFields("Email Title", titleController, 0),
                SizedBox(
                  height: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 10),
                      Text(titleErrorMessage,
                          style: TextStyle(color: Colors.red, fontSize: 8)),
                    ],
                  ),
                ),
                FormFields("Email Subject", subjectController, 1),
                SizedBox(
                  height: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 10),
                      Text(subjectErrorMessage,
                          style: TextStyle(color: Colors.red, fontSize: 8)),
                    ],
                  ),
                ),
                FormFields("Email Body", bodyController, 2),
                SizedBox(
                  height: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 10),
                      Text(bodyErrorMessage,
                          style: TextStyle(color: Colors.red, fontSize: 8)),
                    ],
                  ),
                ),
                FormFields("Email Recipients", recipientsController, 3),
                SizedBox(
                  height: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 10),
                      Text(recipientsErrorMessage,
                          style: TextStyle(color: Colors.red, fontSize: 8)),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: (validateTitle(titleController.text) &&
                              validateSubject(subjectController.text) &&
                              validateBody(bodyController.text) &&
                              validateRecipients(recipientsController.text))
                          ? () {
                              setState(() {
                                curr = 2;
                              });
                            }
                          : null,
                      child: Container(
                          height: 41,
                          width: 120,
                          decoration: BoxDecoration(
                              color: Color(0xff00B1B9),
                              border: Border.all(
                                color: Colors.transparent,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4))),
                          child: const Center(
                            child: Text(
                              "Next",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          )),
                    ),
                    const SizedBox(width: 10)
                  ],
                )
              ],
            ),
          )),
    );
  }

  Widget ReviewSection() {
    return Material(
      elevation: 2.0,
      child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          height: 600,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 42,
                        width: 98,
                        margin: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Color(0xFFDBDBDB))),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              curr = 1;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Icon(Icons.arrow_back_ios_new,
                                  size: 12, color: Color(0xffB0B0B0)),
                              SizedBox(width: 3),
                              Padding(
                                padding: EdgeInsets.only(top: 2.5),
                                child: Text(
                                  "Back",
                                  style: TextStyle(
                                      fontFamily: 'SharpSans',
                                      color: Color(0xffB0B0B0),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Text(
                        "Review and Submit",
                        style: GoogleFonts.mulish(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 42,
                        width: 98,
                      )
                    ]),
                const SizedBox(height: 10),
                ReviewFields("Email Title", titleController),
                const SizedBox(height: 10),
                ReviewFields("Email Subject", subjectController),
                const SizedBox(height: 10),
                ReviewFields("Email Body", bodyController),
                const SizedBox(height: 10),
                ReviewFields("Email Recipients", recipientsController),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        createSurvey();
                      },
                      child: Container(
                          height: 41,
                          width: 150,
                          decoration: BoxDecoration(
                              color: Color(0xff00B1B9),
                              border: Border.all(
                                color: Colors.transparent,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4))),
                          child: const Center(
                            child: Text(
                              "Create Survey",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          )),
                    ),
                    const SizedBox(width: 10)
                  ],
                )
              ],
            ),
          )),
    );
  }

  Widget FormFields(
      String header, TextEditingController valcontroller, int idx) {
    List<dynamic> functions = [
      validateTitle,
      validateSubject,
      validateBody,
      validateRecipients,
    ];
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Align(
            alignment: const Alignment(-1.0, 0.0),
            child: Text(
              header,
              style: const TextStyle(
                fontFamily: 'SharpSans',
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            height: 45,
            child: TextFormField(
              obscureText: false,
              controller: valcontroller,
              onChanged: (val) {
                functions[idx](val);
              },
              decoration: InputDecoration(
                hintText: 'Enter $header',
                hintStyle: const TextStyle(
                    fontFamily: 'SharpSans',
                    color: Color(0xff7B7B7B),
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xFFB0B0B0), width: 1),
                  borderRadius: BorderRadius.circular(5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xFF3867D6), width: 1),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget ReviewFields(String header, TextEditingController valcontroller) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Align(
            alignment: const Alignment(-1.0, 0.0),
            child: Text(
              header,
              style: const TextStyle(
                fontFamily: 'SharpSans',
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            SizedBox(
              height: 45,
              child: Center(
                child: Text(
                  valcontroller.text.toString(),
                  style: GoogleFonts.mulish(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ]),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.5 - 30,
              child: Divider(
                color: Color(0xffB0B0B0),
              ))
        ],
      ),
    );
  }

  bool validateTitle(String val) {
    if (val.isEmpty) {
      setState(() {
        titleErrorMessage = "Title can not be empty";
      });
      return false;
    }
    setState(() {
      titleErrorMessage = "";
    });
    return true;
  }

  bool validateSubject(String val) {
    if (val.isEmpty) {
      setState(() {
        subjectErrorMessage = "Subject can not be empty";
      });
      return false;
    }
    setState(() {
      subjectErrorMessage = "";
    });
    return true;
  }

  bool validateBody(String val) {
    if (val.isEmpty) {
      setState(() {
        bodyErrorMessage = "Body can not be empty";
      });
      return false;
    }
    setState(() {
      bodyErrorMessage = "";
    });
    return true;
  }

  bool validateRecipients(String val) {
    if (val.isEmpty) {
      setState(() {
        recipientsErrorMessage = "Recipients list cannot be empty";
      });
      return false;
    }
    var emailList = val
        .split(
          ',',
        )
        .map((e) => e.trim())
        .where((e) => !RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(e))
        .toList();

    if (emailList.isNotEmpty) {
      setState(() {
        recipientsErrorMessage = "Invalid emails -> ${emailList.toString()}";
      });
      return false;
    }
    setState(() {
      recipientsErrorMessage = "";
    });
    return true;
  }
}
