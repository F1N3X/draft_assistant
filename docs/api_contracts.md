# Requêtes API et schémas de données

## Data Dragon : catalogue des champions

```http
GET https://ddragon.leagueoflegends.com/cdn/13.1.1/data/en_US/champion.json
```

Réponse minimale attendue :

```json
{
  "type": "champion",
  "format": "standAloneComplex",
  "version": "13.1.1",
  "data": {
    "Jinx": {
      "id": "Jinx",
      "key": "222",
      "name": "Jinx",
      "image": { "full": "Jinx.png" }
    }
  }
}
```

Le client lit `data`, puis construit l'image suivante :

```text
https://ddragon.leagueoflegends.com/cdn/13.1.1/img/champion/{image.full}
```

## Firebase Authentication

Google Sign-In est initialisé avec `GOOGLE_CLIENT_ID`. Le client récupère un `idToken`, construit un `OAuthCredential`, puis authentifie Firebase.

Après connexion, l'application crée ou fusionne `users/{uid}` :

```json
{
  "draftIds": ["draft-id-1", "draft-id-2"]
}
```

## Firestore : document `drafts/{draftId}`

```json
{
  "userId": "firebase-user-id",
  "createdAt": "Firestore Timestamp",
  "updatedAt": "Firestore Timestamp",
  "myTeam": "blue",
  "selections": {
    "blueChampion1": {
      "id": "Jinx",
      "key": "222",
      "name": "Jinx",
      "imageUrl": "https://ddragon.leagueoflegends.com/.../Jinx.png"
    }
  },
  "aiAdvice": {
    "rawResponse": "{...}",
    "summary": "Composition orientée team fight.",
    "strengths": ["Bon scaling"],
    "weaknesses": ["Faible début de partie"],
    "winCondition": "Jouer autour des objectifs à 20 minutes.",
    "winRate": 52.5,
    "championAdvice": [
      { "champion": "Ashe", "synergy": 70.6 }
    ]
  }
}
```

Le cache ObjectBox représente les dates en millisecondes Unix et les maps `selections`/`aiAdvice` en JSON.

## Firebase AI : réponse

Le prompt contient équipe, champions, bans et complétude. Le modèle doit renvoyer uniquement :

```json
{
  "summary": "Résumé court",
  "strengths": ["Force 1", "Force 2"],
  "weaknesses": ["Faiblesse 1"],
  "win_condition": "Condition de victoire",
  "win_rate": 56.2,
  "champion_advice": [
    { "champion": "Jinx", "synergy": 85.0 },
    { "champion": "Ashe", "synergy": 70.6 }
  ]
}
```

Règles : `win_rate` et `synergy` sont entre 0 et 100 avec au plus un chiffre décimal ; `strengths` et `weaknesses` ont au plus deux éléments ; une draft complète ne reçoit aucun conseil de champion, sinon exactement deux sont demandés. Le parseur accepte une réponse entourée d'une balise Markdown JSON.

## Routes de navigation

```http
GET /
GET /saves
GET /saves/:draftId
GET /profile
GET /champions-list?slot=blueChampion1
```

Ces routes sont locales à GoRouter, pas des endpoints backend. `slot` doit être un identifiant `DraftSlot` ; une valeur inconnue retombe sur `blueBan1`.

## Erreurs et repli

| Service | Erreur | Comportement |
| --- | --- | --- |
| Data Dragon | Réseau, JSON sans `data` | Exception de chargement |
| Firebase AI | Réponse vide ou invalide | `aiError` est renseigné |
| Firestore lecture | Index/document absent ou réseau | Lecture ObjectBox |
| Firestore écriture | Permission ou réseau | Copie ObjectBox écrite |
| Google Sign-In | Client ID/token invalide | Message d'erreur de connexion |