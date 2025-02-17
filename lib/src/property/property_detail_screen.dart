import 'package:appimmo/src/property/property_controller.dart';
import 'package:appimmo/src/users/users_controller.dart';
import 'package:appimmo/src/users/users_model.dart';
import 'package:flutter/material.dart';
import 'package:appimmo/src/property/property_model.dart';
import 'package:appimmo/src/settings/settings_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class PropertyDetailsPage extends StatefulWidget {
  final Property property;
  final SettingsController settingsController;

  const PropertyDetailsPage({
    Key? key,
    required this.property,
    required this.settingsController,
  }) : super(key: key);

  @override
  _PropertyDetailsPageState createState() => _PropertyDetailsPageState();
}

class _PropertyDetailsPageState extends State<PropertyDetailsPage> {
  final UserController _userController = UserController();
  final PropertyController _propertyController = PropertyController();
  @override
  Widget build(BuildContext context) {
    final primaryColor = widget.settingsController.primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.property.titre,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 10,
        shadowColor: primaryColor.withOpacity(0.5),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image principale avec effet de dégradé
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.property.cover_url,
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Text(
                    widget.property.titre,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Galerie d'images
            if (widget.property.images.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Galerie d\'images',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      height: 120, // Hauteur de la galerie
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.property.images.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                widget.property.images[index],
                                width: 160, // Largeur de chaque image
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 16),

            // Section des caractéristiques principales
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.property.prix} €',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: widget.settingsController.primaryColor,
                    ),
                  ),
                  SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children: [
                      _buildFeatureItem(
                        icon: Icons.king_bed,
                        label: '${widget.property.nombrePieces} Chambres',
                      ),
                      _buildFeatureItem(
                        icon: Icons.bathtub,
                        label:
                            '${widget.property.nombreSallesDeBain} Salles de bain',
                      ),
                      _buildFeatureItem(
                        icon: Icons.square_foot,
                        label: '${widget.property.surface} m²',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Section de description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.property.description,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Section des détails
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Détails',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  _buildDetailRow('Type:', widget.property.type),
                  _buildDetailRow('Adresse:', widget.property.adresse),
                  _buildDetailRow('Ville:', widget.property.ville),
                  _buildDetailRow('Statut:', widget.property.statut),
                  _buildDetailRow('Tags:', widget.property.tags.join(', ')),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Section des informations de l'agent
            _buildAgentCard(),
            SizedBox(height: 24),

            // Section pour contacter l'agence
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contactez l\'agence pour organiser un rendez-vous :',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  TextButton(
                    onPressed: () async {
                      final url = Uri.parse(
                          'tel:+243975889135'); // Numéro de téléphone de l'agence
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Impossible de lancer l\'appel.'),
                          ),
                        );
                      }
                    },
                    child: Text(
                      '+243 97 58 89 135',
                      style: TextStyle(
                        fontSize: 16,
                        color: primaryColor,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
// Section des commentaires
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Commentaires',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ),
            SizedBox(height: 8),
            widget.property.comments.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('Aucun commentaire disponible'),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.property.comments.length,
                    itemBuilder: (context, index) {
                      final comment = widget.property.comments[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        elevation: 4,
                        shadowColor: Colors.black.withOpacity(0.1),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                comment.authorEmail,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                comment.content,
                                style: TextStyle(fontSize: 14),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Publié le : ${comment.createdAt.toLocal().toString().split(' ')[0]}',
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
            SizedBox(height: 16),
            // Section des annonces similaires
            _buildSimilarPropertiesSection(
                widget.property, widget.settingsController),
          ],
        ),
      ),
    );
  }

  Widget _buildSimilarPropertiesSection(
      Property currentProperty, SettingsController settingController) {
    return FutureBuilder<List<Property>>(
      future: _propertyController.getSimilarProperties(currentProperty),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Afficher un message d'erreur détaillé
          return Text('Erreur : ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('Aucune annonce similaire disponible');
        } else {
          final similarProperties = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Annonces Similaires',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: widget.settingsController.primaryColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: similarProperties.length,
                    itemBuilder: (context, index) {
                      final property = similarProperties[index];
                      return Card(
                        margin: EdgeInsets.only(right: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              property.cover_url,
                              height: 120,
                              width: 160,
                              fit: BoxFit.cover,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                property.titre,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text('${property.prix} €',
                                style: TextStyle(
                                    color: widget
                                        .settingsController.primaryColor)),
                            TextButton(
                              onPressed: () {
                                // Naviguer vers la page de détails de la propriété
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PropertyDetailsPage(
                                            property: property,
                                            settingsController:
                                                settingController,
                                          )),
                                );
                              },
                              child: Text('Voir détails'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildAgentCard() {
    return FutureBuilder<User?>(
      future: _userController.getUser(
          widget.property.agentId), // Récupère les informations de l'agent
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child:
                  CircularProgressIndicator()); // Affiche un indicateur de chargement
        } else if (snapshot.hasError) {
          return Text('Erreur lors du chargement des informations de l\'agent');
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Text('Aucune information disponible pour cet agent');
        } else {
          final agent = snapshot.data!;
          return GestureDetector(
            onTap: () {
              _showAgentInfo(
                  context, agent); // Affiche les informations de l'agent
            },
            child: Card(
              elevation: 4,
              shadowColor: Colors.black.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Publié par :',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      agent.nom +
                          ' ' +
                          agent.prenom, // Affiche le nom de l'agent
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  void _showAgentInfo(BuildContext context, User agent) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Informations de l\'agent'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nom : ${agent.nom}'),
              SizedBox(height: 8),
              Text('Email : ${agent.email}'), // Affiche l'email de l'agent
              SizedBox(height: 8),
              Text(
                  'Téléphone : ${agent.telephone}'), // Affiche le téléphone de l'agent
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Fermer'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFeatureItem({required IconData icon, required String label}) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey),
        SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Row(
      children: [
        Text(
          '$title ',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
