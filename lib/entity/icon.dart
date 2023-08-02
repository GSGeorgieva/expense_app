part of project.entity;

@JsonSerializable()
class Icon {
  String? path;

  Icon({this.path});

  factory Icon.fromJson(Map<String, dynamic> json) => _$IconFromJson(json);

  Map<String, dynamic> toJson() => _$IconToJson(this);
}
