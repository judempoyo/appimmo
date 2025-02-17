import 'package:appimmo/src/home/contact_page.dart';
import 'package:appimmo/src/home/searrch..dart';
import 'package:appimmo/src/property/favorite_property_card.dart';
import 'package:appimmo/src/property/property_card.dart';
import 'package:appimmo/src/property/property_controller.dart';
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

  List<Property> _properties = [];

  @override
  void initState() {
    super.initState();
    _propertyController.getAllPropertiesStream();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
    _properties = [];
  }

  void _handleTabChange() {
    if (_tabController.index == 1) {
      setState(() {});
    }
    setState(() {});
  }

  void _onMenuAction(String value) async {
    switch (value) {
      case 'profil':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(
              userId: userId,
              settingsController: widget.settingsController,
            ),
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
              return PropertyCard(
                property: properties[index],
                userId: userId,
                onLike: (propertyId) async {
                  if (properties[index].likes.contains(userId)) {
                    await _propertyController.unlikeProperty(
                        propertyId, userId);
                  } else {
                    await _propertyController.likeProperty(propertyId, userId);
                  }
                  //setState(() {});
                },
                onFavorite: (propertyId) async {
                  if (properties[index].favorites.contains(userId)) {
                    await _propertyController.removeFavorite(
                        userId, propertyId);
                  } else {
                    await _propertyController.addFavorite(userId, propertyId);
                  }
                  //setState(() {});
                },
                settingsController: widget.settingsController,
              );
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
                        agent.nom,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        agent.email,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        agent.telephone,
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
                      Icon(Icons.person,
                          color: widget.settingsController.primaryColor),
                      SizedBox(width: 8),
                      Text('Profil'),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'parametres',
                  child: Row(
                    children: [
                      Icon(Icons.settings,
                          color: widget.settingsController.primaryColor),
                      SizedBox(width: 8),
                      Text('Paramètres'),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'notifications',
                  child: Row(
                    children: [
                      Icon(Icons.notifications,
                          color: widget.settingsController.primaryColor),
                      SizedBox(width: 8),
                      Text('Notifications'),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'a_propos',
                  child: Row(
                    children: [
                      Icon(Icons.info,
                          color: widget.settingsController.primaryColor),
                      SizedBox(width: 8),
                      Text('À propos'),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'deconnexion',
                  child: Row(
                    children: [
                      Icon(Icons.logout,
                          color: widget.settingsController.primaryColor),
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
          isScrollable: true,
          labelStyle: TextStyle(fontSize: 12),
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: [
            Tab(
              icon: Icon(Icons.home),
              text: _tabController.index == 0 ? 'Accueil' : null,
            ),
            Tab(
              icon: Icon(Icons.list),
              text: _tabController.index == 1 ? 'Propriétés' : null,
            ),
            Tab(
              icon: Icon(Icons.people),
              text: _tabController.index == 2 ? 'Agents' : null,
            ),
            Tab(
              icon: Icon(Icons.favorite),
              text: _tabController.index == 3 ? 'Favoris' : null,
            ),
            Tab(
              icon: Icon(Icons.contact_mail),
              text: _tabController.index == 4 ? 'Contact' : null,
            ),
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
                          return PropertyCard(
                            property: properties[index],
                            userId: userId,
                            onLike: (propertyId) async {
                              if (properties[index].likes.contains(userId)) {
                                await _propertyController.unlikeProperty(
                                    propertyId, userId);
                              } else {
                                await _propertyController.likeProperty(
                                    propertyId, userId);
                              }
                              //setState(() {});
                            },
                            onFavorite: (propertyId) async {
                              if (properties[index]
                                  .favorites
                                  .contains(userId)) {
                                await _propertyController.removeFavorite(
                                    userId, propertyId);
                              } else {
                                await _propertyController.addFavorite(
                                    userId, propertyId);
                              }
                              //setState(() {});
                            },
                            settingsController: widget.settingsController,
                          );
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
          // Page des agents
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
                          return FavoriteCard(
                            property: properties[index],
                            settingsController: widget.settingsController,
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          // Page de contact
          ContactPage(),
        ],
      ),
    );
  }
}
