# pedagogie/models.py
from django.db import models
from scolarite.models import Cours, Coefficient
from administration.models import Salle, Classe,Periode
from utilisateurs.models import Enseignant, Eleve, AncienEleve

class Trimestre(models.Model):
    nom = models.CharField(max_length=50)
    date_debut = models.DateField()
    date_fin = models.DateField()
    periode = models.ForeignKey(Periode, on_delete=models.CASCADE, related_name='trimestres')

    def __str__(self):
        return f"{self.nom} - {self.periode}"

class EmploiDuTemps(models.Model):
    annee_scolaire = models.CharField(max_length=20)
    salle = models.ForeignKey(Salle, on_delete=models.CASCADE, related_name='emplois_du_temps')

    def __str__(self):
        return f"Emploi {self.annee_scolaire} - {self.salle}"

class Enseignement(models.Model):
    enseignant = models.ForeignKey(
        Enseignant, on_delete=models.CASCADE, related_name="enseignements"
    )
    cours = models.ForeignKey(
        Cours, on_delete=models.CASCADE, related_name="enseignements"
    )
    salle = models.ForeignKey(
        Salle, on_delete=models.CASCADE, related_name="enseignements"
    )

    annee_scolaire = models.CharField(max_length=20)
    heures_par_semaine = models.PositiveIntegerField(default=0)
    statut = models.CharField(
        max_length=20,
        choices=[('actif', 'Actif'), ('annule', 'Annulé')],
        default='actif'
    )

    class Meta:
        unique_together = ('enseignant', 'cours', 'salle', 'annee_scolaire')

    def __str__(self):
        return f"{self.enseignant} enseigne {self.cours.nom} dans {self.salle.nom} ({self.annee_scolaire})"

class Seance(models.Model):
    enseignement = models.ForeignKey(
        Enseignement, on_delete=models.CASCADE, related_name="seances",default=1
    )
    date = models.DateField()
    type = models.CharField(max_length=50)   # ex: "Cours", "TD", "TP"
    status = models.CharField(max_length=50) # ex: "Planifiée", "Effectuée"
    heure_debut = models.TimeField(null=True, blank=True)
    duree = models.PositiveIntegerField(default=60)  # durée en minutes

    class Meta:
        unique_together = ('enseignement', 'date', 'heure_debut')

    def __str__(self):
        return f"Seance {self.date} - {self.enseignement}"

class Creneau(models.Model):
    """
    Un créneau correspond à un intervalle horaire dans l'emploi du temps.
    Un créneau peut planifier une seule séance, peut avoir 0 ou 1 devoir, et plusieurs absences.
    """
    jours = models.CharField(max_length=20)       # ex: "Lundi"
    heure_debut = models.TimeField()
    heure_fin = models.TimeField()

    emploi_du_temps = models.ForeignKey(EmploiDuTemps, on_delete=models.CASCADE, related_name='creneaux')
    seance = models.ForeignKey(Seance, on_delete=models.SET_NULL, null=True, blank=True, related_name='creneaux')

    # 0 ou 1 devoir par créneau
    devoir = models.ForeignKey('Devoir', on_delete=models.SET_NULL, null=True, blank=True, related_name='creneaux')

    def __str__(self):
        return f"{self.jours} {self.heure_debut}-{self.heure_fin} @ {self.emploi_du_temps}"


class Absence(models.Model):
    """
    Une absence concerne un Ancien Élève pour un créneau précis.
    """
    motif = models.CharField(max_length=200)
    justifier = models.BooleanField(default=False)

    # Absence - Créneau : (* : 1)
    creneau = models.ForeignKey(Creneau, on_delete=models.CASCADE, related_name='absences')
    ancien_eleve = models.ForeignKey(AncienEleve, on_delete=models.CASCADE, related_name='absences')

    def __str__(self):
        return f"Absence {self.ancien_eleve} @ {self.creneau}"

class Devoir(models.Model):
    """
    Un devoir est lié à un cours et peut être attribué à un créneau.
    """
    titre = models.CharField(max_length=100)
    description = models.TextField(blank=True)
    date_publication = models.DateField()  # date d'annonce
    date_devoir = models.DateField()       # date d'exécution / échéance
    type = models.CharField(max_length=50) # "Exercice", "Contrôle", "DM", ...
    note_max = models.FloatField(default=20)

    
    eleves = models.ManyToManyField(AncienEleve, through='Note', related_name='devoirs')

    def __str__(self):
        return f"{self.titre} ({self.cours})"

class Note(models.Model):
    devoir = models.ForeignKey(Devoir, on_delete=models.CASCADE, related_name='notes')
    ancien_eleve = models.ForeignKey(AncienEleve, on_delete=models.CASCADE, related_name='notes')
    valeur = models.FloatField(null=True, blank=True)
    remarque = models.TextField(blank=True)
    bareme = models.FloatField(default=20)

    class Meta:
        unique_together = (('devoir', 'ancien_eleve'),)

    def __str__(self):
        return f"{self.ancien_eleve} - {self.devoir} : {self.valeur}/{self.bareme}"

class Absence(models.Model):
    motif = models.CharField(max_length=200)
    justifier = models.BooleanField(default=False)
    seance = models.ForeignKey(Seance, on_delete=models.CASCADE, related_name='absences')
    ancien_eleve = models.ForeignKey(AncienEleve, on_delete=models.CASCADE, related_name='absences')

    def __str__(self):
        return f"Absence {self.ancien_eleve} @ {self.seance}"

class Bulletin(models.Model):
    mention = models.CharField(max_length=50, blank=True)
    date_creation = models.DateField()
    ancien_eleve = models.ForeignKey(AncienEleve, on_delete=models.CASCADE, related_name='bulletins')
    trimestre = models.ForeignKey(Trimestre, on_delete=models.CASCADE, related_name='bulletins')

    def __str__(self):
        return f"Bulletin {self.ancien_eleve} - {self.trimestre}"
