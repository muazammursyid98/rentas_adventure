import 'dart:convert';

import 'package:http/http.dart';

import '../../../models/index.dart';

import 'modelTest.dart';

extension BankExt on Bank {
  static Future<Bank> fromFuture(Future<Response> future,
      {testModel = false}) async {
    var rest = (await future).body;
    var decoded = json.decode(rest);
    var model = Bank.fromJson(decoded);
    modelTest(model, rest);
    return model;
  }
}

extension BankFPXExt on BankFPX {
  static Future<BankFPX> fromFuture(Future<Response> future,
      {testModel = false}) async {
    var rest = (await future).body;
    var decoded = json.decode(rest);
    var model = BankFPX.fromJson(decoded);
    modelTest(model, rest);
    return model;
  }
}

extension BillExt on Bill {
  static Future<Bill> fromFuture(Future<Response> future,
      {testModel = false}) async {
    var rest = (await future).body;
    var decoded = json.decode(rest);
    var model = Bill.fromJson(decoded);
    modelTest(model, rest);
    return model;
  }
}

extension BillCodeExt on BillCode {
  static Future<BillCode> fromFuture(Future<Response> future,
      {testModel = false}) async {
    var rest = (await future).body;
    var decoded = json.decode(rest);
    var model = BillCode.fromJson(decoded);
    modelTest(model, rest);
    return model;
  }
}

extension TransactionExt on Transaction {
  static Future<Transaction> fromFuture(Future<Response> future,
      {testModel = false}) async {
    var rest = (await future).body;
    var decoded = json.decode(rest);
    var model = Transaction.fromJson(decoded);
    modelTest(model, rest);
    return model;
  }
}

extension CategoryExt on Category {
  static Future<Category> fromFuture(Future<Response> future,
      {testModel = false}) async {
    var rest = (await future).body;
    var decoded = json.decode(rest);
    var model = Category.fromJson(decoded);
    modelTest(model, rest);
    return model;
  }
}

extension CategoryCodeExt on CategoryCode {
  static Future<CategoryCode> fromFuture(Future<Response> future,
      {testModel = false}) async {
    var rest = (await future).body;
    var decoded = json.decode(rest);
    var model = CategoryCode.fromJson(decoded);
    modelTest(model, rest);
    return model;
  }
}

extension PackageExt on Package {
  static Future<Package> fromFuture(Future<Response> future,
      {testModel = false}) async {
    var rest = (await future).body;
    var decoded = json.decode(rest);
    var model = Package.fromJson(decoded);
    modelTest(model, rest);
    return model;
  }
}

extension SettlementExt on Settlement {
  static Future<Settlement> fromFuture(Future<Response> future,
      {testModel = false}) async {
    var rest = (await future).body;
    var decoded = json.decode(rest);
    var model = Settlement.fromJson(decoded);
    modelTest(model, rest);
    return model;
  }
}

extension SettlementSummaryExt on SettlementSummary {
  static Future<SettlementSummary> fromFuture(Future<Response> future,
      {testModel = false}) async {
    var rest = (await future).body;
    var decoded = json.decode(rest);
    var model = SettlementSummary.fromJson(decoded);
    modelTest(model, rest);
    return model;
  }
}

extension UserExt on User {
  static Future<User> fromFuture(Future<Response> future,
      {testModel = false}) async {
    var rest = (await future).body;
    var decoded = json.decode(rest);
    var model = User.fromJson(decoded);
    modelTest(model, rest);
    return model;
  }
}

extension UserCreatedExt on UserCreated {
  static Future<UserCreated> fromFuture(Future<Response> future,
      {testModel = false}) async {
    var rest = (await future).body;
    var decoded = json.decode(rest);
    var model = UserCreated.fromJson(decoded);
    modelTest(model, rest);
    return model;
  }
}

extension UserStatusExt on UserStatus {
  static Future<UserStatus> fromFuture(Future<Response> future,
      {testModel = false}) async {
    var rest = (await future).body;
    var decoded = json.decode(rest);
    var model = UserStatus.fromJson(decoded);
    modelTest(model, rest);
    return model;
  }
}
