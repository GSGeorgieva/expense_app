part of main.dart;

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  Categories createState() => Categories();
}

class Categories extends State<AddCategory> {
  final _db = FirebaseFirestore.instance;
  Color? defaultColor;
  int? optionSelected;
  ent.Category? category;
  bool? isDisabled;
  final TextEditingController _value = TextEditingController();
  bool listenForChange = true;
  late List docs;

  getCategories() async {
    if(!listenForChange) return docs;
    final colCat = await _db.collection(ent.$Icon.icons).get();
    return docs = colCat.docs;
  }

  void checkOption(int index) {
    listenForChange = false;
    if(optionSelected == index) return;
    setState(() {
      optionSelected = index;
    });
    prepareInsert();
  }

  void changeColor(Color color) {
    listenForChange = false;
    setState(() => defaultColor = color);
    prepareInsert();
  }


  void prepareInsert() {
    listenForChange = false;
    bool? currentSt = isDisabled;
    currentSt = category != null &&
        _value.text != '' &&
        defaultColor != Colors.transparent;
    if(currentSt != isDisabled) {
      setState(() {
      isDisabled = currentSt;
    });
    }
  }

  _insertCategory() async {
    final cat = ent.Category(
        icon: category!.icon,
        title: _value.value.text,
        color: defaultColor!.value,
        uid: FirebaseAuth.instance.currentUser!.uid);

    await _db
        .collection(ent.$Category.categories)
        .add(cat.toJson())
        .whenComplete(() async {
      const page = AddCategory();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (BuildContext context) => page));
    });
  }

  final GlobalKey formKey1 = GlobalKey();

  @override
  Widget build(BuildContext context) {
    defaultColor ??= Colors.transparent;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(children: [
            SingleChildScrollView(
                child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    height: 420,
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
                                } else if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  final data = snapshot.data as List;
                                  final el = data
                                      .map((e) =>
                                          e.data() as Map<String, dynamic>?)
                                      .toList();
                                  return SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 2,
                                    width: MediaQuery.of(context).size.width,
                                    child: GridView.count(
                                        crossAxisCount: 4,
                                        crossAxisSpacing: 4.0,
                                        mainAxisSpacing: 8.0,
                                        shrinkWrap: true,
                                        // new line
                                        children:
                                            List.generate(el.length, (index) {
                                          final dto =
                                              ent.Category.fromJson(el[index]!)
                                                ..color =
                                                    index == optionSelected
                                                        ? defaultColor!.value
                                                        : Colors.grey.value
                                                ..icon = el[index]!['path'];
                                          return Center(
                                              child: SelectCard(dto, onTap: () {
                                            category = dto;
                                            return checkOption(index);
                                          },
                                                  selected:
                                                      index == optionSelected));
                                        })),
                                  );
                                }
                              }
                              return const Center(
                                  child: CircularProgressIndicator());
                            })))),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 50,
                  width: 150,
                  margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: TextFormField(
                        key: formKey1,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.text,
                        style: const TextStyle(fontSize: 16),
                        onEditingComplete: () {
                          FocusScope.of(context).unfocus();
                          if(_value.value != '') prepareInsert();
                        },
                        decoration: const InputDecoration(
                            isDense: false, // Added this
                            contentPadding: EdgeInsets.zero),
                        controller: _value),
                  ),
                ),
                Container(
                  height: 50,
                  width: 150,
                  margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              defaultColor!.value == Colors.transparent.value
                                  ? Colors.blue
                                  : defaultColor),
                      onPressed: () => {
                            FocusScope.of(context).unfocus(),
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                      actions: <Widget>[
                                        ElevatedButton(
                                          child: const Text('Done'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                      content: SingleChildScrollView(
                                        child: MaterialPicker(
                                          pickerColor: defaultColor!,
                                          onColorChanged: changeColor,
                                          enableLabel: true,
                                        ),
                                      ));
                                })
                          },
                      child: const Text('Pick color')),
                ),
              ],
            ),
            Container(
                constraints:
                    const BoxConstraints.tightFor(width: 120, height: 40),
                margin: const EdgeInsets.fromLTRB(0, 100, 0, 0),
                // height: 100,
                alignment: Alignment.center,
                child: ElevatedButton(
                    onPressed: isDisabled == null || !isDisabled!
                        ? null
                        : _insertCategory,
                    child: const Text('Add', style: TextStyle(fontSize: 18.0))))
          ]),
        ));
  }
}
