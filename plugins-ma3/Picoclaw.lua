return function()
    -- On utilise les fonctions globales de la MA3 (plus stables)
    Printf("Picoclaw AI: Tentative d'ouverture de la fenêtre...")
    
    local title = "Picoclaw AI 🦞"
    local defaultText = "Tapez une commande (ex: Fixture 1 At Full)"
    
    -- Ouvre la fenêtre de saisie de texte
    local input = TextInput(title, defaultText)
    
    if input ~= nil and input ~= "" then
        Echo("Picoclaw AI: Commande reçue -> " .. input)
        
        -- On exécute la commande dans la console
        Cmd(input)
        
        -- Petite confirmation visuelle
        Confirm("Picoclaw AI", "Commande exécutée avec succès ! 🦞")
    else
        Echo("Picoclaw AI: Annulé ou vide.")
    end
end
