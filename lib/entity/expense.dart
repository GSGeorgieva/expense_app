part of project.entity;

@JsonSerializable()
class Expense {
  int? color;
  String? icon;
  String? title;
  num? value;
  String? uid;
  int? date;

  DateTime? get getDate => DateTime.fromMicrosecondsSinceEpoch(date!);

  Expense({this.title, this.color, this.icon, this.value, this.date, this.uid});

  factory Expense.fromJson(Map<String, dynamic> json) =>
      _$ExpenseFromJson(json);

  Map<String, dynamic> toJson() => _$ExpenseToJson(this);
}

class ExpenseCollection<E extends Expense> extends Collection {

  ExpenseCollection sortData(List<Map<String, dynamic>?>? data) {
    final ExpenseCollection res = ExpenseCollection();
    if(data == null) return res;
    for (final d in data) {
      final exp = Expense.fromJson(d!);
      Expense? current = res.firstWhereOrNull((c) => c?.title == exp.title);
      if (current == null) {
        res.add(current = Expense()
          ..title = exp.title
          ..color = exp.color
          ..icon = exp.icon
          ..value = 0);
      }
      current.value = current.value! + exp.value!;
    }
    return res;
  }

  Map<String, double> pieData(ExpenseCollection data) {
    final Map<String, double> result = {};
    for (final d in data) {
      if (!result.containsKey(d!.title)) {
        result.addAll({d.title!: 0});
      }
      result[d.title!] = result[d.title!]! + d.value!;
    }
    return result;
  }
}
