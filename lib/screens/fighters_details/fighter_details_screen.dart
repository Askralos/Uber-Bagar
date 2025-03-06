import 'package:flutter/material.dart';
import 'package:uberbagar/models/fighter.dart';

class FighterDetailsScreen extends StatelessWidget {

  final Fighter fighter;
  FighterDetailsScreen({Key? key, required this.fighter}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('${fighter.firstName} ${fighter.lastName}'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  child: Image.network(
                    fighter.image,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: Colors.black54,
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${fighter.firstName} ${fighter.lastName}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        fighter.category,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.flag,
                            color: Colors.white70,
                            size: 18,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Statistiques de combat
            Padding(
              padding: EdgeInsets.all(16),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildRecord(
                        'VICTOIRES',
                        fighter.wins.toString(),
                        Colors.green,
                      ),
                      Container(
                        height: 50,
                        width: 1,
                        color: Colors.grey[300],
                      ),
                      _buildRecord(
                        'DÉFAITES',
                        (fighter.fights - fighter.wins).toString(),
                        Colors.red,
                      ),
                      Container(
                        height: 50,
                        width: 1,
                        color: Colors.grey[300],
                      ),
                      _buildRecord(
                        'NULS',
                        (fighter.fights - fighter.wins - (fighter.fights - fighter.wins)).toString(),
                        Colors.orange,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Informations',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.all(16),
              child: Row(
                children: [
                  // Taille
                  Expanded(
                    child: FighterStatCard(
                      title: 'TAILLE',
                      value: '${fighter.height} cm',
                      icon: Icons.height,
                    ),
                  ),
                  SizedBox(width: 16),
                  // Poids
                  Expanded(
                    child: FighterStatCard(
                      title: 'POIDS',
                      value: '${fighter.weight} kg',
                      icon: Icons.fitness_center,
                    ),
                  ),
                ],
              ),
            ),

            // Description
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Biographie',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    fighter.description,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecord(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}


class FighterStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const FighterStatCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              icon,
              color: Colors.red,
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
