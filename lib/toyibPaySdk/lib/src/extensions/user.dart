import '../../models/user/userStatuses.dart';
import '../../models/user/users.dart';
import '../toyyibpay_dart_base.dart';
import 'index.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

extension ToyyibUser on ToyyibPay {
  /// ### Create User `(For Enterprise Account Only)`
  /// This API will show how to create toyyibPay user from API. This API will return User Secret Key which later will be used for creating Category and Bill.
  ///
  /// You need to pass the following parameters to create user.
  ///
  /// - `Fullname` - User full name
  /// - `User name` - User name to access or login
  /// - `Email` - User Email OR User Id (not necessary in email format)
  /// - `Password` - User Password
  /// - `Phone` - User Phone
  /// - `Bank` - User Bank Selection
  /// - `Account No` - User Bank Account No
  /// - `Account Holder Name` - User Account Holder Name
  /// - `Registration No` - User Company / Business / Organization Registration No
  /// - `Package` - User Package
  /// - `Following` - Enterprise User Secret Key
  /// - `Our API system will return User Secret Key in JSON format. It will return error if the email already exist.
  ///
  /// For more info, read the [documentation](https://toyyibpay.com/apireference/#cu).
  Future<Users> createAccount({
    required fullname,
    required username,
    required email,
    required password,
    required phone,
    required bank,
    required accountNo,
    required accountHolderName,
    required registrationNo,
    required int package,
  }) {
    var params = bodyParams({
      'fullname': fullname,
      'username': username,
      'email': email,
      'password': password,
      'phone': phone,
      'bank': bank,
      'accountNo': accountNo,
      'accountHolderName': accountHolderName,
      'registrationNo': registrationNo,
      'package': package,
    });
    return UsersExt.fromFuture(http
        .post(Uri.parse(url('/index.php/api/createAccount')), body: params));
  }

  /// ### Get User Status `(For Enterprise Account Only)`
  /// You may check user account status by submitting user email and enterprise user secret key. Status code description as follows:-
  /// - `0` - Inactive
  /// - `1` - New-Pending Approval
  /// - `2` - Active
  ///
  /// For more info, read the [documentation](https://toyyibpay.com/apireference/#gus).
  Future<UserStatuses> getUserStatus({
    @required username,
    @required enterpriseUserSecretKey,
  }) {
    var params = bodyParams({
      'username': username,
      'enterpriseUserSecretKey': enterpriseUserSecretKey,
    });
    return UserStatusesExt.fromFuture(http
        .post(Uri.parse(url('/index.php/api/getUserStatus')), body: params));
  }

  /// ### Get All User `(Enterprise/OEM Account Only)`
  /// You may check all user account information by submitting partner type and user secret key as follows:-

  /// - `userSecretKey` - Secret key for `OEM` or `Enterprise` user
  /// - `partnerType` - `OEM` or `ENTERPRISE`
  ///
  /// For more info, read the [documentation](https://toyyibpay.com/apireference/#gau).
  Future<Users> getAllUser({
    @required partnerType,
  }) {
    var params = bodyParams({
      'partnerType': partnerType,
    });
    return UsersExt.fromFuture(
        http.post(Uri.parse(url('/admin/api/getAllUser')), body: params));
  }
}
