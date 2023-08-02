library project.entity;

import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

part 'entity.g.dart';
part 'entity/category.dart';
part 'entity/collection.dart';
part 'entity/currency.dart';
part 'entity/expense.dart';
part 'entity/icon.dart';

Future<List> getExpenses(FirebaseFirestore db, DateTime d, String? uid,
    {bool? isDay, bool? isMonth, bool? isYear}) async {
  if (isMonth == null && isYear == null && isDay == null) isDay = true;

  late DateTime qD1, qD2;
  if (isDay != null && isDay) {
    qD1 = DateTime(d.year, d.month, d.day);
    qD2 = DateTime(d.year, d.month, d.day).add(const Duration(days: 1));
  } else if (isMonth != null && isMonth) {
    qD1 = DateTime(d.year, d.month, 1);
    qD2 = DateTime(d.year, d.month + 1, 1);
  } else {
    qD1 = DateTime(d.year, 1, 1);
    qD2 = DateTime(qD1.year + 1, qD1.month + qD1.day);
  }

  final colCat = await db
      .collection($Expense.expense)
      .where($Expense.uid, isEqualTo: uid)
      .where($Expense.date, isGreaterThanOrEqualTo: qD1.millisecondsSinceEpoch)
      .where($Expense.date, isLessThan: qD2.millisecondsSinceEpoch)
      .get();

  return colCat.docs;
}

Future<String?> getCurrency(FirebaseFirestore db, String? uid) async {
  String currencyCode;
  final colCurrency = await db
      .collection('currency')
      .where($Expense.uid, isEqualTo: uid)
      .get();
  currencyCode = colCurrency.docs.first['currency'];
  return currencyCode;
}
