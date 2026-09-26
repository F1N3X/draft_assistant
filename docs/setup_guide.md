# Guide d'installation et de lancement

## 1. Prérequis

- Git et Flutter dans le `PATH`.
- Un SDK Dart compatible avec `^3.13.3`.
- Android Studio/SDK pour Android.
- Un projet Firebase avec Authentication, Firestore, Firebase AI et App Check configurés.
- Un appareil Android physique ou un émulateur Android.

Vérifier l'environnement :

```bash
flutter doctor -v
flutter --version
```

## 2. Cloner le projet

```bash
git clone <url-du-depot>
cd draft_assistant
flutter pub get
```

Le fichier objectbox.g.dart est généré par ObjectBox et est déjà versionné dans le dépôt. Il ne doit pas être modifié manuellement.

## 3. Configurer Firebase

1. Créer un projet dans la console Firebase.
2. Ajouter les applications correspondant aux plateformes ciblées (Android).
3. Télécharger le fichier ```google-services.json``` et le placer dans le dossier ```android/app/``` du projet
4. Activer le fournisseur Google dans **Authentication > Sign-in** method
5. Créer la base **Cloud Firestore**.
6. Configurer Firebase AI.
7. Configurer Firebase App Check en utilisant le fournisseur adapté à l'environnement de développement

## 4. Configurer Google Sign-In

L'application utilise la variable ```GOOGLE_CLIENT_ID``` pour récupérer le client ID serveur nécessaire à l'authentification Google.

Cette valeur doit être renseignée dans le fichier ```.env```, à la racine du projet :

```json
GOOGLE_CLIENT_ID=<client-id-serveur>
```

Le fichier ```.env``` est utilisé par la configuration de lancement de VS Code pour transmettre les variables à l'application.

### Configurer les empreintes SHA-1 et SHA-256

Pour récupérer les empreintes du certificat de signature Android, exécuter la commande suivante depuis le dossier ```android/``` :

```bash
./gradlew signingReport
```

Repérer les valeurs ```SHA1``` et ```SHA-256``` correspondant à la variante utilisée, puis les enregistrer dans les paramètres de l'application Android de la console Firebase.

Après l'ajout des empreintes, télécharger à nouveau le fichier ```google-services.json``` si nécessaire et le remplacer dans ```android/app/```.

Sans la variable ```GOOGLE_CLIENT_ID```, la connexion Google échoue volontairement.

## 5. Lancer l'application

### Avec Visual Studio Code

Le fichier ```.vscode/launch.json``` contient la configuration de lancement suivante :

```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Launch app with .env",
            "request": "launch",
            "type": "dart",
            "program": "lib/main.dart",
            "toolArgs": [
                "--dart-define-from-file=.env"
            ]
        }
    ]
}
```

Pour lancer l'application :

1. Ouvrir le projet dans VS Code.
2. Vérifier que le fichier ```.env``` contient ```GOOGLE_CLIENT_ID```.
3. Sélectionner la configuration Launch app with .env.
4. Choisir un appareil Android connecté ou un émulateur.
5. Démarrer le débogage.

### Depuis le terminal

Lister les appareils disponibles :

```bash
flutter devices
```

Lancer l'application sur un appareil Android :

```bash
flutter run -d <device-id> --dart-define-from-file=.env
```

L'appareil doit avoir accès à Data Dragon, Firebase Authentication, Cloud Firestore et Firebase AI.

## 6. Vérifier le projet

```bash
flutter test
```

## 7. Tester le parcours principal

1. Ouvrir `/` et attendre le catalogue.
2. Sélectionner bans et champions pour les deux équipes.
3. Demander l'analyse IA.
4. Se connecter depuis `/profile` avec Google.
5. Sauvegarder une draft.
6. Vérifier `users/{uid}` et `drafts/{draftId}` dans Firestore.
7. Ouvrir `/saves/:draftId` et vérifier le repli ObjectBox sans réseau.
