import 'dart:async';

import 'package:appimmo/src/home/searrch..dart';
import 'package:appimmo/src/property/property_controller.dart';
import 'package:appimmo/src/property/property_detail_screen.dart';
import 'package:appimmo/src/users/users_controller.dart';
import 'package:appimmo/src/users/users_model.dart';
import 'package:flutter/material.dart';
import 'package:appimmo/src/users/profile_screen.dart';
import 'package:appimmo/src/settings/settings_controller.dart';
import 'package:appimmo/src/settings/settings_view.dart';
import 'package:appimmo/src/settings/about_view.dart';
import 'package:appimmo/src/settings/notifications_view.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:appimmo/src/property/property_model.dart';

abstract class BasePage extends StatefulWidget {
  final SettingsController settingsController;

  const BasePage({
    Key? key,
    required this.settingsController,
  }) : super(key: key);

  @override
  BasePageState createState();
}

abstract class BasePageState<T extends BasePage> extends State<T>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final PropertyController _propertyController = PropertyController();
  final UserController _userController = UserController();
  final String userId = firebase_auth.FirebaseAuth.instance.currentUser!.uid;

  String _selectedPropertyType = 'Tous';

  List<Property> _properties = []; //

  @override
  void initState() {
    super.initState();
    _propertyController.getAllPropertiesStream();
    _tabController = TabController(length: 5, vsync: this);
    _tabController
        .addListener(_handleTabChange); // Écouter les changements d'onglet
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange); // Supprimer l'écouteur
    _tabController.dispose();
    super.dispose();
    _properties = [];
  }

  // Gérer les changements d'onglet
  void _handleTabChange() {
    if (_tabController.index == 1) {
      // Si l'onglet "proprietes" est actif, redémarrer le stream
      setState(() {});
    } else {
      // Sinon, annuler le stream
    }
  }

  void _onMenuAction(String value) async {
    switch (value) {
      case 'profil':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(userId: ''),
          ),
        );
        break;
      case 'parametres':
        Navigator.pushNamed(context, SettingsView.routeName);
        break;
      case 'notifications':
        Navigator.pushNamed(context, NotificationsView.routeName);
        break;
      case 'a_propos':
        Navigator.pushNamed(context, AboutUsPage.routeName);
        break;
      case 'deconnexion':
        await firebase_auth.FirebaseAuth.instance.signOut();
        Navigator.pushReplacementNamed(context, '/login');
        break;
      default:
        break;
    }
  }

  Widget _buildPropertyCard(Property property) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            property.cover_url,
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property.titre,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${property.prix} €',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  property.adresse,
                  style: const TextStyle(fontSize: 14),
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
                              property: property,
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
                    Row(children: [
                      IconButton(
                        onPressed: () async {
                          if (property.likes.contains(userId)) {
                            await _propertyController.unlikeProperty(
                                property.propertyId!, userId);
                          } else {
                            await _propertyController.likeProperty(
                                property.propertyId!, userId);
                          }
                          setState(() {}); // Refresh the page
                        },
                        icon: Icon(
                          property.likes.contains(userId)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: property.likes.contains(userId)
                              ? Colors.red
                              : Colors.grey,
                        ),
                      ),
                      Text('${property.likes.length}'),
                      IconButton(
                        onPressed: () async {
                          if (property.favorites.contains(userId)) {
                            await _propertyController.removeFavorite(
                                userId, property.propertyId!);
                          } else {
                            await _propertyController.addFavorite(
                                userId, property.propertyId!);
                          }
                          setState(() {}); // Refresh the page
                        },
                        icon: Icon(
                          property.favorites.contains(userId)
                              ? Icons.star_outlined
                              : Icons.star_outline,
                          color: property.favorites.contains(userId)
                              ? Colors.yellow
                              : Colors.grey,
                        ),
                      ),
                      //Text('${property.favorites.length}'),
                    ]),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyList() {
    return StreamBuilder<List>(
      stream: _propertyController.getAllPropertiesStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
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
              ],
            ),
          );
        } else {
          final properties = snapshot.data!
              .where((property) =>
                  _selectedPropertyType == 'Tous' ||
                  property.type == _selectedPropertyType)
              .toList();
          return ListView.builder(
            itemCount: properties.length,
            itemBuilder: (context, index) {
              return _buildPropertyCard(properties[index]);
            },
          );
        }
      },
    );
  }

  Widget _buildAgentList() {
    return FutureBuilder<List<User>>(
      future: _userController.getAllAgentsSync(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Aucun agent trouvé.'));
        } else {
          final agents = snapshot.data!;
          return ListView.builder(
            itemCount: agents.length,
            itemBuilder: (context, index) {
              final agent = agents[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        agent.nom ?? 'Nom non disponible',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        agent.email ?? 'Email non disponible',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        agent.telephone ?? 'Téléphone non disponible',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          // Logique pour contacter l'agent
                        },
                        child: Text('Contacter l\'agent'),
                        style: ElevatedButton.styleFrom(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  Widget _buildPropertyTypeFilter() {
    return DropdownButton<String>(
      value: _selectedPropertyType,
      onChanged: (String? newValue) {
        setState(() {
          _selectedPropertyType = newValue!;
        });
      },
      items: <String>['Tous', 'Appartement', 'Maison', 'Bureau']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildFavoriteCard(Property property) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            property.cover_url,
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
                  property.titre,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${property.prix} €',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.green,
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
                              property: property,
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
                            userId, property.propertyId!);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('APPIMMO'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SearchPage(
                          settingsController: widget.settingsController,
                        )),
              );
            },
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.menu),
            onSelected: _onMenuAction,
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'profil',
                  child: Row(
                    children: [
                      Icon(Icons.person, color: Colors.black),
                      SizedBox(width: 8),
                      Text('Profil'),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'parametres',
                  child: Row(
                    children: [
                      Icon(Icons.settings, color: Colors.black),
                      SizedBox(width: 8),
                      Text('Paramètres'),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'notifications',
                  child: Row(
                    children: [
                      Icon(Icons.notifications, color: Colors.black),
                      SizedBox(width: 8),
                      Text('Notifications'),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'a_propos',
                  child: Row(
                    children: [
                      Icon(Icons.info, color: Colors.black),
                      SizedBox(width: 8),
                      Text('À propos'),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'deconnexion',
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Colors.black),
                      SizedBox(width: 8),
                      Text('Déconnexion'),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.home), text: 'Accueil'),
            Tab(icon: Icon(Icons.list), text: 'Propriétés'),
            Tab(icon: Icon(Icons.people), text: 'Agents'),
            Tab(icon: Icon(Icons.favorite), text: 'Favoris'),
            Tab(icon: Icon(Icons.contact_mail), text: 'Contact')
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Page d'accueil
          Column(
            children: [
              Text('Propriétés en vedette'),
              Expanded(
                child: FutureBuilder(
                  future: _propertyController.getFeaturedProperties(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Erreur: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off,
                                size: 50, color: Colors.grey),
                            SizedBox(height: 10),
                            Text(
                              'Aucune propriété en vedette.',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          ],
                        ),
                      );
                    } else {
                      final properties = snapshot.data!;
                      return ListView.builder(
                        itemCount: properties.length,
                        itemBuilder: (context, index) {
                          return _buildPropertyCard(properties[index]);
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          // Page des propriétés
          Column(
            children: [
              _buildPropertyTypeFilter(),
              Expanded(child: _buildPropertyList()),
            ],
          ),
//page des agents
          _buildAgentList(),
          // Page des favoris
          Column(
            children: [
              Text('Favoris'),
              Expanded(
                child: FutureBuilder(
                  future: _propertyController.getFavoriteProperties(userId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Erreur: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off,
                                size: 50, color: Colors.grey),
                            SizedBox(height: 10),
                            Text(
                              'Aucun favori.',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          ],
                        ),
                      );
                    } else {
                      final properties = snapshot.data!;
                      return ListView.builder(
                        itemCount: properties.length,
                        itemBuilder: (context, index) {
                          return _buildFavoriteCard(properties[index]);
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          // Page de contact
          // Page de contact
          Column(
            children: [
              Text('Contact'),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Informations de l'agence
                      Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                'Agence Immo',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Adresse : 123 rue de la République, 75001 Paris',
                                style: TextStyle(fontSize: 14),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Téléphone : 01 23 45 67 89',
                                style: TextStyle(fontSize: 14),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Email : contact@agenceimmo.com',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      // Formulaire de contact
                      Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                'Formulaire de contact',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'Nom',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              SizedBox(height: 8),
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              SizedBox(height: 8),
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'Message',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  // Envoyer le formulaire de contact
                                },
                                child: Text('Envoyer'),
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
