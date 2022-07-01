import 'package:client/checkout/checkout.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/browser_client.dart';
import 'package:url_launcher/url_launcher.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Stack(
            children: [
              Container(
                  child: Image.asset("assets/images/Background.png",
                      height: MediaQuery.of(context).size.height * 0.70,
                      fit: BoxFit.fill,
                      width: MediaQuery.of(context).size.width)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Center(
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset("assets/images/02.png"),
                            InkWell(
                              onTap: () async {
                                launch("http://localhost:5000/auth/google");
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
                                      "Sign in with Google",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  )),
                            )
                          ],
                        )),
                  ),
                  const SizedBox(height: 100),
                  Center(
                    child: Text(
                      "Emaily Survey App",
                      style: GoogleFonts.mulish(
                          color: Colors.white,
                          fontSize: 52,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      "We will enable anyone to survey highly specific target groups. \nConduct market research in hours rather than weeks and make better decisions using customer opinions. \nIn couple of simple steps ",
                      style: GoogleFonts.mulish(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w300),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Center(
                      child: InkWell(
                    child: Container(
                        height: 41,
                        width: 100,
                        decoration: BoxDecoration(
                            color: Color(0xffFF8B4A),
                            border: Border.all(
                              color: Colors.transparent,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        child: const Center(
                          child: Text(
                            "Try Now",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        )),
                  )),
                  const SizedBox(height: 35),
                  Image.asset(
                    "assets/images/landing-image.jpg",
                    height: 300,
                  ),
                  const SizedBox(height: 100),
                  Text(
                    "Used by 100+ organizations across the world",
                    style: GoogleFonts.mulish(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10),
                  Image.asset("assets/images/companies.png"),
                  const SizedBox(height: 50),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Here From \nOur Users",
                          style: GoogleFonts.mulish(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          "",
                          style: GoogleFonts.mulish(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          )
        ]),
      ),
    );
  }
}
