import 'package:flutter/material.dart';
import 'package:uberbagar/models/fighter.dart';
import 'package:uberbagar/screens/fighters/widgets/fighter_card.dart';
import 'package:uberbagar/services/supabase_service.dart';

import '../add_fighters/add_fighters_screen.dart';
import '../fighters_details/fighter_details_screen.dart';

class FightersScreen extends StatefulWidget {
  @override
  _FightersScreenState createState() => _FightersScreenState();
}

class _FightersScreenState extends State<FightersScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  List<Fighter> _fighters = [];
  bool _isLoading = true;
  String _selectedCategory = 'Tous';

  final List<String> _categories = [
    'Tous',
    'Poids Léger',
    'Poids Moyen',
    'Poids Lourd',
    'Poids Plume',
  ];

  @override
  void initState() {
    super.initState();
    _loadFighters();
  }

  Future<void> _loadFighters() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (_selectedCategory == 'Tous') {
        _fighters = await _supabaseService.getFighters();
      } else {
        _fighters = await _supabaseService.getFightersByCategory(_selectedCategory);
      }
      print('Combattants chargés: $_fighters');
    } catch (e, stacktrace) {
      print('Erreur lors du chargement des combattants: $e');
      print(stacktrace);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du chargement des combattants: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Combattants'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddFighterScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _loadFighters();  // Appel de la méthode de chargement des combattants
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _categories.map((category) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: FilterChip(
                      label: Text(category),
                      selected: _selectedCategory == category,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = category;
                          _loadFighters();
                        });
                      },
                      selectedColor: Colors.red.shade100,
                      checkmarkColor: Colors.red,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: Text('Aucun combattant trouvé'))
                : ListView.builder(
              itemCount: _fighters.length,
              itemBuilder: (context, index) {
                return FighterCard(
                  fighter: _fighters[index],
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                        builder: (context) => FighterDetailsScreen(fighter: _fighters[index])),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

