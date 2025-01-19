import 'package:flutter/material.dart';
import 'package:appimmo/src/property/property_model.dart';
import 'package:appimmo/src/settings/settings_controller.dart';

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
  @override
  Widget build(BuildContext context) {
    final primaryColor = widget.settingsController.primaryColor;
    final secondaryColor = widget.settingsController.accentColor;

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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isLargeScreen = constraints.maxWidth > 600;
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isLargeScreen ? 32 : 16,
                vertical: 16,
              ),
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
                      Positioned(
                        bottom: 20,
                        right: 20,
                        child: Row(
                          children: [
                            Icon(Icons.favorite, color: Colors.white),
                            SizedBox(
                                width:
                                    4), // Ajout d'un espace entre l'icône et le texte
                            Text(
                              widget.property.likes.length.toString(),
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  // Section des informations de la propriété
                  if (isLargeScreen)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              _buildInfoCard(
                                title: 'Description',
                                content: Text(widget.property.description),
                                icon: Icons.description,
                                color: primaryColor,
                              ),
                              SizedBox(height: 16),
                              _buildInfoCard(
                                title: 'Détails',
                                content: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Type :',
                                          style: TextStyle(
                                              fontSize: 16, color: Colors.grey),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          widget.property.type,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Text(
                                          'Prix :',
                                          style: TextStyle(
                                              fontSize: 16, color: Colors.grey),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          '${widget.property.prix} €',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Text(
                                          'Surface :',
                                          style: TextStyle(
                                              fontSize: 16, color: Colors.grey),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          '${widget.property.surface} m²',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Text(
                                          'Nombre de pièces :',
                                          style: TextStyle(
                                              fontSize: 16, color: Colors.grey),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          widget.property.nombrePieces
                                              .toString(),
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Text(
                                          'Adresse :',
                                          style: TextStyle(
                                              fontSize: 16, color: Colors.grey),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          widget.property.adresse,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Text(
                                          'Ville :',
                                          style: TextStyle(
                                              fontSize: 16, color: Colors.grey),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          widget.property.ville,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Text(
                                          'Code postal :',
                                          style: TextStyle(
                                              fontSize: 16, color: Colors.grey),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          widget.property.codePostal,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Text(
                                          'Pays :',
                                          style: TextStyle(
                                              fontSize: 16, color: Colors.grey),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          widget.property.pays,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                icon: Icons.info,
                                color: secondaryColor,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            children: [
                              _buildAgentCard(),
                              SizedBox(height: 16),
                              if (widget.property.images.isNotEmpty)
                                _buildImageGallery(),
                            ],
                          ),
                        ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        _buildInfoCard(
                          title: 'Description',
                          content: Text(widget.property.description),
                          icon: Icons.description,
                          color: primaryColor,
                        ),
                        SizedBox(height: 16),
                        _buildInfoCard(
                          title: 'Détails',
                          content: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Type :',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    widget.property.type,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    'Prix :',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    '${widget.property.prix} €',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    'Surface :',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    '${widget.property.surface} m²',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    'Nombre de pièces :',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    widget.property.nombrePieces.toString(),
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    'Adresse :',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    widget.property.adresse,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    'Ville :',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    widget.property.ville,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    'Code postal :',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    widget.property.codePostal,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    'Pays :',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    widget.property.pays,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          icon: Icons.info,
                          color: secondaryColor,
                        ),
                        SizedBox(height: 16),
                        _buildAgentCard(),
                        SizedBox(height: 16),
                        if (widget.property.images.isNotEmpty)
                          _buildImageGallery(),
                      ],
                    ),
                  // Section des commentaires
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
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
                      ? Text('Aucun commentaire disponible')
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
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                  // Bouton pour contacter l'agent
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Code pour contacter l'agent
                      },
                      child: Text('Contacter l\'agent'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required Widget content,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildAgentCard() {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informations de l\'agent',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Nom : ${widget.property.agentId}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 4),
            /* Text(
              'Email : ${widget.property.agentEmail}',
              style: TextStyle(fontSize: 16),
            ), */
          ],
        ),
      ),
    );
  }

  Widget _buildImageGallery() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Galerie d\'images',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          SizedBox(height: 8),
          SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.property.images.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.property.images[index],
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
