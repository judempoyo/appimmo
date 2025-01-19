import 'package:appimmo/src/property/property_detail_screen.dart';
import 'package:appimmo/src/settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:appimmo/src/property/property_model.dart';
import 'package:appimmo/src/property/property_service.dart';

class SearchPage extends StatefulWidget {
  final SettingsController settingsController;

  const SearchPage({super.key, required this.settingsController});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final PropertyService _propertyService = PropertyService();
  String? _selectedType;
  String? _selectedAvailability;
  String? _selectedCity;
  double _minPrice = 0;
  double _maxPrice = 1000000; // Exemple de prix maximum
  bool _showFilters = false; // Contrôle l'affichage des filtres
  String _searchText = '';

// Filtrez les propriétés en fonction du texte de recherche
  final List<String> _propertyTypes = [
    'Tout',
    'Appartement',
    'Maison',
    'Bureau'
  ];
  final List<String> _availabilityOptions = [
    'Tout',
    'Disponible',
    'Loué',
    'Vendu'
  ];

  // Méthode pour appliquer les filtres
  void _applyFilters() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen =
        screenWidth > 600; // Définir un seuil pour les grands écrans

    return Scaffold(
      appBar: AppBar(
        title: Text('Recherche de propriétés'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Barre de recherche
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Rechercher une propriété...',
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        border: InputBorder.none,
                      ),
                      onChanged: (text) {
                        setState(() {
                          _searchText = text;
                        });
                      },
                    )),
              ),

              SizedBox(height: 20),

              // Bouton pour afficher/masquer les filtres
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showFilters = !_showFilters;
                  });
                },
                child: Text(_showFilters
                    ? 'Masquer les filtres'
                    : 'Afficher les filtres'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Filtres (affichés uniquement si _showFilters est vrai)
              Visibility(
                visible: _showFilters,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        isLargeScreen
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                        labelText: 'Type de propriété',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        prefixIcon: Icon(Icons.home),
                                      ),
                                      value: _selectedType,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedType = value;
                                        });
                                        _applyFilters();
                                      },
                                      items: _propertyTypes.map((type) {
                                        return DropdownMenuItem(
                                          value: type,
                                          child: Text(type),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Expanded(
                                    child: TextField(
                                      decoration: InputDecoration(
                                        labelText: 'Ville',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        prefixIcon: Icon(Icons.location_city),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedCity = value;
                                        });
                                        _applyFilters();
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                        labelText: 'Disponibilité',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        prefixIcon: Icon(Icons.check_circle),
                                      ),
                                      value: _selectedAvailability,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedAvailability = value;
                                        });
                                        _applyFilters();
                                      },
                                      items: _availabilityOptions.map((option) {
                                        return DropdownMenuItem(
                                          value: option,
                                          child: Text(option),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      labelText: 'Type de propriété',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      prefixIcon: Icon(Icons.home),
                                    ),
                                    value: _selectedType,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedType = value;
                                      });
                                      _applyFilters();
                                    },
                                    items: _propertyTypes.map((type) {
                                      return DropdownMenuItem(
                                        value: type,
                                        child: Text(type),
                                      );
                                    }).toList(),
                                  ),
                                  SizedBox(height: 20),
                                  TextField(
                                    decoration: InputDecoration(
                                      labelText: 'Ville',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      prefixIcon: Icon(Icons.location_city),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedCity = value;
                                      });
                                      _applyFilters();
                                    },
                                  ),
                                  SizedBox(height: 20),
                                  DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      labelText: 'Disponibilité',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      prefixIcon: Icon(Icons.check_circle),
                                    ),
                                    value: _selectedAvailability,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedAvailability = value;
                                      });
                                      _applyFilters();
                                    },
                                    items: _availabilityOptions.map((option) {
                                      return DropdownMenuItem(
                                        value: option,
                                        child: Text(option),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                        SizedBox(height: 20),

                        // Slider pour le prix minimum
                        Text('Prix minimum: \$${_minPrice.toStringAsFixed(0)}'),
                        Slider(
                          value: _minPrice,
                          min: 0,
                          max: _maxPrice,
                          divisions: 100,
                          label: _minPrice.round().toString(),
                          onChanged: (value) {
                            setState(() {
                              _minPrice = value;
                            });
                            _applyFilters();
                          },
                        ),

                        // Slider pour le prix maximum
                        Text('Prix maximum: \$${_maxPrice.toStringAsFixed(0)}'),
                        Slider(
                          value: _maxPrice,
                          min: _minPrice,
                          max: 1000000,
                          divisions: 100,
                          label: _maxPrice.round().toString(),
                          onChanged: (value) {
                            setState(() {
                              _maxPrice = value;
                            });
                            _applyFilters();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Affichage des résultats

              StreamBuilder<List>(
                stream: _propertyService.getAllPropertiesStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erreur: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off, size: 50, color: Colors.grey),
                          SizedBox(height: 10),
                          Text(
                            'Aucune propriété trouvée.',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              // Réessayer la recherche
                              setState(() {
                                _searchText = '';
                                _selectedType = null;
                                _selectedAvailability = null;
                                _selectedCity = null;
                                _minPrice = 0;
                                _maxPrice = 1000000;
                              });
                            },
                            child: Text('Réessayer'),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              // Modifier les filtres
                              setState(() {
                                _showFilters = !_showFilters;
                              });
                            },
                            child: Text(_showFilters
                                ? 'Masquer les filtres'
                                : 'Afficher les filtres'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    final properties = snapshot.data!.where((property) {
                      return (_selectedType == null ||
                              _selectedType == 'Tout' ||
                              property.type == _selectedType) &&
                          (_selectedAvailability == null ||
                              _selectedAvailability == 'Tout' ||
                              property.disponible == _selectedAvailability) &&
                          (_selectedCity == null ||
                              _selectedCity!.isEmpty ||
                              property.ville == _selectedCity) &&
                          property.prix >= _minPrice &&
                          property.prix <= _maxPrice &&
                          (property.titre
                                  .toLowerCase()
                                  .contains(_searchText.toLowerCase()) ||
                              property.adresse
                                  .toLowerCase()
                                  .contains(_searchText.toLowerCase()) ||
                              property.ville
                                  .toLowerCase()
                                  .contains(_searchText.toLowerCase()));
                    }).toList();

                    if (properties.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off,
                                size: 50, color: Colors.grey),
                            SizedBox(height: 10),
                            Text(
                              'Aucune propriété trouvée.',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                // Réessayer la recherche
                                setState(() {
                                  _searchText = '';
                                  _searchController.clear();
                                  _selectedType = null;
                                  _selectedAvailability = null;
                                  _selectedCity = null;
                                  _minPrice = 0;
                                  _maxPrice = 1000000;
                                });
                              },
                              child: Text('Réessayer'),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      );
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: properties.length,
                        itemBuilder: (context, index) {
                          final property = properties[index];
                          return Card(
                            elevation: 2,
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              title: Text(property.titre,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                  '${property.adresse} - \$${property.prix}'),
                              onTap: () {
                                // Navigation vers la page de détails de la propriété
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PropertyDetailsPage(
                                      property: property,
                                      settingsController:
                                          widget.settingsController,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    }
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
