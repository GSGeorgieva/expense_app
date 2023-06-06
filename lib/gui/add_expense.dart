part of main.dart;

class ExpenseRp extends StatefulWidget {
  final ent.Category category;

  const ExpenseRp({super.key, required this.category});

  @override
  ExpenseState createState() => ExpenseState();
}

class ExpenseState extends State<ExpenseRp> {
  final _db = FirebaseFirestore.instance;
  late ElevatedButton btn;
  bool _isEnabled = false;
  final today = DateTime.now();

  insertExpense(ent.Category category) async {
    final cat = ent.Expense(
        icon: category.icon,
        title: category.title,
        color: category.color,
        date: DateTime.now().millisecondsSinceEpoch,
        uid: FirebaseAuth.instance.currentUser!.uid,
        value: num.parse(_value.value.text));

    await _db.collection('expenses').add(cat.toJson()).whenComplete(() async =>
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    FirstPage(date: DateTime.now()))));
  }

  final TextEditingController _value = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final formatedDate = DateFormat('yyyy-MM-dd').format(DateTime.now().toLocal());
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: ListView(
            children: [
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(widget.category.color!),
                    child: IconButton(
                      icon: Image.network(widget.category.icon!),
                      onPressed: () {},
                    ),
                  )),
              Row(
                children: [
                  Text(formatedDate),
                  ///todo ctreate calendar button
                  FloatingActionButton(
                    backgroundColor: Colors.blue,
                    onPressed: () {
                      Container(
                        height: 250,
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Value:'),
                          controller: _value,
                          onChanged: (v) => _isEnabled = v.isNotEmpty,
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.calendar_today,
                      size: 25,
                      color: Colors.black38,
                    ),
                  )
                ]
              ),
              SizedBox(
                // height: 600,
                child: CalendarDatePicker(
                  initialDate: today,
                  firstDate: DateTime(1999, 1, 1),
                  lastDate: DateTime(today.year + 20, today.month, today.day),
                  onDateChanged: (e) => {},
                )
                ,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  btn = ElevatedButton(
                    onPressed: () async {
                      _isEnabled ? await insertExpense(widget.category) : null;
                    },
                    child: const Text(
                      'Add',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
