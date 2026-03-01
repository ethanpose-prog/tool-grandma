-- ClawChat v1.1.8 for grandMA3
-- Assistant: Picoclaw 🦞 (v1.1.8)

return function()
    Echo("--------------------------------------")
    Echo("ClawChat v1.1.8 - Initialisation...")
    
    -- Utilisation de TextInput (Popup natif MA3)
    local msg = TextInput("Picoclaw Chat 🦞", "Tapez votre message pour l'IA...")
    
    if msg and msg ~= "" then
        Echo("Picoclaw: Message reçu -> " .. msg)
        Confirm("Message envoyé", "Votre message '" .. msg .. "' a été transmis à Picoclaw.")
    else
        Echo("ClawChat: Annulé ou message vide.")
    end
end
