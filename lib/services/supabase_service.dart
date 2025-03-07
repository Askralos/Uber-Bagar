import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/fighter.dart';

class SupabaseService {
  final supabase = Supabase.instance.client;

  Future<List<Fighter>> getFighters() async {
    final response = await supabase.from('fighters').select("*");
    print('Réponse Supabase: $response');
    return response.map((json) => Fighter.fromJson(json)).toList();
  }

  Future<Fighter> getFighterById(String id) async {
    final response = await supabase
        .from('fighters')
        .select()
        .eq('id', id)
        .single();

    return Fighter.fromJson(response);
  }

  Future<List<Fighter>> getFightersByCategory(String category) async {
    final response = await supabase
        .from('fighters')
        .select()
        .eq('category', category)
        .order('firstName');

    return response.map((json) => Fighter.fromJson(json)).toList();
  }

  Future<void> addFighter(Fighter fighter) async {
    try {
      final response = await supabase.from('fighters').insert([
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
      ]).select();

      print('Combattant ajouté avec succès');
    } catch (e) {
      print('Erreur lors de l\'ajout du combattant: $e');
      rethrow;
    }
  }

  Future<List<Fighter>> getFighterLocations() async {
    final response = await supabase
        .from('fighters')
        .select('id, firstName, lastName, longitude, latitude');

    return response.map((json) => Fighter.fromJson(json)).toList();
  }
}

