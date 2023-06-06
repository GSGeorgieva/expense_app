part of main.dart;

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
            providerConfigs: const [
              EmailProviderConfiguration(),
              FacebookProviderConfiguration(clientId: '694381755705103'),
              GoogleProviderConfiguration(
                  clientId:
                      "1013723770905-n4t49p07m5c064aiacrjtokopn93uftc.apps.googleusercontent.com")
            ],
            headerBuilder: (context, constraints, shrinkOffset) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: AspectRatio(
                    aspectRatio: 1, child: Image.asset('assets/finance.png')),
              );
            },
            subtitleBuilder: (context, action) {
              return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0));
            },
            footerBuilder: (context, action) {
              return const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                    'By signing in, you agree to our terms and conditions.',
                    style: TextStyle(color: Colors.grey)),
              );
            },
          );
        }

        return FirstPage(date: DateTime.now());
      },
    );
  }
}
