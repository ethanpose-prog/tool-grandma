return function()
    -- Prompt user for input
    local input = TextInput("Picoclaw 🦞", "Que veux-tu faire ? (ex: Patch 10 spots)")
    
    -- Check if input is not nil or empty
    if input ~= nil and input ~= "" then
        Printf("Picoclaw AI: Analyzing request: " .. input)
        
        -- Default action for this version: Select and bring to full
        -- In the future, this will be connected to the Picoclaw API
        Cmd("Fixture 1 Thru 10 At Full")
        
        -- Confirmation message
        MessageBox({
            title = "Picoclaw AI",
            message = "J'ai allumé les fixtures 1 à 10 pour toi !",
            buttons = {{value = 1, name = "Merci 🦞"}}
        })
    else
        Printf("Picoclaw AI: Operation cancelled.")
    end
end
