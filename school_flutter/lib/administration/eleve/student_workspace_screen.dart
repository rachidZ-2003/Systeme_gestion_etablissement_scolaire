import 'package:flutter/material.dart';

class StudentLoginScreen extends StatefulWidget {
  const StudentLoginScreen({super.key});

  @override
  State<StudentLoginScreen> createState() => _StudentLoginScreenState();
}

class _StudentLoginScreenState extends State<StudentLoginScreen> {
  final _ineController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() {
    // Identifiants fixes provisoires
    if (_ineController.text == "INE123" &&
        _passwordController.text == "1234") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const StudentDashboard()),
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
                        "Connexion -  élève",
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
                              color: Color.fromARGB(255, 107, 255, 139),
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
                              color: Color.fromARGB(255, 107, 255, 156),
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
                            backgroundColor: const Color.fromARGB(255, 107, 255, 127),
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



class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  void _navigateTo(BuildContext context, String page) {
    Navigator.pop(context); // Ferme le Drawer
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Ouverture de la page : $page"),
        duration: const Duration(seconds: 2),
      ),
    );
    // 👉 Ici tu peux remplacer par un vrai Navigator.push()
    // Navigator.push(context, MaterialPageRoute(builder: (_) => PageDemande()));
  }
  void _navigateToParentWorkspace(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const  StudentLoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Élève"),
        backgroundColor: const Color.fromARGB(255, 107, 255, 156),
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 107, 255, 156),
              ),
              accountName: Text("Élève"),
              accountEmail: Text("eleve@email.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.school, color: Colors.green, size: 40),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.edit_document, color: Colors.blue),
              title: const Text("Faire une Demande"),
              onTap: () => _navigateTo(context, "Demande"),
            ),
            ListTile(
              leading: const Icon(Icons.replay_circle_filled,
                  color: Colors.orange),
              title: const Text("Réinscription"),
              onTap: () => _navigateTo(context, "Réinscription"),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Déconnexion"),
              onTap: () {
                Navigator.pop(context);
                _navigateToParentWorkspace(context);
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text(
          "Bienvenue dans ton espace élève 🎓",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
