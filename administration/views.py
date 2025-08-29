from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from django.contrib.auth.hashers import make_password
from django.utils import timezone
from datetime import datetime
import secrets
import string

from .models import Etablissement, Batiment, Classe, Salle, SouscriptionEtablissement, Periode
from .serializers import (
    EtablissementSerializer, BatimentSerializer, ClasseSerializer, 
    SalleSerializer, SouscriptionEtablissementSerializer, PeriodeSerializer,
    SouscriptionEtablissementCreateSerializer
)
from utilisateurs.models import ChefEtablissement, Caissier, Censeur, Enseignant
from utilisateurs.serializers import (
    ChefEtablissementSerializer, CaissierSerializer, 
    CenseurSerializer, EnseignantSerializer
)


class EtablissementViewSet(viewsets.ModelViewSet):
    queryset = Etablissement.objects.all()
    serializer_class = EtablissementSerializer

    @action(detail=True, methods=['get'])
    def statistiques(self, request, pk=None):
        """Récupère les statistiques d'un établissement"""
        etablissement = self.get_object()
        
        # Compter les éléments liés
        nb_batiments = etablissement.batiments.count()
        nb_classes = Classe.objects.count()  # Vous pourriez vouloir filtrer par établissement
        nb_salles = Salle.objects.filter(batiment__etablissement=etablissement).count()
        
        data = {
            'etablissement': EtablissementSerializer(etablissement).data,
            'statistiques': {
                'nombre_batiments': nb_batiments,
                'nombre_classes': nb_classes,
                'nombre_salles': nb_salles,
            }
        }
        return Response(data)

    @action(detail=True, methods=['get'])
    def patrimoine_complet(self, request, pk=None):
        """Récupère tout le patrimoine d'un établissement"""
        etablissement = self.get_object()
        
        # Récupérer tous les bâtiments avec leurs salles
        batiments = etablissement.batiments.all()
        
        data = {
            'etablissement': EtablissementSerializer(etablissement).data,
            'batiments': BatimentSerializer(batiments, many=True).data,
            'total_salles': Salle.objects.filter(batiment__etablissement=etablissement).count()
        }
        return Response(data)


class BatimentViewSet(viewsets.ModelViewSet):
    queryset = Batiment.objects.all()
    serializer_class = BatimentSerializer

    def get_queryset(self):
        """Filtrer par établissement si spécifié"""
        queryset = Batiment.objects.all()
        etablissement_id = self.request.query_params.get('etablissement', None)
        if etablissement_id is not None:
            queryset = queryset.filter(etablissement=etablissement_id)
        return queryset

    @action(detail=True, methods=['get'])
    def salles(self, request, pk=None):
        """Récupère toutes les salles d'un bâtiment"""
        batiment = self.get_object()
        salles = batiment.salles.all()
        return Response(SalleSerializer(salles, many=True).data)


class ClasseViewSet(viewsets.ModelViewSet):
    queryset = Classe.objects.all()
    serializer_class = ClasseSerializer


class SalleViewSet(viewsets.ModelViewSet):
    queryset = Salle.objects.all()
    serializer_class = SalleSerializer

    def get_queryset(self):
        """Filtrer par bâtiment ou établissement si spécifié"""
        queryset = Salle.objects.all()
        batiment_id = self.request.query_params.get('batiment', None)
        etablissement_id = self.request.query_params.get('etablissement', None)
        
        if batiment_id is not None:
            queryset = queryset.filter(batiment=batiment_id)
        elif etablissement_id is not None:
            queryset = queryset.filter(batiment__etablissement=etablissement_id)
            
        return queryset

    @action(detail=False, methods=['get'])
    def par_classe(self, request):
        """Récupère les salles groupées par classe"""
        classe_id = request.query_params.get('classe', None)
        if classe_id:
            salles = self.get_queryset().filter(classe=classe_id)
            return Response(SalleSerializer(salles, many=True).data)
        return Response({'error': 'Paramètre classe requis'}, status=400)


class PeriodeViewSet(viewsets.ModelViewSet):
    queryset = Periode.objects.all()
    serializer_class = PeriodeSerializer

    def get_queryset(self):
        """Filtrer par établissement si spécifié"""
        queryset = Periode.objects.all()
        etablissement_id = self.request.query_params.get('etablissement', None)
        if etablissement_id is not None:
            queryset = queryset.filter(etablissement=etablissement_id)
        return queryset

    @action(detail=False, methods=['post'])
    def creer_annee_complete(self, request):
        """Crée une année scolaire complète avec trimestres/semestres"""
        try:
            annee_scolaire = request.data.get('annee_scolaire')
            etablissement_id = request.data.get('etablissement')
            type_periode = request.data.get('type_periode', 'trimestre')  # trimestre ou semestre
            
            if not all([annee_scolaire, etablissement_id]):
                return Response(
                    {'error': 'Année scolaire et établissement requis'}, 
                    status=status.HTTP_400_BAD_REQUEST
                )
            
            etablissement = Etablissement.objects.get(id=etablissement_id)
            
            # Créer les périodes selon le type
            periodes_created = []
            if type_periode == 'trimestre':
                noms_periodes = ['1er Trimestre', '2ème Trimestre', '3ème Trimestre']
            else:
                noms_periodes = ['1er Semestre', '2ème Semestre']
            
            for nom in noms_periodes:
                periode = Periode.objects.create(
                    annee_scolaire=f"{annee_scolaire} - {nom}",
                    etablissement=etablissement
                )
                periodes_created.append(periode)
            
            return Response({
                'message': f'{len(periodes_created)} périodes créées avec succès',
                'periodes': PeriodeSerializer(periodes_created, many=True).data
            }, status=status.HTTP_201_CREATED)
            
        except Etablissement.DoesNotExist:
            return Response(
                {'error': 'Établissement non trouvé'}, 
                status=status.HTTP_404_NOT_FOUND
            )
        except Exception as e:
            return Response(
                {'error': str(e)}, 
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )


class SouscriptionEtablissementViewSet(viewsets.ModelViewSet):
    queryset = SouscriptionEtablissement.objects.all()
    serializer_class = SouscriptionEtablissementSerializer

    def get_serializer_class(self):
        if self.action == 'create':
            return SouscriptionEtablissementCreateSerializer
        return SouscriptionEtablissementSerializer

    @action(detail=False, methods=['post'])
    def souscrire_avec_otp(self, request):
        """Effectue une souscription avec vérification OTP"""
        try:
            code_otp = request.data.get('code_otp')
            chef_id = request.data.get('chef_id')
            etablissement_id = request.data.get('etablissement_id')
            
            if not all([code_otp, chef_id, etablissement_id]):
                return Response(
                    {'error': 'Code OTP, chef et établissement requis'}, 
                    status=status.HTTP_400_BAD_REQUEST
                )
            
            # Ici vous implémenterez la vérification OTP
            # Pour l'instant, on accepte n'importe quel code de 6 chiffres
            if len(code_otp) != 6 or not code_otp.isdigit():
                return Response(
                    {'error': 'Code OTP invalide'}, 
                    status=status.HTTP_400_BAD_REQUEST
                )
            
            chef = ChefEtablissement.objects.get(id=chef_id)
            etablissement = Etablissement.objects.get(id=etablissement_id)
            
            # Vérifier si une souscription existe déjà
            if SouscriptionEtablissement.objects.filter(
                chef=chef, etablissement=etablissement
            ).exists():
                return Response(
                    {'error': 'Souscription déjà existante'}, 
                    status=status.HTTP_400_BAD_REQUEST
                )
            
            # Créer la souscription
            souscription = SouscriptionEtablissement.objects.create(
                date_souscription=timezone.now().date(),
                chef=chef,
                etablissement=etablissement
            )
            
            return Response({
                'message': 'Souscription effectuée avec succès',
                'souscription': SouscriptionEtablissementSerializer(souscription).data
            }, status=status.HTTP_201_CREATED)
            
        except (ChefEtablissement.DoesNotExist, Etablissement.DoesNotExist):
            return Response(
                {'error': 'Chef d\'établissement ou établissement non trouvé'}, 
                status=status.HTTP_404_NOT_FOUND
            )
        except Exception as e:
            return Response(
                {'error': str(e)}, 
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )


class GestionUtilisateursViewSet(viewsets.ViewSet):
    """ViewSet pour la gestion des comptes utilisateurs par le chef d'établissement"""
    
    def generer_mot_passe(self, longueur=8):
        """Génère un mot de passe aléatoire"""
        caracteres = string.ascii_letters + string.digits + "!@#$%"
        return ''.join(secrets.choice(caracteres) for _ in range(longueur))

    @action(detail=False, methods=['post'])
    def creer_caissier(self, request):
        """Crée un compte caissier"""
        try:
            data = request.data.copy()
            
            # Générer un mot de passe si non fourni
            if not data.get('mot_passe'):
                data['mot_passe'] = self.generer_mot_passe()
            
            # Hasher le mot de passe
            data['mot_passe'] = make_password(data['mot_passe'])
            data['role'] = 'caissier'
            
            # Créer le caissier
            caissier_data = {
                'nom': data.get('nom'),
                'prenom': data.get('prenom'),
                'email': data.get('email'),
                'telephone': data.get('telephone', ''),
                'mot_passe': data['mot_passe'],
                'role': data['role'],
                'date_naissance': data.get('date_naissance'),
                'genre': data.get('genre', ''),
                'date_embauche': data.get('date_embauche', timezone.now().date())
            }
            
            caissier = Caissier.objects.create(**caissier_data)
            
            return Response({
                'message': 'Compte caissier créé avec succès',
                'utilisateur': CaissierSerializer(caissier).data,
                'mot_passe_genere': data.get('mot_passe') != make_password(data['mot_passe'])
            }, status=status.HTTP_201_CREATED)
            
        except Exception as e:
            return Response(
                {'error': str(e)}, 
                status=status.HTTP_400_BAD_REQUEST
            )

    @action(detail=False, methods=['post'])
    def creer_censeur(self, request):
        """Crée un compte censeur"""
        try:
            data = request.data.copy()
            
            # Générer un mot de passe si non fourni
            if not data.get('mot_passe'):
                data['mot_passe'] = self.generer_mot_passe()
            
            # Hasher le mot de passe
            mot_passe_original = data['mot_passe']
            data['mot_passe'] = make_password(data['mot_passe'])
            data['role'] = 'censeur'
            
            # Créer le censeur
            censeur_data = {
                'nom': data.get('nom'),
                'prenom': data.get('prenom'),
                'email': data.get('email'),
                'telephone': data.get('telephone', ''),
                'mot_passe': data['mot_passe'],
                'role': data['role'],
                'date_naissance': data.get('date_naissance'),
                'genre': data.get('genre', ''),
                'date_embauche': data.get('date_embauche', timezone.now().date())
            }
            
            censeur = Censeur.objects.create(**censeur_data)
            
            return Response({
                'message': 'Compte censeur créé avec succès',
                'utilisateur': CenseurSerializer(censeur).data,
                'mot_passe_genere': mot_passe_original if not request.data.get('mot_passe') else None
            }, status=status.HTTP_201_CREATED)
            
        except Exception as e:
            return Response(
                {'error': str(e)}, 
                status=status.HTTP_400_BAD_REQUEST
            )

    @action(detail=False, methods=['post'])
    def creer_enseignant(self, request):
        """Crée un compte enseignant"""
        try:
            data = request.data.copy()
            
            # Générer un mot de passe si non fourni
            if not data.get('mot_passe'):
                data['mot_passe'] = self.generer_mot_passe()
            
            # Générer un matricule si non fourni
            if not data.get('matricule'):
                # Format: ENS + année + numéro séquentiel
                year = str(datetime.now().year)[-2:]
                count = Enseignant.objects.count() + 1
                data['matricule'] = f"ENS{year}{count:04d}"
            
            # Hasher le mot de passe
            mot_passe_original = data['mot_passe']
            data['mot_passe'] = make_password(data['mot_passe'])
            data['role'] = 'enseignant'
            
            # Créer l'enseignant
            enseignant_data = {
                'nom': data.get('nom'),
                'prenom': data.get('prenom'),
                'email': data.get('email'),
                'telephone': data.get('telephone', ''),
                'mot_passe': data['mot_passe'],
                'role': data['role'],
                'date_naissance': data.get('date_naissance'),
                'genre': data.get('genre', ''),
                'matricule': data['matricule'],
                'grade': data.get('grade', ''),
                'specialite': data.get('specialite', ''),
                'date_embauche': data.get('date_embauche', timezone.now().date())
            }
            
            enseignant = Enseignant.objects.create(**enseignant_data)
            
            return Response({
                'message': 'Compte enseignant créé avec succès',
                'utilisateur': EnseignantSerializer(enseignant).data,
                'mot_passe_genere': mot_passe_original if not request.data.get('mot_passe') else None
            }, status=status.HTTP_201_CREATED)
            
        except Exception as e:
            return Response(
                {'error': str(e)}, 
                status=status.HTTP_400_BAD_REQUEST
            )

    @action(detail=False, methods=['get'])
    def liste_tous_comptes(self, request):
        """Liste tous les comptes de l'établissement"""
        try:
            # Récupérer tous les utilisateurs par type
            caissiers = Caissier.objects.all()
            censeurs = Censeur.objects.all()
            enseignants = Enseignant.objects.all()
            chefs = ChefEtablissement.objects.all()
            
            data = {
                'caissiers': CaissierSerializer(caissiers, many=True).data,
                'censeurs': CenseurSerializer(censeurs, many=True).data,
                'enseignants': EnseignantSerializer(enseignants, many=True).data,
                'chefs_etablissement': ChefEtablissementSerializer(chefs, many=True).data,
                'statistiques': {
                    'total_caissiers': caissiers.count(),
                    'total_censeurs': censeurs.count(),
                    'total_enseignants': enseignants.count(),
                    'total_chefs': chefs.count(),
                }
            }
            
            return Response(data)
            
        except Exception as e:
            return Response(
                {'error': str(e)}, 
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )