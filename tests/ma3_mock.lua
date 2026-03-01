-- ma3_mock.lua
-- Simulateur minimaliste pour tester le plugin ClawChat

function Printf(fmt, ...) print(string.format("[MA3 LOG] " .. fmt, ...)) end
function GetDisplayByIndex(i) 
    return {
        GetMainOverlay = function() 
            return {
                Append = function(self, type) 
                    return { 
                        Name = "", 
                        Find = function() return nil end,
                        Remove = function() end,
                        Append = function() return {Append = function() return {SetSignalFunction = function() end} end} end,
                        SetSignalFunction = function(self, name, func) 
                            _G.lastSignalFunc = func -- On capture la fonction du bouton SEND
                        end
                    } 
                end,
                Find = function() return nil end
            }
        end
    }
end

-- Mock coroutine yield
coroutine.yield = function(t) 
    print("[MA3 SIM] Yielding for " .. t .. "s...")
    error("STOP_LOOP") -- On arrête la boucle infinie pour le test
end

-- Mock os.time
os.time = function() return 123456789 end

print("[MA3 SIM] Environnement de test prêt.")
