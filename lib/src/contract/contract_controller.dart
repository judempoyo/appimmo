import 'contract_service.dart';
import 'contract_model.dart';

class ContractController {
  final ContractService _contractService = ContractService();

  Future<void> createContract(Contract contract) async {
    await _contractService.createContract(contract);
  }

  Future<Contract?> getContract(String contractId) async {
    return await _contractService.getContractById(contractId);
  }

  Future<void> updateContract(
      String contractId, Map<String, dynamic> updates) async {
    await _contractService.updateContract(contractId, updates);
  }

  Future<void> deleteContract(String contractId) async {
    await _contractService.deleteContract(contractId);
  }
}
