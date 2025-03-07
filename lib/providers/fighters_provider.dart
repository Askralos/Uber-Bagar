import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/fighter.dart';

class FightersProvider with ChangeNotifier {
  final _supabase = Supabase.instance.client;
  List<Fighter> _fighters = [];
  bool _isLoading = false;
  String _selectedCategory = 'Tous';
  StreamSubscription? _fightersSubscription;

  // Getters
  List<Fighter> get fighters => _fighters;
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;

  FightersProvider() {
    // Initialisation de l'écoute des changements en temps réel
    _initRealtimeSubscription();
    // Chargement initial des combattants
    fetchFighters();
  }

  void _initRealtimeSubscription() {
    // Annulation de toute souscription existante
    _fightersSubscription?.cancel();

    // Création d'une nouvelle souscription aux changements de la table fighters
    _fightersSubscription = _supabase
        .from('fighters')
        .stream(primaryKey: ['id'])
        .listen((List<Map<String, dynamic>> data) {
      // Conversion des données en objets Fighter
      final updatedFighters = data.map((json) => Fighter.fromJson(json)).toList();

      // Si une catégorie est sélectionnée, filtrer les combattants
      if (_selectedCategory != 'Tous') {
        _fighters = updatedFighters
            .where((fighter) => fighter.category == _selectedCategory)
            .toList();
      } else {
        _fighters = updatedFighters;
      }

      // Notification des auditeurs (widgets) pour reconstruire l'UI
      notifyListeners();
    }, onError: (error) {
      debugPrint('Erreur lors de lécoute des changements en temps réel: $error');
      });
  }

  // Méthode pour charger tous les combattants
  Future<void> fetchFighters() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _supabase.from('fighters').select("*");

      if (_selectedCategory != 'Tous') {
        _fighters = response
            .map((json) => Fighter.fromJson(json))
            .where((fighter) => fighter.category == _selectedCategory)
            .toList();
      } else {
        _fighters = response.map((json) => Fighter.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('Erreur lors du chargement des combattants: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Méthode pour changer la catégorie sélectionnée
  void setCategory(String category) {
    if (_selectedCategory != category) {
      _selectedCategory = category;
      fetchFighters();
    }
  }

  // Méthode pour ajouter un combattant
  Future<void> addFighter(Fighter fighter) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _supabase.from('fighters').insert([
        {
          'firstName': fighter.firstName,
          'lastName': fighter.lastName,
          'category': fighter.category,
          'fights': fighter.fights,
          'height': fighter.height,
          'weight': fighter.weight,
          'wins': fighter.wins,
          'sex': fighter.sex,
          'pricing': fighter.pricing,
          'style': fighter.style,
          'longitude': fighter.longitude,
          'latitude': fighter.latitude,
          'description': fighter.description,
          'image': fighter.image,
          'rating': fighter.rating,
        }
      ]);

      // Le combattant sera automatiquement ajouté à la liste via la souscription en temps réel
    } catch (e) {
      debugPrint('Erreur lors de l\'ajout du combattant: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Méthode pour supprimer un combattant
  Future<void> deleteFighter(int id) async {
    try {
      await _supabase.from('fighters').delete().eq('id', id);
      // Le combattant sera automatiquement supprimé de la liste via la souscription en temps réel
    } catch (e) {
      debugPrint('Erreur lors de la suppression du combattant: $e');
      rethrow;
    }
  }

  Future<void> updateFighter(Fighter fighter) async {
    try {
      await _supabase.from('fighters').update({
        'firstName': fighter.firstName,
        'lastName': fighter.lastName,
        'category': fighter.category,
        'fights': fighter.fights,
        'height': fighter.height,
        'weight': fighter.weight,
        'wins': fighter.wins,
        'sex': fighter.sex,
        'pricing': fighter.pricing,
        'style': fighter.style,
        'longitude': fighter.longitude,
        'latitude': fighter.latitude,
        'description': fighter.description,
        'image': fighter.image,
        'rating': fighter.rating,
      }).eq('id', fighter.id as Object);

    } catch (e) {
      debugPrint('Erreur lors de la mise à jour du combattant: $e');
      rethrow;
    }
  }

  @override
  void dispose() {
    _fightersSubscription?.cancel();
    super.dispose();
  }
}