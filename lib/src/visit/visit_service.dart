import 'package:appimmo/src/visit/visit_model.dart';
import 'package:firebase_database/firebase_database.dart';

class VisitService {
  final DatabaseReference _visitsRef = FirebaseDatabase.instance.ref('visits');

  // Créer une visite
  Future<void> createVisit(Visit visit) async {
    try {
      final visitRef = _visitsRef.push();
      visit.visitId = visitRef.key;
      await visitRef.set(visit.toMap());
    } catch (e) {
      throw Exception("Erreur lors de la création de la visite : $e");
    }
  }

  // Récupérer une visite par ID
  Future<Visit?> getVisitById(String visitId) async {
    try {
      final snapshot = await _visitsRef.child(visitId).get();
      if (snapshot.exists) {
        return Visit.fromMap(snapshot.value as Map<String, dynamic>, visitId);
      }
      return null;
    } catch (e) {
      throw Exception("Erreur lors de la récupération de la visite : $e");
    }
  }

  // Récupérer toutes les visites
  Future<List<Visit>> getAllVisits() async {
    try {
      final snapshot = await _visitsRef.get();
      if (snapshot.exists) {
        final visits = <Visit>[];
        final data = snapshot.value as Map<dynamic, dynamic>;
        data.forEach((key, value) {
          visits.add(Visit.fromMap(value as Map<String, dynamic>, key));
        });
        return visits;
      }
      return [];
    } catch (e) {
      throw Exception("Erreur lors de la récupération des visites : $e");
    }
  }

  // Mettre à jour une visite
  Future<void> updateVisit(Visit visit) async {
    try {
      if (visit.visitId == null) {
        throw Exception("L'ID de la visite est null");
      }
      await _visitsRef.child(visit.visitId!).update(visit.toMap());
    } catch (e) {
      throw Exception("Erreur lors de la mise à jour de la visite : $e");
    }
  }

  // Supprimer une visite
  Future<void> deleteVisit(String visitId) async {
    try {
      await _visitsRef.child(visitId).remove();
    } catch (e) {
      throw Exception("Erreur lors de la suppression de la visite : $e");
    }
  }
}
