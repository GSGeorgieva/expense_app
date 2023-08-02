part of project.entity;

@JsonSerializable()
class Currency {
  String? code;
  String? uid;

  Currency({this.code, this.uid});

  factory Currency.fromJson(Map<String, dynamic> json) =>
      _$CurrencyFromJson(json);

  Map<String, dynamic> toJson() => _$CurrencyToJson(this);
}
