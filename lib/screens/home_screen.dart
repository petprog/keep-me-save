import 'package:flutter/material.dart';

import '../superbase/supabase_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _supabaseClient = SupabaseManager();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Home Page"),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: handleClick,
              itemBuilder: (BuildContext context) {
                return {
                  'Logout',
                }.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: const SizedBox(
            height: double.infinity,
            child: Center(
              child: Text("You are successfully logged in"),
            )));
  }

  void handleClick(String value) {
    switch (value) {
      case 'Logout':
        _supabaseClient.logout(context);
        break;
    }
  }
}
