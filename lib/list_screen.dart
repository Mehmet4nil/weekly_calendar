import 'package:flutter/material.dart';

class SecondRoute extends StatelessWidget {
  Widget _myListView;
  SecondRoute(this._myListView);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List Of Selected Items"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 595.0,
              child: _myListView,
            ),
            Center(
                child: RaisedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              textColor: Colors.white,
              padding: const EdgeInsets.all(0.0),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Color(0xFF0D47A1),
                      Color(0xFF1976D2),
                      Color(0xFF42A5F5),
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(10.0),
                child: const Text('Go Back', style: TextStyle(fontSize: 20)),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
