import 'package:flutter/material.dart';
import 'package:flutter_msal/flutter_msal.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const _clientId = '<YOUR_CLIENT_ID>';
  static const _redirectUri =
      'msauth://<YOUR_PACKAGE_NAME>/<YOUR_BASE64_URL_ENCODED_PACKAGE_SIGNATURE>';
  static const _authority = 'https://login.microsoftonline.com/common';

  final PublicClientApplication application = PublicClientApplication(
    configuration: const PublicClientApplicationConfiguration(
      clientId: _clientId,
      redirectUri: _redirectUri,
      authority: _authority,
    ),
  );

  String resultText = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('MSAL')),
        body: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  child: const Text('Sign in'),
                  onPressed: () async {
                    try {
                      final result = await application.signIn(
                        scopes: const ["user.read"],
                      );
                      setState(() => resultText = result.toString());
                    } on Exception catch (e) {
                      setState(() => resultText = e.toString());
                    }
                  },
                ),
                ElevatedButton(
                  child: const Text('Sign out'),
                  onPressed: () async {
                    try {
                      await application.signOut();
                      setState(() => resultText = "Signed out");
                    } on Exception catch (e) {
                      setState(() => resultText = e.toString());
                    }
                  },
                ),
                Text(resultText),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
