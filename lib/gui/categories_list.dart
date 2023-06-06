part of main.dart;

class CategoriesRep extends StatefulWidget {
  const CategoriesRep({super.key});

  @override
  CategoriesState createState() => CategoriesState();
}

class CategoriesState extends State<CategoriesRep> {
  final _db = FirebaseFirestore.instance;

  getCategories() async {
    final colCat = await _db.collection('categories').get();
    return colCat.docs;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(),
          body: FutureBuilder(
            future: getCategories(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
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
                      .map((e) => e.data() as Map<String, dynamic>?)
                      .toList();
                  return GridView.count(
                      crossAxisCount: 3,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 8.0,
                      children: List.generate(el.length, (index) {
                        final dto = ent.Category.fromJson(el[index]!);
                        return Center(
                            child: SelectCard(dto,
                                onTap: () => {}, selected: false));
                      }));
                }
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          )),
    );
  }
}

class SelectCard extends StatelessWidget {
  SelectCard(this.cat,
      {super.key, required this.onTap, required this.selected});

  final ent.Category cat;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
            fixedSize: selected ? const Size(100, 100) : const Size(70, 70),
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(20),
            backgroundColor: Color(cat.color!)),
        child: Image.network(cat.icon!));
  }
}
