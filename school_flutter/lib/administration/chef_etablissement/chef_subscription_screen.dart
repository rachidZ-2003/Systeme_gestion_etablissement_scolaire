
import 'package:flutter/material.dart';
import 'package:school_flutter/administration/chef_etablissement/chef_etablissement_bashboard.dart';
class ChefSubscriptionScreen extends StatefulWidget {
  final String codeEtablissement;
  const ChefSubscriptionScreen({super.key, required this.codeEtablissement});

  @override
  State<ChefSubscriptionScreen> createState() => _ChefSubscriptionScreenState();
}

class _ChefSubscriptionScreenState extends State<ChefSubscriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  Map<String, dynamic>? _etablissementData;

  // Données fictives pour la démonstration (remplacez par votre API ou base de données)
  final Map<String, Map<String, dynamic>> _mockEtablissements = {
    'CODE123': {'nom': 'Lycée Moderne', 'adresse': 'Abidjan'},
    'CODE456': {'nom': 'Collège International', 'adresse': 'Yamoussoukro'},
  };

  @override
  void initState() {
    super.initState();
    _etablissementData = _mockEtablissements[widget.codeEtablissement];
  }

  void _navigateTochefEtablissementSubscription() {
     if (_formKey.currentState!.validate()) {
      // TODO: Enregistrer le compte chef dans le backend (nom d'utilisateur, mot de passe, établissement lié)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Compte chef d\'établissement créé avec succès')),
      );
      
      
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChefLogin()),
    );
  }


  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFFF5F5F7), // Couleur de fond gris clair
    body: Container(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              
              // Titre principal
              const Text(
                'Creation compte - chef d\'etablissement',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 60),
              
              // Informations établissement
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  'Établissement: ${_etablissementData?['nom'] ?? 'Inconnu'}\nAdresse: ${_etablissementData?['adresse'] ?? 'Inconnue'}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF7F8C8D),
                    height: 1.4,
                  ),
                ),
              ),
              
              // Champ Identifiant
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    hintText: 'Nom d\'utilisateur',
                    hintStyle: TextStyle(
                      color: Color(0xFFBDC3C7),
                      fontSize: 16,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF2C3E50),
                  ),
                  validator: (value) => value!.isEmpty ? 'Nom d\'utilisateur requis' : null,
                ),
              ),
              
              // Champ Mot de passe
              Container(
                margin: const EdgeInsets.only(bottom: 32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    hintText: 'Mot de passe',
                    hintStyle: TextStyle(
                      color: Color(0xFFBDC3C7),
                      fontSize: 16,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF2C3E50),
                  ),
                  obscureText: true,
                  validator: (value) => value!.length < 6 ? 'Mot de passe trop court' : null,
                ),
              ),
              
              // Bouton Se connecter
              Container(
                width: double.infinity,
                height: 54,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color.fromARGB(255, 46, 204, 99), Color(0xFF27AE60)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 46, 204, 59).withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _navigateTochefEtablissementSubscription();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Se connecter',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    ),
  );
}
}