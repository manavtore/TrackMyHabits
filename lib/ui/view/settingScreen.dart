import 'package:flutter/material.dart';
import 'package:habit_tracker/features/auth/authcontroller.dart';
import 'package:habit_tracker/ui/view/loginPage.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
             ListTile(
              title: const Text('Dark Mode'),
              trailing: Switch(
                value: false,
                onChanged: (bool value) {
                  //change the theme
                },
              ),
              ),
              ListTile(
              title: const Text('Notifications'),
              trailing: Switch(
                value: false,
                onChanged: (bool value) {
                  //change the theme
                },
                
              ),
              ),
             ButtonBar(
              children: <Widget>[
                ElevatedButton(
                  onPressed: () async {
                   AuthenticationNotifier().signOut();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const loginScreen()));
                  },
                  child: const Text('Log Out'),
                ),
              ],
              )
          ],
        ),
      ),

    );
  }
}