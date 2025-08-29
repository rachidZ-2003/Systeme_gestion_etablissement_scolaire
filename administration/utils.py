# administration/utils.py
"""
Utilitaires pour l'application administration
"""
import secrets
import string
from datetime import datetime
from django.contrib.auth.hashers import make_password
from django.core.mail import send_mail
from django.conf import settings


class CodeGenerator:
    """Générateur de codes divers"""
    
    @staticmethod
    def generer_code_etablissement(ville, type_etablissement='PUB'):
        """
        Génère un code d'établissement unique
        Format: VILLE_TYPE_ANNEE_NUMERO
        """
        year = str(datetime.now().year)[-2:]
        random_num = secrets.randbelow(9999)
        ville_code = ville[:3].upper()
        return f"{ville_code}_{type_etablissement}_{year}_{random_num:04d}"
    
    @staticmethod
    def generer_mot_passe(longueur=8):
        """Génère un mot de passe sécurisé"""
        caracteres = string.ascii_letters + string.digits + "!@#$%&*"
        mot_passe = ''.join(secrets.choice(caracteres) for _ in range(longueur))
        
        # S'assurer qu'il y a au moins une majuscule, une minuscule, un chiffre
        if (not any(c.isupper() for c in mot_passe) or 
            not any(c.islower() for c in mot_passe) or 
            not any(c.isdigit() for c in mot_passe)):
            # Régénérer si les critères ne sont pas respectés
            return CodeGenerator.generer_mot_passe(longueur)
        
        return mot_passe
    
    @staticmethod
    def generer_otp(longueur=6):
        """Génère un code OTP numérique"""
        return ''.join(secrets.choice(string.digits) for _ in range(longueur))
    
    @staticmethod
    def generer_matricule_enseignant():
        """Génère un matricule d'enseignant unique"""
        from utilisateurs.models import Enseignant
        
        year = str(datetime.now().year)[-2:]
        count = Enseignant.objects.count() + 1
        return f"ENS{year}{count:04d}"


class ValidationUtils:
    """Utilitaires de validation"""
    
    @staticmethod
    def valider_email(email):
        """Valide le format d'un email"""
        import re
        pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
        return re.match(pattern, email) is not None
    
    @staticmethod
    def valider_telephone(telephone):
        """Valide le format d'un numéro de téléphone"""
        import re
        # Format international ou local
        pattern = r'^(\+\d{1,3}[- ]?)?\d{8,15}$'
        return re.match(pattern, telephone.replace(' ', '')) is not None
    
    @staticmethod
    def valider_capacite_salle(capacite):
        """Valide la capacité d'une salle"""
        from .constants import MIN_CAPACITE_SALLE, MAX_CAPACITE_SALLE
        return MIN_CAPACITE_SALLE <= capacite <= MAX_CAPACITE_SALLE


class NotificationUtils:
    """Utilitaires pour les notifications"""
    
    @staticmethod
    def envoyer_email_creation_compte(utilisateur, mot_passe_temporaire=None):
        """Envoie un email de notification de création de compte"""
        if not hasattr(settings, 'EMAIL_HOST'):
            return False
        
        sujet = "Création de votre compte - Plateforme Scolaire"
        message = f"""
        Bonjour {utilisateur.prenom} {utilisateur.nom},
        
        Votre compte a été créé avec succès sur la plateforme de gestion scolaire.
        
        Informations de connexion:
        - Email: {utilisateur.email}
        - Rôle: {utilisateur.role}
        """
        
        if mot_passe_temporaire:
            message += f"""
        - Mot de passe temporaire: {mot_passe_temporaire}
        
        IMPORTANT: Veuillez changer votre mot de passe lors de votre première connexion.
        """
        
        message += """
        
        Cordialement,
        L'équipe de gestion scolaire
        """
        
        try:
            send_mail(
                sujet,
                message,
                settings.DEFAULT_FROM_EMAIL,
                [utilisateur.email],
                fail_silently=False,
            )
            return True
        except Exception:
            return False
    
    @staticmethod
    def envoyer_otp_souscription(chef_etablissement, code_otp):
        """Envoie le code OTP pour la souscription"""
        if not hasattr(settings, 'EMAIL_HOST'):
            return False
        
        sujet = "Code OTP pour souscription d'établissement"
        message = f"""
        Bonjour {chef_etablissement.prenom} {chef_etablissement.nom},
        
        Voici votre code OTP pour la souscription de votre établissement:
        
        Code OTP: {code_otp}
        
        Ce code expire dans 10 minutes.
        
        Cordialement,
        L'équipe de gestion scolaire
        """
        
        try:
            send_mail(
                sujet,
                message,
                settings.DEFAULT_FROM_EMAIL,
                [chef_etablissement.email],
                fail_silently=False,
            )
            return True
        except Exception:
            return False


class StatistiquesUtils:
    """Utilitaires pour les statistiques"""
    
    @staticmethod
    def calculer_statistiques_etablissement(etablissement):
        """Calcule les statistiques complètes d'un établissement"""
        from .models import Batiment, Salle, Classe
        from utilisateurs.models import Enseignant, Eleve
        
        stats = {
            'etablissement': {
                'nom': etablissement.code_etablissement,
                'ville': etablissement.ville,
                'type': etablissement.type
            },
            'infrastructure': {
                'batiments': etablissement.batiments.count(),
                'salles': Salle.objects.filter(batiment__etablissement=etablissement).count(),
                'capacite_totale': sum(
                    salle.capacite for salle in 
                    Salle.objects.filter(batiment__etablissement=etablissement)
                ),
                'classes': Classe.objects.count()  # À adapter selon votre logique
            },
            'personnel': {
                'enseignants': Enseignant.objects.count(),  # À filtrer par établissement
                # Ajouter d'autres statistiques selon vos besoins
            },
            'eleves': {
                # À implémenter selon vos relations
                'total': 0,
                'par_niveau': {}
            }
        }
        
        return stats
    
    @staticmethod
    def generer_rapport_patrimoine(etablissement):
        """Génère un rapport détaillé du patrimoine"""
        from .models import Batiment, Salle
        
        batiments = etablissement.batiments.all()
        rapport = {
            'etablissement': etablissement.code_etablissement,
            'date_rapport': datetime.now().strftime('%Y-%m-%d %H:%M'),
            'batiments': []
        }
        
        for batiment in batiments:
            salles = batiment.salles.all()
            batiment_info = {
                'nom': batiment.nom,
                'type': batiment.type,
                'salles': [
                    {
                        'nom': salle.nom,
                        'capacite': salle.capacite,
                        'type': salle.type_salle,
                        'classe': salle.classe.niveau if salle.classe else None
                    }
                    for salle in salles
                ],
                'capacite_totale': sum(salle.capacite for salle in salles),
                'nb_salles': len(salles)
            }
            rapport['batiments'].append(batiment_info)
        
        return rapport


class PeriodeUtils:
    """Utilitaires pour la gestion des périodes scolaires"""
    
    @staticmethod
    def generer_periodes_annee(annee_scolaire, type_periode='trimestre'):
        """Génère les noms des périodes pour une année scolaire"""
        if type_periode == 'trimestre':
            return [
                f"{annee_scolaire} - 1er Trimestre",
                f"{annee_scolaire} - 2ème Trimestre",
                f"{annee_scolaire} - 3ème Trimestre"
            ]
        elif type_periode == 'semestre':
            return [
                f"{annee_scolaire} - 1er Semestre",
                f"{annee_scolaire} - 2ème Semestre"
            ]
        else:
            return [f"{annee_scolaire} - Année complète"]
    
    @staticmethod
    def valider_annee_scolaire(annee_scolaire):
        """Valide le format d'une année scolaire (ex: 2023-2024)"""
        import re
        pattern = r'^\d{4}-\d{4}$'
        if not re.match(pattern, annee_scolaire):
            return False
        
        debut, fin = map(int, annee_scolaire.split('-'))
        return fin == debut + 1
