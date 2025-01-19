import 'package:firebase_database/firebase_database.dart';
import 'contract_model.dart';

class ContractService {
  final DatabaseReference _contractsRef =
      FirebaseDatabase.instance.ref('contracts');

  // Créer un contrat
  Future<void> createContract(Contract contract) async {
    final contractRef = _contractsRef.push();
    contract.contractId = contractRef.key;
    await contractRef.set(contract.toMap());
  }

  // Récupérer un contrat par ID
  Future<Contract?> getContractById(String contractId) async {
    final snapshot = await _contractsRef.child(contractId).get();
    if (snapshot.exists) {
      return Contract.fromMap(
          snapshot.value as Map<String, dynamic>, contractId);
    }
    return null;
  }

  // Mettre à jour un contrat
  Future<void> updateContract(
      String contractId, Map<String, dynamic> updates) async {
    await _contractsRef.child(contractId).update(updates);
  }

  // Supprimer un contrat
  Future<void> deleteContract(String contractId) async {
    await _contractsRef.child(contractId).remove();
  }
}
