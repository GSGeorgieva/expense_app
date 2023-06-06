part of main.dart;

class FirstPage extends StatelessWidget {
  bool? isMonth, isYear, isDay;
  late String dateFormatted;

  FirstPage(
      {super.key, required this.date, this.isMonth, this.isDay, this.isYear});

  late DateTime date;
  final _db = FirebaseFirestore.instance;

  getDailyExp() async {
    if (isMonth == null && isYear == null && isDay == null) isDay = true;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    late DateTime qD1, qD2;
    if (isDay != null && isDay!) {
      qD1 = DateTime(date.year, date.month, date.day);
      qD2 = DateTime(date.year, date.month, date.day)
          .add(const Duration(days: 1));
      dateFormatted = DateFormat('yyyy-MM-dd').format(date.toLocal());
    } else if (isMonth != null && isMonth!) {
      qD1 = DateTime(date.year, date.month, 1);
      qD2 = DateTime(date.year, date.month + 1, 1);
      dateFormatted = DateFormat(DateFormat.YEAR_MONTH).format(date.toLocal());
    } else if (isYear != null && isYear!) {
      qD1 = DateTime(date.year, 1, 1);
      qD2 = DateTime(qD1.year + 1, qD1.month + qD1.day);
      dateFormatted = DateFormat(DateFormat.YEAR).format(date.toLocal());
    }

    final colCat = await _db
        .collection(ent.$Expense.expenses)
        .where(ent.$Expense.uid, isEqualTo: uid)
        .where(ent.$Expense.date,
            isGreaterThanOrEqualTo: qD1.millisecondsSinceEpoch)
        .where(ent.$Expense.date, isLessThan: qD2.millisecondsSinceEpoch)
        .get();

    return colCat.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('')),
        backgroundColor: Colors.grey[200],
        body: FutureBuilder(
            future: getDailyExp(),
            builder: (ctx, snapshot) {
              double total = 0;
              List<Color> colors = [];
              List<ent.Expense?> sorted = [];
              if (snapshot.connectionState == ConnectionState.done) {
                final data = snapshot.data as List;
                final el =
                    data.map((e) => e.data() as Map<String, dynamic>?).toList();
                sorted = ent.ExpenseCollection().sortData(el)
                  ..sort(((c, n) => n!.value!.compareTo(c!.value!)));
                for (var s in sorted) {
                  total = total + s!.value!;
                  colors.add(Color(s.color!));
                }
              }
              return Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: (isDay == null || !isDay!)
                                ? () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            FirstPage(
                                                date: DateTime.now(),
                                                isDay: true)))
                                : null,
                            child: const Text('Day')),
                        ElevatedButton(
                            onPressed: (isMonth == null || !isMonth!)
                                ? () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            FirstPage(
                                                date: DateTime.now(),
                                                isMonth: true)))
                                : null,
                            child: const Text('Month')),
                        ElevatedButton(
                            onPressed: (isYear == null || !isYear!)
                                ? () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            FirstPage(
                                                date: DateTime.now(),
                                                isYear: true)))
                                : null,
                            child: const Text('Year')),
                      ]),
                  SingleChildScrollView(
                      child: Container(
                          margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          padding: const EdgeInsets.fromLTRB(5, 20, 5, 10),
                          constraints: const BoxConstraints(maxHeight: 360),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25.0)),
                          child: Wrap(children: [
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      height: 30,
                                      child: FloatingActionButton(
                                          heroTag: 'btn1',
                                          backgroundColor: Colors.blue,
                                          onPressed: () {
                                            if (isYear != null && isYear!) {
                                              date =
                                                  DateTime(date.year - 1, 1, 1);
                                            } else if (isMonth != null &&
                                                isMonth!) {
                                              date = DateTime(
                                                  date.year, date.month - 1, 1);
                                            } else if (isDay != null &&
                                                isDay!) {
                                              date = date.subtract(
                                                  const Duration(days: 1));
                                            }
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        FirstPage(
                                                            date: date,
                                                            isMonth: isMonth,
                                                            isYear: isYear,
                                                            isDay: isDay)));
                                          },
                                          child: const ImageIcon(
                                              AssetImage('assets/left.png'),
                                              size: 20,
                                              color: Colors.white))),
                                  SizedBox(
                                      height: 20, child: Text(dateFormatted)),
                                  SizedBox(
                                      height: 30,
                                      child: FloatingActionButton(
                                          heroTag: 'btn2',
                                          backgroundColor: Colors.blue,
                                          onPressed: () {
                                            if (isYear != null && isYear!) {
                                              date =
                                                  DateTime(date.year + 1, 1, 1);
                                            } else if (isMonth != null &&
                                                isMonth!) {
                                              date = DateTime(
                                                  date.year, date.month + 1, 1);
                                            } else if (isDay != null &&
                                                isDay!) {
                                              date = date
                                                  .add(const Duration(days: 1));
                                            }
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        FirstPage(
                                                            date: date,
                                                            isMonth: isMonth,
                                                            isYear: isYear,
                                                            isDay: isDay)));
                                          },
                                          child: const ImageIcon(
                                            AssetImage('assets/right.png'),
                                            size: 20,
                                            color: Colors.white,
                                          )))
                                ]),
                            Container(
                                height: 250,
                                alignment: Alignment.topCenter,
                                child: PieChart(
                                    legendOptions:
                                        const LegendOptions(showLegends: false),
                                    chartValuesOptions:
                                        const ChartValuesOptions(
                                            showChartValues: false),
                                    dataMap: sorted.isNotEmpty
                                        ? ent.ExpenseCollection()
                                            .pieData(sorted)
                                        : {"empty": 0},
                                    chartType: ChartType.ring,
                                    colorList: colors.isNotEmpty
                                        ? colors
                                        : [Colors.transparent],
                                    centerTextStyle: const TextStyle(
                                        fontSize: 18, color: Colors.black),
                                    emptyColor: Colors.transparent,
                                    centerText:
                                        '${total == 0 ? 'No expenses' : total}',
                                    chartRadius: 200,
                                    ringStrokeWidth: 34.0)),
                            Container(
                                height: 35,
                                alignment: Alignment.bottomRight,
                                child: FloatingActionButton(
                                    heroTag: 'btn3',
                                    backgroundColor: Colors.blue,
                                    onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                ExpensePage(
                                                    date: DateTime.now()))),
                                    child: const Icon(Icons.add,
                                        size: 20, color: Colors.white)))
                          ]))),
                  SizedBox(
                      height: 240,
                      child: ListView(
                          shrinkWrap: true,
                          children: List.generate(sorted.length, (index) {
                            final exp = sorted[index];
                            return AboutListTile(child: DailyExpenseRow(exp));
                          })))
                ],
              );
            }),
        drawer: getDrawer(context));
  }
}

class DailyExpenseRow extends StatelessWidget {
  final ent.Expense? cat;

  const DailyExpenseRow(this.cat, {super.key});

  @override
  Widget build(BuildContext context) {
    if (cat != null) {
      return Container(
          height: 58,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(25.0)),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Color(cat!.color!),
                        child: Image.network(cat!.icon!, width: 22))),
                Container(
                    alignment: Alignment.center,
                    child: Text(cat!.title!,
                        style: const TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.bold))),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Text('${cat!.value!} lv'),
                )
              ]));
    } else {
      return Container(height: 80, width: 1000, color: Colors.grey);
    }
  }
}
