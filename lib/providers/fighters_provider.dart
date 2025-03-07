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

  List<Fighter> get fighters => _fighters;
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;

  FightersProvider() {
    _initRealtimeSubscription();
    fetchFighters();
  }

  void _initRealtimeSubscription() {
    _fightersSubscription?.cancel();

    _fightersSubscription = _supabase
        .from('fighters')
        .stream(primaryKey: ['id'])
        .listen((List<Map<String, dynamic>> data) {
      final updatedFighters = data.map((json) => Fighter.fromJson(json)).toList();

      if (_selectedCategory != 'Tous') {
        _fighters = updatedFighters
            .where((fighter) => fighter.category == _selectedCategory)
            .toList();
      } else {
        _fighters = updatedFighters;
      }

      notifyListeners();
    }, onError: (error) {
      debugPrint('Erreur lors de lécoute des changements en temps réel: $error');
      });
  }

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

  void setCategory(String category) {
    if (_selectedCategory != category) {
      _selectedCategory = category;
      fetchFighters();
    }
  }

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

    } catch (e) {
      debugPrint('Erreur lors de l\'ajout du combattant: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _fightersSubscription?.cancel();
    super.dispose();
  }
}