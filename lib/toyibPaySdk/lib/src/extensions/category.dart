import '../../models/category/category.dart';
import '../../models/category/categoryCode.dart';
import '../toyyibpay_dart_base.dart';
import 'index.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

extension ToyyibCategory on ToyyibPay {
  /// ### Create Category
  /// Category is a collection of bills. As an example, you may create a 'Rental' Category for bill related to rental. User Secret Key is required in order to create a Category. Please login to toyyibPay to get User Secret Key.
  ///
  /// In the example below, we will show you how to create a Category. You need to pass the following parameters to generate category code.
  ///
  /// - `userSecretKey` - User Secret Key
  /// - `catname` - Category Name
  /// - `catdescription` - Category Description
  ///
  /// Our API system will return Category Code in JSON format.
  ///
  /// For more info, read the [documentation](https://toyyibpay.com/apireference/#cc).
  Future<CategoryCode> createCategory({
    @required catname,
    @required catdescription,
  }) {
    var params = bodyParams({
      'catname': catname,
      'catdescription': catdescription,
    });
    return CategoryCodeExt.fromFuture(http
        .post(Uri.parse(url('/index.php/api/createCategory')), body: params));
  }

  /// ### Get Category
  /// In the example below, we will show you how to get category information. You need to pass the following parameters :
  ///
  /// - `userSecretKey` - User Secret Key
  /// - `categoryCode` - Category Code
  ///
  /// Our API system will return information in JSON format.
  ///
  /// For more info, read the [documentation](https://toyyibpay.com/apireference/#gc).
  Future<Category> getCategoryDetails({
    @required categoryCode,
  }) {
    var params = bodyParams({
      'categoryCode': categoryCode,
    });
    return CategoryExt.fromFuture(http.post(
        Uri.parse(url('/index.php/api/getCategoryDetails')),
        body: params));
  }
}
