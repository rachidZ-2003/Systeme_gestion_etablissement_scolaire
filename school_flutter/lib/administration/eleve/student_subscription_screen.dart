import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_localizations/flutter_localizations.dart';

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inscription Élève',
      theme: ThemeData(primarySwatch: Colors.blue),
      supportedLocales: const [
        Locale('fr', 'FR'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const StudentSubscriptionScreen(),
    );
  }
}

class StudentSubscriptionScreen extends StatefulWidget {
  const StudentSubscriptionScreen({super.key});
  @override
  State<StudentSubscriptionScreen> createState() =>
      _StudentSubscriptionScreenState();
}

class _StudentSubscriptionScreenState
    extends State<StudentSubscriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();

  // Contrôleurs pour les informations personnelles
  final _nomController = TextEditingController();
  final _prenomsController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _dateNaissanceController = TextEditingController();
  final _lieuNaissanceController = TextEditingController();

  // Contrôleurs pour les informations scolaires
  final _etablissementController = TextEditingController();
  final _classeController = TextEditingController();

  // Contrôleurs pour le compte
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Variables d'état
  int _currentStep = 0;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  String? _selectedGenre;
  String? _selectedRole;
  DateTime? _dateNaissance;

  // Documents - Web compatible
  Uint8List? _photoEleveBytes;
  String? _photoEleveName;

  final ImagePicker _imagePicker = ImagePicker();

  // Options
  final List<String> _genreOptions = ['M', 'F'];
  final List<String> _roleOptions = [
    'eleve',
  ];
  final List<String> _classeOptions = [
    '6ème',
    '5ème',
    '4ème',
    '3ème',
    '2nde',
    '1ère',
    'Terminale',
    '2nde Pro',
    '1ère Pro',
    'Tle Pro',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _nomController.dispose();
    _prenomsController.dispose();
    _dateNaissanceController.dispose();
    _lieuNaissanceController.dispose();
    _telephoneController.dispose();
    _emailController.dispose();
    _etablissementController.dispose();
    _classeController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (image != null) {
        if (kIsWeb) {
          final bytes = await image.readAsBytes();
          setState(() {
            _photoEleveBytes = bytes;
            _photoEleveName = image.name;
          });
        }
        _showSnackBar('Photo ajoutée avec succès', isError: false);
      }
    } catch (e) {
      _showSnackBar('Erreur lors de la sélection de l\'image: $e',
          isError: true);
    }
  }

  /// ✅ Correction de la sélection de date
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 15)),
      firstDate: DateTime(1990),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
    );
    if (picked != null) {
      setState(() {
        _dateNaissance = picked;
        _dateNaissanceController.text =
            "${picked.day.toString().padLeft(2, '0')}/"
            "${picked.month.toString().padLeft(2, '0')}/"
            "${picked.year}";
      });
    }
  }

 
  
  void _nextStep() {
    if (_currentStep < 2) {
      if (_validateCurrentStep()) {
        setState(() {
          _currentStep++;
        });
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }
  
  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
  
  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _validatePersonalInfo();
      case 1:
        return _validateSchoolInfo();
      case 2:
        return _validateAccountInfo();
      default:
        return false;
    }
  }
  
  bool _validatePersonalInfo() {
    if (_nomController.text.trim().isEmpty ||
        _prenomsController.text.trim().isEmpty ||
        _dateNaissance == null ||
        _lieuNaissanceController.text.trim().isEmpty ||
        _selectedGenre == null ||
        _telephoneController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty) {
      _showSnackBar('Veuillez remplir tous les champs obligatoires', isError: true);
      return false;
    }
    return true;
  }
  
  bool _validateSchoolInfo() {
    if (_etablissementController.text.trim().isEmpty ||
        _classeController.text.trim().isEmpty) {
      _showSnackBar('Veuillez remplir tous les champs scolaires obligatoires', isError: true);
      return false;
    }
    return true;
  }
  
  bool _validateAccountInfo() {
    if (_usernameController.text.trim().isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      _showSnackBar('Veuillez remplir tous les champs du compte', isError: true);
      return false;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      _showSnackBar('Les mots de passe ne correspondent pas', isError: true);
      return false;
    }
    return true;
  }
  
  Future<void> _submitSubscription() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (!_validateCurrentStep()) {
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Simulation d'un appel API
      await Future.delayed(const Duration(seconds: 3));
     
      // TODO: Remplacer par votre appel API réel selon les modèles Django
      // Les données à envoyer correspondent aux champs des modèles Utilisateur et Eleve
      final userData = {
        'nom': _nomController.text.trim(),
        'prenoms': _prenomsController.text.trim(),
        'telephone': _telephoneController.text.trim(),
        'email': _emailController.text.trim(),
        'date_naissance': _dateNaissance?.toIso8601String(),
        'lieu_naissance': _lieuNaissanceController.text.trim(),
        'genre': _selectedGenre,
        'role': _selectedRole ?? 'eleve',
        'username': _usernameController.text.trim(),
        'password': _passwordController.text,
      };
      
      final eleveData = {
        'date_inscription': DateTime.now().toIso8601String(),
        'classe': _classeController.text.trim(),
        'etablissement': _etablissementController.text.trim(),
        // Photo sera traitée séparément
      };
      
      print('Données utilisateur: $userData');
      print('Données élève: $eleveData');
      if (_photoEleveBytes != null) {
        print('Photo: ${_photoEleveName} (${_photoEleveBytes!.length} bytes)');
      }
      
      _showSnackBar('Compte élève créé avec succès !', isError: false);
     
      await Future.delayed(const Duration(seconds: 1));
     
      if (mounted) {
        Navigator.pop(context, true);
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
          onPressed: () =>
              ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        ),
      ),
    );
  }

  Widget _buildStepHeader({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, size: 32, color: color),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
            Text(subtitle, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
      ],
    );
  }

  Widget _buildPhotoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Photo de l\'élève',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Center(
          child: GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade200,
                image: _photoEleveBytes != null
                    ? DecorationImage(
                        image: MemoryImage(_photoEleveBytes!), 
                        fit: BoxFit.cover
                      )
                    : null,
              ),
              child: _photoEleveBytes == null
                  ? Icon(Icons.add_photo_alternate, size: 48, color: Colors.grey.shade600)
                  : null,
            ),
          ),
        ),
        if (_photoEleveName != null)
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                _photoEleveName!,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inscription Élève'),
        backgroundColor: const Color.fromARGB(255, 25, 210, 87),
        foregroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: LinearProgressIndicator(
            value: (_currentStep + 1) / 3,
            backgroundColor: Colors.blue.shade100,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.orange.shade600),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.orange.shade50],
          ),
        ),
        child: Form(
          key: _formKey,
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildPersonalInfoStep(),
              _buildSchoolInfoStep(),
              _buildAccountStep(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, -2),
              blurRadius: 8,
              color: Colors.black.withOpacity(0.1),
            ),
          ],
        ),
        child: Row(
          children: [
            if (_currentStep > 0)
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _previousStep,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Précédent'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            if (_currentStep > 0) const SizedBox(width: 16),
            Expanded(
              flex: _currentStep == 0 ? 1 : 1,
              child: ElevatedButton.icon(
                onPressed: _isLoading
                    ? null
                    : _currentStep < 2
                        ? _nextStep
                        : _submitSubscription,
                icon: _isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Icon(_currentStep < 2 ? Icons.arrow_forward : Icons.check),
                label: Text(_isLoading
                    ? 'Création...'
                    : _currentStep < 2
                        ? 'Suivant'
                        : 'Créer le Compte'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: _currentStep < 2 ? const Color.fromARGB(255, 30, 229, 63) : Colors.green.shade600,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPersonalInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepHeader(
            icon: Icons.person,
            title: 'Informations Personnelles',
            subtitle: 'Étape 1/3',
            color: const Color.fromARGB(255, 40, 210, 25),
          ),
          const SizedBox(height: 24),
          
          // Photo de l'élève
          _buildPhotoSection(),
          const SizedBox(height: 24),
          
          // Nom et Prénoms
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _nomController,
                  decoration: const InputDecoration(
                    labelText: 'Nom de famille *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) => value == null || value.trim().isEmpty ? 'Nom requis' : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _prenomsController,
                  decoration: const InputDecoration(
                    labelText: 'Prénoms *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) => value == null || value.trim().isEmpty ? 'Prénoms requis' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Date et lieu de naissance
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _dateNaissanceController,
                  decoration: const InputDecoration(
                    labelText: 'Date de naissance *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: _selectDate,
                  validator: (value) => value == null || value.trim().isEmpty ? 'Date de naissance requise' : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _lieuNaissanceController,
                  decoration: const InputDecoration(
                    labelText: 'Lieu de naissance *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) => value == null || value.trim().isEmpty ? 'Lieu de naissance requis' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Genre (selon le modèle Django)
          DropdownButtonFormField<String>(
            value: _selectedGenre,
            decoration: const InputDecoration(
              labelText: 'Genre *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.wc),
            ),
            items: _genreOptions.map((String genre) {
              return DropdownMenuItem<String>(
                value: genre,
                child: Text(genre == 'M' ? 'Masculin' : 'Féminin'),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedGenre = newValue;
              });
            },
            validator: (value) => value == null ? 'Genre requis' : null,
          ),
          const SizedBox(height: 16),
          
          // Contact
          TextFormField(
            controller: _telephoneController,
            decoration: const InputDecoration(
              labelText: 'Téléphone *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.phone),
              hintText: 'Ex: +226 54 22 77 12',
            ),
            keyboardType: TextInputType.phone,
            validator: (value) => value == null || value.trim().isEmpty ? 'Téléphone requis' : null,
          ),
          const SizedBox(height: 16),
          
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email),
              hintText: 'votre.email@exemple.com',
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Email requis';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Email invalide';
              }
              return null;
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
  
  Widget _buildSchoolInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepHeader(
            icon: Icons.school,
            title: 'Informations Scolaires',
            subtitle: 'Étape 2/3',
            color: Colors.orange.shade700,
          ),
          const SizedBox(height: 24),
          
          // Établissement (champ du modèle Eleve)
          TextFormField(
            controller: _etablissementController,
            decoration: const InputDecoration(
              labelText: 'Nom de l\'établissement *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.business),
              helperText: 'Nom complet de votre lycée/collège',
            ),
            textCapitalization: TextCapitalization.words,
            validator: (value) => value == null || value.trim().isEmpty ? 'Nom de l\'établissement requis' : null,
          ),
          const SizedBox(height: 16),
          
          // Classe (champ du modèle Eleve)
          DropdownButtonFormField<String>(
            value: _classeController.text.isEmpty ? null : _classeController.text,
            decoration: const InputDecoration(
              labelText: 'Classe *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.class_),
            ),
            items: _classeOptions.map((String classe) {
              return DropdownMenuItem<String>(
                value: classe,
                child: Text(classe),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _classeController.text = newValue ?? '';
              });
            },
            validator: (value) => value == null || value.isEmpty ? 'Classe requise' : null,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
  
  Widget _buildAccountStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepHeader(
            icon: Icons.account_circle,
            title: 'Création du Compte',
            subtitle: 'Étape 3/3',
            color: Colors.green.shade700,
          ),
          const SizedBox(height: 24),
          
          // Section création de compte
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Créer votre compte',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Rôle (selon le modèle Utilisateur)
                  DropdownButtonFormField<String>(
                    value: _selectedRole ?? 'eleve',
                    decoration: const InputDecoration(
                      labelText: 'Rôle dans l\'établissement',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.work),
                    ),
                    items: _roleOptions.map((String role) {
                      return DropdownMenuItem<String>(
                        value: role,
                        child: Text(_getRoleDisplayName(role)),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRole = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Nom d'utilisateur (pour l'authentification)
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Nom d\'utilisateur *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                      helperText: 'Minimum 3 caractères, lettres, chiffres et _ seulement',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Nom d\'utilisateur requis';
                      }
                      if (value.trim().length < 3) {
                        return 'Minimum 3 caractères';
                      }
                      if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value.trim())) {
                        return 'Seuls les lettres, chiffres et _ sont autorisés';
                      }
                      return null;
                    },
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Mot de passe requis';
                      }
                      if (value.length < 8) {
                        return 'Au moins 8 caractères';
                      }
                      if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
                        return 'Majuscule, minuscule et chiffre requis';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Confirmer mot de passe
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Confirmation requise';
                      }
                      if (value != _passwordController.text) {
                        return 'Les mots de passe ne correspondent pas';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
  
  String _getRoleDisplayName(String role) {
    switch (role) {
      case 'parent':
        return 'Parent';
      case 'eleve':
        return 'Élève';
      case 'enseignant':
        return 'Enseignant';
      case 'chef':
        return 'Chef d\'établissement';
      case 'censeur':
        return 'Censeur';
      case 'caissier':
        return 'Caissier';
      default:
        return role;
    }
  }
}