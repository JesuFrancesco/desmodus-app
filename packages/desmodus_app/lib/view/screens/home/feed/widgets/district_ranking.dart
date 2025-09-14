import 'package:flutter/material.dart';

class DistrictRanking extends StatelessWidget {
  const DistrictRanking({Key? key}) : super(key: key);

  // Lista ficticia de distritos con puntaje de afectación
  final List<Map<String, dynamic>> districtData = const [
    {'name': 'San Juan de Lurigancho', 'attacks': 24},
    {'name': 'Villa El Salvador', 'attacks': 20},
    {'name': 'Comas', 'attacks': 17},
    {'name': 'Ate', 'attacks': 15},
    {'name': 'Puente Piedra', 'attacks': 12},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...districtData.asMap().entries.map((entry) {
            int index = entry.key + 1;
            String name = entry.value['name'];
            int attacks = entry.value['attacks'];

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Text(
                    '$index.',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(name, style: const TextStyle(fontSize: 16)),
                  ),
                  Text(
                    '$attacks ataques',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
