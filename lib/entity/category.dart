part of project.entity;

@JsonSerializable()
class Category {
  String? title;
  int? color;
  String? icon;
  String? uid;

  Category({this.title, this.color, this.icon, this.uid});


  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}
