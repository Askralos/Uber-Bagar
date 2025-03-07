import 'package:flutter/material.dart';
import 'package:uberbagar/models/fighter.dart';

class FighterCard extends StatelessWidget {
  final Fighter fighter;
  final VoidCallback onTap;

  const FighterCard({
    Key? key,
    required this.fighter,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(fighter.image),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${fighter.firstName} ${fighter.lastName}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      fighter.category,
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        _buildStatItem(
                          context,
                          '${fighter.wins}',
                          'V',
                          Colors.green,
                        ),
                        _buildStatItem(
                          context,
                          '${fighter.fights - fighter.wins}',
                          'D',
                          Colors.red,
                        ),
                        _buildStatItem(
                          context,
                          '${fighter.fights - fighter.wins - (fighter.fights - fighter.wins)}', // draws (to be handled)
                          'N',
                          Colors.orange,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
      BuildContext context,
      String value,
      String label,
      Color color,
      ) {
    return Container(
      margin: EdgeInsets.only(right: 16),
      child: Row(
        children: [
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
