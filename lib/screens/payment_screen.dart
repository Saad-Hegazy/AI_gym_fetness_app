// import 'dart:convert';
// import 'dart:io';
// import 'dart:math';
//
// import 'package:bambara_flutter/bambara_flutter.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_mobx/flutter_mobx.dart';
//
// //import 'package:flutter_paystack/flutter_paystack.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:http/http.dart' as http;
// import 'package:grip/components/tab_payment.dart';
// import 'package:grip/screens/web_view_screen.dart';
// import 'package:my_fatoorah/my_fatoorah.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
//
// import '../extensions/LiveStream.dart';
// import '../extensions/animatedList/animated_list_view.dart';
// import '../extensions/app_button.dart';
// import '../extensions/decorations.dart';
// import '../extensions/extension_util/int_extensions.dart';
// import '../extensions/extension_util/string_extensions.dart';
// import '../extensions/extension_util/widget_extensions.dart';
// import '../extensions/loader_widget.dart';
// import '../extensions/shared_pref.dart';
// import '../extensions/system_utils.dart';
// import '../extensions/text_styles.dart';
// import '../extensions/widgets.dart';
// import '../main.dart';
// import '../models/payment_list_model.dart';
// import '../models/stripe_pay_model.dart';
// import '../models/subscription_response.dart';
// import '../network/network_utils.dart';
// import '../network/rest_api.dart';
// import '../screens/no_data_screen.dart';
// import '../utils/app_colors.dart';
// import '../utils/app_common.dart';
// import '../utils/app_config.dart';
// import '../utils/app_constants.dart';
//
// class PaymentScreen extends StatefulWidget {
//   static String tag = '/payment_screen';
//   final SubscriptionModel? mSubscriptionModel;
//
//   PaymentScreen({this.mSubscriptionModel});
//
//   @override
//   PaymentScreenState createState() => PaymentScreenState();
// }
//
// class PaymentScreenState extends State<PaymentScreen> {
//   List<PaymentModel> paymentList = [];
//
//   String clientId = 'Ac8LLq1kIPUq1mdExtXHlim208LHG4pV_VagO3F297Qjv1xMswNlVzLPCWFLd40GO5jyXsIfC-Ef89la';
//   String clientSecret = 'EOiDT5b9f7C8BZjrUtO1I-VNTm4zS9mys-2QgIDRRY543nXsfM3ebSClAl7WftDAdiaHJQZqiKYVu-oC';
//
//   String? selectedPaymentType,
//       stripPaymentKey,
//       stripPaymentPublishKey,
//       payStackPublicKey,
//       payPalTokenizationKey,
//       flutterWavePublicKey,
//       flutterWaveSecretKey,
//       flutterWaveEncryptionKey,
//       payTabsProfileId,
//       payTabsServerKey,
//       payTabsClientKey,
//       myFatoorahToken,
//       paytmMerchantId,
//       orangeMoneyPublicKey,
//       paytmMerchantKey;
//
//   String? razorKey;
//
//   bool isPaytmTestType = true;
//   bool isFatrooahTestType = true;
//   bool loading = false;
//
//   // final plugin = PaystackPlugin();
//
//   late Razorpay _razorpay;
//
//   // CheckoutMethod method = CheckoutMethod.card;
//
//   @override
//   void initState() {
//     super.initState();
//     init();
//   }
//
//   @override
//   void dispose() {
//     appStore.setLoading(false);
//     super.dispose();
//   }
//
//   void init() async {
//     await paymentListApiCall();
//     if (paymentList.any((element) => element.type == PAYMENT_TYPE_STRIPE)) {
//       Stripe.publishableKey = stripPaymentPublishKey.validate();
//       Stripe.merchantIdentifier = mStripeIdentifier;
//       await Stripe.instance.applySettings().catchError((e) {
//         log("${e.toString()}");
//       });
//     }
//     if (paymentList.any((element) => element.type == PAYMENT_TYPE_PAYSTACK)) {
//       print("---------109>>>${payStackPublicKey.validate()}");
//       // plugin.initialize(publicKey: payStackPublicKey.validate());
//     }
//     if (paymentList.any((element) => element.type == PAYMENT_TYPE_RAZORPAY)) {
//       _razorpay = Razorpay();
//       _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//       _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//       _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//     }
//   }
//
//   /// Get Payment Gateway Api Call
//   Future<void> paymentListApiCall() async {
//     appStore.setLoading(true);
//     await getPaymentApi().then((value) {
//       appStore.setLoading(false);
//       paymentList.addAll(value.data!);
//       if (paymentList.isNotEmpty) {
//         paymentList.forEach((element) {
//           if (element.type == PAYMENT_TYPE_STRIPE) {
//             stripPaymentKey = element.isTest == 1 ? element.testValue!.secretKey : element.liveValue!.secretKey;
//             // stripPaymentKey = 'sk_test_51GrhA2Bz1ljKAgF9FIJPLupBUCHFCOy5rS6LCnYHSu6Od0Qyx3TElGbxIu8BGRvq14fgidGOYyNkQPivZGnzWoVt004fCZxVdk';
//             stripPaymentPublishKey = element.isTest == 1 ? element.testValue!.publishableKey : element.liveValue!.publishableKey;
//             //stripPaymentPublishKey = 'pk_test_51GrhA2Bz1ljKAgF98fI6WfB2YUn4CewOB0DNQC1pSeXspUc1LlUYs3ou19oPF0ATcqa52FXTYmv6v0mkvPZb9BSD00SUpBj9tI';
//           } else if (element.type == PAYMENT_TYPE_PAYSTACK) {
//             payStackPublicKey = element.isTest == 1 ? element.testValue!.publicKey : element.liveValue!.publicKey;
//           } else if (element.type == PAYMENT_TYPE_RAZORPAY) {
//             razorKey = element.isTest == 1 ? element.testValue!.keyId.validate() : element.liveValue!.keyId.validate();
//           } else if (element.type == PAYMENT_TYPE_PAYPAL) {
//             payPalTokenizationKey = element.isTest == 1 ? element.testValue?.tokenizationKey : element.liveValue?.tokenizationKey;
//           } else if (element.type == PAYMENT_TYPE_FLUTTERWAVE) {
//             flutterWavePublicKey = element.isTest == 1 ? element.testValue!.publicKey : element.liveValue!.publicKey;
//             flutterWaveSecretKey = element.isTest == 1 ? element.testValue!.secretKey : element.liveValue!.secretKey;
//             flutterWaveEncryptionKey = element.isTest == 1 ? element.testValue!.encryptionKey : element.liveValue!.encryptionKey;
//           } else if (element.type == PAYMENT_TYPE_PAYTABS) {
//             payTabsProfileId = element.isTest == 1 ? element.testValue!.profileId : element.liveValue!.profileId;
//             payTabsClientKey = element.isTest == 1 ? element.testValue!.clientKey : element.liveValue!.clientKey;
//             payTabsServerKey = element.isTest == 1 ? element.testValue!.serverKey : element.liveValue!.serverKey;
//           } else if (element.type == PAYMENT_TYPE_MYFATOORAH) {
//             if (element.isTest == 1) {
//               isFatrooahTestType = true;
//             } else {
//               isFatrooahTestType = false;
//             }
//             myFatoorahToken = element.isTest == 1 ? element.testValue!.accessToken : element.liveValue!.accessToken;
//           } else if (element.type == PAYMENT_TYPE_PAYTM) {
//             if (element.isTest == 1) {
//               isPaytmTestType = true;
//             } else {
//               isPaytmTestType = false;
//             }
//             paytmMerchantId = element.isTest == 1 ? element.testValue!.merchantId : element.liveValue!.merchantId;
//             paytmMerchantKey = element.isTest == 1 ? element.testValue!.merchantKey : element.liveValue!.merchantKey;
//           } else if (element.type == PAYMENT_TYPE_ORANGE_MONEY) {
//             orangeMoneyPublicKey = element.isTest == 1 ? element.testValue!.publicKey : element.liveValue!.publicKey;
//           }
//         });
//       }
//       setState(() {});
//     }).catchError((error) {
//       appStore.setLoading(false);
//       log('${error.toString()}');
//     });
//   }
//
//   /// My Fatoorah Payment
//   Future<void> myFatoorahPayment() async {
//     PaymentResponse response = await MyFatoorah.startPayment(
//       context: context,
//       successChild: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(Icons.verified, size: 50, color: Colors.green),
//           16.height,
//           Text(languages.lblSuccess, style: boldTextStyle(color: Colors.green, size: 24)),
//         ],
//       ).center(),
//       errorChild: Center(child: Text("Failed", style: boldTextStyle(color: Colors.red, size: 24))),
//       request: isFatrooahTestType
//           ? MyfatoorahRequest.test(
//               currencyIso: Country.SaudiArabia,
//               successUrl: 'https://pub.dev/packages/get',
//               errorUrl: 'https://www.google.com/',
//               invoiceAmount: widget.mSubscriptionModel!.price.toString().validate().toDouble(),
//               language: appStore.selectedLanguageCode == 'ar' ? ApiLanguage.Arabic : ApiLanguage.English,
//               token: myFatoorahToken!,
//             )
//           : MyfatoorahRequest.live(
//               currencyIso: Country.SaudiArabia,
//               successUrl: 'https://pub.dev/packages/get',
//               errorUrl: 'https://www.google.com/',
//               invoiceAmount: widget.mSubscriptionModel!.price.toString().validate().toDouble(),
//               language: appStore.selectedLanguageCode == 'ar' ? ApiLanguage.Arabic : ApiLanguage.English,
//               token: myFatoorahToken!,
//             ),
//     );
//     if (response.isSuccess) {
//       paymentConfirm();
//     } else if (response.isError) {
//       toast("Failed");
//     }
//   }
//
//   ///Orange Money
//   // Future<void> orangeMoneyPayment() async {
//   //   const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
//   //   Random _rnd = Random();
//   //
//   //   String getRandomString(int length) => String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
//   //
//   //   appStore.setLoading(true);
//   //   await BambaraView(
//   //     data: BambaraData(
//   //       amount: widget.mSubscriptionModel!.price!.toInt(),
//   //       provider: 'bank-card',
//   //       reference: getRandomString(30),
//   //       phone: userStore.phoneNo.validate(),
//   //       email: userStore.email.validate(),
//   //       name: userStore.username.validate(),
//   //       publicKey: orangeMoneyPublicKey.validate(),
//   //     ),
//   //     onClosed: () => print("CLOSED"),
//   //     onError: (value) {
//   //       appStore.setLoading(false);
//   //     },
//   //     onSuccess: (value) {
//   //       print("Success" + value.toString());
//   //       appStore.setLoading(false);
//   //       paymentConfirm();
//   //     },
//   //     onRedirect: (data) => print(data),
//   //     onProcessing: (data) => print(data),
//   //     closeOnComplete: false,
//   //   ).show(context);
//   // }
//
//   /// Razor Pay
//   void razorPayPayment() {
//     var options = {
//       'key': razorKey.validate(),
//       'amount': (widget.mSubscriptionModel!.price!.toDouble() * 100).toInt(),
//       'name': APP_NAME,
//       'timeout': 60,
//       'description': mRazorDescription,
//       'retry': {'enabled': true, 'max_count': 1},
//       'send_sms_hash': true,
//       'prefill': {
//         'contact': getStringAsync(CONTACT_NUMBER),
//         'email': getStringAsync(EMAIL),
//       },
//       'external': {
//         'wallets': ['paytm']
//       }
//     };
//     try {
//       _razorpay.open(options);
//     } catch (e,s) {
//       print("---------266>>>>${e.toString()}");
//       print("---------267>>>>${s.toString()}");
//       debugPrint('Error: e');
//     }
//   }
//
//   void _handlePaymentSuccess(PaymentSuccessResponse response) {
//     toast(languages.lblSuccessMsg);
//     paymentConfirm();
//   }
//
//   void _handlePaymentError(PaymentFailureResponse response) {
//     _razorpay.clear();
//     toast("ERROR: " + response.code.toString() + " - " + response.message!);
//   }
//
//   void _handleExternalWallet(ExternalWalletResponse response) {
//     _razorpay.clear();
//     toast("EXTERNAL_WALLET: " + response.walletName!);
//   }
//
//   /// StripPayment
//   void stripePay() async {
//     Map<String, String> headers = {
//       HttpHeaders.authorizationHeader: 'Bearer ${stripPaymentKey.validate()}',
//       HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
//     };
//
//     var request = http.Request('POST', Uri.parse(stripeURL));
//
//     request.bodyFields = {'amount': '${(widget.mSubscriptionModel!.price!.toDouble() * 100).toInt()}', 'currency': "${userStore.currencyCode.toUpperCase()}", 'payment_method_types[]': 'card'};
//
//     log(request.bodyFields);
//     request.headers.addAll(headers);
//
//     log(request);
//
//     appStore.setLoading(true);
//
//     await request.send().then((value) {
//       http.Response.fromStream(value).then((response) async {
//         if (response.statusCode == 200) {
//           var res = StripePayModel.fromJson(await handleResponse(response));
//
//           SetupPaymentSheetParameters setupPaymentSheetParameters = SetupPaymentSheetParameters(
//             paymentIntentClientSecret: res.clientSecret.validate(),
//             style: ThemeMode.light,
//             appearance: PaymentSheetAppearance(colors: PaymentSheetAppearanceColors(primary: primaryColor)),
//             applePay: PaymentSheetApplePay(merchantCountryCode: "${userStore.currencySymbol.toUpperCase()}"),
//             googlePay: PaymentSheetGooglePay(merchantCountryCode: "${userStore.currencySymbol.toUpperCase()}", testEnv: true),
//             merchantDisplayName: APP_NAME,
//             customerId: userStore.userId.toString(),
//           );
//
//           await Stripe.instance.initPaymentSheet(paymentSheetParameters: setupPaymentSheetParameters).then((value) async {
//             await Stripe.instance.presentPaymentSheet().then((value) async {
//               paymentConfirm();
//             });
//           }).catchError((e) {
//             log("presentPaymentSheet ${e.toString()}");
//           });
//         }
//         appStore.setLoading(false);
//       }).catchError((e) {
//         appStore.setLoading(false);
//         toast(e.toString());
//       });
//     }).catchError((e) {
//       appStore.setLoading(false);
//       toast(e.toString());
//     });
//   }
//
//   ///PayStack Payment
//   void payStackPayment(BuildContext context) async {
//     appStore.setLoading(true);
//     final url = Uri.parse('https://api.paystack.co/transaction/initialize');
//
//     try {
//       final response = await http.post(
//         url,
//         headers: {'Authorization': 'Bearer sk_test_82c719a06347ed85a6c11fa952f00604ed8abea1'},
//         body: jsonEncode({
//           'email': 'customer@example.com',
//           'amount': 10 * 100,
//         }),
//       );
//       print("--------------352>>>${response.statusCode}");
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         print("--------------367>>>${data}");
//
//         String orderId = data['data']['authorization_url'];
//         String accessCode = data['data']['access_code'];
//         String reference = data['data']['reference'];
//         appStore.setLoading(false);
//         print("--------------367>>>${orderId}");
//         print("--------------363>>>${accessCode}");
//         print("--------------364>>>${reference}");
//         var abc = await WebViewScreen(
//                 onClick: (msg) {
//                   if (msg == "Success") {
//                     paymentConfirm();
//                   }
//                 },
//                 mInitialUrl: orderId)
//             .launch(context);
//         payStackPaymentStatus(reference);
//       } else {
//         appStore.setLoading(false);
//         print('Failed to create order: ${response.statusCode} - ${response.body}');
//         return null;
//       }
//     } catch (e) {
//       appStore.setLoading(false);
//       print('Error: $e');
//       return null;
//     }
//
//     /*  appStore.setLoading(true);
//     Charge charge = Charge()
//       ..amount = (widget.mSubscriptionModel!.price.toString().toDouble() * 100).toInt()
//       ..email = userStore.email.validate()
//       ..currency = userStore.currencyCode.toUpperCase();
//     charge.reference = _getReference();
//
//     try {
//       CheckoutResponse response = await plugin.checkout(context, method: method, charge: charge, fullscreen: false);
//       payStackUpdateStatus(response.reference, response.message);
//       if (response.message == 'Success') {
//         appStore.setLoading(false);
//         paymentConfirm();
//       } else {
//         appStore.setLoading(false);
//         toast(languages.lblPaymentFailed);
//       }
//     } catch (e) {
//       appStore.setLoading(false);
//       payStackShowMessage("Check console for error");
//       rethrow;
//     }*/
//   }
//
//   void payStackPaymentStatus(String? reference) async {
//     appStore.setLoading(true);
//     final url = Uri.parse('https://api.paystack.co/transaction/verify/${reference}');
//
//     try {
//       final response = await http.get(
//         url,
//         headers: {'Authorization': 'Bearer sk_test_82c719a06347ed85a6c11fa952f00604ed8abea1'},
//       );
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         print("--------------421>>>${data.toString()}");
//
//         String accessCode = data['data']['status'];
//         String message = data['data']['gateway_response'];
//         print("--------------419>>>${response.statusCode}");
//         if(accessCode=="success"){
//           paymentConfirm();
//           appStore.setLoading(false);
//
//         }else{
//           toast(message);
//           appStore.setLoading(false);
//         }
//       } else {
//         appStore.setLoading(false);
//         print('Failed to create order: ${response.statusCode} - ${response.body}');
//         return null;
//       }
//     } catch (e) {
//       appStore.setLoading(false);
//       print('Error: $e');
//       return null;
//     }
//   }
//
//   payStackUpdateStatus(String? reference, String message) {
//     payStackShowMessage(message, const Duration(seconds: 7));
//   }
//
//   void payStackShowMessage(String message, [Duration duration = const Duration(seconds: 4)]) {
//     toast(message);
//     log(message);
//   }
//
//   String _getReference() {
//     String platform;
//     if (Platform.isIOS) {
//       platform = 'iOS';
//     } else {
//       platform = 'Android';
//     }
//     return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
//   }
//
//   /// Paypal Payment
//   Future<String?> getPaypalAccessToken() async {
//     const String url = 'https://api-m.sandbox.paypal.com/v1/oauth2/token';
//     //const String liveURL = 'https://api-m.paypal.com/v1/oauth2/token';
//
//     String credentials = '$clientId:$clientSecret';
//     String encodedCredentials = base64Encode(utf8.encode(credentials));
//
//     Map<String, String> headers = {
//       'Authorization': 'Basic $encodedCredentials',
//       'Content-Type': 'application/x-www-form-urlencoded',
//     };
//
//     Map<String, String> body = {
//       'grant_type': 'client_credentials',
//     };
//
//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: headers,
//         body: body,
//       );
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         String accessToken = data['access_token'];
//         print('Access Token: $accessToken');
//         return accessToken;
//       } else {
//         print('Failed to get token: ${response.statusCode} - ${response.body}');
//         return null;
//       }
//     } catch (e) {
//       print('Error: $e');
//       return null;
//     }
//   }
//
//   void payPalPayment() async {
//     appStore.setLoading(true);
//     var accessToken = await getPaypalAccessToken();
//     print('Access Token424: $accessToken');
//     const String url = 'https://api-m.sandbox.paypal.com/v2/checkout/orders';
//     Map<String, String> headers = {
//       'Authorization': 'Bearer $accessToken',
//       'Content-Type': 'application/json',
//       'Accept': 'application/json',
//     };
//
//     Map<String, dynamic> body = {
//       'intent': 'CAPTURE',
//       'purchase_units': [
//         {
//           'amount': {
//             'currency_code': 'USD',
//             'value': '10.00',
//           },
//           'description': 'Test purchase',
//         }
//       ],
//       'application_context': {
//         'return_url': 'https://example.com/return',
//         'cancel_url': 'https://example.com/cancel',
//         'shipping_preference': 'NO_SHIPPING',
//       }
//     };
//
//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: headers,
//         body: jsonEncode(body),
//       );
//
//       if (response.statusCode == 201) {
//         final data = jsonDecode(response.body);
//         String orderId = data['id'];
//         var link = await "https://www.sandbox.paypal.com/checkoutnow?token=${orderId}";
//         appStore.setLoading(false);
//         WebViewScreen(
//                 onClick: (msg) {
//                   if (msg == "Success") {
//                     paymentConfirm();
//                   }
//                 },
//                 mInitialUrl: link)
//             .launch(context);
//         print('Order Created: $orderId');
//         print('Full Response: ${response.body}');
//       } else {
//         appStore.setLoading(false);
//         print('Failed to create order: ${response.statusCode} - ${response.body}');
//         return null;
//       }
//     } catch (e) {
//       appStore.setLoading(false);
//       print('Error: $e');
//       return null;
//     }
//   }
//
// /*
//   void payPalPayment() async {
//     print("===================>>>${payPalTokenizationKey}");
//
//     appStore.setLoading(true);
//     // final request = await BraintreePayPalRequest(amount: widget.mSubscriptionModel?.price.toString(), currencyCode: userStore.currencySymbol.toUpperCase(), displayName: userStore.username.validate());
//     // final request = await BraintreePayPalRequest(amount: widget.mSubscriptionModel?.price.toString(), currencyCode: "USD", displayName: userStore.username.validate());
//
//     var request = BraintreeDropInRequest(
//       tokenizationKey: payPalTokenizationKey ?? "",
//       collectDeviceData: true,
//       vaultManagerEnabled: true,
//       requestThreeDSecureVerification: true,
//       */
// /*email: "test@email.com",
//       billingAddress: BraintreeBillingAddress(
//         givenName: "Jill",
//         surname: "Doe",
//         phoneNumber: "5551234567",
//         streetAddress: "555 Smith St",
//         extendedAddress: "#2",
//         locality: "Chicago",
//         region: "IL",
//         postalCode: "12345",
//         countryCodeAlpha2: "US",
//       ),*/ /*
//
//       paypalRequest: BraintreePayPalRequest(amount: widget.mSubscriptionModel?.price.toString(), displayName: userStore.username.validate(), currencyCode: "USD"),
//       cardEnabled: true,
//     );
//
//     final result = await BraintreeDropIn.start(request);
//
//     if (result != null) {
//       appStore.setLoading(false);
//       paymentConfirm();
//     } else {
//       appStore.setLoading(false);
//     }
//   }
// */
//
//   /// FlutterWave Payment
//
//   Future<void> flutterWaveCheckout() async {
//     appStore.setLoading(true);
//
//     const url = 'https://api.flutterwave.com/v3/payments';
//     const headers = {'Authorization': 'Bearer FLWSECK_TEST-225b7ab3a7e088b4ddb1afa06db5bdbd-X', 'Content-Type': 'application/json'};
//
//     var body = {
//       "redirect_url": "https://example_company.com/success",
//       "tx_ref": getRandomString(10),
//       "amount": widget.mSubscriptionModel?.price.toString(),
//       "currency": userStore.currencySymbol.validate().toLowerCase(),
//       "customer": {
//         "email": userStore.email.validate(),
//         "name": "Flutterwave Developers",
//         "phonenumber": userStore.phoneNo.validate(),
//         "first_name": userStore.fName.validate(),
//         "last_name": userStore.lName.validate()
//       },
//       "customizations": {"title": "MightyFitness Standard Payment"}
//     };
//
//     final response = await http.post(
//       Uri.parse(url),
//       headers: headers,
//       body: jsonEncode(body),
//     );
//
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       if (data['status'] == 'success') {
//         setState(() {
//           var paymentLink = data['data']['link'];
//           appStore.setLoading(false);
//           print("----------414>>>${paymentLink}");
//           WebViewScreen(
//                   onClick: (msg) {
//                     if (msg == "Success") {
//                       paymentConfirm();
//                     }
//                   },
//                   mInitialUrl: paymentLink)
//               .launch(context);
//         });
//       } else {
//         appStore.setLoading(false);
//
//         print('Error: ${data['message']}');
//       }
//     } else {
//       appStore.setLoading(false);
//       print('Failed with status code: ${response.statusCode}');
//     }
//   }
//
//   /// orangeMoney Payment
//   void orangeMoneyPayment() async {
//     appStore.setLoading(true);
//
//     print("---------------------<<<----${orangeMoneyPublicKey}");
//     await BambaraView(
//       data: BambaraData(
//         amount: widget.mSubscriptionModel?.price?.toInt() ?? 0,
//         provider: 'bank-card',
//         reference: getRandomString(30),
//         phone: userStore.phoneNo.validate(),
//         email: userStore.email.validate(),
//         name: userStore.username.validate(),
//         publicKey: "pk_IuR83FabBsxW2P6mHPJywyGljga9QcFg",
//       ),
//       onClosed: () {
//         appStore.setLoading(false);
//       },
//       onError: (data) {
//         appStore.setLoading(false);
//       },
//       onSuccess: (data) {
//         if (data.status == 'successful') {
//           appStore.setLoading(false);
//           paymentConfirm();
//           print("${data.toJson()}");
//         }
//       },
//       onRedirect: (data) {
//         appStore.setLoading(false);
//       },
//       onProcessing: (data) {
//         appStore.setLoading(false);
//       },
//       closeOnComplete: false,
//     ).show(context);
//   }
//
//   /// PayTabs Payment
//   /*void payTabsPayment() {
//     appStore.setLoading(true);
//     FlutterPaytabsBridge.startCardPayment(generateConfig(), (event) {
//       if (event["status"] == "success") {
//         var transactionDetails = event["data"];
//         if (transactionDetails["isSuccess"]) {
//           toast("Transaction Successful");
//           paymentConfirm();
//         } else {
//           toast("Transaction Failed");
//         }
//         toast("Transaction Successful");
//       } else if (event["status"] == "error") {
//         print("error");
//       } else if (event["status"] == "event") {
//         //
//       }
//       appStore.setLoading(false);
//       setState(() {});
//     });
//   }*/
//
//   /* PaymentSdkConfigurationDetails generateConfig() {
//     List<PaymentSdkAPms> apms = [];
//     print("----------------------${payTabsProfileId}");
//     print("----------------------${payTabsServerKey}");
//     print("----------------------${payTabsClientKey}");
//    // apms.add(PaymentSdkAPms.STC_PAY);
//     apms.add(PaymentSdkAPms.AMAN);
//     var configuration = PaymentSdkConfigurationDetails(
//         profileId: payTabsProfileId,
//         serverKey: payTabsServerKey,
//         clientKey: payTabsClientKey,
//         transactionType: PaymentSdkTransactionType.SALE,
//         cartDescription: "fghfg",
//         merchantName: "fghfg",
//         screentTitle: "Pay with Card",
//         amount: widget.mSubscriptionModel!.price!.toDouble(),
//         showBillingInfo: true,
//         forceShippingInfo: true,
//         linkBillingNameWithCardHolderName: true,
//         currencyCode:"EGP" */ /*userStore.currencySymbol.toUpperCase()*/ /*,
//         merchantCountryCode: "EG",
//         alternativePaymentMethods: apms,
//         billingDetails: payTab.BillingDetails(
//           userStore.username.validate(),
//           userStore.email.validate(),
//           userStore.phoneNo.validate(),
//           '',
//           '',
//           '',
//           '',
//           '',
//         ),
//         );
//
//     var theme = IOSThemeConfigurations();
//
//     theme.logoImage = ic_logo;
//
//     configuration.iOSThemeConfigurations = theme;
//
//     return configuration;
//   }*/
//
//   /* void paytmPayment() async {
//     appStore.setLoading(true);
//     String orderId = DateTime.now().millisecondsSinceEpoch.toString();
//
//     //String callBackUrl = (isPaytmTestType ? 'https://securegw-stage.paytm.in' : 'https://securegw.paytm.in') + '/theia/paytmCallback?ORDER_ID=' + orderId;
//     String callBackUrl = 'https://securegw-stage.paytm.in/theia/paytmCallback?ORDER_ID=${orderId}';
//
//     //var url = 'https://desolate-anchorage-29312.herokuapp.com/generateTxnToken';
//     //var url = 'https://securegw-stage.paytm.in/coft-center/coft/merchant/${paytmMerchantId}/${paytmMerchantKey}/generateTokenData?requestId=2';
//     var url= 'https://securegw-stage.paytm.in/theia/api/v1/initiateTransaction?mid=${paytmMerchantId}&orderId=${orderId}';
//     print("paytmMerchantId_____________________${paytmMerchantId}");
//     print("paytmMerchantKey_____________________${paytmMerchantKey}");
//     print("orderId_____________________${orderId}");
//
//
//     var body = json.encode({
//       "mid": paytmMerchantId,
//       "key_secret": paytmMerchantKey,
//       "website": isPaytmTestType ? "WEBSTAGING" : "DEFAULT",
//       "orderId": orderId,
//       "amount": widget.mSubscriptionModel!.price.toString(),
//       "callbackUrl": callBackUrl,
//       "custId": userStore.userId,
//       "testing": isPaytmTestType ? 0 : 1
//     });
//
//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         body: body,
//         headers: {'Content-type': "application/json"},
//       );
//
//       String txnToken = response.body;
//
//       print("token_____________________${jsonEncode(response.body)}");
//       print("token_____________________${txnToken}");
//
//       var paytmResponse = Paytm.payWithPaytm(
//         mId: paytmMerchantId!,
//         orderId: orderId,
//         txnToken: txnToken,
//         txnAmount: widget.mSubscriptionModel!.price.toString(),
//         callBackUrl: callBackUrl,
//         staging: isPaytmTestType,
//         appInvokeEnabled: false,
//       );
//
//       paytmResponse.then((value) {
//         setState(() {
//           loading = false;
//           if (value['error']) {
//             toast(value['errorMessage']);
//           } else {
//             if (value['response'] != null) {
//               toast(value['response']['RESPMSG']);
//               if (value['response']['STATUS'] == 'TXN_SUCCESS') {
//                 paymentConfirm();
//               }
//             }
//           }
//         });
//       });
//     } catch (e) {
//       print(e);
//     }
//   }*/
//
//   /// PayTm Payment
//
//   void paytmPayment() async {
//     appStore.setLoading(true);
//
//     String orderId = DateTime.now().millisecondsSinceEpoch.toString();
//     String callBackUrl = 'https://securegw-stage.paytm.in/theia/paytmCallback?ORDER_ID=${orderId}';
//
//     var url = 'https://securegw-stage.paytm.in/theia/api/v1/initiateTransaction?mid=${paytmMerchantId}&orderId=${orderId}';
//
//     var body = json.encode({
//       "mid": paytmMerchantId,
//       "key_secret": paytmMerchantKey,
//       "website": isPaytmTestType ? "WEBSTAGING" : "DEFAULT",
//       "orderId": orderId,
//       "amount": widget.mSubscriptionModel!.price.toString(),
//       "callbackUrl": callBackUrl,
//       "custId": userStore.userId,
//       "testing": isPaytmTestType ? 0 : 1
//     });
//
//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         body: body,
//         headers: {'Content-type': "application/json"},
//       );
//
//       String txnToken = response.body;
//
//     //   var responseData = AllInOneSdk.startTransaction(paytmMerchantId ?? '', orderId, widget.mSubscriptionModel!.price.toString(), txnToken, "", isPaytmTestType, false);
//     //   responseData.then((value) {
//     //     print(value);
//     //     setState(() {
//     //       print("${value.toString()}");
//     //     });
//     //   }).catchError((onError) {
//     //     if (onError is PlatformException) {
//     //       appStore.setLoading(false);
//     //       setState(() {
//     //         print("${widget.mSubscriptionModel!.price.toString()}");
//     //       });
//     //     } else {
//     //       setState(() {
//     //         appStore.setLoading(false);
//     //         print("${onError.toString()}");
//     //       });
//     //     }
//     //   });
//     // } catch (e) {
//     //   appStore.setLoading(false);
//     //   print(e);
//     // }
//   }
//
//   Future<void> paymentConfirm() async {
//     appStore.setLoading(true);
//     Map req = {"package_id": widget.mSubscriptionModel!.id, "payment_status": "paid", "payment_type": selectedPaymentType, "txn_id": "", "transaction_detail": ""};
//     await subscribePackageApi(req).then((value) async {
//       toast(value.message);
//       await getUSerDetail(context, userStore.userId).whenComplete(() {
//         setState(() {
//           appStore.setLoading(false);
//           LiveStream().emit(PAYMENT);
//           finish(context);
//           finish(context);
//         });
//       });
//     }).catchError((e) {
//       appStore.setLoading(false);
//       print(e.toString());
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: appBarWidget(languages.lblPayments, context: context),
//       body: Stack(
//         children: [
//           paymentList.isNotEmpty
//               ? AnimatedListView(
//                   shrinkWrap: true,
//                   itemCount: paymentList.length,
//                   padding: EdgeInsets.all(16),
//                   itemBuilder: (context, index) {
//                     return Container(
//                       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//                       margin: EdgeInsets.only(bottom: 16),
//                       decoration:
//                           boxDecorationWithRoundedCorners(border: Border.all(width: 0.5, color: selectedPaymentType == paymentList[index].type ? primaryColor.withOpacity(0.80) : GreyLightColor)),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: [
//                               cachedImage(paymentList[index].gatewayLogo!, width: 35, height: 35, fit: BoxFit.contain),
//                               12.width,
//                               Text(paymentList[index].title.validate().capitalizeFirstLetter(), style: primaryTextStyle(), maxLines: 2),
//                             ],
//                           ).expand(),
//                           selectedPaymentType == paymentList[index].type
//                               ? Container(
//                                   padding: EdgeInsets.all(0),
//                                   decoration: boxDecorationWithRoundedCorners(backgroundColor: primaryColor, borderRadius: radius(8)),
//                                   child: Icon(Icons.check, color: Colors.white),
//                                 )
//                               : SizedBox(),
//                         ],
//                       ),
//                     ).onTap(() {
//                       selectedPaymentType = paymentList[index].type;
//                       setState(() {});
//                     });
//                   })
//               : NoDataScreen().visible(!appStore.isLoading),
//           Observer(
//             builder: (context) {
//               return Loader().center().visible(appStore.isLoading);
//             },
//           )
//         ],
//       ),
//       bottomNavigationBar: Padding(
//         padding: EdgeInsets.all(16),
//         child: Visibility(
//           visible: paymentList.isNotEmpty,
//           child: AppButton(
//             text: languages.lblPay,
//             color: primaryColor,
//             onTap: () {
//               if (selectedPaymentType == PAYMENT_TYPE_RAZORPAY) {
//                 razorPayPayment();
//               } else if (selectedPaymentType == PAYMENT_TYPE_STRIPE) {
//                 stripePay();
//               } else if (selectedPaymentType == PAYMENT_TYPE_PAYSTACK) {
//                 payStackPayment(context);
//                 //payStackeNew();
//               } else if (selectedPaymentType == PAYMENT_TYPE_PAYPAL) {
//                 payPalPayment();
//               } else if (selectedPaymentType == PAYMENT_TYPE_FLUTTERWAVE) {
//                 flutterWaveCheckout();
//               } else if (selectedPaymentType == PAYMENT_TYPE_PAYTABS) {
//                 // payTabsPayment();
//                 PayTabScreen(
//                   cartId: userStore.userId.toString(),
//                   currencyCode: userStore.currencyCode.toUpperCase(),
//                   amount: widget.mSubscriptionModel?.price?.toDouble(),
//                   profileId: payTabsProfileId,
//                   clientKey: payTabsClientKey,
//                   serverKey: payTabsServerKey,
//                   onCall: () {
//                     paymentConfirm();
//                   },
//                 ).launch(context);
//               } else if (selectedPaymentType == PAYMENT_TYPE_PAYTM) {
//                 paytmPayment();
//               } else if (selectedPaymentType == PAYMENT_TYPE_ORANGE_MONEY) {
//                 orangeMoneyPayment();
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
// Random _rnd = Random();
//
// String getRandomString(int length) => String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
