part of main.dart;

class ExpensePage extends StatefulWidget {
  final DateTime? date;

  const ExpensePage({super.key, this.date});

  @override
  ExpenseCont createState() => ExpenseCont()..date = date ?? DateTime.now();
}

class ExpenseCont extends State<ExpensePage> {
  List? categories;
  late DateTime date;
  num? value;
  final TextEditingController _sum = TextEditingController();
  final _db = FirebaseFirestore.instance;
  late ElevatedButton btnAdd;
  int? optionSelected;
  ent.Category? category;
  bool? isEnabled = false;
  late String _dateRep;
  String? currencyCode;
  bool listenForChange = false;

  _insertExpense() async {
    final cat = ent.Expense(
        icon: category!.icon,
        title: category!.title,
        color: category!.color,
        date: date.millisecondsSinceEpoch,
        uid: FirebaseAuth.instance.currentUser!.uid,
        value: num.parse(_sum.value.text));

    await _db.collection(ent.$Expense.expense).add(cat.toJson()).whenComplete(
        () async => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => Home(date: date))));
  }

  getCategories() async {
    if (categories != null) return categories;
    final colCat = await _db
        .collection(ent.$Category.categories)
        .where(ent.$Category.uid,
            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    categories = colCat.docs;
    return categories;
  }

  void checkOption(int index) {
    prepareInsert();
    setState(() {
      optionSelected = index;
    });
  }

  void prepareInsert() {
    setState(() {
      isEnabled = category != null && _sum.text != '';
    });
  }

  void changeDate(DateTime? v) {
    setState(() {
      if (v != null) date = v;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('AAAA $date');
    _dateRep = DateFormat('yyyy-MM-dd').format(date.toLocal());
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: [
                      Container(
                          height: 40,
                          width: 200,
                          margin: const EdgeInsets.fromLTRB(50, 30, 10, 0),
                          child: TextFormField(
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(fontSize: 26),
                              decoration: const InputDecoration(
                                  isDense: true, // Added this
                                  contentPadding: EdgeInsets.zero),
                              controller: _sum,
                              onEditingComplete: () {
                                FocusScope.of(context).unfocus();
                                prepareInsert();
                              }))
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: (Column(
                      children: [
                        ElevatedButton(
                          child: const Icon(Icons.calendar_today_outlined),
                          onPressed: () {
                            showDatePicker(
                                    context: context,
                                    initialDate: date,
                                    firstDate: DateTime(2000, 1, 1),
                                    lastDate: DateTime(date.year + 5, 1, 1))
                                .then((value) => changeDate(value));
                          },
                        ),
                        Text(_dateRep)
                      ],
                    )),
                  )
                ]),
            SingleChildScrollView(
                child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                    height: 500,
                    width: MediaQuery.of(context).size.width,
                    child: Scaffold(
                        body: FutureBuilder(
                            future: getCategories(),
                            builder: (ctx, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (snapshot.hasError) {
                                  return Center(
                                    child: Text(
                                      '${snapshot.error} occurred',
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  );
                                } else if (snapshot.hasData) {
                                  final data = snapshot.data as List;
                                  final el = data
                                      .map((e) =>
                                          e.data() as Map<String, dynamic>?)
                                      .toList();
                                  return GridView.count(
                                      crossAxisCount: 4,
                                      crossAxisSpacing: 0,
                                      mainAxisSpacing: 0,
                                      children:
                                          List.generate(el.length, (index) {
                                        final dto =
                                            ent.Category.fromJson(el[index]!);
                                        return Center(
                                            child: SelectCard(dto, onTap: () {
                                          category = dto;
                                          return checkOption(index);
                                        }, selected: index == optionSelected));
                                      }));
                                }
                              }
                              return const Center(
                                  child: CircularProgressIndicator());
                            })))),
            Container(
                constraints:
                    const BoxConstraints.tightFor(width: 120, height: 40),
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                // height: 100,
                alignment: Alignment.center,
                child: ElevatedButton(
                    onPressed: isEnabled == null || !isEnabled!
                        ? null
                        : _insertExpense,
                    child: const Text('Add', style: TextStyle(fontSize: 18.0))))
          ]),
        ));
  }
}
