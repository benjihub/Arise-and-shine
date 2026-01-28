import 'package:arise_and_shine/components/flutterwave_checkout.dart';
import 'package:arise_and_shine/constants/constants.dart';
import 'package:arise_and_shine/controllers/home_controller.dart';
import 'package:arise_and_shine/controllers/ministry_controller.dart';
import 'package:arise_and_shine/controllers/profile_controller.dart';
import 'package:arise_and_shine/widgets/our_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GivingScreen extends StatefulWidget {
  const GivingScreen({super.key});

  @override
  State<GivingScreen> createState() => _GivingScreenState();
}

class _GivingScreenState extends State<GivingScreen> {
  final ministryController = Get.find<MinistryController>();
  final profileController = Get.find<ProfileController>();
  final homeController = Get.find<HomeController>();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();

  String? selectedCategory;

  var isLoading = false;

  @override
  void initState() {
    _nameController.text = profileController.userDetails['name'] ?? "";
    emailController.text = profileController.userDetails['email'] ?? "";
    _contactController.text = profileController.userDetails['phone'] ?? "";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> categories = (ministryController.settings['donation']
            ?['donation_type'] as List<dynamic>)
        .map((item) => item.toString())
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: "give".tr.text.make(),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "select_category".tr,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .bottomNavigationBarTheme
                        .backgroundColor,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(12),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        DropdownButtonFormField<String>(
                          value: selectedCategory,
                          items: categories
                              .map((category) => DropdownMenuItem<String>(
                                    value: category,
                                    child: Text(category),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCategory = value;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: "choose_category".tr,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please select a category";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "amount_in_tzs".tr,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            prefixIcon: const Icon(Icons.money_rounded),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter an amount";
                            }
                            if (double.tryParse(value) == null) {
                              return "Please enter a valid number";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: "name".tr,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            prefixIcon: const Icon(Icons.person),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your name";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _contactController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: "contact".tr,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            prefixIcon: const Icon(Icons.phone),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your contact";
                            }
                            if (value.length < 10) {
                              return "Please enter a valid contact number";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: "email".tr,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            prefixIcon: const Icon(Icons.email),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your email";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ourButton(
                      onPress: () {
                        if (_formKey.currentState!.validate()) {
                          _startPayment();
                        }
                      },
                      title: "submit".tr,
                      color: primaryColor,
                      textColor: whiteColor),
                ),
                // 10.heightBox,
                // isLoading
                //     ? loadingIndicator()
                //     : SizedBox(
                //         width: double.infinity,
                //         child: ourButton(
                //             onPress: () {
                //               if (_formKey.currentState!.validate()) {
                //                 initiateMobileMoneyPayment();
                //               }
                //             },
                //             title: "use_mobile_money".tr,
                //             color: primaryColor,
                //             textColor: whiteColor),
                //       ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _startPayment() {
    String amount = _amountController.text.trim();
    String name = _nameController.text.trim();
    String contact = _contactController.text.trim();
    String publicKey = ministryController.settings['payment_gateways']
        ['flutterwave']['public_key'];
    String txRef = "txref-${DateTime.now().millisecondsSinceEpoch}";
    String email = emailController.text.trim();

    Get.to(() => FlutterwavePaymentScreen(
          publicKey: publicKey,
          amount: double.parse(amount),
          txRef: txRef,
          email: email,
          phone: contact,
          name: name,
        ));
  }

  // Future<void> initiateMobileMoneyPayment() async {
  //   setState(() {
  //     isLoading = true;
  //   });

  //   homeController.hideKeyboard();

  //   String amount = _amountController.text.trim();
  //   String name = _nameController.text.trim();
  //   String contact = _contactController.text.trim();
  //   String email = emailController.text.trim();

  //   final url = Uri.parse(
  //       'https://api.flutterwave.com/v3/charges?type=mobile_money_tanzania');

  //   final headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization':
  //         'Bearer ${ministryController.settings['payment_gateways']['flutterwave']['secret_key']}',
  //   };

  //   final body = json.encode({
  //     "tx_ref": "txref-${DateTime.now().millisecondsSinceEpoch}",
  //     "amount": amount.toString(),
  //     "currency": "TZS",
  //     "email": email,
  //     "name": name,
  //     "phone_number": contact,
  //   });

  //   try {
  //     final response = await http.post(url, headers: headers, body: body);

  //     if (response.statusCode == 200) {
  //       final responseData = json.decode(response.body);
  //       print(responseData);

  //       if (responseData['status'] == 'success') {
  //         setState(() {
  //           isLoading = false;
  //         });

  //         showSuccessDialog(context);

  //         // Handle success (e.g., navigate or show success message)
  //       } else {
  //         setState(() {
  //           isLoading = false;
  //         });

  //         // Handle failure (e.g., show error message)
  //         showFailureDialog(context,
  //             "Failed to initiate donation: ${responseData['message']}");
  //       }
  //     } else {
  //       setState(() {
  //         isLoading = false;
  //       });

  //       // Handle server errors
  //       showFailureDialog(context, "Error: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     setState(() {
  //       isLoading = false;
  //     });

  //     // Handle network errors
  //     showFailureDialog(context, "Error: $e");
  //   }
  // }

  // void showSuccessDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text("Donation Initiated"),
  //         content:
  //             const Text("Please complete the donation on your mobile device."),
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //               Navigator.pop(context);
  //             },
  //             child: const Text("OK"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // void showFailureDialog(BuildContext context, String message) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text("Donation Initiation Failed"),
  //         content: Text(message),
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text("OK"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
