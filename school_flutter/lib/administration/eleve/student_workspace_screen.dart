import 'package:flutter/material.dart';
import 'package:school_flutter/screens/student/auth/student_login_screen.dart';


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
        MaterialPageRoute(builder: (context) => const StudentWorkspaceScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Identifiants incorrects")),
      );
    }
  }

  // Fonction pour gérer le retour
  void _goBack() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back,
              color: Color(0xFF2D3748),
              size: 20,
            ),
          ),
          onPressed: _goBack,
        ),
      ),
      extendBodyBehindAppBar: true,
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
                        "Connexion - élève",
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
                      
                      const SizedBox(height: 16),
                      
                      // Bouton de retour alternatif (optionnel)
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: _goBack,
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.grey[600],
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_back,
                                size: 18,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Retour à l'accueil",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
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

class StudentWorkspaceScreen extends StatefulWidget {
  const StudentWorkspaceScreen({super.key});

  @override
  State<StudentWorkspaceScreen> createState() => _StudentWorkspaceScreenState();
}

class _StudentWorkspaceScreenState extends State<StudentWorkspaceScreen> {
  String currentPage = "Accueil";

  void _navigateTo(String page) {
    setState(() {
      currentPage = page;
    });
    Navigator.pop(context); // Ferme le Drawer
    
    // Afficher un message pour indiquer la navigation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Page active : $page"),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color.fromARGB(255, 107, 255, 127),
      ),
    );
  }

  void _logout() {
    Navigator.pop(context); // Ferme le drawer
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const StudentLoginScreen()),
    );
  }

  Widget _getPageContent() {
    switch (currentPage) {
      case "Accueil":
        return _buildHomeContent();
      case "Faire une Demande":
        return _buildRequestContent();
      case "Consulter Demandes":
        return _buildConsultContent();
      case "Notifications":
        return _buildNotificationContent();
      case "Localiser Établissement":
        return _buildLocationContent();
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.home,
            size: 80,
            color: Color.fromARGB(255, 107, 255, 127),
          ),
          const SizedBox(height: 20),
          const Text(
            "Bienvenue dans ton espace élève 🎓",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Utilise le menu pour naviguer dans tes services",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestContent() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.edit_document,
            size: 80,
            color: Colors.blue,
          ),
          SizedBox(height: 20),
          Text(
            "Faire une Demande",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Formulaire de demande à venir...",
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildConsultContent() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.list_alt,
            size: 80,
            color: Colors.purple,
          ),
          SizedBox(height: 20),
          Text(
            "Consulter tes Demandes",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Liste des demandes à venir...",
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationContent() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications,
            size: 80,
            color: Colors.orange,
          ),
          SizedBox(height: 20),
          Text(
            "Notifications",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Aucune nouvelle notification",
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationContent() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_on,
            size: 80,
            color: Colors.red,
          ),
          SizedBox(height: 20),
          Text(
            "Localiser l'Établissement",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Carte et informations à venir...",
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard Élève - $currentPage"),
        backgroundColor: const Color.fromARGB(255, 107, 255, 156),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            // Header du drawer
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromARGB(255, 107, 255, 156),
                    Color.fromARGB(255, 80, 220, 120),
                  ],
                ),
              ),
              accountName: const Text(
                "Élève Connecté",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              accountEmail: const Text("eleve@education.bf"),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.school,
                  color: Color.fromARGB(255, 107, 255, 156),
                  size: 40,
                ),
              ),
            ),
            
            // Menu principal
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // Accueil
                  ListTile(
                    leading: Icon(
                      Icons.home,
                      color: currentPage == "Accueil" 
                          ? const Color.fromARGB(255, 107, 255, 156) 
                          : Colors.grey[600],
                    ),
                    title: Text(
                      "Accueil",
                      style: TextStyle(
                        fontWeight: currentPage == "Accueil" 
                            ? FontWeight.bold 
                            : FontWeight.normal,
                        color: currentPage == "Accueil"
                            ? const Color.fromARGB(255, 107, 255, 156)
                            : Colors.black87,
                      ),
                    ),
                    selected: currentPage == "Accueil",
                    selectedTileColor: const Color.fromARGB(255, 107, 255, 156).withOpacity(0.1),
                    onTap: () => _navigateTo("Accueil"),
                  ),
                  
                  const Divider(height: 1),
                  
                  // Section Services
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      "SERVICES",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  
                  // Faire une demande
                  ListTile(
                    leading: Icon(
                      Icons.edit_document,
                      color: currentPage == "Faire une Demande" 
                          ? Colors.blue 
                          : Colors.grey[600],
                    ),
                    title: Text(
                      "Faire une Demande",
                      style: TextStyle(
                        fontWeight: currentPage == "Faire une Demande" 
                            ? FontWeight.bold 
                            : FontWeight.normal,
                        color: currentPage == "Faire une Demande"
                            ? Colors.blue
                            : Colors.black87,
                      ),
                    ),
                    selected: currentPage == "Faire une Demande",
                    selectedTileColor: Colors.blue.withOpacity(0.1),
                    onTap: () => _navigateTo("Faire une Demande"),
                  ),
                  
                  // Consulter demandes
                  ListTile(
                    leading: Icon(
                      Icons.list_alt,
                      color: currentPage == "Consulter Demandes" 
                          ? Colors.purple 
                          : Colors.grey[600],
                    ),
                    title: Text(
                      "Consulter Demandes",
                      style: TextStyle(
                        fontWeight: currentPage == "Consulter Demandes" 
                            ? FontWeight.bold 
                            : FontWeight.normal,
                        color: currentPage == "Consulter Demandes"
                            ? Colors.purple
                            : Colors.black87,
                      ),
                    ),
                    selected: currentPage == "Consulter Demandes",
                    selectedTileColor: Colors.purple.withOpacity(0.1),
                    onTap: () => _navigateTo("Consulter Demandes"),
                  ),
                  
                  // Notifications
                  ListTile(
                    leading: Stack(
                      children: [
                        Icon(
                          Icons.notifications,
                          color: currentPage == "Notifications" 
                              ? Colors.orange 
                              : Colors.grey[600],
                        ),
                        // Badge pour les notifications (optionnel)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 12,
                              minHeight: 12,
                            ),
                            child: const Text(
                              '3',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                    title: Text(
                      "Notifications",
                      style: TextStyle(
                        fontWeight: currentPage == "Notifications" 
                            ? FontWeight.bold 
                            : FontWeight.normal,
                        color: currentPage == "Notifications"
                            ? Colors.orange
                            : Colors.black87,
                      ),
                    ),
                    selected: currentPage == "Notifications",
                    selectedTileColor: Colors.orange.withOpacity(0.1),
                    onTap: () => _navigateTo("Notifications"),
                  ),
                  
                  // Localiser établissement
                  ListTile(
                    leading: Icon(
                      Icons.location_on,
                      color: currentPage == "Localiser Établissement" 
                          ? Colors.red 
                          : Colors.grey[600],
                    ),
                    title: Text(
                      "Localiser Établissement",
                      style: TextStyle(
                        fontWeight: currentPage == "Localiser Établissement" 
                            ? FontWeight.bold 
                            : FontWeight.normal,
                        color: currentPage == "Localiser Établissement"
                            ? Colors.red
                            : Colors.black87,
                      ),
                    ),
                    selected: currentPage == "Localiser Établissement",
                    selectedTileColor: Colors.red.withOpacity(0.1),
                    onTap: () => _navigateTo("Localiser Établissement"),
                  ),
                  
                  const Divider(),
                  
                  // Section Compte
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      "COMPTE",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  
                  // Se connecter en tant qu'élève (optionnel si déjà connecté)
                  ListTile(
                    leading: Icon(
                      Icons.person_outline,
                      color: Colors.grey[600],
                    ),
                    title: const Text(
                      "Profil Élève",
                      style: TextStyle(color: Colors.black87),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const StudentLogin(), 
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            
            // Section déconnexion (en bas)
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                "Déconnexion",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: _logout,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _getPageContent(),
      ),
    );
  }
}