from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import (
    EtablissementViewSet, BatimentViewSet, ClasseViewSet, SalleViewSet, 
    SouscriptionEtablissementViewSet, PeriodeViewSet, GestionUtilisateursViewSet
)

# Router pour les ViewSets standards
router = DefaultRouter()
router.register(r'etablissements', EtablissementViewSet)
router.register(r'batiments', BatimentViewSet)
router.register(r'classes', ClasseViewSet)
router.register(r'salles', SalleViewSet)
router.register(r'periodes', PeriodeViewSet)
router.register(r'souscriptions', SouscriptionEtablissementViewSet)
router.register(r'gestion-utilisateurs', GestionUtilisateursViewSet, basename='gestion-utilisateurs')

urlpatterns = [
    # URLs du router principal
    path('', include(router.urls)),
]

# Les actions personnalisées sont automatiquement disponibles via le router :
# GET /api/administration/etablissements/{id}/statistiques/
# GET /api/administration/etablissements/{id}/patrimoine_complet/
# GET /api/administration/batiments/{id}/salles/
# GET /api/administration/salles/par_classe/?classe={id}
# POST /api/administration/periodes/creer_annee_complete/
# POST /api/administration/souscriptions/souscrire_avec_otp/
# POST /api/administration/gestion-utilisateurs/creer_caissier/
# POST /api/administration/gestion-utilisateurs/creer_censeur/
# POST /api/administration/gestion-utilisateurs/creer_enseignant/
# GET /api/administration/gestion-utilisateurs/liste_tous_comptes/