import os
import time
import json
import requests

# CONFIGURATION
# Path to the grandMA3 plugins folder (adjust to your system)
MA3_PATH = os.path.expanduser("~/MALightingTechnology/gma3_library/plugins/ClawChat")
REQUEST_FILE = os.path.join(MA3_PATH, "request.json")
RESPONSE_FILE = os.path.join(MA3_PATH, "response.json")

# Picoclaw API (Replace with your actual endpoint or use a local LLM bridge)
# For this example, we'll use a placeholder that Ethan can configure.
API_URL = "http://localhost:5000/ask" # Example local endpoint

def process_request(text):
    print(f"🦞 Picoclaw Bridge: Reçu -> {text}")
    
    # Simulation de réponse (ou appel API réel)
    # Ici, on pourrait appeler l'API de Picoclaw ou OpenAI
    try:
        # Exemple d'appel API simplifié
        # response = requests.post(API_URL, json={"prompt": text})
        # reply = response.json().get("reply", "Erreur API")
        
        # Pour le test, on fait une réponse statique intelligente
        if "blackout" in text.lower():
            reply = "Compris. J'envoie la commande de Blackout. [Cmd: Go+ Exec 101]"
        elif "merci" in text.lower():
            reply = "À ton service, Ethan ! 🦞"
        else:
            reply = f"J'ai bien reçu : '{text}'. Je traite ta demande technique..."
            
    except Exception as e:
        reply = f"Erreur Bridge: {str(e)}"
    
    return reply

def main():
    if not os.path.exists(MA3_PATH):
        os.makedirs(MA3_PATH)
        print(f"Création du dossier: {MA3_PATH}")

    print("🚀 ClawChat Bridge en attente de messages de grandMA3...")
    
    while True:
        if os.path.exists(REQUEST_FILE):
            try:
                with open(REQUEST_FILE, "r") as f:
                    data = json.load(f)
                    user_text = data.get("text", "")
                
                os.remove(REQUEST_FILE)
                
                if user_text:
                    bot_reply = process_request(user_text)
                    
                    with open(RESPONSE_FILE, "w") as f:
                        json.dump({"text": bot_reply}, f)
                    print(f"✅ Réponse envoyée à MA3: {bot_reply}")
                    
            except Exception as e:
                print(f"❌ Erreur: {e}")
        
        time.sleep(0.5)

if __name__ == "__main__":
    main()
