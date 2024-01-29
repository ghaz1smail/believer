import 'package:believer/controller/app_localization.dart';
import 'package:believer/controller/my_app.dart';
import 'package:believer/views/screens/splash_screen.dart';
import 'package:believer/views/widgets/edit_text.dart';
import 'package:flutter/material.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete your account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: auth.userData.uid.isEmpty
            ? Column(
                children: [
                  const Text(
                    'Enter your email and password to delete your account',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  EditText(
                      hint: 'example@gmail.com',
                      function: () {},
                      controller: auth.email,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'pleaseEmail'.tr(context);
                        }
                        return null;
                      },
                      title: 'email'),
                  const SizedBox(
                    height: 10,
                  ),
                  EditText(
                      hint: '',
                      function: () {},
                      controller: auth.password,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'pleasePassword'.tr(context);
                        }
                        return null;
                      },
                      title: 'password'),
                  const SizedBox(
                    height: 10,
                  ),
                  MaterialButton(
                    onPressed: () {
                      if (auth.email.text.isNotEmpty &&
                          auth.password.text.isNotEmpty) {
                        auth.logOut();
                      }
                    },
                    color: primaryColor,
                    child: const Text('Delete'),
                  ),
                ],
              )
            : Column(
                children: [
                  const Text(
                    'Are you sure you want to delete your account?',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          auth.logOut();
                        },
                        color: primaryColor,
                        child: const Text('Yes'),
                      ),
                      MaterialButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, 'user');
                        },
                        textColor: Colors.white,
                        color: Colors.red,
                        child: const Text('No'),
                      )
                    ],
                  )
                ],
              ),
      ),
    );
  }
}
