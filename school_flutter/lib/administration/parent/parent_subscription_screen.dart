import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:school_flutter/administration/parent/parent_bashbord.dart';

class ParentSubscriptionScreen extends StatefulWidget {
  const ParentSubscriptionScreen({super.key});

  @override
  State<ParentSubscriptionScreen> createState() => _ParentSubscriptionScreenState();
}

class _ParentSubscriptionScreenState extends State<ParentSubscriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _matriculeController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _isMatriculeValid = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _isVerifyingMatricule = false;
  Map<String, dynamic>? _studentData;

  // Données fictives pour la démonstration (remplacez par votre API ou base de données)
  final Map<String, Map<String, dynamic>> _mockDatabase = {
    'MAT123': {
      'nom': 'Jean Dupont', 
      'classe': '3ème', 
      'ecole': 'Lycée Moderne',
      'dateNaissance': '2008-05-15'
    },
    'MAT456': {
      'nom': 'Marie Koffi', 
      'classe': 'Terminale', 
      'ecole': 'Collège International',
      'dateNaissance': '2005-09-20'
    },
    'MAT789': {
      'nom': 'Pierre Martin', 
      'classe': '1ère', 
      'ecole': 'Lycée Technique',
      'dateNaissance': '2006-12-03'
    },
  };

  @override
  void dispose() {
    _matriculeController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _verifyMatricule() async {
    final matricule = _matriculeController.text.trim().toUpperCase();
    
    if (matricule.isEmpty) {
      _showSnackBar('Veuillez saisir un matricule', isError: true);
      return;
    }

    setState(() {
      _isVerifyingMatricule = true;
    });

    // Simulation d'un appel API
    await Future.delayed(const Duration(seconds: 1));

    if (_mockDatabase.containsKey(matricule)) {
      setState(() {
        _isMatriculeValid = true;
        _studentData = _mockDatabase[matricule];
        _isVerifyingMatricule = false;
      });
      _showSnackBar('Matricule vérifié avec succès', isError: false);
    } else {
      setState(() {
        _isMatriculeValid = false;
        _studentData = null;
        _isVerifyingMatricule = false;
      });
      _showSnackBar('Matricule non trouvé. Vérifiez et réessayez.', isError: true);
    }
  }

  Future<void> _submitSubscription() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_isMatriculeValid) {
      _showSnackBar('Veuillez d\'abord vérifier le matricule', isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulation d'un appel API pour créer le compte
      await Future.delayed(const Duration(seconds: 2));
      
      // TODO: Remplacer par votre appel API réel
      // await ApiService.createParentAccount({
      //   'username': _usernameController.text.trim(),
      //   'password': _passwordController.text,
      //   'matricule': _matriculeController.text.trim().toUpperCase(),
      //   'studentData': _studentData,
      // });

      _showSnackBar('Compte parent créé avec succès !', isError: false);
      
      // Attendre un peu avant de naviguer pour que l'utilisateur voie le message
      await Future.delayed(const Duration(seconds: 1));
      
      if (mounted) {
        Navigator.pop(context); 
         _navigateToParentWorkspace();
      }
    } catch (e) {
      _showSnackBar('Erreur lors de la création du compte: $e', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
   
  }
   void _navigateToParentWorkspace() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ParentLoginScreen()),
    );
  }

  void _showSnackBar(String message, {required bool isError}) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: Duration(seconds: isError ? 4 : 2),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        ),
      ),
    );
  }

  void _resetForm() {
    setState(() {
      _isMatriculeValid = false;
      _studentData = null;
      _matriculeController.clear();
      _usernameController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
    });
  }

  String? _validateMatricule(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Le matricule est requis';
    }
    if (value.trim().length < 3) {
      return 'Le matricule doit contenir au moins 3 caractères';
    }
    return null;
  }

  String? _validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Le nom d\'utilisateur est requis';
    }
    if (value.trim().length < 3) {
      return 'Le nom d\'utilisateur doit contenir au moins 3 caractères';
    }
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value.trim())) {
      return 'Seuls les lettres, chiffres et _ sont autorisés';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le mot de passe est requis';
    }
    if (value.length < 8) {
      return 'Le mot de passe doit contenir au moins 8 caractères';
    }
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
      return 'Le mot de passe doit contenir au moins une majuscule, une minuscule et un chiffre';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez confirmer le mot de passe';
    }
    if (value != _passwordController.text) {
      return 'Les mots de passe ne correspondent pas';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Souscription Parent'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        actions: [
          if (_isMatriculeValid)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _resetForm,
              tooltip: 'Réinitialiser',
            ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green.shade50, Colors.orange.shade50],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // En-tête avec instructions
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Icon(
                              Icons.family_restroom,
                              size: 48,
                              color: Colors.green.shade700,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Création de compte parent',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Saisissez le matricule de votre enfant pour commencer',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey.shade600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Champ matricule
                    TextFormField(
                      controller: _matriculeController,
                      decoration: InputDecoration(
                        labelText: 'Matricule de l\'élève *',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.tag_rounded),
                        suffixIcon: _isVerifyingMatricule
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: Padding(
                                  padding: EdgeInsets.all(14),
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              )
                            : _isMatriculeValid
                                ? Icon(Icons.check_circle, color: Colors.green.shade600)
                                : null,
                        helperText: 'Ex: MAT123, MAT456',
                      ),
                      textCapitalization: TextCapitalization.characters,
                      inputFormatters: [
                        UpperCaseTextFormatter(),
                        LengthLimitingTextInputFormatter(10),
                      ],
                      validator: _validateMatricule,
                      onFieldSubmitted: (_) => _verifyMatricule(),
                      onChanged: (_) {
                        if (_isMatriculeValid) {
                          setState(() {
                            _isMatriculeValid = false;
                            _studentData = null;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    // Bouton de vérification
                    ElevatedButton.icon(
                      onPressed: _isVerifyingMatricule ? null : _verifyMatricule,
                      icon: _isVerifyingMatricule
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.search),
                      label: Text(_isVerifyingMatricule ? 'Vérification...' : 'Vérifier Matricule'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: Colors.green.shade600,
                        foregroundColor: Colors.white,
                      ),
                    ),

                    // Informations de l'élève et formulaire
                    if (_isMatriculeValid && _studentData != null) ...[
                      const SizedBox(height: 24),
                      
                      // Carte d'informations de l'élève
                      Card(
                        elevation: 3,
                        color: Colors.green.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.person, color: Colors.green.shade700),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Informations de l\'élève',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green.shade700,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _buildInfoRow('Nom', _studentData!['nom']),
                              _buildInfoRow('Classe', _studentData!['classe']),
                              _buildInfoRow('École', _studentData!['ecole']),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Formulaire de création de compte
                      Text(
                        'Informations du compte parent',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Nom d'utilisateur
                      TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Nom d\'utilisateur *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                          helperText: 'Minimum 3 caractères, lettres, chiffres et _ seulement',
                        ),
                        validator: _validateUsername,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 16),

                      // Mot de passe
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Mot de passe *',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          helperText: 'Au moins 8 caractères avec majuscule, minuscule et chiffre',
                        ),
                        obscureText: !_isPasswordVisible,
                        validator: _validatePassword,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 16),

                      // Confirmation mot de passe
                      TextFormField(
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(
                          labelText: 'Confirmer le mot de passe *',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(_isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                              });
                            },
                          ),
                        ),
                        obscureText: !_isConfirmPasswordVisible,
                        validator: _validateConfirmPassword,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _submitSubscription(),
                      ),
                      const SizedBox(height: 24),

                      // Bouton de soumission
                      ElevatedButton.icon(
                        onPressed: _isLoading ? null : _submitSubscription,
                        icon: _isLoading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.account_circle),
                        label: Text(_isLoading ? 'Création en cours...' : 'Créer le Compte'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.orange.shade600,
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        
                      ),
                      const SizedBox(height: 16),

                      // Note de sécurité
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color.fromARGB(255, 144, 249, 144)),
                          
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info, color: const Color.fromARGB(255, 30, 229, 106), size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Vos informations sont sécurisées et ne seront utilisées que pour la gestion du suivi scolaire.',
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 25, 210, 40),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}

// Formatter pour convertir automatiquement en majuscules
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}