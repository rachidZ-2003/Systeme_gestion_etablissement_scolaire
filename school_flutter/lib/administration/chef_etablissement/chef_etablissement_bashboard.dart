import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "SchoolMap",
      theme: ThemeData(primarySwatch: Colors.green),
      home: const ChefLogin (),
    );
  }
}

/// --------------------
/// PAGE DE CONNEXION
/// --------------------
class ChefLogin extends StatefulWidget {
  const ChefLogin({super.key});

  @override
  State<ChefLogin> createState() => _ChefLoginState();
}

class _ChefLoginState extends State<ChefLogin> {
  final _ineController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() {
    // Identifiants fixes provisoires
    if (_ineController.text == "INE123" &&
        _passwordController.text == "1234") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ChefEtablissementDashboard()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Identifiants incorrects")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE8E8F5), // Couleur lilas très claire
              Color(0xFFF5F5F5), // Blanc cassé
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                elevation: 8,
                shadowColor: Colors.black.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Titre
                      const Text(
                        "Connexion - chef d'etablissement",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      // Champ Identifiant
                      TextField(
                        controller: _ineController,
                        decoration: InputDecoration(
                          hintText: "Identifiant",
                          hintStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.grey[300]!,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.grey[300]!,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 107, 255, 174),
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Champ Mot de passe
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Mot de passe",
                          hintStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.grey[300]!,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.grey[300]!,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 107, 255, 164),
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Bouton de connexion
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 107, 255, 144),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Se connecter",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// --------------------
/// DASHBOARD - CHEF D'ÉTABLISSEMENT
/// --------------------
class ChefEtablissementDashboard extends StatefulWidget {
  const ChefEtablissementDashboard({super.key});

  @override
  State<ChefEtablissementDashboard> createState() =>
      _ChefEtablissementDashboardState();
}

class _ChefEtablissementDashboardState extends State<ChefEtablissementDashboard> {
  int _selectedIndex = 0;

  final List<String> _titles = [
    "Panneaux d’accueil",
    "Paramétrages",
    "Utilisateur",
    "École",
    "Pédagogie",
    "Gestion des Notes",
    "Inscription",
    "Notification",
    "Importation"
  ];

  final List<IconData> _icons = [
    Icons.home,
    Icons.settings,
    Icons.person,
    Icons.school,
    Icons.menu_book,
    Icons.assignment,
    Icons.how_to_reg,
    Icons.account_balance,
    Icons.notifications,
    Icons.file_upload,
  ];

  // Méthode pour naviguer vers la page correspondante
  //void _navigateToPage(int index) {
  //  Navigator.push(
   //   context,
   //   MaterialPageRoute(builder: (context) => _buildPage(index)),
   // );
  //}

  // Construction de la page en fonction de l'index
  //Widget _buildPage(int index) {
   // switch (index) {
     // case 0:
     //   return AccueilPage();
    //  case 1:
    //    return GestionElevesPage();
    //  case 2:
    //    return GestionEnseignantsPage();
     // case 3:
    //    return StatistiquesPage();
    //  case 4:
    //    return ParametresPage();
     // case 5:
     //   return GestionEnseignantsPage();
    //  case 6:
     //   return StatistiquesPage();
     // case 7:
     //   return ParametresPage();
     // case 8:
      //  return GestionEnseignantsPage();
     // case 9:
      //default:
       // return Container();
   // }
  //}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade800,
        title: Text("ShoolMap - ${_titles[_selectedIndex]}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Déconnexion",
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ChefLogin ()),
              );
            },
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: CircleAvatar(
              //backgroundImage: AssetImage("assets/profile.png"), // image fictive
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.green.shade800),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  CircleAvatar(
                    radius: 30,
                  //  backgroundImage: AssetImage("assets/logo.png"), // logo fictif
                  ),
                  SizedBox(height: 10),
                  Text("SchoolMap",
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                  Text("Chef d'établissement",
                      style: TextStyle(color: Colors.white70, fontSize: 14)),
                ],
              ),
            ),
            for (int i = 0; i < _titles.length; i++)
              ListTile(
                leading: Icon(_icons[i]),
                title: Text(_titles[i]),
                selected: i == _selectedIndex,
                onTap: () {
                  setState(() {
                    _selectedIndex = i;
                  });
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
      body: Center(
        child: Text(
          "Bienvenue dans ${_titles[_selectedIndex]}",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
