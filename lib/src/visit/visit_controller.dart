import 'package:appimmo/src/visit/visit_model.dart';
import 'package:appimmo/src/visit/visit_service.dart';

class VisitController {
  final VisitService _visitService = VisitService();

  // Créer une visite
  Future<void> createVisit(Visit visit) async {
    await _visitService.createVisit(visit);
  }

  // Récupérer une visite par ID
  Future<Visit?> getVisit(String visitId) async {
    return await _visitService.getVisitById(visitId);
  }

  // Récupérer toutes les visites
  Future<List<Visit>> getAllVisits() async {
    return await _visitService.getAllVisits();
  }

  // Mettre à jour une visite
  Future<void> updateVisit(Visit visit) async {
    await _visitService.updateVisit(visit);
  }

  // Supprimer une visite
  Future<void> deleteVisit(String visitId) async {
    await _visitService.deleteVisit(visitId);
  }
}
