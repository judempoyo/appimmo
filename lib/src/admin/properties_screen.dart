import 'dart:io';

import 'package:appimmo/src/property/property_controller.dart';
import 'package:appimmo/src/property/property_model.dart';
import 'package:appimmo/src/property/property_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PropertiesListScreen extends StatefulWidget {
  const PropertiesListScreen({Key? key}) : super(key: key);

  @override
  _PropertiesListScreenState createState() => _PropertiesListScreenState();
}

class _PropertiesListScreenState extends State<PropertiesListScreen> {
  final PropertyController _propertyController = PropertyController();
  List<Property> _properties = [];
  @override
  void initState() {
    super.initState();
    _loadProperties();
  }

  Future<void> _loadProperties() async {
    final properties = await _propertyController.getAllProperties();
    setState(() {
      _properties = properties;
    });
  }

  void _navigateToPropertyForm(BuildContext context, {Property? property}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PropertyFormScreen(property: property),
      ),
    ).then((_) => _loadProperties());
  }

  void _deleteProperty(String propertyId) async {
    await _propertyController.deleteProperty(propertyId);
    _loadProperties();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Biens Immobiliers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _navigateToPropertyForm(context),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _properties.length,
        itemBuilder: (context, index) {
          final property = _properties[index];
          return ListTile(
            title: Text(property.titre),
            subtitle: Text('${property.type} - ${property.prix} €'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () =>
                      _navigateToPropertyForm(context, property: property),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteProperty(property.propertyId!),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class PropertyFormScreen extends StatefulWidget {
  final Property? property;

  const PropertyFormScreen({Key? key, this.property}) : super(key: key);

  @override
  _PropertyFormScreenState createState() => _PropertyFormScreenState();
}

class _PropertyFormScreenState extends State<PropertyFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _propertyController = PropertyController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late String _titre;
  late String _description;
  late String _type;
  late double _prix;
  late double _surface;
  late int _nombrePieces;
  late String _adresse;
  late String _ville;
  late String _codePostal;
  late String _pays;
  File? _coverImage;
  List<File?> _images = [];

  @override
  void initState() {
    super.initState();
    if (widget.property != null) {
      _titre = widget.property!.titre;
      _description = widget.property!.description;
      _type = widget.property!.type;
      _prix = widget.property!.prix;
      _surface = widget.property!.surface;
      _nombrePieces = widget.property!.nombrePieces;
      _adresse = widget.property!.adresse;
      _ville = widget.property!.ville;
      _codePostal = widget.property!.codePostal;
      _pays = widget.property!.pays;
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _coverImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _addImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  Future<void> _saveProperty() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Upload cover image and get its URL
      String coverUrl = '';
      if (_coverImage != null) {
        coverUrl = await _propertyController.uploadImage(_coverImage!);
      } else if (widget.property != null) {
        coverUrl = widget.property!.cover_url;
      }

      // Upload additional images and get their URLs
      List<String> imageUrls = [];
      for (var image in _images) {
        if (image != null) {
          final url = await _propertyController.uploadImage(image);
          imageUrls.add(url);
        }
      }

      final property = Property(
        propertyId: widget.property?.propertyId ?? '',
        titre: _titre,
        description: _description,
        type: _type,
        prix: _prix,
        surface: _surface,
        nombrePieces: _nombrePieces,
        adresse: _adresse,
        ville: _ville,
        codePostal: _codePostal,
        pays: _pays,
        disponible: true,
        agentId: _auth.currentUser!.uid,
        likes: widget.property?.likes ?? [],
        comments: widget.property?.comments ?? [],
        images: imageUrls,
        cover_url: coverUrl,
      );

      if (widget.property == null) {
        _propertyController
            .createProperty(property, _coverImage, _images)
            .then((_) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Bien ajoutée avec succès !'),
              backgroundColor: Colors.green,
            ),
          );
        }).catchError((error) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur lors de l\'ajout : $error'),
              backgroundColor: Colors.red,
            ),
          );
        });
      } else {
        _propertyController.updateProperty(property).then((_) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Bien mise à jour avec succès !'),
              backgroundColor: Colors.green,
            ),
          );
        }).catchError((error) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur lors de la mise à jour : $error'),
              backgroundColor: Colors.red,
            ),
          );
        });
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.property == null ? 'Ajouter un Bien' : ' Modifier un Bien'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _titre,
                decoration: const InputDecoration(labelText: 'Titre'),
                validator: (value) =>
                    value!.isEmpty ? 'Veuillez entrer un titre' : null,
                onSaved: (value) => _titre = value!,
              ),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) =>
                    value!.isEmpty ? 'Veuillez entrer une description' : null,
                onSaved: (value) => _description = value!,
              ),
              TextFormField(
                initialValue: _type,
                decoration: const InputDecoration(labelText: 'Type'),
                validator: (value) =>
                    value!.isEmpty ? 'Veuillez entrer un type' : null,
                onSaved: (value) => _type = value!,
              ),
              TextFormField(
                initialValue: _prix.toString(),
                decoration: const InputDecoration(labelText: 'Prix'),
                validator: (value) =>
                    value!.isEmpty ? 'Veuillez entrer un prix' : null,
                onSaved: (value) => _prix = double.parse(value!),
              ),
              TextFormField(
                initialValue: _surface.toString(),
                decoration: const InputDecoration(labelText: 'Surface'),
                validator: (value) =>
                    value!.isEmpty ? 'Veuillez entrer une surface' : null,
                onSaved: (value) => _surface = double.parse(value!),
              ),
              TextFormField(
                initialValue: _nombrePieces.toString(),
                decoration:
                    const InputDecoration(labelText: 'Nombre de Pièces'),
                validator: (value) => value!.isEmpty
                    ? 'Veuillez entrer le nombre de pièces'
                    : null,
                onSaved: (value) => _nombrePieces = int.parse(value!),
              ),
              TextFormField(
                initialValue: _adresse,
                decoration: const InputDecoration(labelText: 'Adresse'),
                validator: (value) =>
                    value!.isEmpty ? 'Veuillez entrer une adresse' : null,
                onSaved: (value) => _adresse = value!,
              ),
              TextFormField(
                initialValue: _ville,
                decoration: const InputDecoration(labelText: 'Ville'),
                validator: (value) =>
                    value!.isEmpty ? 'Veuillez entrer une ville' : null,
                onSaved: (value) => _ville = value!,
              ),
              TextFormField(
                initialValue: _codePostal,
                decoration: const InputDecoration(labelText: 'Code Postal'),
                validator: (value) =>
                    value!.isEmpty ? 'Veuillez entrer un code postal' : null,
                onSaved: (value) => _codePostal = value!,
              ),
              TextFormField(
                initialValue: _pays,
                decoration: const InputDecoration(labelText: 'Pays'),
                validator: (value) =>
                    value!.isEmpty ? 'Veuillez entrer un pays' : null,
                onSaved: (value) => _pays = value!,
              ),
              const SizedBox(height: 20),
              // Bouton pour télécharger l'image de couverture
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Télécharger une image de couverture'),
              ),
              const SizedBox(height: 20),

              // Affichage de l'image de couverture sélectionnée ou existante
              _coverImage != null
                  ? CircleAvatar(
                      radius: 50,
                      backgroundImage: FileImage(_coverImage!),
                    )
                  : widget.property?.cover_url != null
                      ? CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              NetworkImage(widget.property!.cover_url),
                        )
                      : Text('Aucune image sélectionnée'),

              const SizedBox(height: 20),

              // Bouton pour ajouter une image supplémentaire
              ElevatedButton(
                onPressed: _addImage,
                child: Text('Ajouter une image'),
              ),
              const SizedBox(height: 20),

              // Affichage des images supplémentaires
              _images.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: _images.length,
                      itemBuilder: (context, index) {
                        return CircleAvatar(
                          radius: 50,
                          backgroundImage: FileImage(_images[index]!),
                        );
                      },
                    )
                  : widget.property?.images.isNotEmpty == true
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.property!.images.length,
                          itemBuilder: (context, index) {
                            return CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  NetworkImage(widget.property!.images[index]),
                            );
                          },
                        )
                      : Text('Aucune image ajoutée'),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProperty,
                child: const Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
