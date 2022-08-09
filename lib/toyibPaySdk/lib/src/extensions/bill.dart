import '../../models/bill/billCodes.dart';
import '../../models/bill/bills.dart';
import '../../models/bill/transactions.dart';
import '../toyyibpay_dart_base.dart';
import 'index.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:http/src/response.dart';

extension ToyyibBill on ToyyibPay {
  /// ### Create Bill
  /// Bill serves as an invoice to your customer. In the example below, we will show you how to create a Bill. You need to pass the following parameters to generate category code.
  /// - `userSecretKey` - User Secret Key
  /// - `categoryCode` - Category Code. Get your Category Code from Create Category API
  /// - `billName` - Your bill name. Bill Name will be displayed as bill title
  ///  \* Max 30 alphanumeric characters, space and '_' only
  /// - `billDescription` - Your bill description.
  ///  \* Max 100 alphanumeric characters, space and '_' only
  /// - `billPriceSetting` - For fixed amount bill, set it to 0. For dynamic bill (user can key in the amount paid), set it to 1
  /// - `billPayorInfo` - If you want to create open bill without require payer information, set it to 0. If you need payer information, set it to 1
  /// - `billAmount` - Key in the bill amount. The amount is in cent. e.g. 100 = RM1. If you set billPriceSetting to 1 (dynamic bill), please put 0
  /// - `billReturnUrl` - Key in return Url if you need the bill to be redirected to your own page upon payment completion.
  /// - `billCallbackUrl` - Key in callback url if you need the bill to be redirected to your callback page upon sucessful of payment transaction.
  /// - `billExternalReferenceNo` - Provide your own system reference no if you think it is required. You may use this reference no to check the payment status for the bill.
  /// - `billTo` - If you intend to provide the bill to specific person, you may fill the person nam in this field. If not, please leave it blank.
  /// - `billEmail` - Provide your customer email here
  /// - `billPhone` - Provide your customer phone number here.
  /// - `billSplitPayment` - Set 1 if the you need the payment to be splitted to other toyyibPay users.
  /// - `billSplitPaymentArgs` - Provide JSON for split payment. e.g. [{"id":"johndoe","amount":"200"}]
  /// - `billPaymentChannel` - Set 0 for FPX, 1 Credit Card and 2 for both FPX & Credit Card.
  /// - `billDisplayMerchant` - [OPTIONAL] Set 1 to display merchant info in your customer's email and 0 to hide merchant info.
  /// - `billContentEmail` - [OPTIONAL] Provide additional messages by sending an extra email to your customer.
  /// - `billAdditionalField` - [OPTIONAL] Provide JSON for extra field of your bill. e.g.
  ///  `$array2 = array("add_input_1" => "Alamat", "add_input_2" => "Poskod", "add_input_3" => "Jalan");`
  ///  `$json = json_encode($array2);`
  /// - `billChargeToCustomer` - Below are the values available :
  ///   - Leave blank to set charges for both FPX and Credit Card on bill owner.
  ///   - Set `0` to charge FPX to customer, Credit Card to bill owner.
  ///   - Set `1` to charge FPX bill owner, Credit Card to customer.
  ///   - Set `2` to charge both FPX and Credit Card to customer.
  ///
  /// Our API system will return Bill Code in JSON format.
  ///
  /// For more info, read the [documentation](https://toyyibpay.com/apireference/#cb).
  Future<List<BillCodes>> createBill({
    @required categoryCode,
    @required billName,
    @required billDescription,
    @required billPriceSetting,
    @required billPayorInfo,
    @required billAmount,
    @required billReturnUrl,
    @required billCallbackUrl,
    @required billExternalReferenceNo,
    @required billTo,
    @required billEmail,
    @required billPhone,
    @required billSplitPayment,
    @required billSplitPaymentArgs,
    @required billPaymentChannel,
    billDisplayMerchant,
    billContentEmail,
    billAdditionalField,
    @required billChargeToCustomer,
  }) {
    var params = bodyParams({
      'categoryCode': categoryCode,
      'billName': billName,
      'billDescription': billDescription,
      'billPriceSetting': billPriceSetting,
      'billPayorInfo': billPayorInfo,
      'billAmount': billAmount,
      'billReturnUrl': billReturnUrl,
      'billCallbackUrl': billCallbackUrl,
      'billExternalReferenceNo': billExternalReferenceNo,
      'billTo': billTo,
      'billEmail': billEmail,
      'billPhone': billPhone,
      'billSplitPayment': billSplitPayment,
      'billSplitPaymentArgs': billSplitPaymentArgs,
      'billPaymentChannel': billPaymentChannel,
      'billDisplayMerchant': billDisplayMerchant,
      'billContentEmail': billContentEmail,
      'billAdditionalField': billAdditionalField,
      'billChargeToCustomer': billChargeToCustomer,
    });
    return BillCodesExt.fromFuture(
        http.post(Uri.parse(url('/index.php/api/createBill')), body: params));
  }

  /// ### Create Bill Multi Payment
  ///Bill serves as an invoice to your customer. In the example below, we will show you how to create a Bill for multipayment. You need to pass the following parameters to generate bill code.

  ///- `userSecretKey` - User Secret Key
  ///- `categoryCode` - Category Code. Get your Category Code from Create Category API
  ///- `billName` - Your bill name. Bill Name will be displayed as bill title
  /// \* Max 30 alphanumeric characters, space and '_' only
  ///- `billDescription` - Your bill description.
  /// \* Max 100 alphanumeric characters, space and '_' only
  ///- `billPriceSetting` - Put 1 if the bill has fix amount, put 0 if dynamic amount.
  ///- `billPayorInfo` - If you want to create open bill without require payer information, set it to 0. If you need payer information, set it to 1
  ///- `billAmount` - Key in the bill amount. The amount is in cent. e.g. 100 = RM1. If you set billPriceSetting to 1 (dynamic bill), please put 0
  ///- `billReturnUrl` - Key in return Url if you need the bill to be redirected to your own page upon payment completion.
  ///- `billCallbackUrl` - Key in callback url if you need the bill to be redirected to your callback page upon sucessful of payment transaction.
  ///- `billExternalReferenceNo` - Provide your own system reference no if you think it is required. You may use this reference no to check the payment status for the bill.
  ///- `billTo` - If you intend to provide the bill to specific person, you may fill the person nam in this field. If not, please leave it blank.
  ///- `billEmail` - Provide your customer email here
  ///- `billPhone` - Provide your customer phone number here.
  ///- `billSplitPayment` - Set 1 if the you need the payment to be splitted to other toyyibPay users.
  ///- `billSplitPaymentArgs` - Provide JSON for split payment. e.g. [{"id":"johndoe","amount":"200"}]
  ///- `billMultiPayment` - Set 1 if you need the multi payment on.
  ///- *[OPTIONAL]*`billPaymentChannel` - 0 = FPX Only, 1 = Credit/Debit Card only, 2 = FPX and Credit Card
  ///- *[OPTIONAL]*`billDisplayMerchant` - 0 = Not display merchant details in email, 1 = Display merchant details in email.
  ///- *[OPTIONAL]*`billContentEmail` - Provide your email content.
  ///
  /// Our API system will return Bill Code in JSON format.
  ///
  /// For more info, read the [documentation](https://toyyibpay.com/apireference/#cbm).
  Future<List<BillCodes>> createBillMultiPayment({
    @required categoryCode,
    @required billName,
    @required billDescription,
    @required billPriceSetting,
    @required billPayorInfo,
    @required billAmount,
    @required billReturnUrl,
    @required billCallbackUrl,
    @required billExternalReferenceNo,
    billTo,
    @required billEmail,
    @required billPhone,
    @required billSplitPayment,
    @required billSplitPaymentArgs,
    @required billMultiPayment,
    billPaymentChannel,
    billDisplayMerchant,
    billContentEmail,
  }) {
    var params = bodyParams({
      'categoryCode': categoryCode,
      'billName': billName,
      'billDescription': billDescription,
      'billPriceSetting': billPriceSetting,
      'billPayorInfo': billPayorInfo,
      'billAmount': billAmount,
      'billReturnUrl': billReturnUrl,
      'billCallbackUrl': billCallbackUrl,
      'billExternalReferenceNo': billExternalReferenceNo,
      'billTo': billTo,
      'billEmail': billEmail,
      'billPhone': billPhone,
      'billSplitPayment': billSplitPayment,
      'billSplitPaymentArgs': billSplitPaymentArgs,
      'billMultiPayment': billMultiPayment,
      'billPaymentChannel': billPaymentChannel,
      'billDisplayMerchant': billDisplayMerchant,
      'billContentEmail': billContentEmail,
    });
    return BillCodesExt.fromFuture(http.post(
        Uri.parse(url('/index.php/api/createBillMultiPayment')),
        body: params));
  }

  /// ### Run Bill
  /// Run Bill can make customer do the payment. In the example below, we will show you how to run a Bill for multipayment. You need to pass the following parameters to generate category code.
  ///- `userSecretKey` - User Secret Key
  ///- `billCode` - Your billcode / permanent link
  ///- `billpaymentAmount` - If the original bill's `billPriceSetting` = 1, leave this blank. The bill amount will follow the original bill's amount. Otherwise (original bill's `billPriceSetting` = 0), enter the amount in cent (e.g. 100 = RM 100).
  ///- `billpaymentPayorNam*` - Customer name
  ///- `billpaymentPayorPhone` - Customer phone number
  ///- `billpaymentPayorEmail` - Customer email
  ///- `billBankID` - If you need to by pass payment page, please key in Bank Code (refer to Get Bank FPX API).
  /// Our API system will run our payment page
  ///
  /// For more info, read the [documentation](https://toyyibpay.com/apireference/#rb).
  Future<Response> runBill({
    @required billCode,

    /// amount you want
    @required billpaymentAmount,
    @required billpaymentPayorName,
    @required billpaymentPayorPhone,
    @required billpaymentPayorEmail,
    billBankID,
  }) {
    var params = bodyParams({
      'billCode': billCode,
      'billpaymentAmount': billpaymentAmount,
      'billpaymentPayorName': billpaymentPayorName,
      'billpaymentPayorPhone': billpaymentPayorPhone,
      'billpaymentPayorEmail': billpaymentPayorEmail,
      'billBankID': billBankID,
    });
    return http.post(Uri.parse(url('/index.php/api/runBill')), body: params);
  }

  /// ### Get All Bill `(Enterprise/OEM Account Only)`
  /// You may get all bill information by submitting OEM secret key or Enterprise secret key.
  ///
  /// - `userSecretKey` - Secret key for OEM or Enterprise user
  /// - `partnerType` - `OEM` or `ENTERPRISE`
  /// - `year-month` - Required year & month, if left blank all bill will be return
  ///
  /// Our API system will run our payment page
  ///
  /// For more info, read the [documentation](https://toyyibpay.com/apireference/#gab).
  Future<Bills> getAllBill({
    @required partnerType,
    yearMonth,
  }) {
    var params = bodyParams({
      'partnerType': partnerType,
      'year-month': yearMonth,
    });
    return BillsExt.fromFuture(
        http.post(Uri.parse(url('/admin/api/getAllBill')), body: params));
  }

  /// ### Get Bill Transactions
  /// You may check bill payment status by submitting Bill Code and Bill Payment Status(Optional). Bill payment status code description as follows:-
  ///
  /// - `1` - Successful transaction
  /// - `2` - Pending transaction
  /// - `3` - Unsuccessful transaction
  /// - `4` - Pending
  ///
  /// For more info, read the [documentation](https://toyyibpay.com/apireference/#gbt).
  Future<Transactions> getBillTransactions({
    @required billCode,
    @required billpaymentStatus,
  }) {
    var params = bodyParams({
      'billCode': billCode,
      'billpaymentStatus': billpaymentStatus,
    });
    return TransactionsExt.fromFuture(http.post(
        Uri.parse(url('/index.php/api/getBillTransactions')),
        body: params));
  }
}
