import 'dart:io';

import 'package:appimmo/src/property/property_detail_screen.dart';
import 'package:appimmo/src/settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:appimmo/src/property/property_model.dart';
import 'package:appimmo/src/property/property_service.dart';
import 'package:file_picker/file_picker.dart';

class PropertyListPage extends StatefulWidget {
  final SettingsController settingsController;

  const PropertyListPage({super.key, required this.settingsController});

  @override
  _PropertyListPageState createState() => _PropertyListPageState();
}

class _PropertyListPageState extends State<PropertyListPage> {
  final PropertyService _propertyService = PropertyService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Propriétés'),
      ),
      body: FutureBuilder(
        future: _propertyService.getAllProperties(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            PopupMenuButton(
                              icon: Icon(Icons.more_horiz),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      Icon(Icons.remove_red_eye),
                                      SizedBox(width: 10),
                                      Text('Voir la propriété'),
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PropertyDetailsPage(
                                          property: snapshot.data![index],
                                          settingsController:
                                              widget.settingsController,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit),
                                      SizedBox(width: 10),
                                      Text('Modifier'),
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PropertyFormPage(
                                          property: snapshot.data![index],
                                          settingsController:
                                              widget.settingsController,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete),
                                      SizedBox(width: 10),
                                      Text('Supprimer'),
                                    ],
                                  ),
                                  onTap: () async {
                                    await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text('Confirmation'),
                                        content: Text(
                                            'Voulez-vous vraiment supprimer cette propriété ?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('Non'),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              await _propertyService
                                                  .deleteProperty(snapshot
                                                      .data![index]
                                                      .propertyId!);
                                              setState(() {});
                                              Navigator.pop(context);
                                            },
                                            child: Text('Oui'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                        Text(
                          snapshot.data![index].titre,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: widget.settingsController.primaryColor),
                        ),
                        SizedBox(height: 5),
                        Text(
                          snapshot.data![index].adresse,
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PropertyFormPage(
                      settingsController: widget.settingsController,
                    )),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: widget.settingsController.primaryColor,
      ),
    );
  }
}

class PropertyFormPage extends StatefulWidget {
  final Property? property;
  final SettingsController settingsController;

  PropertyFormPage({this.property, required this.settingsController});

  @override
  _PropertyFormPageState createState() => _PropertyFormPageState();
}

class _PropertyFormPageState extends State<PropertyFormPage> {
  final PropertyService _propertyService = PropertyService();
  final _formKey = GlobalKey<FormState>();
  String _titre = '';
  String _description = '';
  String _type = '';
  double _prix = 0;
  double _surface = 0;
  int _nombrePieces = 0;
  int _nombreSallesDeBain = 0;
  String _adresse = '';
  String _ville = '';
  bool _disponible = true;
  DateTime _dateAjout = DateTime.now();
  String _agentId = '';
  List<String> _images = [];
  List<String> _favorites = [];
  String _coverUrl = '';
  bool _isFeatured = false;
  String _statut = '';
  List<String> _tags = [];

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
      _nombreSallesDeBain = widget.property!.nombreSallesDeBain;
      _adresse = widget.property!.adresse;
      _ville = widget.property!.ville;
      _disponible = widget.property!.disponible;
      _dateAjout = widget.property!.dateAjout;
      _agentId = widget.property!.agentId;
      _images = widget.property!.images;
      _favorites = widget.property!.favorites;
      _coverUrl = widget.property!.cover_url;
      _isFeatured = widget.property!.isFeatured;
      _statut = widget.property!.statut;
      _tags = widget.property!.tags;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.property != null ? 'Modifier propriété' : 'Créer propriété'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  initialValue: _titre,
                  decoration: InputDecoration(
                    labelText: 'Titre',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Entrez un titre';
                    }
                    return null;
                  },
                  onSaved: (value) => _titre = value!,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  initialValue: _description,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Entrez une description';
                    }
                    return null;
                  },
                  onSaved: (value) => _description = value!,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  initialValue: _type,
                  decoration: InputDecoration(
                    labelText: 'Type',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Entrez un type';
                    }
                    return null;
                  },
                  onSaved: (value) => _type = value!,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  initialValue: _prix.toString(),
                  decoration: InputDecoration(
                    labelText: 'Prix',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Entrez un prix';
                    }
                    return null;
                  },
                  onSaved: (value) => _prix = double.parse(value!),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  initialValue: _surface.toString(),
                  decoration: InputDecoration(
                    labelText: 'Surface',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Entrez une surface';
                    }
                    return null;
                  },
                  onSaved: (value) => _surface = double.parse(value!),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  initialValue: _nombrePieces.toString(),
                  decoration: InputDecoration(
                    labelText: 'Nombre de pièces',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Entrez un nombre de pièces';
                    }
                    return null;
                  },
                  onSaved: (value) => _nombrePieces = int.parse(value!),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  initialValue: _nombreSallesDeBain.toString(),
                  decoration: InputDecoration(
                    labelText: 'Nombre de salles de bain',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Entrez un nombre de salles de bain';
                    }
                    return null;
                  },
                  onSaved: (value) => _nombreSallesDeBain = int.parse(value!),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  initialValue: _adresse,
                  decoration: InputDecoration(
                    labelText: 'Adresse',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Entrez une adresse';
                    }
                    return null;
                  },
                  onSaved: (value) => _adresse = value!,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  initialValue: _ville,
                  decoration: InputDecoration(
                    labelText: 'Ville',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Entrez une ville';
                    }
                    return null;
                  },
                  onSaved: (value) => _ville = value!,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final pickedFile = await FilePicker.platform.pickFiles(
                      type: FileType.image,
                    );

                    if (pickedFile != null) {
                      setState(() {
                        _coverUrl = pickedFile.files.first.path!;
                      });
                    }
                  },
                  child: Text('Télécharger l\'image de couverture'),
                ),
                CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      _coverUrl.isNotEmpty ? FileImage(File(_coverUrl)) : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final pickedFiles = await FilePicker.platform.pickFiles(
                      type: FileType.image,
                      allowMultiple: true,
                    );

                    if (pickedFiles != null) {
                      setState(() {
                        _images = pickedFiles.paths
                            .map((path) => File(path!))
                            .cast<String>()
                            .toList();
                      });
                    }
                  },
                  child: Text('Télécharger les images'),
                ),
                Wrap(
                  children: _images.map((image) {
                    return CircleAvatar(
                      radius: 50,
                      backgroundImage: FileImage(File(image)),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Tags',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                  ),
                  onSaved: (value) {
                    if (value != null && value.isNotEmpty) {
                      _tags.add(value);
                    }
                  },
                ),
                const SizedBox(height: 20),
                Wrap(
                  children: _tags.map((tag) {
                    return Chip(
                      label: Text(tag),
                      onDeleted: () {
                        setState(() {
                          _tags.remove(tag);
                        });
                      },
                    );
                  }).toList(),
                ),
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    labelText: 'Statut',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                  ),
                  items: [
                    DropdownMenuItem(
                      child: Text('En vente'),
                      value: 'En vente',
                    ),
                    DropdownMenuItem(
                      child: Text('En location'),
                      value: 'En location',
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _statut = value as String;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez sélectionner un statut';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                SwitchListTile(
                  title: Text('Is Featured'),
                  value: _isFeatured,
                  onChanged: (value) => setState(() => _isFeatured = value),
                ),
                const SizedBox(height: 20),
                SwitchListTile(
                  title: Text('Disponible'),
                  value: _disponible,
                  onChanged: (value) => setState(() => _disponible = value),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(widget.property != null
                      ? 'Modifier propriété'
                      : 'Créer propriété'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.settingsController.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (widget.property != null) {
        await _propertyService.updateProperty(Property(
          propertyId: widget.property!.propertyId,
          titre: _titre,
          description: _description,
          type: _type,
          prix: _prix,
          surface: _surface,
          nombrePieces: _nombrePieces,
          nombreSallesDeBain: _nombreSallesDeBain,
          adresse: _adresse,
          ville: _ville,
          disponible: _disponible,
          dateAjout: _dateAjout,
          agentId: _agentId,
          images: _images,
          favorites: _favorites,
          cover_url: _coverUrl,
          isFeatured: _isFeatured,
          statut: _statut,
          tags: _tags,
        ));
      } else {
        await _propertyService.createProperty(
          Property(
            titre: _titre,
            description: _description,
            type: _type,
            prix: _prix,
            surface: _surface,
            nombrePieces: _nombrePieces,
            nombreSallesDeBain: _nombreSallesDeBain,
            adresse: _adresse,
            ville: _ville,
            disponible: _disponible,
            dateAjout: _dateAjout,
            agentId: _agentId,
            images: _images,
            favorites: _favorites,
            cover_url: _coverUrl,
            isFeatured: _isFeatured,
            statut: _statut,
            tags: _tags,
          ),
          null,
          [],
        );
      }
      Navigator.pop(context);
    }
  }
}
