import 'dart:core';
export 'extensions/settlement.dart';
export 'extensions/bill.dart';
export 'extensions/category.dart';
export 'extensions/general.dart';
export 'extensions/user.dart';

class ToyyibPay {
  /// ## ToyyibPay
  /// Welcome to toyyibPay API Reference. With toyyibPay API Reference, you may now start develop codes to communicate with toyyibPay.
  ///
  /// **Read [Documentation](https://toyyibpay.com/apireference/#)**
  ///
  /// ### SandBox Mode
  /// Please register account at https://dev.toyyibpay.com
  ///
  /// *and set `sandbox: true` to parameter*
  ///
  /// **Read [Documentation](https://toyyibpay.com/apireference/#sb)**
  ///
  /// ### API Process Flow
  /// You will interact a lot with Category and Bill.
  ///
  /// Category is a group of bills. You can create a category based on bills type. e.g. House rental, Subscription fees.
  ///
  /// A bill is an invoice for your customer. A bill must belong to a Category
  ///
  /// To start using the API, you would have to create a Category. Then the payment flow will kicks in as per below:
  /// 1. Customer visits your site.
  /// 2. Customer chooses to make payment.
  /// 3. Your site creates a Bill via API call.
  /// 4. toyyibPay API returns Bill's code.
  /// 5. Your site redirects the customer to Bill's URL.
  /// 6. The customer makes payment via payment option of choice.
  /// 7. toyyibPay sends a server-side update (Payment Completion) to your site on Bill's status on payment failure or success.
  /// 8. Your site can check payment status via API call
  ///
  /// **Read [Documentation](https://toyyibpay.com/apireference/#apl)**
  ToyyibPay(this.secreteKey, {required this.sandbox}) {
    if (secreteKey == null) throw ('Secret Key Required');
  }

  bool sandbox = false;
  final String secreteKey;
  String url(url) {
    return baseUrl.resolve(url).toString();
  }

  Uri get baseUrl {
    return Uri.parse(
        sandbox ? 'https://dev.toyyibpay.com/' : 'https://toyyibpay.com/');
  }

  Map bodyParams(Map params, {secretParamString}) {
    secretParamString ??= 'userSecretKey';
    var newParams = {};
    params.forEach((key, value) {
      if (value != null) newParams[key] = value;
    });
    return {secretParamString: secreteKey}..addAll(newParams);
  }
}
