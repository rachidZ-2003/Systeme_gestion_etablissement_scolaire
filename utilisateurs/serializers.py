from rest_framework import serializers
from .models import (
    Eleve, Utilisateur, ChefEtablissement, Caissier, Censeur,
    Enseignant, AncienEleve, Parent

)
from django.contrib.auth.hashers import make_password
from rest_framework_simplejwt.tokens import RefreshToken
from django.utils import timezone


# ----------------- Utilisateur -----------------
class UtilisateurSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True, required=True)  # champ API

    class Meta:
        model = Utilisateur
        fields = ['id', 'email', 'nom', 'prenom', 'role', 'password']

    def validate_role(self, value):
        request = self.context.get('request')
        user = request.user if request else None
        if value == 'chef' and (not user or not user.is_superuser):
            raise serializers.ValidationError("Seul l'administrateur peut créer un chef d'établissement.")
        if value in ['censeur', 'caissier', 'enseignant'] and (not user or user.role != 'chef'):
            raise serializers.ValidationError(
                "Seul un chef d'établissement peut créer un censeur, caissier ou enseignant."
            )
        return value

    def create(self, validated_data):
        password = validated_data.pop('password')
        role = validated_data.get('role')
        if role == 'chef':
            user = ChefEtablissement(**validated_data)
        elif role == 'censeur':
            user = Censeur(**validated_data)
        elif role == 'caissier':
            user = Caissier(**validated_data)
        elif role == 'enseignant':
            user = Enseignant(**validated_data)
        else:
            user = Utilisateur(**validated_data)
        user.set_password(password)  # hachage
        user.save()
        return user


# ----------------- Eleve -----------------
class EleveSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True, required=True)
    photo = serializers.CharField(allow_null=True, required=False)
    date_inscription = serializers.DateField(default=timezone.now().date)

    class Meta:
        model = Eleve
        fields = [
            "id", "nom", "prenom", "email", "telephone",
            "password", "date_naissance", "genre", "date_inscription", "photo"
        ]

    def create(self, validated_data):
        password = validated_data.pop('password')
        validated_data["role"] = "eleve"
        
        user = Eleve(**validated_data)
        user.set_password(password)
        user.save()
        return user


# ----------------- Autres serializers -----------------
class AncienEleveSerializer(serializers.ModelSerializer):
    class Meta:
        model = AncienEleve
        fields = '__all__'


class ChefEtablissementSerializer(serializers.ModelSerializer):
    date_embauche = serializers.DateField(default=timezone.now().date)
    class Meta:
        model = ChefEtablissement
        fields = '__all__'


class CaissierSerializer(serializers.ModelSerializer):
    date_embauche = serializers.DateField(default=timezone.now().date)
    class Meta:
        model = Caissier
        fields = '__all__'


class CenseurSerializer(serializers.ModelSerializer):
    date_embauche = serializers.DateField(default=timezone.now().date)
    class Meta:
        model = Censeur
        fields = '__all__'


class EnseignantSerializer(serializers.ModelSerializer):
    date_embauche = serializers.DateField(default=timezone.now().date)
    class Meta:
        model = Enseignant
        fields = '__all__'


class ParentSerializer(serializers.ModelSerializer):
    date_embauche = serializers.DateField(default=timezone.now().date)
    class Meta:
        model = Parent
        fields = '__all__'


class UtilisateurChoiceSerializer(serializers.ModelSerializer):
    class Meta:
        model = Utilisateur
        fields = ['id', 'nom', 'prenom', 'role']


# ----------------- JWT -----------------
class MyTokenObtainPairSerializer(serializers.Serializer):
    email = serializers.EmailField()
    password = serializers.CharField(write_only=True)  # ajouter le mot de passe pour login

    def validate(self, attrs):
        email = attrs.get('email')
        password = attrs.get('password')

        try:
            user = Utilisateur.objects.get(email=email)
        except Utilisateur.DoesNotExist:
            raise serializers.ValidationError("Utilisateur non trouvé")

        if not user.check_password(password):
            raise serializers.ValidationError("Mot de passe incorrect")

        refresh = RefreshToken.for_user(user)
        refresh['role'] = user.role
        refresh['nom'] = user.nom
        refresh['prenom'] = user.prenom

        return {
            'refresh': str(refresh),
            'access': str(refresh.access_token),
            'role': user.role,
            'nom': user.nom,
            'prenom': user.prenom
        }
