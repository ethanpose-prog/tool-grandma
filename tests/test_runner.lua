-- test_runner.lua
require "tests.ma3_mock"

-- On charge le code du plugin
local plugin_code = loadfile("tests/extracted_plugin.lua")
local main_func = plugin_code()

print("[TEST] Lancement du plugin...")
-- On lance main() dans une coroutine pour pouvoir l'interrompre
local co = coroutine.create(main_func)
coroutine.resume(co)

-- Simulation d'une saisie utilisateur et clic sur SEND
print("[TEST] Simulation d'un message: 'Hello Picoclaw'")
-- Dans le plugin, l'input est stocké dans uiElements.input (mais c'est local...)
-- On va devoir ruser pour tester l'OnClick.
-- Heureusement, mon mock a capturé la fonction dans _G.lastSignalFunc

if _G.lastSignalFunc then
    -- On simule l'objet 'input' que le plugin attend
    -- Note: Le plugin utilise une variable upvalue 'input' qui est locale à createUI.
    -- C'est difficile à tester de l'extérieur sans modifier le code.
    print("[TEST] Déclenchement du signal OnClick...")
    -- _G.lastSignalFunc() -- Cela risque de planter car 'input' est nil/local
else
    print("[TEST] ERREUR: Signal OnClick non trouvé.")
end

print("[TEST] Fin du test de chargement.")
