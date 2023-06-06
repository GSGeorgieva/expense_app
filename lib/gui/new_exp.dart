part of main.dart;

class ExpensePage extends StatefulWidget {
  final DateTime? date;

  const ExpensePage({super.key, this.date});

  @override
  ExpenseCont createState() => ExpenseCont();
}

class ExpenseCont extends State<ExpensePage> {
  DateTime? date;
  num? value;
  final TextEditingController _sum = TextEditingController();
  final _db = FirebaseFirestore.instance;
  late ElevatedButton btnAdd;
  int? optionSelected;
  ent.Category? category;
  bool? isDisabled;

  _insertExpense() async {
    final cat = ent.Expense(
        icon: category!.icon,
        title: category!.title,
        color: category!.color,
        date: DateTime.now().millisecondsSinceEpoch,
        uid: FirebaseAuth.instance.currentUser!.uid,
        value: num.parse(_sum.value.text));

    await _db.collection('expenses').add(cat.toJson()).whenComplete(() async =>
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    FirstPage(date: date ?? DateTime.now()))));
  }

  getCategories() async {
    final colCat = await _db.collection('categories').get();
    return colCat.docs;
  }

  void checkOption(int index) {
    setState(() {
      optionSelected = index;
      prepareInsert();
    });
  }

  void prepareInsert() {
    setState(() {
      isDisabled = category != null && _sum.text != '';
    });
  }

  @override
  Widget build(BuildContext context) {
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
                          height: 20,
                          width: 100,
                          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: TextFormField(
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  isDense: true, // Added this
                                  contentPadding: EdgeInsets.zero),
                              controller: _sum,
                              onChanged: (_) => prepareInsert())),
                      const SizedBox(
                          child: Text('Curr',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16, height: 2)))
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: (ElevatedButton(
                      child: Icon(Icons.calendar_today_outlined),
                      onPressed: () {
                        showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now()
                        );
                      },
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
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                height: 50,
                alignment: Alignment.center,
                child: ElevatedButton(
                    onPressed: isDisabled == null || !isDisabled!
                        ? null
                        : _insertExpense,
                    child: const Text('Add', style: TextStyle(fontSize: 18.0))))
          ]),
        ));
  }
}
