from django.db import models

# Create your models here.
# communication/models.py
from django.db import models
from utilisateurs.models import Utilisateur

class Notification(models.Model):
    message = models.TextField()
    date_envoie = models.DateTimeField(auto_now_add=True)
    status = models.CharField(max_length=50, blank=True)
    titre = models.CharField(max_length=100, blank=True)
    utilisateur = models.ForeignKey(Utilisateur, on_delete=models.CASCADE, related_name='notifications')

    def __str__(self):
        return f"{self.titre or 'Notification'} -> {self.utilisateur}"
