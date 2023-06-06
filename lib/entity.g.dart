// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      key: json['key'] as String?,
      title: json['title'] as String?,
      color: json['color'] as int?,
      icon: json['icon'] as String?,
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'key': instance.key,
      'title': instance.title,
      'color': instance.color,
      'icon': instance.icon,
    };

abstract class $Expense {
  static const String expenses = 'expenses',
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
