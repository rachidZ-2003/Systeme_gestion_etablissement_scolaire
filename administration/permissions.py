# administration/permissions.py
"""
Permissions personnalisées pour l'application administration
"""
from rest_framework import permissions
from utilisateurs.models import ChefEtablissement, Caissier, Censeur, Enseignant


class IsChefEtablissement(permissions.BasePermission):
    """
    Permission pour vérifier si l'utilisateur est un chef d'établissement
    """
    def has_permission(self, request, view):
        if not request.user.is_authenticated:
            return False
        
        try:
            ChefEtablissement.objects.get(email=request.user.email)
            return True
        except ChefEtablissement.DoesNotExist:
            return False


class IsCaissier(permissions.BasePermission):
    """
    Permission pour vérifier si l'utilisateur est un caissier
    """
    def has_permission(self, request, view):
        if not request.user.is_authenticated:
            return False
        
        try:
            Caissier.objects.get(email=request.user.email)
            return True
        except Caissier.DoesNotExist:
            return False


class IsCenseur(permissions.BasePermission):
    """
    Permission pour vérifier si l'utilisateur est un censeur
    """
    def has_permission(self, request, view):
        if not request.user.is_authenticated:
            return False
        
        try:
            Censeur.objects.get(email=request.user.email)
            return True
        except Censeur.DoesNotExist:
            return False


class IsEnseignant(permissions.BasePermission):
    """
    Permission pour vérifier si l'utilisateur est un enseignant
    """
    def has_permission(self, request, view):
        if not request.user.is_authenticated:
            return False
        
        try:
            Enseignant.objects.get(email=request.user.email)
            return True
        except Enseignant.DoesNotExist:
            return False


class IsPersonnelEtablissement(permissions.BasePermission):
    """
    Permission pour vérifier si l'utilisateur fait partie du personnel d'un établissement
    (Chef, Caissier, Censeur, Enseignant)
    """
    def has_permission(self, request, view):
        if not request.user.is_authenticated:
            return False
        
        # Vérifier dans tous les rôles du personnel
        user_email = request.user.email
        
        roles_personnel = [
            ChefEtablissement,
            Caissier,
            Censeur,
            Enseignant
        ]
        
        for role_model in roles_personnel:
            try:
                role_model.objects.get(email=user_email)
                return True
            except role_model.DoesNotExist:
                continue
        
        return False


class IsAdminOrChef(permissions.BasePermission):
    """
    Permission pour les administrateurs système ou chefs d'établissement
    """
    def has_permission(self, request, view):
        if not request.user.is_authenticated:
            return False
        
        # Vérifier si c'est un superuser
        if request.user.is_superuser:
            return True
        
        # Vérifier si c'est un chef d'établissement
        try:
            ChefEtablissement.objects.get(email=request.user.email)
            return True
        except ChefEtablissement.DoesNotExist:
            return False


class CanManagePatrimoine(permissions.BasePermission):
    """
    Permission pour gérer le patrimoine (bâtiments, salles, etc.)
    """
    def has_permission(self, request, view):
        if not request.user.is_authenticated:
            return False
        
        # Seuls les chefs d'établissement peuvent gérer le patrimoine
        try:
            ChefEtablissement.objects.get(email=request.user.email)
            return True
        except ChefEtablissement.DoesNotExist:
            return False


class CanCreateUsers(permissions.BasePermission):
    """
    Permission pour créer des comptes utilisateurs
    """
    def has_permission(self, request, view):
        if not request.user.is_authenticated:
            return False
        
        # Seuls les administrateurs et chefs d'établissement peuvent créer des comptes
        if request.user.is_superuser:
            return True
        
        try:
            ChefEtablissement.objects.get(email=request.user.email)
            return True
        except ChefEtablissement.DoesNotExist:
            return False


class CanManageSouscription(permissions.BasePermission):
    """
    Permission pour gérer les souscriptions d'établissement
    """
    def has_permission(self, request, view):
        if not request.user.is_authenticated:
            return False
        
        # Administrateurs et chefs d'établissement
        if request.user.is_superuser:
            return True
        
        try:
            ChefEtablissement.objects.get(email=request.user.email)
            return True
        except ChefEtablissement.DoesNotExist:
            return False


class ReadOnlyOrIsOwner(permissions.BasePermission):
    """
    Permission lecture seule ou propriétaire de l'objet
    """
    def has_permission(self, request, view):
        return request.user.is_authenticated
    
    def has_object_permission(self, request, view, obj):
        # Permissions de lecture pour tous les utilisateurs authentifiés
        if request.method in permissions.SAFE_METHODS:
            return True
        
        # Permissions d'écriture seulement pour le propriétaire ou admin
        if request.user.is_superuser:
            return True
        
        # Vérifier si l'utilisateur est le propriétaire selon le contexte
        if hasattr(obj, 'chef') and hasattr(obj.chef, 'email'):
            return obj.chef.email == request.user.email
        
        return False


# Mixins de permissions pour les vues
class ChefEtablissementPermissionMixin:
    """
    Mixin pour appliquer les permissions de chef d'établissement
    """
    permission_classes = [IsChefEtablissement]


class PersonnelPermissionMixin:
    """
    Mixin pour appliquer les permissions du personnel
    """
    permission_classes = [IsPersonnelEtablissement]


class AdminOrChefPermissionMixin:
    """
    Mixin pour appliquer les permissions admin ou chef
    """
    permission_classes = [IsAdminOrChef]
