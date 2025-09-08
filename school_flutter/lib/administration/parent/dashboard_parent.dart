import 'package:flutter/material.dart';



void main() {
  runApp(const DashboardParentPage ());
}

class DashboardParentPage extends StatefulWidget {
  const DashboardParentPage({super.key});

  @override
  State<DashboardParentPage> createState() => _DashboardParentPageState();
}

class _DashboardParentPageState extends State<DashboardParentPage> {
  final List<Map<String, dynamic>> _enfants = [
    {
      'nom': 'Alice Dupont',
      'classe': '6ème A',
      'moyenne': 15.5,
      'absences': 2,
      'notifications': 3,
    },
    {
      'nom': 'Thomas Dupont',
      'classe': '4ème B',
      'moyenne': 14.0,
      'absences': 1,
      'notifications': 1,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Espace Parent'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // TODO: Show notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Show settings
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Subscription Status Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'État de la souscription',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Statut: Actif'),
                          Chip(
                            label: const Text('Valide jusqu\'au 31/12/2024'),
                            backgroundColor: Colors.green[100],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Handle subscription renewal
                        },
                        child: const Text('Renouveler la souscription'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Children List
              const Text(
                'Mes enfants',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _enfants.length,
                itemBuilder: (context, index) {
                  final enfant = _enfants[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    enfant['nom'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Classe: ${enfant['classe']}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: const Icon(Icons.more_vert),
                                onPressed: () {
                                  // TODO: Show more options
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatCard(
                                'Moyenne',
                                enfant['moyenne'].toString(),
                                Colors.blue,
                              ),
                              _buildStatCard(
                                'Absences',
                                enfant['absences'].toString(),
                                Colors.orange,
                              ),
                              _buildStatCard(
                                'Notifications',
                                enfant['notifications'].toString(),
                                Colors.red,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildActionButton(
                                'Notes',
                                Icons.grade,
                                () {
                                  // TODO: Show grades
                                },
                              ),
                              _buildActionButton(
                                'Emploi du temps',
                                Icons.calendar_today,
                                () {
                                  // TODO: Show schedule
                                },
                              ),
                              _buildActionButton(
                                'Bulletins',
                                Icons.article,
                                () {
                                  // TODO: Show report cards
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Handle adding a new child
        },
        label: const Text('Ajouter un enfant'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback onPressed) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
    );
  }
}
