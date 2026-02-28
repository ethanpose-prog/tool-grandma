-- Picoclaw AI Plugin for grandMA3
-- Version: 1.0.4
-- Author: Ethan - Impact Vision

local function main()
    Printf("Picoclaw AI: Lancement du plugin...")

    -- On tente d'utiliser MessageBox (plus moderne et stable)
    -- Si MessageBox échoue, on se rabat sur TextInput
    
    local success, result = pcall(function()
        local messageOptions = {
            title = "Picoclaw AI 🦞",
            message = "Entrez votre commande pour la console :",
            commands = {
                {value = 1, name = "Exécuter"},
                {value = 0, name = "Annuler"}
            },
            inputs = {
                {name = "Commande", value = "Fixture 1 At Full", blackFilter = ""}
            },
            backColor = "Global.DarkGrey",
            timeout = 0
        }
        return MessageBox(messageOptions)
    end)

    if success and result and result.success and result.result == 1 then
        local command = result.inputs["Commande"]
        if command ~= "" then
            Printf("Picoclaw AI: Exécution de -> " .. command)
            Cmd(command)
        else
            Printf("Picoclaw AI: Commande vide, abandon.")
        end
    elseif not success then
        -- Fallback sur TextInput si MessageBox n'est pas dispo (vieilles versions)
        Printf("Picoclaw AI: MessageBox non dispo, essai TextInput...")
        local input = TextInput("Picoclaw AI 🦞", "Fixture 1 At Full")
        if input ~= nil and input ~= "" then
             Printf("Picoclaw AI: Exécution de -> " .. input)
             Cmd(input)
        else
             Printf("Picoclaw AI: Annulé ou vide.")
        end
    else
        Printf("Picoclaw AI: Action annulée par l'utilisateur.")
    end
end

return main
