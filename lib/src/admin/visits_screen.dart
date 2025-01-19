import 'package:flutter/material.dart';
import 'package:appimmo/src/visit/visit_model.dart';
import 'package:appimmo/src/visit/visit_service.dart';

class VisitsListScreen extends StatefulWidget {
  const VisitsListScreen({Key? key}) : super(key: key);

  @override
  _VisitsListScreenState createState() => _VisitsListScreenState();
}

class _VisitsListScreenState extends State<VisitsListScreen> {
  final VisitService _visitService = VisitService();
  List<Visit> _visits = [];

  @override
  void initState() {
    super.initState();
    _loadVisits();
  }

  Future<void> _loadVisits() async {
    final visits = await _visitService.getAllVisits();
    setState(() {
      _visits = visits;
    });
  }

  void _navigateToVisitForm(BuildContext context, {Visit? visit}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VisitFormScreen(visit: visit),
      ),
    ).then((_) => _loadVisits());
  }

  void _deleteVisit(String visitId) async {
    await _visitService.deleteVisit(visitId);
    _loadVisits();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Visites'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _navigateToVisitForm(context),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _visits.length,
        itemBuilder: (context, index) {
          final visit = _visits[index];
          return ListTile(
            title: Text(visit.dateVisite.toString()),
            subtitle:
                Text('Propriété: ${visit.propertyId}, Statut: ${visit.statut}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _navigateToVisitForm(context, visit: visit),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteVisit(visit.visitId!),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class VisitFormScreen extends StatefulWidget {
  final Visit? visit;

  const VisitFormScreen({Key? key, this.visit}) : super(key: key);

  @override
  _VisitFormScreenState createState() => _VisitFormScreenState();
}

class _VisitFormScreenState extends State<VisitFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _visitService = VisitService();

  late String _propertyId;
  late String _clientId;
  late String _agentId;
  late DateTime _dateVisite;
  late String _statut;

  @override
  void initState() {
    super.initState();
    if (widget.visit != null) {
      _propertyId = widget.visit!.propertyId;
      _clientId = widget.visit!.clientId;
      _agentId = widget.visit!.agentId;
      _dateVisite = widget.visit!.dateVisite;
      _statut = widget.visit!.statut;
    } else {
      _propertyId = '';
      _clientId = '';
      _agentId = '';
      _dateVisite = DateTime.now();
      _statut = '';
    }
  }

  Future<void> _saveVisit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final visit = Visit(
        visitId: widget.visit?.visitId ?? '',
        propertyId: _propertyId,
        clientId: _clientId,
        agentId: _agentId,
        dateVisite: _dateVisite,
        statut: _statut,
      );

      if (widget.visit == null) {
        await _visitService.createVisit(visit);
      } else {
        await _visitService.updateVisit(visit);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.visit == null
            ? 'Ajouter une Visite'
            : 'Modifier une Visite'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _propertyId,
                decoration: const InputDecoration(labelText: 'ID de Propriété'),
                validator: (value) => value!.isEmpty
                    ? 'Veuillez entrer un ID de propriété'
                    : null,
                onSaved: (value) => _propertyId = value!,
              ),
              TextFormField(
                initialValue: _clientId,
                decoration: const InputDecoration(labelText: 'ID de Client'),
                validator: (value) =>
                    value!.isEmpty ? 'Veuillez entrer un ID de client' : null,
                onSaved: (value) => _clientId = value!,
              ),
              TextFormField(
                initialValue: _agentId,
                decoration: const InputDecoration(labelText: 'ID d\'Agent'),
                validator: (value) =>
                    value!.isEmpty ? 'Veuillez entrer un ID d\'agent' : null,
                onSaved: (value) => _agentId = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Statut'),
                validator: (value) =>
                    value!.isEmpty ? 'Veuillez entrer un statut' : null,
                onSaved: (value) => _statut = value!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveVisit,
                child: const Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
