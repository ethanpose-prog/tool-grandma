import os
import time
import json

# CONFIGURATION
# Le chemin doit correspondre au dossier de ton plugin grandMA3
MA3_PATH = os.path.expanduser("~/MALightingTechnology/gma3_library/plugins/ClawChat")
REQUEST_FILE = os.path.join(MA3_PATH, "user_question.json")
RESPONSE_FILE = os.path.join(MA3_PATH, "ai_response.json")

def process_request(text):
    print(f"🦞 Picoclaw Bridge: Reçu -> {text}")
    
    # Logique de réponse simplifiée pour le test
    if "blackout" in text.lower():
        reply = "Compris. J'envoie la commande de Blackout. [Cmd: Go+ Exec 101]"
    elif "merci" in text.lower():
        reply = "À ton service, Ethan ! 🦞"
    else:
        reply = f"J'ai bien reçu : '{text}'. Je traite ta demande technique..."
    
    return reply

def main():
    if not os.path.exists(MA3_PATH):
        os.makedirs(MA3_PATH)
        print(f"Création du dossier: {MA3_PATH}")

    print(f"🚀 ClawChat Bridge actif !")
    print(f"📁 Surveillance de : {REQUEST_FILE}")
    
    last_timestamp = 0

    while True:
        if os.path.exists(REQUEST_FILE):
            try:
                with open(REQUEST_FILE, "r") as f:
                    data = json.load(f)
                    user_text = data.get("question", "")
                    timestamp = data.get("timestamp", 0)
                
                # On ne traite que si le timestamp est nouveau
                if timestamp > last_timestamp:
                    last_timestamp = timestamp
                    if user_text:
                        bot_reply = process_request(user_text)
                        
                        # On écrit la réponse
                        with open(RESPONSE_FILE, "w") as f:
                            json.dump({
                                "response": bot_reply,
                                "timestamp": int(time.time())
                            }, f)
                        print(f"✅ Réponse envoyée à MA3: {bot_reply}")
                    
            except Exception as e:
                print(f"❌ Erreur lecture: {e}")
        
        time.sleep(0.5)

if __name__ == "__main__":
    main()
