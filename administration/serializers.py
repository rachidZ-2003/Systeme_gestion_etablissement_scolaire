from rest_framework import serializers
from .models import Etablissement, Batiment, Classe, Salle, SouscriptionEtablissement, Periode
from utilisateurs.serializers import ChefEtablissementSerializer
from utilisateurs.models import ChefEtablissement


class EtablissementSerializer(serializers.ModelSerializer):
    nb_batiments = serializers.SerializerMethodField()
    nb_salles = serializers.SerializerMethodField()
    
    class Meta:
        model = Etablissement
        fields = [
            'id', 'code_etablissement', 'adresse', 'telephone', 'type', 
            'logo', 'ville', 'nb_batiments', 'nb_salles'
        ]
    
    def get_nb_batiments(self, obj):
        """Retourne le nombre de bâtiments"""
        return obj.batiments.count()
    
    def get_nb_salles(self, obj):
        """Retourne le nombre total de salles"""
        return Salle.objects.filter(batiment__etablissement=obj).count()


class BatimentSerializer(serializers.ModelSerializer):
    etablissement_nom = serializers.CharField(source='etablissement.code_etablissement', read_only=True)
    nb_salles = serializers.SerializerMethodField()
    salles = serializers.SerializerMethodField()
    
    class Meta:
        model = Batiment
        fields = [
            'id', 'nom', 'type', 'etablissement', 'etablissement_nom', 
            'nb_salles', 'salles'
        ]
    
    def get_nb_salles(self, obj):
        """Retourne le nombre de salles dans ce bâtiment"""
        return obj.salles.count()
    
    def get_salles(self, obj):
        """Retourne la liste des salles (optionnel, selon le contexte)"""
        # Retourner seulement les IDs pour éviter la récursion
        return list(obj.salles.values('id', 'nom', 'capacite', 'type_salle'))


class ClasseSerializer(serializers.ModelSerializer):
    nb_salles = serializers.SerializerMethodField()
    
    class Meta:
        model = Classe
        fields = ['id', 'niveau', 'nb_salles']
    
    def get_nb_salles(self, obj):
        """Retourne le nombre de salles affectées à cette classe"""
        return obj.salles.count()


class SalleSerializer(serializers.ModelSerializer):
    batiment_nom = serializers.CharField(source='batiment.nom', read_only=True)
    classe_niveau = serializers.CharField(source='classe.niveau', read_only=True)
    etablissement_nom = serializers.CharField(source='batiment.etablissement.code_etablissement', read_only=True)
    
    class Meta:
        model = Salle
        fields = [
            'id', 'nom', 'capacite', 'type_salle', 'batiment', 'classe',
            'batiment_nom', 'classe_niveau', 'etablissement_nom'
        ]
    
    def validate_capacite(self, value):
        """Valide que la capacité est positive"""
        if value < 0:
            raise serializers.ValidationError("La capacité ne peut pas être négative")
        return value


class PeriodeSerializer(serializers.ModelSerializer):
    etablissement_nom = serializers.CharField(source='etablissement.code_etablissement', read_only=True)
    
    class Meta:
        model = Periode
        fields = ['id', 'annee_scolaire', 'etablissement', 'etablissement_nom']
    
    def validate_annee_scolaire(self, value):
        """Valide le format de l'année scolaire"""
        if not value or len(value) < 4:
            raise serializers.ValidationError("Format d'année scolaire invalide")
        return value


class SouscriptionEtablissementSerializer(serializers.ModelSerializer):
    chef = ChefEtablissementSerializer(read_only=True)
    etablissement = EtablissementSerializer(read_only=True)
    chef_nom_complet = serializers.SerializerMethodField()
    
    class Meta:
        model = SouscriptionEtablissement
        fields = [
            'id', 'date_souscription', 'chef', 'etablissement', 
            'chef_nom_complet'
        ]
    
    def get_chef_nom_complet(self, obj):
        """Retourne le nom complet du chef d'établissement"""
        return f"{obj.chef.prenom} {obj.chef.nom}"


class SouscriptionEtablissementCreateSerializer(serializers.ModelSerializer):
    """Serializer pour la création de souscription"""
    chef_id = serializers.IntegerField(write_only=True)
    etablissement_id = serializers.IntegerField(write_only=True)
    
    class Meta:
        model = SouscriptionEtablissement
        fields = ['date_souscription', 'chef_id', 'etablissement_id']
    
    def validate_chef_id(self, value):
        """Valide que le chef existe"""
        try:
            ChefEtablissement.objects.get(id=value)
        except ChefEtablissement.DoesNotExist:
            raise serializers.ValidationError("Chef d'établissement non trouvé")
        return value
    
    def validate_etablissement_id(self, value):
        """Valide que l'établissement existe"""
        try:
            Etablissement.objects.get(id=value)
        except Etablissement.DoesNotExist:
            raise serializers.ValidationError("Établissement non trouvé")
        return value
    
    def create(self, validated_data):
        chef_id = validated_data.pop('chef_id')
        etablissement_id = validated_data.pop('etablissement_id')
        
        chef = ChefEtablissement.objects.get(id=chef_id)
        etablissement = Etablissement.objects.get(id=etablissement_id)
        
        return SouscriptionEtablissement.objects.create(
            chef=chef,
            etablissement=etablissement,
            **validated_data
        )


# Serializers pour les statistiques et rapports
class StatistiquesEtablissementSerializer(serializers.Serializer):
    """Serializer pour les statistiques d'établissement"""
    etablissement = EtablissementSerializer(read_only=True)
    nombre_batiments = serializers.IntegerField(read_only=True)
    nombre_salles = serializers.IntegerField(read_only=True)
    nombre_classes = serializers.IntegerField(read_only=True)
    nombre_periodes = serializers.IntegerField(read_only=True)


class PatrimoineCompletSerializer(serializers.Serializer):
    """Serializer pour le patrimoine complet d'un établissement"""
    etablissement = EtablissementSerializer(read_only=True)
    batiments = BatimentSerializer(many=True, read_only=True)
    total_salles = serializers.IntegerField(read_only=True)
    total_capacite = serializers.IntegerField(read_only=True)