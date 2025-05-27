import 'package:flutter/material.dart';

enum ThemeMode { light, dark, system }

class UserPreferences extends StatefulWidget {
  const UserPreferences({super.key});

  @override
  State<UserPreferences> createState() => _UserPreferencesState();
}

class _UserPreferencesState extends State<UserPreferences> {
  ThemeMode _theme = ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Preferences'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            ListView(
              shrinkWrap: true,
              children: [
                Card(
                  child: Column(
                    children: [
                      ListTile(title: Text("App Theme")),
                      RadioListTile(
                        title: const Text("Light"),
                        value: ThemeMode.light,
                        groupValue: _theme,
                        onChanged: (ThemeMode? value) {
                          setState(() {
                            _theme = value as ThemeMode;
                          });
                        },
                      ),
                      RadioListTile(
                        title: const Text("Dark"),
                        value: ThemeMode.dark,
                        groupValue: _theme,
                        onChanged: (ThemeMode? value) {
                          setState(() {
                            _theme = value as ThemeMode;
                          });
                        },
                      ),
                      RadioListTile(
                        title: const Text("System"),
                        value: ThemeMode.system,
                        groupValue: _theme,
                        onChanged: (ThemeMode? value) {
                          setState(() {
                            _theme = value as ThemeMode;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
