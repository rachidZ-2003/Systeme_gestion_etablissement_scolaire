from rest_framework import viewsets
from .models import Cours, Coefficient, Demande, Inscription, Tranche
from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from .models import Cours, Coefficient, Demande, Inscription, Tranche ,AncienEleve
from .serializers import CoursSerializer, CoefficientSerializer, DemandeSerializer, InscriptionSerializer, TrancheSerializer, ClasseSerializer , EnseignantSerializer , SeanceSerializer , EleveSerializer
from utilisateurs.models import Enseignant
from administration.models import Classe ,Salle# Import Classe model
from pedagogie.models import Seance
import random
import string

def generate_matricule():
    return 'AE' + ''.join(random.choices(string.digits, k=6))


# Removed Eleve import and EleveSerializer import from scolarite/views.py

class ClasseViewSet(viewsets.ModelViewSet):
    queryset = Classe.objects.all()
    serializer_class = ClasseSerializer

class CoursViewSet(viewsets.ModelViewSet):
    queryset = Cours.objects.all()
    serializer_class = CoursSerializer

class CoefficientViewSet(viewsets.ModelViewSet):
    queryset = Coefficient.objects.all()
    serializer_class = CoefficientSerializer

class DemandeViewSet(viewsets.ModelViewSet):
    queryset = Demande.objects.all()
    serializer_class = DemandeSerializer

    @action(detail=True, methods=['post'])
    def consulter(self, request, pk=None):
        """Permet au chef de voir les détails d’une demande avant décision"""
        demande = self.get_object()
        return Response({
            "eleve": str(demande.eleve),
            "etablissement": str(demande.etablissement),
            "niveau_demande": demande.niveau,
            "statut": demande.statut
        }, status=status.HTTP_200_OK)

    @action(detail=True, methods=['post'])
    def valider(self, request, pk=None):
        """Validation de la demande + création de l’ancien élève"""
        demande = self.get_object()

        if demande.statut != "en_attente":
            return Response({"error": "Cette demande a déjà été traitée."}, status=status.HTTP_400_BAD_REQUEST)

        salle_id = request.data.get("salle_id")
        if not salle_id:
            return Response({"error": "Vous devez fournir une salle pour l’élève."}, status=status.HTTP_400_BAD_REQUEST)

        try:
            salle = Salle.objects.get(id=salle_id)
        except Salle.DoesNotExist:
            return Response({"error": "Salle introuvable."}, status=status.HTTP_404_NOT_FOUND)

        eleve = demande.eleve

        # Création de l'ancien élève
        ancien = AncienEleve.objects.create(
            eleve=eleve,                # lien OneToOne avec l'élève
            matricule=generate_matricule(),
            niveau="N/A",               # ou le niveau de la demande
            salle=salle
        )

        demande.statut = "acceptee"
        demande.save()

        return Response({
            "status": "Demande validée",
            "ancien_eleve_id": ancien.id,
            "matricule": ancien.matricule,
            "salle": salle.nom
        }, status=status.HTTP_200_OK)


    @action(detail=True, methods=['post'])
    def rejeter(self, request, pk=None):
        demande = self.get_object()
        if demande.statut != "en_attente":
            return Response({"error": "Cette demande a déjà été traitée."}, status=status.HTTP_400_BAD_REQUEST)
        demande.statut = "refusee"
        demande.save()
        return Response({"status": "Demande rejetée"}, status=status.HTTP_200_OK)


class InscriptionViewSet(viewsets.ModelViewSet):
    queryset = Inscription.objects.all()
    serializer_class = InscriptionSerializer

    @action(detail=True, methods=['post'])
    def validate(self, request, pk=None):
        inscription = self.get_object()
        inscription.statut = 'validee'
        inscription.save()
        return Response({'status': 'inscription validated'}, status=status.HTTP_200_OK)

    @action(detail=True, methods=['post'])
    def reject(self, request, pk=None):
        inscription = self.get_object()
        inscription.statut = 'refusee'
        inscription.save()
        return Response({'status': 'inscription rejected'}, status=status.HTTP_200_OK)

from django.db.models import Count
from utilisateurs.models import Eleve, AncienEleve
from administration.models import Etablissement

class TrancheViewSet(viewsets.ModelViewSet):
    queryset = Tranche.objects.all()
    serializer_class = TrancheSerializer

    @action(detail=False, methods=['post'])
    def generate_quittance(self, request):
        inscription_id = request.data.get('inscription_id')
        date_paiement = request.data.get('date_paiement')
        mode_paiement = request.data.get('mode_paiement')
        status = request.data.get('status', 'payee') # Default status

        if not all([inscription_id, date_paiement, mode_paiement]):
            return Response({'error': 'Missing required fields'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            inscription = Inscription.objects.get(id=inscription_id)
        except Inscription.DoesNotExist:
            return Response({'error': 'Inscription not found'}, status=status.HTTP_404_NOT_FOUND)

        tranche = Tranche.objects.create(
            inscription=inscription,
            date_paiement=date_paiement,
            mode_paiement=mode_paiement,
            status=status
        )
        serializer = self.get_serializer(tranche)
        return Response(serializer.data, status=status.HTTP_201_CREATED)

from rest_framework.views import APIView
from rest_framework.response import Response

class StatsView(APIView):
    def get(self, request, format=None):
        total_cours = Cours.objects.count()
        total_classes = Classe.objects.count()
        
        demandes_par_statut = Demande.objects.values('statut').annotate(count=Count('id'))
        inscriptions_par_statut = Inscription.objects.values('statut').annotate(count=Count('id'))
        
        total_eleves = Eleve.objects.count()
        total_anciens_eleves = AncienEleve.objects.count()
        total_etablissements = Etablissement.objects.count()

        data = {
            'total_cours': total_cours,
            'total_classes': total_classes,
            'demandes_par_statut': list(demandes_par_statut),
            'inscriptions_par_statut': list(inscriptions_par_statut),
            'total_eleves': total_eleves,
            'total_anciens_eleves': total_anciens_eleves,
            'total_etablissements': total_etablissements,
        }
        return Response(data)


class EnseignantViewSet(viewsets.ModelViewSet):
    queryset = Enseignant.objects.all()
    serializer_class = EnseignantSerializer


class SeanceViewSet(viewsets.ModelViewSet):
    queryset = Seance.objects.all()
    serializer_class = SeanceSerializer


class EleveCreateViewSet(viewsets.ModelViewSet):
    queryset = Eleve.objects.all()
    serializer_class = EleveSerializer


class ELeveListView(viewsets.ModelViewSet):
    queryset = Eleve.objects.all()
    serializer_class = EleveSerializer