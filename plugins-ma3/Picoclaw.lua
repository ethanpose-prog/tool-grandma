-- [[
-- Picoclaw AI Agent v2.0 - Impact Vision Edition
-- Author: Ethan @ Impact Vision
-- Description: AI-Powered Assistant for grandMA3 (Bridge to Picoclaw Server)
-- ]]

return function()
    -- Configuration du serveur Picoclaw
    local api_url = "http://127.0.0.1:80/api/chat"
    local model = "gemini-3-flash-preview:cloud"

    Printf("--------------------------------------------------")
    Printf("🦞 Picoclaw AI Agent v2.0 - Impact Vision Edition")
    Printf("--------------------------------------------------")

    -- 1. Récupération de l'input utilisateur
    local userInput = TextInput("Picoclaw AI (Impact Vision)", "Ex: Patch 10 Robe Forte à partir de 101")
    
    if userInput == nil or userInput == "" then
        Printf("Picoclaw: Annulé.")
        return
    end

    -- 2. Définition du comportement de l'IA (Expert Impact Vision)
    local systemPrompt = "Tu es un expert grandMA3 pour Impact Vision (Suisse). " ..
                         "Réponds TOUJOURS au format strict: MESSAGE ||| COMMAND. " ..
                         "MESSAGE: ton explication technique courte en français. " ..
                         "COMMAND: la syntaxe gMA3 exacte prête à être exécutée. " ..
                         "Si aucune commande n'est requise, laisse COMMAND vide."

    -- 3. Fonction d'échappement JSON pour la sécurité
    local function escape_json(s)
        return s:gsub('"', '\\"'):gsub('\n', '\\n'):gsub('\r', '\\r')
    end

    -- 4. Construction du JSON Payload (Compatible avec ai-automator /api/chat)
    local jsonPayload = string.format(
        '{"user":"Ethan","messages":[{"role":"system","content":"%s"},{"role":"user","content":"%s"}]}',
        escape_json(systemPrompt), escape_json(userInput)
    )
    
    -- 5. Commande CURL pour interroger le serveur (Fonctionne sur onPC)
    local curlCmd = string.format('curl -s -X POST %s -H "Content-Type: application/json" -d "%s"', api_url, jsonPayload)

    Printf("Picoclaw: Envoi de la requête au cerveau AI...")
    
    -- Exécution via io.popen (Nécessite onPC ou console déverrouillée)
    local handle = io.popen(curlCmd)
    if not handle then
        ErrPrintf("Picoclaw ERROR: Impossible d'exécuter curl. (Vérifiez que vous êtes sur onPC)")
        Confirm("Picoclaw Error", "Le plugin nécessite 'io.popen' (disponible uniquement sur onPC).")
        return
    end
    
    local result = handle:read("*a")
    handle:close()

    if not result or result == "" then
        ErrPrintf("Picoclaw ERROR: Aucune réponse du serveur AI.")
        Confirm("Picoclaw Error", "Le serveur AI ne répond pas. Vérifiez la connexion réseau.")
        return
    end

    -- 6. Extraction du contenu de la réponse (Parsing manuel simple)
    local content = result:match('"content"%s*:%s*"(.-)"')
    if not content then
        ErrPrintf("Picoclaw ERROR: Réponse JSON corrompue.")
        return
    end
    
    -- Nettoyage des caractères d'échappement
    content = content:gsub("\\n", "\n"):gsub("\\\"", "\""):gsub("\\\\", "\\")

    -- 7. Découpage MESSAGE ||| COMMAND
    local message, command = content:match("(.-)%s*|||%s*(.*)")
    
    if message and command then
        -- Affichage dans la console MA3
        Printf("AI MESSAGE: " .. message)
        
        -- Exécution de la commande si présente
        if command ~= "" then
            Printf("AI COMMAND: " .. command)
            Cmd(command)
        end
        
        -- Feedback visuel (Style Impact Vision)
        Confirm("Picoclaw AI 🦞", "MESSAGE: " .. message .. "\n\nCOMMANDE EXÉCUTÉE: " .. command)
    else
        -- Fallback si le format n'est pas respecté
        Confirm("Picoclaw AI 🦞", "RÉPONSE: " .. content)
    end
end
