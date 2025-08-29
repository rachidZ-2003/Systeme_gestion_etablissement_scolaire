# administration/constants.py
"""
Constantes pour l'application administration
"""

# Types d'établissements
TYPES_ETABLISSEMENT = [
    ('public', 'Public'),
    ('prive', 'Privé'),
    ('mixte', 'Mixte')
]

# Types de bâtiments
TYPES_BATIMENT = [
    ('administratif', 'Bâtiment Administratif'),
    ('pedagogique', 'Bâtiment Pédagogique'),
    ('laboratoire', 'Laboratoire'),
    ('bibliotheque', 'Bibliothèque'),
    ('restaurant', 'Restaurant/Cantine'),
    ('sport', 'Bâtiment Sportif'),
    ('dortoir', 'Dortoir'),
    ('autre', 'Autre')
]

# Types de salles
TYPES_SALLE = [
    ('classe', 'Salle de classe'),
    ('amphitheatre', 'Amphithéâtre'),
    ('laboratoire', 'Laboratoire'),
    ('informatique', 'Salle informatique'),
    ('conference', 'Salle de conférence'),
    ('bibliotheque', 'Bibliothèque'),
    ('sport', 'Salle de sport'),
    ('musique', 'Salle de musique'),
    ('art', 'Salle d\'art'),
    ('bureau', 'Bureau'),
    ('administration', 'Administration'),
    ('autre', 'Autre')
]

# Niveaux scolaires standards
NIVEAUX_CLASSE = [
    # Primaire
    ('cp', 'CP - Cours Préparatoire'),
    ('ce1', 'CE1 - Cours Élémentaire 1'),
    ('ce2', 'CE2 - Cours Élémentaire 2'),
    ('cm1', 'CM1 - Cours Moyen 1'),
    ('cm2', 'CM2 - Cours Moyen 2'),
    
    # Collège
    ('6eme', '6ème'),
    ('5eme', '5ème'),
    ('4eme', '4ème'),
    ('3eme', '3ème'),
    
    # Lycée
    ('seconde', 'Seconde'),
    ('premiere', 'Première'),
    ('terminale', 'Terminale'),
    
    # Post-bac
    ('bts1', 'BTS 1ère année'),
    ('bts2', 'BTS 2ème année'),
    ('licence1', 'Licence 1'),
    ('licence2', 'Licence 2'),
    ('licence3', 'Licence 3'),
    ('master1', 'Master 1'),
    ('master2', 'Master 2'),
]

# Types de périodes
TYPES_PERIODE = [
    ('trimestre', 'Trimestre'),
    ('semestre', 'Semestre'),
    ('annuel', 'Annuel')
]

# Paramètres par défaut
DEFAULT_CAPACITE_SALLE = 30
MIN_CAPACITE_SALLE = 1
MAX_CAPACITE_SALLE = 500

# Messages d'erreur
MESSAGES_ERREUR = {
    'ETABLISSEMENT_EXISTE': 'Un établissement avec ce code existe déjà',
    'SOUSCRIPTION_EXISTE': 'Une souscription existe déjà pour cet établissement',
    'OTP_INVALIDE': 'Code OTP invalide ou expiré',
    'UTILISATEUR_EXISTE': 'Un utilisateur avec cet email existe déjà',
    'CAPACITE_INVALIDE': 'La capacité doit être comprise entre 1 et 500',
    'PERIODE_CHEVAUCHE': 'Cette période chevauche avec une période existante',
}

# Messages de succès
MESSAGES_SUCCES = {
    'ETABLISSEMENT_CREE': 'Établissement créé avec succès',
    'SOUSCRIPTION_REUSSIE': 'Souscription effectuée avec succès',
    'UTILISATEUR_CREE': 'Compte utilisateur créé avec succès',
    'PATRIMOINE_CONFIGURE': 'Patrimoine configuré avec succès',
    'PERIODE_CREEE': 'Période scolaire créée avec succès',
}

# Rôles utilisateurs
ROLES_UTILISATEUR = [
    ('admin', 'Administrateur'),
    ('chef', 'Chef d\'établissement'),
    ('censeur', 'Censeur'),
    ('caissier', 'Caissier'),
    ('enseignant', 'Enseignant'),
    ('eleve', 'Élève'),
    ('parent', 'Parent')
]
