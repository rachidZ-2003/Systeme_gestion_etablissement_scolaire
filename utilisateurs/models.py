from django.db import models

# Create your models here.
# utilisateurs/models.py
from django.db import models

# ================= Utilisateur de base =================
class Utilisateur(models.Model):
    nom = models.CharField(max_length=100)
    prenom = models.CharField(max_length=100)
    email = models.EmailField(unique=True)
    telephone = models.CharField(max_length=20, blank=True)
    mot_passe = models.CharField(max_length=128)
    role = models.CharField(max_length=50)  # ex: "chef", "enseignant", ...
    date_creation = models.DateTimeField(auto_now_add=True)
    statut = models.BooleanField(default=True)
    date_naissance = models.DateField(null=True, blank=True)
    genre = models.CharField(max_length=10, blank=True)  # "M", "F", etc.

    def __str__(self):
        return f"{self.prenom} {self.nom}"


# ================= Rôles hérités =================
class ChefEtablissement(Utilisateur):
    date_embauche = models.DateField()


class Caissier(Utilisateur):
    date_embauche = models.DateField()


class Censeur(Utilisateur):
    date_embauche = models.DateField()


class Enseignant(Utilisateur):
    matricule = models.CharField(max_length=50, unique=True)
    grade = models.CharField(max_length=50, blank=True)
    specialite = models.CharField(max_length=100, blank=True)
    date_embauche = models.DateField()


class Eleve(Utilisateur):
    date_inscription = models.DateField()
    photo = models.ImageField(upload_to="eleves_photos/", null=True, blank=True)
    # relation ManyToMany avec Etablissement via Demande (scolarite.models)
    # etablissements = models.ManyToManyField(Etablissement, through="Demande")


class AncienEleve(Eleve):
    matricule = models.CharField(max_length=50, blank=True)
    niveau = models.CharField(max_length=50, blank=True)
    # salle_frequentee = models.ForeignKey('administration.Salle', on_delete=models.SET_NULL, null=True, blank=True, related_name='anciens_eleves')


class Parent(Utilisateur):
    lien_parent = models.CharField(max_length=50, blank=True)
    # anciens_eleves = models.ManyToManyField(AncienEleve, through='parents.SouscriptionParent', related_name='parents')
