import 'dart:convert';

import 'package:http/http.dart';

import '../../../models/index.dart';

import 'modelTest.dart';

extension BanksExt on Banks {
  String arrayFromKey(rest) {
    return wrapArray(rest);
  }

  static String wrapArray(rest) {
    return '{"banks":$rest}';
  }

  static Future<Banks> fromFuture(Future<Response> future,
      {testModel = false}) async {
    var rest = (await future).body;
    var decoded = json.decode(wrapArray(rest));
    var model = Banks.fromJson(decoded);
    modelTest(model, rest, wrapper: model.arrayFromKey);
    return model;
  }
}

extension BankFPXsExt on BankFPXs {
  String arrayFromKey(rest) {
    return wrapArray(rest);
  }

  static String wrapArray(rest) {
    return '{"bankFPXs":$rest}';
  }

  static Future<BankFPXs> fromFuture(Future<Response> future,
      {testModel = false}) async {
    var rest = (await future).body;
    var decoded = json.decode(wrapArray(rest));
    var model = BankFPXs.fromJson(decoded);
    modelTest(model, rest, wrapper: model.arrayFromKey);
    return model;
  }
}

extension BillsExt on Bills {
  String arrayFromKey(rest) {
    return wrapArray(rest);
  }

  static String wrapArray(rest) {
    return '{"bills":$rest}';
  }

  static Future<Bills> fromFuture(Future<Response> future,
      {testModel = false}) async {
    var rest = (await future).body;
    var decoded = json.decode(wrapArray(rest));
    var model = Bills.fromJson(decoded);
    modelTest(model, rest, wrapper: model.arrayFromKey);
    return model;
  }
}

extension BillCodesExt on BillCodes {
  String arrayFromKey(rest) {
    return wrapArray(rest);
  }

  static String wrapArray(rest) {
    return '{"billCodes":$rest}';
  }

  static Future<List<BillCodes>> fromFuture(Future<Response> future,
      {testModel = false}) async {
    var model;
    try {
      var rest = (await future).body;
      model = billCodesFromJson(rest);
    } catch (e) {
      print(e);
    }
    //modelTest(model, rest, wrapper: model.arrayFromKey);
    return model;
  }
}

extension TransactionsExt on Transactions {
  String arrayFromKey(rest) {
    return wrapArray(rest);
  }

  static String wrapArray(rest) {
    return '{"transactions":$rest}';
  }

  static Future<Transactions> fromFuture(Future<Response> future,
      {testModel = false}) async {
    var rest = (await future).body;
    var decoded = json.decode(wrapArray(rest));
    var model = Transactions.fromJson(decoded);
    modelTest(model, rest, wrapper: model.arrayFromKey);
    return model;
  }
}

extension CategoriesExt on Categories {
  String arrayFromKey(rest) {
    return wrapArray(rest);
  }

  static String wrapArray(rest) {
    return '{"transactions":$rest}';
  }

  static Future<Categories> fromFuture(Future<Response> future,
      {testModel = false}) async {
    var rest = (await future).body;
    var decoded = json.decode('{ "categories": $rest }');
    var model = Categories.fromJson(decoded);
    modelTest(model, rest, wrapper: model.arrayFromKey);
    return model;
  }
}

extension CategoryCodesExt on CategoryCodes {
  String arrayFromKey(rest) {
    return wrapArray(rest);
  }

  static String wrapArray(rest) {
    return '{"categoryCodes":$rest}';
  }

  static Future<CategoryCodes> fromFuture(Future<Response> future,
      {testModel = false}) async {
    var rest = (await future).body;
    var decoded = json.decode(wrapArray(rest));
    var model = CategoryCodes.fromJson(decoded);
    modelTest(model, rest, wrapper: model.arrayFromKey);
    return model;
  }
}

extension PackagesExt on Packages {
  String arrayFromKey(rest) {
    return wrapArray(rest);
  }

  static String wrapArray(rest) {
    return '{"packages":$rest}';
  }

  static Future<Packages> fromFuture(Future<Response> future,
      {testModel = false}) async {
    var rest = (await future).body;
    var decoded = json.decode(wrapArray(rest));
    var model = Packages.fromJson(decoded);
    modelTest(model, rest, wrapper: model.arrayFromKey);
    return model;
  }
}

extension SettlementsExt on Settlements {
  String arrayFromKey(rest) {
    return wrapArray(rest);
  }

  static String wrapArray(rest) {
    return '{"settlements":$rest}';
  }

  static Future<Settlements> fromFuture(Future<Response> future,
      {testModel = false}) async {
    var rest = (await future).body;
    var decoded = json.decode(wrapArray(rest));
    var model = Settlements.fromJson(decoded);
    modelTest(model, rest, wrapper: model.arrayFromKey);
    return model;
  }
}

extension SettlementSummariesExt on SettlementSummaries {
  String arrayFromKey(rest) {
    return wrapArray(rest);
  }

  static String wrapArray(rest) {
    return '{"settlementSummaries":$rest}';
  }

  static Future<SettlementSummaries> fromFuture(Future<Response> future,
      {testModel = false}) async {
    var rest = (await future).body;
    var decoded = json.decode(wrapArray(rest));
    var model = SettlementSummaries.fromJson(decoded);
    modelTest(model, rest, wrapper: model.arrayFromKey);
    return model;
  }
}

extension UsersExt on Users {
  String arrayFromKey(rest) {
    return wrapArray(rest);
  }

  static String wrapArray(rest) {
    return '{"users":$rest}';
  }

  static Future<Users> fromFuture(Future<Response> future,
      {testModel = false}) async {
    var rest = (await future).body;
    var decoded = json.decode(wrapArray(rest));
    var model = Users.fromJson(decoded);
    modelTest(model, rest, wrapper: model.arrayFromKey);
    return model;
  }
}

extension UserCreatedsExt on UserCreateds {
  String arrayFromKey(rest) {
    return wrapArray(rest);
  }

  static String wrapArray(rest) {
    return '{"userCreateds":$rest}';
  }

  static Future<UserCreateds> fromFuture(Future<Response> future,
      {testModel = false}) async {
    var rest = (await future).body;
    var decoded = json.decode(wrapArray(rest));
    var model = UserCreateds.fromJson(decoded);
    modelTest(model, rest, wrapper: model.arrayFromKey);
    return model;
  }
}

extension UserStatusesExt on UserStatuses {
  String arrayFromKey(rest) {
    return wrapArray(rest);
  }

  static String wrapArray(rest) {
    return '{"userStatuses":$rest}';
  }

  static Future<UserStatuses> fromFuture(Future<Response> future,
      {testModel = false}) async {
    var rest = (await future).body;
    var decoded = json.decode(wrapArray(rest));
    var model = UserStatuses.fromJson(decoded);
    modelTest(model, rest, wrapper: model.arrayFromKey);
    return model;
  }
}
