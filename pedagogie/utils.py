# pedagogie/utils.py
from django.db.models import F, Sum, FloatField, Case, When, Value
from .models import Note, Trimestre, AncienEleve,Salle,Seance
from django.template.loader import render_to_string
from weasyprint import HTML
import tempfile

# ==========================
# Moyennes
# ==========================

def moyenne_par_eleve(ancien_eleve_id, annee_scolaire=None):
    """
    Moyenne générale toutes matières pour un élève
    """
    notes = Note.objects.filter(ancien_eleve_id=ancien_eleve_id)
    if annee_scolaire:
        notes = notes.filter(devoir__creneaux__emploi_du_temps__annee_scolaire=annee_scolaire)

    result = notes.aggregate(
        total=Sum(
            Case(
                When(bareme__gt=0, then=F('valeur') / F('bareme') * F('devoir__note_max')),
                default=Value(0),
                output_field=FloatField()
            )
        ),
        coef=Sum(F('devoir__note_max'), output_field=FloatField())
    )

    return round(result['total'] / result['coef'], 2) if result['coef'] else 0


def moyenne_par_matiere(ancien_eleve_id, cours_id, annee_scolaire=None):
    """
    Moyenne d'un élève pour une matière spécifique
    """
    notes = Note.objects.filter(
        ancien_eleve_id=ancien_eleve_id,
        devoir__creneaux__seance__enseignement__cours__id=cours_id
    )
    if annee_scolaire:
        notes = notes.filter(devoir__creneaux__emploi_du_temps__annee_scolaire=annee_scolaire)

    result = notes.aggregate(
        total=Sum(
            Case(
                When(bareme__gt=0, devoir__isnull=False, then=F('valeur') / F('bareme') * F('devoir__note_max')),
                default=Value(0),
                output_field=FloatField()
            )
        ),
        coef=Sum(
            Case(
                When(devoir__isnull=False, then=F('devoir__note_max')),
                default=Value(0),
                output_field=FloatField()
            )
        )
    )

    return round(result['total'] / result['coef'], 2) if result['coef'] else 0


def moyenne_par_eleve_trimestre(ancien_eleve_id, trimestre_id):
    """
    Moyenne d'un élève pour un trimestre
    """
    trimestre = Trimestre.objects.get(id=trimestre_id)
    notes = Note.objects.filter(
        ancien_eleve_id=ancien_eleve_id,
        devoir__creneaux__seance__date__range=(trimestre.date_debut, trimestre.date_fin)
    )
    result = notes.aggregate(
        total=Sum(F('valeur') / F('bareme') * F('devoir__note_max'), output_field=FloatField()),
        coef=Sum(F('devoir__note_max'), output_field=FloatField())
    )
    return round(result['total'] / result['coef'], 2) if result['coef'] else 0


def moyenne_par_eleve_annuelle(ancien_eleve_id, annee_scolaire):
    """
    Moyenne annuelle d'un élève
    """
    notes = Note.objects.filter(
        ancien_eleve_id=ancien_eleve_id,
        devoir__creneaux__emploi_du_temps__annee_scolaire=annee_scolaire
    )
    result = notes.aggregate(
        total=Sum(F('valeur') / F('bareme') * F('devoir__note_max'), output_field=FloatField()),
        coef=Sum(F('devoir__note_max'), output_field=FloatField())
    )
    return round(result['total'] / result['coef'], 2) if result['coef'] else 0


# ==========================
# Classement
# ==========================

def _calcul_classement(anciens_eleves, fonction_moyenne):
    """
    Calcul du classement à partir d'une liste d'anciens élèves et d'une fonction de calcul de moyenne
    """
    resultats = [{"eleve": e, "moyenne": fonction_moyenne(e.id)} for e in anciens_eleves]
    resultats.sort(key=lambda x: x["moyenne"], reverse=True)

    rang, prev = 0, None
    classement = []
    for i, r in enumerate(resultats, start=1):
        if r["moyenne"] != prev:
            rang = i
        r["rang"] = rang
        prev = r["moyenne"]
        classement.append(r)
    return classement


def classement_salle_trimestre(salle_id, trimestre_id):
    """
    Classement des élèves d'une salle pour un trimestre
    """
    eleves = AncienEleve.objects.filter(salle_id=salle_id)
    return _calcul_classement(eleves, lambda ae_id: moyenne_par_eleve_trimestre(ae_id, trimestre_id))


def classement_salle_annuelle(salle_id, annee_scolaire):
    """
    Classement des élèves d'une salle pour l'année scolaire
    """
    eleves = AncienEleve.objects.filter(salle_id=salle_id)
    return _calcul_classement(eleves, lambda ae_id: moyenne_par_eleve_annuelle(ae_id, annee_scolaire))


def moyennes_tous_eleves(annee_scolaire=None):
    """
    Moyenne de tous les anciens élèves
    """
    eleves = AncienEleve.objects.all()
    return [{"eleve": e, "moyenne": moyenne_par_eleve(e.id, annee_scolaire)} for e in eleves]


def classement_global_trimestre(trimestre_id):
    """
    Classement global tous élèves pour un trimestre
    """
    return _calcul_classement(AncienEleve.objects.all(), lambda ae_id: moyenne_par_eleve_trimestre(ae_id, trimestre_id))


def classement_global_annuelle(annee_scolaire):
    """
    Classement global tous élèves pour l'année scolaire
    """
    return _calcul_classement(AncienEleve.objects.all(), lambda ae_id: moyenne_par_eleve_annuelle(ae_id, annee_scolaire))


