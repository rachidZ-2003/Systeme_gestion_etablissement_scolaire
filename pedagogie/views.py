# pedagogie/views.py
from django.http import HttpResponse
from rest_framework import viewsets
from rest_framework.decorators import api_view, action
from rest_framework.response import Response
from django.shortcuts import get_object_or_404

from .models import Note, Devoir, Absence, Trimestre, Seance, Pourcentage, Salle
from .serializers import (
    NoteSerializer, DevoirSerializer, AbsenceSerializer, TrimestreSerializer,
    SeanceSerializer, PourcentageSerializer
)
from .utils import (
    moyenne_par_eleve, moyenne_par_matiere,
    moyenne_par_eleve_trimestre, moyenne_par_eleve_annuelle,
    classement_salle_trimestre, classement_salle_annuelle,
    moyennes_tous_eleves, classement_global_trimestre,
    classement_global_annuelle
)
from .pdf_utils import generer_bulletin_pdf, generer_emploi_salle_pdf

# ---------------------------
# ViewSets
# ---------------------------
class NoteViewSet(viewsets.ModelViewSet):
    queryset = Note.objects.all()
    serializer_class = NoteSerializer

class DevoirViewSet(viewsets.ModelViewSet):
    queryset = Devoir.objects.all()
    serializer_class = DevoirSerializer

class AbsenceViewSet(viewsets.ModelViewSet):
    queryset = Absence.objects.all()
    serializer_class = AbsenceSerializer

class TrimestreViewSet(viewsets.ModelViewSet):
    queryset = Trimestre.objects.all()
    serializer_class = TrimestreSerializer

class PourcentageViewSet(viewsets.ModelViewSet):
    queryset = Pourcentage.objects.all()
    serializer_class = PourcentageSerializer

class SeanceViewSet(viewsets.ModelViewSet):
    queryset = Seance.objects.all()
    serializer_class = SeanceSerializer

# ---------------------------
# Emplois de temps
# ---------------------------
@api_view(['GET'])
def emploi_salle_pdf(request, salle_id):
    pdf, error = generer_emploi_salle_pdf(salle_id)
    if error:
        return Response({"error": error}, status=404)

    response = HttpResponse(pdf, content_type='application/pdf')
    response['Content-Disposition'] = f'attachment; filename="emploi_salle_{salle_id}.pdf"'
    return response

# PDF de l'emploi du temps
@api_view(['GET'])
def emploi_salle_pdf(request, salle_id):
    pdf, error = generer_emploi_salle_pdf(salle_id)
    if error:
        return Response({"error": error}, status=404)

    response = HttpResponse(pdf, content_type='application/pdf')
    response['Content-Disposition'] = f'attachment; filename="emploi_salle_{salle_id}.pdf"'
    return response

# ---------------------------
# Bulletins
# ---------------------------
@api_view(['GET'])
def bulletin_pdf(request, ancien_eleve_id, annee_scolaire=None, trimestre_id=None):
    try:
        pdf = generer_bulletin_pdf(ancien_eleve_id, annee_scolaire, trimestre_id)
    except Exception as e:
        return Response({"error": str(e)}, status=404)

    response = HttpResponse(pdf, content_type='application/pdf')
    response['Content-Disposition'] = f'attachment; filename="bulletin_{ancien_eleve_id}.pdf"'
    return response

# ---------------------------
# Nouveaux Endpoints Globaux
# ---------------------------
@api_view(['GET'])
def get_moyennes_tous_eleves(request, annee_scolaire=None):
    data = moyennes_tous_eleves(annee_scolaire)
    return Response([
        {
            "eleve_id": res["eleve"].id,
            "nom": res["eleve"].nom,
            "prenom": res["eleve"].prenom,
            "moyenne": res["moyenne"]
        }
        for res in data
    ])

@api_view(['GET'])
def get_classement_global_trimestre(request, trimestre_id):
    data = classement_global_trimestre(trimestre_id)
    return Response([
        {
            "eleve_id": res["eleve"].id,
            "nom": res["eleve"].nom,
            "prenom": res["eleve"].prenom,
            "moyenne": res["moyenne"],
            "rang": res["rang"]
        }
        for res in data
    ])

@api_view(['GET'])
def get_classement_global_annuelle(request, annee_scolaire):
    data = classement_global_annuelle(annee_scolaire)
    return Response([
        {
            "eleve_id": res["eleve"].id,
            "nom": res["eleve"].nom,
            "prenom": res["eleve"].prenom,
            "moyenne": res["moyenne"],
            "rang": res["rang"]
        }
        for res in data
    ])
