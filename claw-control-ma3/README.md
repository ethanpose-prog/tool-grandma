# 🦞 ClawControl MA3 - Manuel d'Utilisation

**ClawControl MA3** est un pont sécurisé (Bridge) qui permet de contrôler une console grandMA3 en langage naturel via le protocole OSC. Il transforme des phrases simples en commandes syntaxiquement correctes pour la MA3.

---

## 🚀 1. Installation & Lancement

### Prérequis
- Node.js (v18+)
- Une console grandMA3 ou onPC (v2.0+) sur le même réseau.

### Démarrage Rapide
1. **Backend (Le Cerveau) :**
   ```bash
   cd claw-control-ma3/backend
   npm install
   npm run dev
   ```
2. **Frontend (L'Interface) :**
   ```bash
   cd claw-control-ma3/frontend
   npm install
   npm run dev
   ```

---

## 🧠 2. Comment ça fonctionne ? (Pipeline de Sécurité)

ClawControl n'envoie jamais directement ton texte à la console. Il suit un processus strict "Safe by Design" :

1.  **Entrée :** Tu tapes "Mets les spots à 80%".
2.  **Intent Parser :** Le système identifie l'action (`DIMMER`) et les paramètres (`spots`, `80`).
3.  **Validator :** Le système vérifie si l'action est autorisée et si les valeurs sont sécurisées (ex: un dimmer ne peut pas dépasser 100).
4.  **Translator :** L'intention est convertie en syntaxe MA3 : `Fixture "spots" At 80`.
5.  **OSC Service :** La commande est encapsulée dans un paquet UDP et envoyée à l'IP de la console sur le port configuré.

---

## 🎚️ 3. Commandes Supportées

Voici quelques exemples de ce que tu peux dire :

| Action | Exemple de commande | Résultat MA3 |
| :--- | :--- | :--- |
| **Intensité** | "Set wash to 100" | `Fixture "wash" At 100` |
| **Patch** | "Patch Cora univers 1 adresse 501" | `Assign Fixture "Cora" At Universe 1.501` |
| **Sélection** | "Select Group 5" | `Group 5` |
| **Programmer** | "Clear all" | `ClearAll` |
| **Enregistrement** | "Store Preset 1.1" | `Store Preset 1.1` |

---

## ⚙️ 4. Configuration (Settings)

Le fichier de configuration se trouve dans `backend/src/config/settings.ts`.

- **MA3_IP :** L'adresse IP de ta console/onPC.
- **OSC_PORT :** Le port configuré dans le menu OSC de la MA3 (par défaut 8000).
- **SIMULATION_MODE :** 
    - `true` (par défaut) : Affiche les commandes dans les logs sans les envoyer.
    - `false` : Envoie réellement les commandes à la console.

---

## 🛠️ 5. Dépannage (Troubleshooting)

1.  **La console ne réagit pas :**
    - Vérifie que le `SIMULATION_MODE` est sur `false`.
    - Vérifie que l'IP de la console est correcte.
    - Dans la MA3 : Menu > Settings > OSC. Vérifie que l'entrée OSC est active (Enable) et que le port correspond.
2.  **Commande non reconnue :**
    - ClawControl utilise des Regex précises. Si ta phrase est trop complexe, essaie d'être plus direct (ex: "Dimmer Spot 50" au lieu de "Est-ce que tu pourrais mettre le spot à 50%").

---

*Développé avec 🦞 par Picoclaw pour Impact Vision Sàrl.*
