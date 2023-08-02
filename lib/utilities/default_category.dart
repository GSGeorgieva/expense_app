part of main.dart;

Future insertDefaultCategories(FirebaseFirestore db) async {
  const path =
      'https://firebasestorage.googleapis.com/v0/b/project1-4cc92.appspot.com/o/';
  final colCat = await db
      .collection(ent.$Category.categories)
      .where(ent.$Category.uid,
          isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .get();
  if (colCat.docs.isEmpty) {
    final List<ent.Category> colCategories = [
      ent.Category()
        ..title = 'Groceries'
        ..color = 4284874597
        ..icon =
            '${path}groceries.png?alt=media&token=7aaf6641-3238-4e5b-b072-7d1183cf81ab'
        ..uid = FirebaseAuth.instance.currentUser?.uid,
      ent.Category()
        ..title = 'Water'
        ..color = 4287221744
        ..icon =
            '${path}water-tap.png?alt=media&token=cf051e8a-d725-48d8-8ff3-a6d6a2b476ec'
        ..uid = FirebaseAuth.instance.currentUser?.uid,
      ent.Category()
        ..title = 'Family'
        ..color = 4294967040
        ..icon =
            '${path}family.png?alt=media&token=e2328b83-833b-43df-8720-946f356e1da3'
        ..uid = FirebaseAuth.instance.currentUser?.uid,
      ent.Category()
        ..title = 'Food'
        ..color = 4293467747
        ..icon =
            '${path}fork.png?alt=media&token=b63b4fd9-f329-4820-af7e-e8d40edf1143'
        ..uid = FirebaseAuth.instance.currentUser?.uid,
      ent.Category()
        ..title = 'Beauty'
        ..color = 4294230722
        ..icon =
            '${path}skincare.png?alt=media&token=77c0f626-5a1d-430f-a161-eca170910728'
        ..uid = FirebaseAuth.instance.currentUser?.uid,
      ent.Category()
        ..title = 'Shopping'
        ..color = 4278255615
        ..icon =
            '${path}tshirt.png?alt=media&token=9e931f07-ee6d-4e3d-86f9-482c0137581e'
        ..uid = FirebaseAuth.instance.currentUser?.uid,
    ];
    for (final f in colCategories) {
      await db.collection(ent.$Category.categories).add(f.toJson());

      //
      // .whenComplete(() async =>
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (BuildContext context) =>
      //             Home(date: DateTime.now()))));
    }
  }
}
