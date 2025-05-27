import 'package:digitaltrainingboards/settings/user_preferences.dart';
import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  title: const Text('Profile Settings'),
                  onTap: () {
                    // Navigate to board settings
                  },
                ),
                ListTile(
                  title: const Text('Board Settings'),
                  onTap: () {
                    // Navigate to board settings
                  },
                ),
                ListTile(
                  title: const Text('User Preferences'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UserPreferences(),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: const Text(
                    'Sign Out',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    // Navigate to about page
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
