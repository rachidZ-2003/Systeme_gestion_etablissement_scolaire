# pedagogie/pdf_utils.py
from io import BytesIO
from django.shortcuts import get_object_or_404
from django.template.loader import render_to_string
from weasyprint import HTML

from .models import AncienEleve, Note, Seance, Salle
from .utils import (
    moyenne_par_eleve, moyenne_par_matiere,
    moyenne_par_eleve_trimestre, classement_salle_trimestre,
    classement_salle_annuelle
)

# ---------------------------
# Bulletin PDF
# ---------------------------
def generer_bulletin_pdf(ancien_eleve_id, annee_scolaire=None, trimestre_id=None):
    ancien_eleve = get_object_or_404(AncienEleve, id=ancien_eleve_id)

    # Moyenne générale
    moyenne_generale = moyenne_par_eleve(ancien_eleve.id, annee_scolaire)

    # Moyenne par matière
    matieres = []
    cours_ids = (
        Note.objects.filter(ancien_eleve_id=ancien_eleve.id)
        .filter(devoir__creneaux__seance__enseignement__cours__isnull=False)
        .values_list('devoir__creneaux__seance__enseignement__cours__id', flat=True)
        .distinct()
    )

    for cid in cours_ids:
        matieres.append({
            "cours_id": cid,
            "moyenne": moyenne_par_matiere(ancien_eleve.id, cid, annee_scolaire)
        })

    # Classement
    if trimestre_id:
        classement = classement_salle_trimestre(ancien_eleve.salle_id, trimestre_id)
    else:
        classement = classement_salle_annuelle(ancien_eleve.salle_id, annee_scolaire)
    
    rang = next((c['rang'] for c in classement if c['eleve'].id == ancien_eleve.id), "N/A")

    # Render HTML
    html_string = render_to_string("pedagogie/bulletin_template.html", {
        "eleve": ancien_eleve.eleve,
        "ancien_eleve": ancien_eleve,
        "moyenne_generale": moyenne_generale,
        "matieres": matieres,
        "rang": rang,
        "trimestre_id": trimestre_id,
        "annee_scolaire": annee_scolaire
    })

    # Générer PDF en mémoire
    pdf_io = BytesIO()
    HTML(string=html_string).write_pdf(pdf_io)
    pdf_data = pdf_io.getvalue()
    pdf_io.close()
    
    return pdf_data

# ---------------------------
# Emploi du temps PDF
# ---------------------------
from .models import Seance, Salle
from django.template.loader import render_to_string
from weasyprint import HTML
import tempfile

def generer_emploi_salle_pdf(salle_id):
    try:
        salle = Salle.objects.get(id=salle_id)
    except Salle.DoesNotExist:
        return None, "Salle introuvable"

    seances = Seance.objects.filter(salle=salle).order_by("jours", "heure_debut")

    # Générer HTML
    html_string = render_to_string("pedagogie/emploi_salle_template.html", {
        "salle": salle,
        "seances": seances
    })

    # Générer PDF
    with tempfile.NamedTemporaryFile(delete=True, suffix=".pdf") as output:
        HTML(string=html_string).write_pdf(output.name)
        output.seek(0)
        pdf_data = output.read()

    return pdf_data, None

