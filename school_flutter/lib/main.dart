import 'package:flutter/material.dart';
import 'package:school_flutter/scolarite/screens/classe_list_screen.dart';
import 'package:school_flutter/scolarite/screens/cours_list_screen.dart';
import 'package:school_flutter/scolarite/screens/demande_list_screen.dart';
import 'package:school_flutter/scolarite/screens/inscription_list_screen.dart';
import 'package:school_flutter/scolarite/screens/tranche_list_screen.dart';
import 'package:school_flutter/scolarite/screens/eleve_form_screen.dart'; // For creating new students
import 'package:school_flutter/scolarite/screens/stats_screen.dart';

// Configuration de l'URL de base de l'API
const String kBaseUrl =
    "http://127.0.0.1:8000/api/"; // Vous pouvez changer le port ici (ex: 8000, 8001, etc.)

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Système de Gestion Scolaire',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MainHomeScreen(),
    );
  }
}

class MainHomeScreen extends StatelessWidget {
  const MainHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accueil Scolarité'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: const Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Gestion des Cours'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CoursListScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.class_),
              title: const Text('Gestion des Classes'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ClasseListScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('Demandes d\'Inscription'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DemandeListScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.how_to_reg),
              title: const Text('Inscriptions'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InscriptionListScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.payment),
              title: const Text('Quittances de Paiement'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TrancheListScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Créer Compte Élève'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EleveFormScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text('Statistiques'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StatsScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text(
          'Bienvenue dans le Système de Gestion Scolaire !',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
