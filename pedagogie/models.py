# pedagogie/models.py
from django.db import models
from scolarite.models import Cours, Classe, Eleve, AncienEleve, Coefficient
from administration.models import Salle, Classe
from utilisateurs.models import Enseignant

class Periode(models.Model):
    annee_scolaire = models.CharField(max_length=20)
    etablissement = models.ForeignKey('administration.Etablissement', on_delete=models.CASCADE, related_name='periodes')

    def __str__(self):
        return f"{self.annee_scolaire} - {self.etablissement}"

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

class Seance(models.Model):
    date = models.DateField()
    type = models.CharField(max_length=50)
    status = models.CharField(max_length=50)
    enseignant = models.ForeignKey(Enseignant, on_delete=models.PROTECT, related_name='seances')
    cours = models.ForeignKey(Cours, on_delete=models.PROTECT, related_name='seances')
    salle = models.ForeignKey(Salle, on_delete=models.PROTECT, related_name='seances')
    devoir = models.ForeignKey('Devoir', on_delete=models.SET_NULL, null=True, blank=True, related_name='seances')

    def __str__(self):
        return f"Seance {self.date} - {self.cours} - {self.salle}"

class Creneau(models.Model):
    jours = models.CharField(max_length=20)
    heure_debut = models.TimeField()
    heure_fin = models.TimeField()
    emploi_du_temps = models.ForeignKey(EmploiDuTemps, on_delete=models.CASCADE, related_name='creneaux')
    seance = models.ForeignKey(Seance, on_delete=models.SET_NULL, null=True, blank=True, related_name='creneaux')

    def __str__(self):
        return f"{self.jours} {self.heure_debut}-{self.heure_fin} @ {self.emploi_du_temps}"

class Devoir(models.Model):
    titre = models.CharField(max_length=100)
    description = models.TextField(blank=True)
    date_publication = models.DateField()
    date_devoir = models.DateField()
    type = models.CharField(max_length=50)
    note_max = models.FloatField(default=20)
    cours = models.ForeignKey(Cours, on_delete=models.CASCADE, related_name='devoirs')
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
