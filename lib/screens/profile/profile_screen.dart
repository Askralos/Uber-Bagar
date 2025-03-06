import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);

  Future<List<dynamic>> _fetchUsers() async {
    var supabase = Supabase.instance.client;

    try {
      final data = await supabase.from('users').select();
      return data;
    } catch (e) {
      throw Exception('Erreur lors de la récupération des utilisateurs: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Utilisateur')),
      body: FutureBuilder(
        future: _fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
            // } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            //   return const Center(child: Text('Aucun utilisateur trouvé.'));
          }

          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                title: Text(user['first_name'] ?? 'Nom non disponible'),
              );
            },
          );
        },
      ),
    );
  }
}
