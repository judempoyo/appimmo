import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:appimmo/src/settings/settings_controller.dart';

class AdminLiveStreamPage extends StatefulWidget {
  const AdminLiveStreamPage({super.key, required this.settingsController});
  final SettingsController settingsController;

  @override
  _AdminLiveStreamPageState createState() => _AdminLiveStreamPageState();
}

class _AdminLiveStreamPageState extends State<AdminLiveStreamPage> {
  final _formKey = GlobalKey<FormState>();
  final _videoIdController = TextEditingController();
  bool _isLive = false;

  final DatabaseReference _databaseRef =
      FirebaseDatabase.instance.ref('liveStream');

  Future<void> _updateLiveStatus() async {
    if (_formKey.currentState!.validate()) {
      final videoId = _videoIdController.text.trim();
      final isLive = _isLive;

      // Sauvegarder les données dans Firebase Realtime Database
      await _databaseRef.set({
        'isLive': isLive,
        'videoId': videoId,
      });

      // Afficher un message de succès
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Statut du live mis à jour avec succès !'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion du Live'),
        backgroundColor: widget.settingsController.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SwitchListTile(
                title: Text('Activer le live'),
                value: _isLive,
                onChanged: (value) {
                  setState(() {
                    _isLive = value;
                  });
                },
              ),
              TextFormField(
                controller: _videoIdController,
                decoration: InputDecoration(
                  labelText: 'ID de la vidéo YouTube Live',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un ID de vidéo valide';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateLiveStatus,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.settingsController.primaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Mettre à jour',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
