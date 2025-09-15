import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http_parser/http_parser.dart'; // Pour MediaType
import 'package:mime/mime.dart'; // Pour détecter automatiquement le type MIME

class StudentSubscriptionScreen extends StatefulWidget {
  const StudentSubscriptionScreen({super.key});
  @override
  State<StudentSubscriptionScreen> createState() =>
      _StudentSubscriptionScreenState();
}

class _StudentSubscriptionScreenState extends State<StudentSubscriptionScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _dateNaissanceController = TextEditingController();

  String? _selectedGenre;
  DateTime? _dateNaissance;
  Uint8List? _photoBytes;
  String? _photoName;

  final ImagePicker _imagePicker = ImagePicker();
  final List<String> _genreOptions = ['M', 'F'];

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _telephoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _dateNaissanceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
      imageQuality: 85,
    );
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _photoBytes = bytes;
        _photoName = image.name;
      });
      debugPrint(
        '📷 Image sélectionnée: $_photoName, taille: ${bytes.length} bytes',
      );
    } else {
      debugPrint('❌ Aucune image sélectionnée');
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 15)),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dateNaissance = picked;
        _dateNaissanceController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
      debugPrint(
        '📅 Date de naissance sélectionnée: ${_dateNaissanceController.text}',
      );
    }
  }

  Future<void> _submitSubscription() async {
    if (!_formKey.currentState!.validate()) {
      debugPrint('❌ Formulaire invalide');
      return;
    }

    if (_passwordController.text.trim() !=
        _confirmPasswordController.text.trim()) {
      debugPrint('❌ Les mots de passe ne correspondent pas');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Les mots de passe ne correspondent pas')),
      );
      return;
    }

    final uri = Uri.parse('http://127.0.0.1:8000/api/utilisateurs/eleves/');
    final Map<String, String> fields = {
      'nom': _nomController.text.trim(),
      'prenom': _prenomController.text.trim(),
      'email': _emailController.text.trim(),
      'telephone': _telephoneController.text.trim(),
      'date_naissance': _dateNaissanceController.text,
      'genre': _selectedGenre ?? '',
      'password': _passwordController.text.trim(),
    };

    debugPrint('📝 Données à envoyer: $fields');

    try {
      var request = http.MultipartRequest('POST', uri);
      request.fields.addAll(fields);

      if (_photoBytes != null && _photoName != null) {
        final mimeType = lookupMimeType(_photoName!) ?? 'image/jpeg';
        final split = mimeType.split('/');
        debugPrint('📷 Ajout du fichier: $_photoName, type MIME: $mimeType');

        request.files.add(
          http.MultipartFile.fromBytes(
            'photo',
            _photoBytes!,
            filename: _photoName!,
            contentType: MediaType(split[0], split[1]),
          ),
        );
      } else {
        debugPrint('⚠️ Aucun fichier photo envoyé');
      }

      debugPrint('⏳ Envoi de la requête au serveur...');
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint('📬 Status code: ${response.statusCode}');
      debugPrint('📬 Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Élève créé avec succès !')),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erreur: ${response.body}')));
      }
    } catch (e) {
      debugPrint('❌ Erreur lors de l\'envoi: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inscription Élève')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage:
                      _photoBytes != null ? MemoryImage(_photoBytes!) : null,
                  child:
                      _photoBytes == null
                          ? const Icon(Icons.add_a_photo, size: 40)
                          : null,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nomController,
                decoration: const InputDecoration(labelText: 'Nom *'),
                validator: (v) => v == null || v.isEmpty ? 'Nom requis' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _prenomController,
                decoration: const InputDecoration(labelText: 'Prénom *'),
                validator:
                    (v) => v == null || v.isEmpty ? 'Prénom requis' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email *'),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Email requis';
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v))
                    return 'Email invalide';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Mot de passe *'),
                obscureText: true,
                validator:
                    (v) =>
                        v == null || v.isEmpty ? 'Mot de passe requis' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirmer le mot de passe *',
                ),
                obscureText: true,
                validator:
                    (v) =>
                        v == null || v.isEmpty ? 'Confirmation requise' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _telephoneController,
                decoration: const InputDecoration(labelText: 'Téléphone *'),
                validator:
                    (v) => v == null || v.isEmpty ? 'Téléphone requis' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dateNaissanceController,
                readOnly: true,
                onTap: _selectDate,
                decoration: const InputDecoration(
                  labelText: 'Date de naissance *',
                ),
                validator:
                    (v) => v == null || v.isEmpty ? 'Date requise' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedGenre,
                decoration: const InputDecoration(labelText: 'Genre *'),
                items:
                    _genreOptions
                        .map(
                          (g) => DropdownMenuItem(
                            value: g,
                            child: Text(g == 'M' ? 'Masculin' : 'Féminin'),
                          ),
                        )
                        .toList(),
                onChanged: (v) => setState(() => _selectedGenre = v),
                validator: (v) => v == null ? 'Genre requis' : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitSubscription,
                child: const Text('Créer le compte'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
