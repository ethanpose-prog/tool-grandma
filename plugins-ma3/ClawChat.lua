-- ClawChat v1.1.6 for grandMA3
-- Assistant: Picoclaw 🦞

local function main()
    Printf("--------------------------------------")
    Printf("ClawChat v1.1.6 - Initialisation...")
    
    -- Utilisation de TextInput (Popup natif MA3)
    local msg = TextInput("Picoclaw Chat 🦞", "Tapez votre message pour l'IA...")
    
    if msg and msg ~= "" then
        Printf("Picoclaw: Message reçu -> " .. msg)
        Confirm("Message envoyé", "Votre message '" .. msg .. "' a été transmis à Picoclaw.")
    else
        Printf("ClawChat: Annulé ou message vide.")
    end
end

return main
