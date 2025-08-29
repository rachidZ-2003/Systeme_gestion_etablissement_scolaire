from rest_framework import serializers
from .models import Utilisateur, ChefEtablissement, Caissier, Censeur, Enseignant, Eleve, AncienEleve

class UtilisateurSerializer(serializers.ModelSerializer):
    class Meta:
        model = Utilisateur
        fields = '__all__'

class ChefEtablissementSerializer(serializers.ModelSerializer):
    utilisateur = UtilisateurSerializer(read_only=True)
    class Meta:
        model = ChefEtablissement
        fields = '__all__'

class CaissierSerializer(serializers.ModelSerializer):
    utilisateur = UtilisateurSerializer(read_only=True)
    class Meta:
        model = Caissier
        fields = '__all__'

class CenseurSerializer(serializers.ModelSerializer):
    utilisateur = UtilisateurSerializer(read_only=True)
    class Meta:
        model = Censeur
        fields = '__all__'

class EnseignantSerializer(serializers.ModelSerializer):
    utilisateur = UtilisateurSerializer(read_only=True)
    class Meta:
        model = Enseignant
        fields = '__all__'

class EleveSerializer(serializers.ModelSerializer):
    utilisateur = UtilisateurSerializer(read_only=True)
    class Meta:
        model = Eleve
        fields = '__all__'

class AncienEleveSerializer(serializers.ModelSerializer):
    utilisateur = UtilisateurSerializer(read_only=True)
    class Meta:
        model = AncienEleve
        fields = '__all__'
