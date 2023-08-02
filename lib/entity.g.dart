// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

abstract class $Category {
  static const String categories = 'categories',
      key = 'key',
      title = 'title',
      color = 'color',
      icon = 'icon',
      uid = 'uid';
}

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      title: json['title'] as String?,
      color: json['color'] as int?,
      icon: json['icon'] as String?,
      uid: json['uid'] as String?,
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'title': instance.title,
      'color': instance.color,
      'icon': instance.icon,
      'uid': instance.uid,
    };

abstract class $Currency {
  static const String currency = 'currency', code = 'code', uid = 'uid';
}

Currency _$CurrencyFromJson(Map<String, dynamic> json) => Currency(
      code: json['code'] as String?,
      uid: json['uid'] as String?,
    );

Map<String, dynamic> _$CurrencyToJson(Currency instance) => <String, dynamic>{
      'code': instance.code,
      'uid': instance.uid,
    };

abstract class $Expense {
  static const String expense = 'expense',
      title = 'title',
      color = 'color',
      icon = 'icon',
      value = 'value',
      date = 'date',
      uid = 'uid';
}

Expense _$ExpenseFromJson(Map<String, dynamic> json) => Expense(
      title: json['title'] as String?,
      color: json['color'] as int?,
      icon: json['icon'] as String?,
      value: json['value'] as num?,
      date: json['date'] as int?,
      uid: json['uid'] as String?,
    );

Map<String, dynamic> _$ExpenseToJson(Expense instance) => <String, dynamic>{
      'color': instance.color,
      'icon': instance.icon,
      'title': instance.title,
      'value': instance.value,
      'uid': instance.uid,
      'date': instance.date,
    };

abstract class $Icon {
  static const String icons = 'icons', path = 'path';
}

Icon _$IconFromJson(Map<String, dynamic> json) => Icon(
      path: json['path'] as String?,
    );

Map<String, dynamic> _$IconToJson(Icon instance) =>
    <String, dynamic>{'path': instance.path};
