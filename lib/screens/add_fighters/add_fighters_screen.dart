import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/fighter.dart';
import '../../providers/fighters_provider.dart';

class AddFighterScreen extends StatefulWidget {
  @override
  _AddFighterScreenState createState() => _AddFighterScreenState();
}

class _AddFighterScreenState extends State<AddFighterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fighter = Fighter(
    firstName: '',
    lastName: '',
    category: '',
    height: 0.0,
    weight: 0.0,
    description: '',
    image: '',
    sex: '',
    style: '',
    pricing: 0,
    id: null,
    wins: 0,
    fights: 0,
    rating: 0.0,
    longitude: 126.978,
    latitude: 37.5657,
  );

  final List<String> _sexOptions = ['Homme', 'Femme'];
  final List<String> _categoryOptions = ['Poids Lourd', 'Poids Moyen', 'Poids Léger', 'Poids Plume'];

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _imageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _styleController = TextEditingController();
  final _pricingController = TextEditingController();

  Future<void> _saveFighter() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        // Utilisation du provider au lieu du service Supabase directement
        await Provider.of<FightersProvider>(context, listen: false).addFighter(_fighter);

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Combattant ajouté avec succès'))
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur: $e'))
        );
      }
    }
  }

  @override
  void dispose() {
    // Libère les contrôleurs quand l'écran est détruit
    _firstNameController.dispose();
    _lastNameController.dispose();
    _imageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _descriptionController.dispose();
    _styleController.dispose();
    _pricingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Accès au provider pour vérifier l'état de chargement
    final isLoading = Provider.of<FightersProvider>(context).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un combattant'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: 'Prénom'),
                onSaved: (value) => _fighter.firstName = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ce champ est obligatoire';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: 'Nom'),
                onSaved: (value) => _fighter.lastName = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ce champ est obligatoire';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _imageController,
                decoration: InputDecoration(labelText: 'URL de l\'image'),
                onSaved: (value) => _fighter.image = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ce champ est obligatoire';
                  }
                  final uri = Uri.tryParse(value);
                  if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
                    return 'Veuillez entrer une URL valide';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _fighter.sex.isEmpty ? null : _fighter.sex,
                decoration: InputDecoration(labelText: 'Sexe'),
                onChanged: (value) {
                  setState(() {
                    _fighter.sex = value!;
                  });
                },
                items: _sexOptions.map((sex) {
                  return DropdownMenuItem<String>(
                    value: sex,
                    child: Text(sex),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ce champ est obligatoire';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _weightController,
                decoration: InputDecoration(labelText: 'Poids (kg)'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _fighter.weight = double.parse(value!),
              ),
              TextFormField(
                controller: _heightController,
                decoration: InputDecoration(labelText: 'Taille (cm)'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _fighter.height = double.parse(value!),
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) => _fighter.description = value!,
              ),
              TextFormField(
                controller: _styleController,
                decoration: InputDecoration(labelText: 'Style'),
                onSaved: (value) => _fighter.style = value!,
              ),
              DropdownButtonFormField<String>(
                value: _fighter.category.isEmpty ? null : _fighter.category,
                decoration: InputDecoration(labelText: 'Catégorie'),
                onChanged: (value) {
                  setState(() {
                    _fighter.category = value!;
                  });
                },
                items: _categoryOptions.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ce champ est obligatoire';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _pricingController,
                decoration: InputDecoration(labelText: 'Tarif'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _fighter.pricing = int.parse(value!),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : _saveFighter,
                child: isLoading
                    ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2)
                )
                    : Text('Ajouter le combattant'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}