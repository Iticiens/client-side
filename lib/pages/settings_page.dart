import 'package:flutter/material.dart';
import 'package:iot/main.dart';
import '../widgets/app_layout.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: Icon(Icons.color_lens),
          title: Text('Theme'),
          onTap: () => showPreferencesDailog(context),
        ),
        ListTile(
          leading: Icon(Icons.speed),
          title: Text('Speed Units'),
          trailing: Text('km/h'),
        ),
        // Add more settings as needed
      ],
    );
  }
}
