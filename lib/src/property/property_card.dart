import 'package:appimmo/src/property/property_detail_screen.dart';
import 'package:appimmo/src/property/property_model.dart';
import 'package:appimmo/src/settings/settings_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class PropertyCard extends StatefulWidget {
  final Property property;
  final String userId;
  final Function(String) onLike;
  final Function(String) onFavorite;
  final SettingsController settingsController;

  const PropertyCard({
    Key? key,
    required this.property,
    required this.userId,
    required this.onLike,
    required this.onFavorite,
    required this.settingsController,
  }) : super(key: key);

  @override
  _PropertyCardState createState() => _PropertyCardState();
}

class _PropertyCardState extends State<PropertyCard> {
  late bool isLiked;
  late bool isFavorited;
  late int likeCount;
  final dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    isLiked = widget.property.likes.contains(widget.userId);
    isFavorited = widget.property.favorites.contains(widget.userId);
    likeCount = widget.property.likes.length;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image et badges
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: CachedNetworkImage(
                  imageUrl: widget.property.cover_url,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons
                      .error), // Optionnel: Afficher une icône d'erreur en cas de problème
                ), /* Image.network(
                  widget.property.cover_url,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ), */
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: widget.property.statut == 'en vente'
                        ? Colors.blue
                        : Colors.orange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.property.statut,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Wrap(
                  spacing: 4,
                  children: widget.property.tags.map((tag) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: widget.settingsController.primaryColor
                            .withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.property.titre,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${widget.property.prix} €',
                  style: TextStyle(
                    fontSize: 16,
                    color: widget.settingsController.primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined),
                    Text(
                      widget.property.adresse,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Type: ${widget.property.type}', // Afficher le type de propriété
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Ajouté le: ${dateFormat.format(widget.property.dateAjout)}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Description: ${widget.property.description}',
                  style: const TextStyle(fontSize: 14),
                  maxLines: 2, // Limiter à 2 lignes
                  overflow: TextOverflow
                      .ellipsis, // Ajouter des points de suspension si trop long
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
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
                      child: Text('Voir la propriete'),
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () async {
                            await widget.onLike(widget.property.propertyId!);
                            setState(() {
                              isLiked = !isLiked;
                              likeCount =
                                  isLiked ? likeCount + 1 : likeCount - 1;
                            });
                          },
                          icon: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: isLiked ? Colors.red : Colors.grey,
                          ),
                        ),
                        Text(
                            '$likeCount'), // Afficher le nombre de likes mis à jour
                        IconButton(
                          onPressed: () async {
                            await widget
                                .onFavorite(widget.property.propertyId!);
                            setState(() {
                              isFavorited = !isFavorited;
                            });
                          },
                          icon: Icon(
                            isFavorited
                                ? Icons.star_outlined
                                : Icons.star_outline,
                            color: isFavorited ? Colors.yellow : Colors.grey,
                          ),
                        ),
                      ],
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
