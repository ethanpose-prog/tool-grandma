# Tool-Grandma 👵
Outils pour techniciens lumière et grandMA3.

## Plugins grandMA3 (Beta)
Situés dans le dossier `/plugins-ma3/`.

### ClawChat (v1.1.7) 🦞
Permet d'envoyer des messages ou des commandes depuis la console.

#### Installation
1. Copiez `ClawChat.xml` dans :
   - **USB** : `grandMA3/gma3_library/datapools/plugins`
   - **Windows** : `C:\ProgramData\MALightingTechnology\gma3_library\datapools\plugins`
2. Dans MA3 : Pool Plugins > Import > `ClawChat.xml`.
3. Cliquez sur le plugin pour l'exécuter.

#### Notes Techniques (Expert MA3)
Basé sur les standards de développement v2.1 :
- Utilisation de `ComponentLua` avec `Installed="Yes"`.
- Script encapsulé dans `<![CDATA[ ... ]]>` pour éviter les erreurs de caractères XML.
- Retourne une fonction `Main` (`return Main`).
- Compatible avec les boîtes de dialogue natives (`Confirm`, `TextInput`, `MessageBox`).

---
Inspiré par le projet `patopesto/GrandMA3-Plugins`.
