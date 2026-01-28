import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FlutterwavePaymentScreen extends StatefulWidget {
  final String publicKey;
  final double amount;
  final String txRef;
  final String email;
  final String phone;
  final String name;

  const FlutterwavePaymentScreen({
    super.key,
    required this.publicKey,
    required this.amount,
    required this.txRef,
    required this.email,
    required this.phone,
    required this.name,
  });

  @override
  State<FlutterwavePaymentScreen> createState() =>
      _FlutterwavePaymentScreenState();
}

class _FlutterwavePaymentScreenState extends State<FlutterwavePaymentScreen> {
  late final WebViewController _controller;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        "FlutterwavePayment",
        onMessageReceived: (JavaScriptMessage message) {
          var data = message.message;

          final Map<String, dynamic> jsonData = jsonDecode(data);

          if (kDebugMode) {
            print(data);
          }
          if (data == "payment_closed") {
            _handlePaymentClose();
          } else if (jsonData['status'] == "successful") {
            _handlePaymentSuccess(data);
          }
        },
      )
      ..loadHtmlString(_generateHtml());
  }

  /// Function to handle closing the payment and navigating back
  void _handlePaymentClose() {
    Navigator.pop(context);
  }

  /// Function to store successful payment details in Firestore
  Future<void> _handlePaymentSuccess(String paymentData) async {
    try {
      final Map<String, dynamic> json = jsonDecode(paymentData);

      // Dynamically extract the payment details
      Map<String, dynamic> paymentDetails = {};

      // Iterate over the JSON and add keys dynamically
      json.forEach((key, value) {
        if (key == "customer") {
          // Handle the customer data as a nested map
          paymentDetails["customer"] = {
            "name": value["name"],
            "email": value["email"],
            "phone_number": value["phone_number"],
          };
        } else if (key == "timestamp") {
          // Handle Firestore timestamp
          paymentDetails["timestamp"] = FieldValue.serverTimestamp();
        } else {
          // Add other keys directly
          paymentDetails[key] = value;
        }
      });

      // Store the payment details in Firestore
      await _firestore.collection("donations").add(paymentDetails);

      if (kDebugMode) {
        print("Donations saved successfully!");
      }

      // Navigate back to the previous screen after storing the payment
      Navigator.pop(context);
    } catch (e) {
      if (kDebugMode) {
        print("Error saving donation: $e");
      }
    }
  }

  String _generateHtml() {
    return '''
  <!DOCTYPE html>
  <html lang="en">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://checkout.flutterwave.com/v3.js"></script>
    <style>
      body {
        font-size: 14px;
        font-family: "Moderat","Inter",sans-serif;
        font-weight: 400;
        color: #333;
        text-align: center;
        padding: 50px;
      }
    </style>
  </head>
  <body>
    <script>
      window.onload = function() {
        makePayment();
      };

      function makePayment() {
        FlutterwaveCheckout({
          public_key: "${widget.publicKey}",
          tx_ref: "${widget.txRef}",
          amount: ${widget.amount},
          currency: "TZS",
          payment_options: "card, banktransfer, ussd",
          customer: {
            email: "${widget.email}",
            phone_number: "${widget.phone}",
            name: "${widget.name}",
          },
          customizations: {
            title: "Flutterwave Payment",
            description: "Donation Payment",
            logo: "https://checkout.flutterwave.com/assets/img/rave-logo.png",
          },
          callback: function (data) {
            window.FlutterwavePayment.postMessage(JSON.stringify(data));
          },
          onclose: function() {
            window.FlutterwavePayment.postMessage("payment_closed");
          }
        });
      }
    </script>
  </body>
  </html>
  ''';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Donation"),
        centerTitle: true,
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
