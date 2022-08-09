import '../../models/settlement/settlementSummaries.dart';
import '../../models/settlement/settlements.dart';
import '../toyyibpay_dart_base.dart';
import 'index.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

extension ToyyibSettlement on ToyyibPay {
  /// ### Get Settlement
  /// You may get all settlement information by submitting OEM secret key or Enterprise secret key as follows:-
  ///
  /// `userSecretKey` - Secret key for `OEM` or `Enterprise` user
  /// `partnerType` - `OEM` = OEM User , `ENTERPRISE` = Enterprise User
  /// `detailByuserName` - `Yes` = Group by Username, `No` = Ungroup
  ///
  /// For more info, read the [documentation](https://toyyibpay.com/apireference/#gs).
  Future<Settlements> getSettlement({
    @required partnerType,
    @required detailByuserName,
  }) {
    var params = bodyParams({
      'partnerType': partnerType,
      'detailByuserName': detailByuserName,
    });
    return SettlementsExt.fromFuture(
        http.post(Uri.parse(url('/admin/api/getSettlement')), body: params));
  }

  /// ### Get Settlement Summary
  /// You may get all settlement summary information by submitting as follows:-
  ///
  /// - `userSecretKey` - Secret key for `Enterprise` User Only
  /// - `userPartnerType` - `OEM` = OEM User , `ENTERPRISE` = Enterprise User
  /// - `userName` - Sample Username
  ///
  /// For more info, read the [documentation](https://toyyibpay.com/apireference/#gss).
  Future<SettlementSummaries> getSettlementSummary({
    @required userPartnerType,
    @required userName,
  }) {
    var params = bodyParams({
      'userPartnerType': userPartnerType,
      'userName': userName,
    });
    return SettlementSummariesExt.fromFuture(
        http.post(Uri.parse(url('/admin/api/getSettlement')), body: params));
  }
}
