part of main.dart;

class CurrencyMain extends StatefulWidget {
  const CurrencyMain({super.key});

  @override
  CurrencyPick createState() => CurrencyPick();
}

class CurrencyPick extends State<CurrencyMain> {
  final _db = FirebaseFirestore.instance;
  final TextEditingController _value = TextEditingController();
  String? currencyCode;
  bool isDisabled = true;
  bool listenForChanges = true;

  Future insertCurrency() async {
    final data = {
      ent.$Currency.uid: FirebaseAuth.instance.currentUser?.uid,
      ent.$Currency.code: currencyCode
    };

    await _db.collection(ent.$Currency.currency).get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });

    await _db.collection(ent.$Currency.currency).add(data).whenComplete(
        () async => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    Home(date: DateTime.now()))));
  }

  Future getCurrency() async {
    if (!listenForChanges) return;
    final colCat = await _db
        .collection(ent.$Currency.currency)
        .where(ent.$Expense.uid,
            isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();
    colCat.docs;
    currencyCode = colCat.docs.first[ent.$Currency.code];
  }
  void checkCurrency(String? code) {
    if (code == currencyCode) return;
    currencyCode = code;
    if (code == null) return;
    setState(() {
      listenForChanges = false;
      isDisabled = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: FutureBuilder(
            future: getCurrency(),
            builder: (cts, snapshot) {
              return Form(
                  child: Column(children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: const EdgeInsetsDirectional.fromSTEB(
                              10, 20, 0, 0),
                          child: const Text("Currency: ",
                              style: TextStyle(fontSize: 26))),
                      Container(
                          margin: const EdgeInsetsDirectional.fromSTEB(
                              10, 20, 0, 0),
                          child: Text(currencyCode ?? 'N/A',
                              style: const TextStyle(fontSize: 26)))
                    ]),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                      margin:
                          const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 10),
                      child: ElevatedButton(
                          onPressed: () {
                            showCurrencyPicker(
                                context: context,
                                showFlag: true,
                                showSearchField: true,
                                showCurrencyName: true,
                                showCurrencyCode: true,
                                onSelect: (Currency currency) {
                                  _value.text = currency.name;
                                  checkCurrency(currency.code);
                                },
                                favorite: ['BGN']);
                          },
                          child: Text(currencyCode != null
                              ? 'Change currency'
                              : 'Pick currency')))
                ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [Container(height: 480)]),
                Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                        onPressed: isDisabled ? null : insertCurrency,
                        child: const Text('Save',
                            style: TextStyle(fontSize: 18.0))))
              ]));
            }));
  }
}
