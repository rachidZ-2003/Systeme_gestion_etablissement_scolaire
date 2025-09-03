#!/bin/bash

echo "🚀 Démarrage du Sprint 1 - Plateforme de Gestion Scolaire"
echo "========================================================="

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Fonction pour afficher les messages colorés
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Vérifier si Python est installé
if ! command -v python &> /dev/null; then
    print_error "Python n'est pas installé"
    exit 1
fi

# Vérifier si Flutter est installé
if ! command -v flutter &> /dev/null; then
    print_error "Flutter n'est pas installé"
    exit 1
fi

print_info "Configuration du backend Django..."

# Aller dans le dossier school
cd school || {
    print_error "Impossible d'accéder au dossier school"
    exit 1
}

# Activer l'environnement virtuel s'il existe
if [ -d ".venv" ]; then
    print_info "Activation de l'environnement virtuel..."
    source .venv/Scripts/activate 2>/dev/null || source .venv/bin/activate
fi

# Installer les dépendances Python
print_info "Installation des dépendances Python..."
pip install -q -r requirements.txt 2>/dev/null || {
    print_info "Installation des packages Django de base..."
    pip install -q django djangorestframework django-cors-headers pillow
}

# Faire les migrations
print_info "Application des migrations de base de données..."
python manage.py makemigrations
python manage.py migrate

# Créer les données de test
print_info "Création des données de test..."
python create_test_data.py

# Créer un superutilisateur admin si nécessaire
print_info "Configuration de l'administrateur Django..."
python manage.py shell -c "
from django.contrib.auth.models import User
if not User.objects.filter(username='admin').exists():
    User.objects.create_superuser('admin', 'admin@school.bf', 'admin123')
    print('Superutilisateur créé: admin / admin123')
else:
    print('Superutilisateur existe déjà')
"

print_status "Backend Django configuré!"

# Configuration Flutter
print_info "Configuration du frontend Flutter..."
cd ../school_flutter || {
    print_error "Impossible d'accéder au dossier school_flutter"
    exit 1
}

# Récupérer les dépendances Flutter
print_info "Installation des dépendances Flutter..."
flutter pub get

print_status "Frontend Flutter configuré!"

# Instructions de démarrage
echo ""
echo "🎉 Configuration terminée avec succès!"
echo "======================================"
echo ""
echo "📋 Pour démarrer l'application:"
echo ""
echo "1️⃣  Backend Django (Terminal 1):"
echo "   cd school"
echo "   python manage.py runserver 8000"
echo ""
echo "2️⃣  Frontend Flutter (Terminal 2):"
echo "   cd school_flutter"
echo "   flutter run -d chrome --web-port 3000"
echo ""
echo "🌐 URLs d'accès:"
echo "   • Application Flutter: http://localhost:3000"
echo "   • Admin Django: http://localhost:8000/admin"
echo "   • API REST: http://localhost:8000/api/"
echo ""
echo "🔑 Comptes de test:"
echo "   • Admin Django: admin / admin123"
echo "   • Chef ID 1: jb.ouedraogo@school.bf / chef123"
echo "   • Chef ID 2: mc.kabore@school.bf / chef456"
echo "   • Chef ID 3: i.sawadogo@school.bf / chef789"
echo ""
echo "🏫 Codes établissements pour test:"
echo "   • ETB123456 (Public - Bobo-Dioulasso)"
echo "   • ETB789012 (Privé - Ouagadougou)"
echo "   • ETB345678 (Public - Banfora)"
echo ""
print_status "Prêt à démarrer le Sprint 1! 🚀"
