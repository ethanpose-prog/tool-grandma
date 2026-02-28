return function()
    -- Utilisation de l'API gma3 pour l'input
    local input = gma3.gui.TextInput("Picoclaw 🦞", "Que veux-tu faire ? (ex: Patch 10 spots)")
    
    if input ~= nil and input ~= "" then
        gma3.echo("Picoclaw AI: Analyzing request: " .. input)
        
        -- Commande test
        gma3.cmd("Fixture 1 Thru 10 At Full")
        
        -- Popup de confirmation
        gma3.gui.MessageBox({
            title = "Picoclaw AI",
            message = "J'ai allumé les fixtures 1 à 10 pour toi !",
            commands = {{value = 1, name = "Merci 🦞"}}
        })
    else
        gma3.echo("Picoclaw AI: Operation cancelled.")
    end
end
