import 'package:flutter/material.dart';

class SideDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text("Choose"),
          ),
          ListTile(
            title: Text("Home"),
            leading: Icon(Icons.home),
            // trailing: Icon(Icons.home),
            onTap: () {
              Navigator.pushReplacementNamed(context, "/home");
            },
          ),
          ListTile(
            title: Text("Manage Products"),
            leading: Icon(Icons.edit),
            // trailing: Icon(Icons.edit),
            onTap: () {
              Navigator.pushReplacementNamed(context, "/admin");
            },
          ),
        ],
      ),
    );
  }
}
