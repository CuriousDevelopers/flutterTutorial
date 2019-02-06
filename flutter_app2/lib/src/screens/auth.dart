import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';


/* 
A StatelessWidget will never rebuild by itself (but can from external events). A StatefulWidget can. That is the golden rule.

BUT any kind of widget can be repainted any times.

Stateless only means that all of its properties are immutable and that the only way to change them is to create a new instance of that widget. It doesn't e.g. lock the widget tree. */

///in this case, we definitely need to use setState for SwitchListTile (accept terms) to show the status right away
class Auth extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AuthState();
  }
}

class AuthState extends State<Auth> {
  
  Map<String, dynamic> _formValues = {
    "email": null,
    "password": null,
    "acceptTerms": true,
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DecorationImage _buildBackgroundImage() {
    return DecorationImage(
      image: AssetImage('assets/background.jpg'),
      colorFilter:
          ColorFilter.mode(Colors.white.withOpacity(0.3), BlendMode.dstATop),
      fit: BoxFit.cover,
    );
  }

  Widget _buildEmailTextField() {
    return TextFormField(
      onSaved: (value) {
        _formValues["email"] = value;
      },
      initialValue: "test@test.com",
      validator: (value) {
        if (value.isEmpty ||
            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) {
          return "invalid email";
        }
      },
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "you@test.com",
        filled: true,
        fillColor: Colors.white,
        icon: Icon(Icons.email),
      ),
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      onSaved: (value) {
        _formValues["password"] = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          return "invalid password";
        }
      },
      obscureText: true,
      initialValue: "Password123",
      decoration: InputDecoration(
        labelText: "Password",
        filled: true,
        fillColor: Colors.white,
        hintText: "Password",
        icon: Icon(Icons.security),
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return SwitchListTile(
      value: _formValues["acceptTerms"],
      onChanged: (value) {
        setState(() {
          _formValues["acceptTerms"] = value;
        });
      },
      title: Text("Accept Terms"),
    );
  }

  void submit(BuildContext context, Function loginFunction) {
    if (_formKey.currentState.validate()) {
      if (!_formValues["acceptTerms"]) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Accept the terms idiot!"),
              content: Text("Stupid!"),
              actions: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.thumb_up),
                )
              ],
            );
          },
        );
      } else {
        _formKey.currentState.save();
        loginFunction(_formValues["email"],_formValues["password"]);
        Navigator.pushReplacementNamed(context, "/products");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;

    return Scaffold(
        appBar: AppBar(
          title: Text("LOG IN!"),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: _buildBackgroundImage(),
          ),
          padding: EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  width: targetWidth,
                  child: Column(
                    children: <Widget>[
                      _buildEmailTextField(),
                      SizedBox(
                        height: 10.0,
                      ),
                      _buildPasswordTextField(),
                      _buildTermsCheckbox(),
                      SizedBox(
                        height: 20.0,
                      ),
                      ScopedModelDescendant(
                        builder: (BuildContext context, Widget child,
                            MainModel model) {
                          return RaisedButton(
                            child: Text("Login"),
                            onPressed: () => submit(context, model.login),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
