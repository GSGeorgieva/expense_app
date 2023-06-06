part of main.dart;

class CurrencyMain extends StatefulWidget {
  const CurrencyMain({super.key});

  @override
  CurrencyPick createState() => CurrencyPick();
}

class CurrencyPick extends State<CurrencyMain> {
  final _db = FirebaseFirestore.instance;

  insertCurrency(String name, String key) async {
    final cat = {'uid': FirebaseAuth.instance.currentUser?.uid, 'currency': ''};

    await _db.collection('currency').add(cat);
    // await _db.collection('currency').add(cat).whenComplete(() async =>
    //     Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //             builder: (BuildContext context) =>
    //                 FirstPage(date: DateTime.now()))));
  }

  final TextEditingController _value = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
          child: Column(
        children: [
          Center(
              child: ElevatedButton(
                  onPressed: () {
                    showCurrencyPicker(
                      context: context,
                      showFlag: true,
                      showSearchField: true,
                      showCurrencyName: true,
                      showCurrencyCode: true,
                      onSelect: (Currency currency) async{
                        _value.text = currency.name;
                        // await insertCurrency(currency.name, currency.symbol);
                      },
                      favorite: ['BGN'],
                    );
                  },
                  child: const Text('Pick currency'))),
          Container(
              width: 280,
              margin: const EdgeInsets.fromLTRB(0, 60, 0, 0),
              alignment: Alignment.center,
              child: TextField(
                textAlign: TextAlign.center,
                controller: _value,
                enabled: false,
              )),
        ],
      )),
    );
  }
}
