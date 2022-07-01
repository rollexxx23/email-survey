import 'dart:convert';
import 'dart:html';
import 'package:http/browser_client.dart';
import 'package:http/http.dart' as http;
import 'package:client/provider/user.dart';
import 'package:client/views/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './util.dart' if (dart.library.html) 'dart:ui' as ui;

class Webpayment extends StatelessWidget {
  final String? name;
  final String? image;
  final int? price;
  Webpayment({this.name, this.price, this.image});
  void success(context) async {
    var client = BrowserClient()..withCredentials = true;
    http.Response response;
    const url = "http://localhost:5000/api/payment";

    try {
      response = await client.post(
        Uri.parse(url),
        headers: {"content-type": "application/json"},
      );
      var credits = Provider.of<UserWrapper>(context, listen: false).userCredit;
      var data = jsonDecode(response.body);
      print(data);
      Provider.of<UserWrapper>(context, listen: false)
          .updateCredits(data["credits"]);
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
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory("rzp-html", (int viewId) {
      IFrameElement element = IFrameElement();
      window.onMessage.forEach((element) {
        print('Event Received in callback: ${element.data}');
        if (element.data == 'MODAL_CLOSED') {
          Navigator.pop(context);
        } else if (element.data == 'SUCCESS') {
          Navigator.pop(context);
          print('PAYMENT SUCCESSFULL!!!!!!!');
          success(context);
        }
      });

      element.src = 'assets/checkout.html?name=$name&price=$price';
      element.style.border = 'none';

      return element;
    });
    return Scaffold(body: Builder(builder: (BuildContext context) {
      return Container(
        child: HtmlElementView(viewType: 'rzp-html'),
      );
    }));
  }
}


// to do:
// improve landing page
// give 5 credits for free
// 3 plans
// better ux