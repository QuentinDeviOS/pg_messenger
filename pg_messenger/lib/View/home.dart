import 'package:flutter/material.dart';
import 'package:pg_messenger/View/login.dart';
import 'package:pg_messenger/View/messageView.dart';
import 'package:pg_messenger/View/register.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Menu"),
        ),
        body: Column(
          children: [
            Spacer(),
            Center(
              child: ElevatedButton(
                child: Text('Login Page'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
              ),
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                child: Text('Registration Page'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Register()),
                  );
                },
              ),
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                child: Text('Messages Page'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MessageView()),
                  );
                },
              ),
            ),
            Spacer(),
          ],
        ));
  }
}
