<<<<<<< HEAD
# Systeme_gestion_etablissement_scolaire
=======
- ✅ Statistiques globales (établissements publics/privés, chefs, souscriptions)
- ✅ Création d'établissements avec code unique
- ✅ Liste et gestion des établissements
- ✅ Interface glassmorphique moderne avec animations

#### Tableau de Bord Chef d'Établissement
- ✅ Navigation par onglets (Dashboard, Établissements, Patrimoine, Utilisateurs, Périodes)
- ✅ Souscription à un établissement via code OTP
- ✅ Création de comptes utilisateurs (Enseignants, Caissiers, Censeurs)
- ✅ Gestion du patrimoine (Bâtiments, Salles, Classes)
- ✅ Création de périodes scolaires
- ✅ Statistiques et activités récentes
- ✅ Design glassmorphique avec animations fluides

### 🎨 Design System

#### Couleurs
- **Administrateur :** Gradient Purple → Pink → Orange
- **Chef d'Établissement :** Gradient Indigo → Blue → Cyan
- **Glass Effect :** Transparence avec blur et bordures lumineuses

#### Animations
- **Fade In :** Apparition progressive des éléments
- **Slide Animations :** Transitions fluides
- **Scale Effects :** Effets de zoom sur les cartes
- **Staggered Animations :** Animations décalées pour les listes

#### Composants
- **GlassCard :** Cartes avec effet de verre
- **GlassButton :** Boutons glassmorphiques avec loading
- **GlassTextField :** Champs de saisie transparents
- **GlassDropdown :** Sélecteurs avec effet de verre

### 📊 API Endpoints

#### Administration
```
GET  /api/administration/administrateur/dashboard_stats/
POST /api/administration/administrateur/create_etablissement/
GET  /api/administration/administrateur/list_etablissements/

POST /api/administration/chef-etablissement/souscrire_etablissement/
POST /api/administration/chef-etablissement/create_compte_utilisateur/
GET  /api/administration/chef-etablissement/dashboard_stats/

POST /api/administration/patrimoine/create_batiment/
POST /api/administration/patrimoine/create_salle/
POST /api/administration/patrimoine/create_classe/
GET  /api/administration/patrimoine/get_patrimoine_by_etablissement/

POST /api/administration/periodes/create_periode/
GET  /api/administration/periodes/list_by_etablissement/
```

### 🗃️ Base de Données

#### Modèles Principaux
- **Utilisateur :** Classe de base pour tous les utilisateurs
- **ChefEtablissement, Enseignant, Caissier, Censeur :** Types d'utilisateurs spécifiques
- **Etablissement :** Établissements scolaires
- **Batiment, Salle, Classe :** Structure du patrimoine
- **Periode :** Périodes scolaires (trimestres/semestres)
- **SouscriptionEtablissement :** Liens chef ↔ établissement

### 🔄 Processus Métier

#### Flux Administrateur
1. Connexion → Tableau de bord
2. Création d'établissement → Génération de code unique
3. Attribution du code au chef d'établissement
4. Supervision des statistiques globales

#### Flux Chef d'Établissement
1. Connexion avec ID → Tableau de bord
2. Souscription avec code établissement
3. Création des comptes personnel (enseignants, caissiers, censeurs)
4. Configuration du patrimoine (bâtiments, salles, classes)
5. Définition des périodes scolaires

### 🔧 Configuration Technique

#### Backend (Django)
- **Framework :** Django 5.0.14
- **API :** Django REST Framework 3.15.2
- **CORS :** django-cors-headers 4.3.1
- **Images :** Pillow 10.4.0
- **Base de données :** SQLite (développement)

#### Frontend (Flutter)
- **Framework :** Flutter 3.7+
- **Design :** Material Design avec Glassmorphism
- **Animations :** flutter_animate 4.5.0
- **HTTP :** http 1.2.2
- **Fonts :** Google Fonts 6.2.1
- **Glass Effects :** glassmorphism 3.0.0

### 🧪 Tests et Validation

#### Données de Test
- 3 établissements (public/privé)
- 3 chefs d'établissement
- 3 enseignants avec spécialités
- 2 caissiers
- 1 censeur
- 5 bâtiments avec types
- 9 classes (6ème à Terminale)
- 5 salles avec capacités
- 4 périodes scolaires

#### Scénarios de Test
1. **Administrateur :** Création d'établissement → Attribution de code
2. **Chef :** Souscription → Création d'utilisateurs → Configuration patrimoine
3. **Navigation :** Test de tous les onglets et fonctionnalités
4. **Responsive :** Test sur différentes tailles d'écran

### 🚧 Limitations Actuelles

- Interface web uniquement (mobile à venir)
- Authentification simplifiée (JWT à implémenter)
- Gestion des permissions basique
- Upload d'images non implémenté
- Notifications en temps réel à venir

### 🔮 Prochains Sprints

#### Sprint 2 : Gestion Pédagogique
- Emploi du temps
- Matières et coefficients
- Attribution enseignants ↔ classes

#### Sprint 3 : Suivi Scolaire
- Notes et évaluations
- Absences
- Bulletins automatiques

#### Sprint 4 : Interface Parents/Élèves
- Portail parents
- Consultation notes
- Communication

### 🤝 Contribution

Pour contribuer au projet :

1. Fork le repository
2. Créer une branche feature (`git checkout -b feature/amelioration`)
3. Commit les changements (`git commit -am 'Ajout fonctionnalité'`)
4. Push vers la branche (`git push origin feature/amelioration`)
5. Créer une Pull Request

### 📞 Support

Pour toute question ou problème :

- **Email :** support@school.bf
- **Documentation :** Consulter ce README
- **Issues :** Utiliser le système d'issues GitHub

---

**🎓 Développé avec passion pour l'éducation au Burkina Faso**

*Version Sprint 1 - Décembre 2024*
>>>>>>> administration
