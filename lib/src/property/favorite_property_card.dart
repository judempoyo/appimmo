import 'package:appimmo/src/property/property_controller.dart';
import 'package:appimmo/src/property/property_detail_screen.dart';
import 'package:appimmo/src/property/property_model.dart';
import 'package:appimmo/src/settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class FavoriteCard extends StatefulWidget {
  final Property property;
  final SettingsController settingsController;

  const FavoriteCard(
      {Key? key, required this.property, required this.settingsController})
      : super(key: key);

  @override
  _FavoriteCardState createState() => _FavoriteCardState();
}

class _FavoriteCardState extends State<FavoriteCard> {
  final PropertyController _propertyController = PropertyController();
  final String userId = firebase_auth.FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            widget.property.cover_url,
            height: 100,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.property.titre,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${widget.property.prix} €',
                  style: TextStyle(
                    fontSize: 14,
                    color: widget.settingsController.primaryColor,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to property details page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PropertyDetailsPage(
                              property: widget.property,
                              settingsController: widget.settingsController,
                            ),
                          ),
                        );
                      },
                      child: Text('Voir la maison'),
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await _propertyController.removeFavorite(
                            userId, widget.property.propertyId!);
                        setState(() {}); // Refresh the page
                      },
                      icon: Icon(Icons.delete, color: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
