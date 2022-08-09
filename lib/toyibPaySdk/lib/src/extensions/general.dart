import '../../models/bank/bankFPXs.dart';
import '../../models/bank/banks.dart';
import '../../models/package/packages.dart';
import '../toyyibpay_dart_base.dart';
import 'index.dart';
import 'package:http/http.dart' as http;

extension ToyyibGeneral on ToyyibPay {
  /// ### Get Bank
  /// Get Bank API is useful for you to get bank information which are accepted to be used with toyyibPay. Bank information is required when you create a user from API
  ///
  /// Our API system will return bank information in JSON format.
  ///
  /// For more info, read the [documentation](https://toyyibpay.com/apireference/#gb).
  Future<Banks> getBank() {
    return BanksExt.fromFuture(
        http.post(Uri.parse(url('/index.php/api/getBank'))));
  }

  /// ### Get Bank FPX
  /// Get Bank FPX API is useful for you to get bank code which are accepted to be used with toyyibPay. Bank code is required when you need to use runBill API
  ///
  /// Our API system will return bank information in JSON format.
  ///
  /// For more info, read the [documentation](https://toyyibpay.com/apireference/#gbf).
  Future<BankFPXs> getBankFPX() {
    return BankFPXsExt.fromFuture(
        http.post(Uri.parse(url('/index.php/api/getBankFPX'))));
  }

  /// ### Get Package
  /// Get Package API is useful for you to get package information which are provided in toyyibPay. Package information is required when you create a user from API
  ///
  /// Our API system will return bank information in JSON format.
  ///
  /// For more info, read the [documentation](https://toyyibpay.com/apireference/#gp).
  Future<Packages> getPackage() {
    return PackagesExt.fromFuture(
        http.post(Uri.parse(url('/index.php/api/getPackage'))));
  }
}
