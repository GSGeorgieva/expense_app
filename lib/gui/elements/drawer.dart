part of main.dart;

Drawer getDrawer(BuildContext context) => Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: ClipOval(
              child: FirebaseAuth.instance.currentUser?.photoURL == null
                  ? Column(children: [
                      const CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          backgroundImage: AssetImage('assets/avatar.png')),
                      Text(FirebaseAuth.instance.currentUser!.displayName ?? '',
                          style: const TextStyle(color: Colors.white70)),
                      Text(FirebaseAuth.instance.currentUser!.email ?? '',
                          style: const TextStyle(color: Colors.white70))
                    ])
                  : Column(
                      children: [
                        CircleAvatar(
                          radius: 40.0,
                          backgroundImage: NetworkImage(
                              FirebaseAuth.instance.currentUser!.photoURL!),
                          backgroundColor: Colors.transparent,
                        ),
                        Text(FirebaseAuth.instance.currentUser!.displayName!,
                            style: const TextStyle(color: Colors.white70)),
                        Text(FirebaseAuth.instance.currentUser!.email!,
                            style: const TextStyle(color: Colors.white70))
                      ],
                    ),
            ),
          ),
          ListTile(
            title: const Text('Main'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          Home(date: DateTime.now())));
            },
          ),
          ListTile(
            title: const Text('Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CurrencyMain()),
              );
            },
          ),
          ListTile(
            title: const Text('My Categories'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CategoriesRep()),
              );
            },
          ),
          ListTile(
            title: const Text('Add Category'),
            onTap: () {
              AddCategory page = const AddCategory();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => page),
              );
            },
          ),
          Align(
              alignment: FractionalOffset.bottomCenter,
              child: Column(
                children: <Widget>[
                  const Divider(),
                  ElevatedButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        // Intent i=new Intent(getApplicationContext(),LoginActivity.class);
                        // startActivity(i);
                      },
                      child: const Text('Sign Out'))
                  // ButtonTheme(child: const SignOutButton(), )
                ],
              )),
        ],
      ),
    );
