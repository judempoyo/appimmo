class User {
  String? userId;
  String nom;
  String prenom;
  String email;
  String motDePasse;
  String avatar;
  String role;
  String telephone;
  String adresse;
  DateTime dateInscription;

  User({
    this.userId,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.motDePasse,
    required this.avatar,
    required this.role,
    required this.telephone,
    required this.adresse,
    DateTime? dateInscription,
  }) : dateInscription = dateInscription ?? DateTime.now();

  // Convertir un objet User en Map pour Firebase
  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'mot_de_passe': motDePasse,
      'avatar': avatar,
      'role': role,
      'telephone': telephone,
      'adresse': adresse,
      'date_inscription': dateInscription.toIso8601String(),
    };
  }

  // Créer un objet User à partir d'un Map de Firebase
  factory User.fromMap(Map<String, dynamic> map, String userId) {
    return User(
      userId: userId,
      nom: map['nom'] ?? '',
      prenom: map['prenom'] ?? '',
      email: map['email'] ?? '',
      motDePasse: map['mot_de_passe'],
      avatar: map['avatar'],
      role: map['role'],
      telephone: map['telephone'] ?? '',
      adresse: map['adresse'] ?? '',
      dateInscription: DateTime.parse(map['date_inscription']),
    );
  }
}
