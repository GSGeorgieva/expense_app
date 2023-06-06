part of main.dart;

Drawer getDrawer(BuildContext context) => Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Drawer Header'),
          ),
          ListTile(
            title: const Text('Currency'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CurrencyMain()),
              );
            },
          ),
          ListTile(
            title: const Text('Item 2'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Categories'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CategoriesRep()),
              );
            },
          ),
          Align(
              alignment: FractionalOffset.bottomCenter,
              child: Column(
                children: <Widget>[
                  const Divider(),
                  ButtonTheme(child: const SignOutButton())
                ],
              )),
        ],
      ),
    );
