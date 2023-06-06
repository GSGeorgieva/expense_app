part of project.entity;

@JsonSerializable()
class Category {
  String? key;
  String? title;
  int? color;
  String? icon;

  Category({this.key, this.title, this.color, this.icon});


  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}
