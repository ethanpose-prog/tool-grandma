

-- ClawChat for grandMA3
-- Version: 1.1.3 (Fix XML Structure)
-- Author: Picoclaw 🦞

local overlayName = "ClawChatOverlay"
local requestFile = "./user_question.json"
local responseFile = "./ai_response.json"

local messages = {}
local uiElements = {}
local lastResponseTime = 0

local function addMessage(sender, text)
    if not text then return end
    table.insert(messages, {sender = sender, text = text})
    if uiElements.scrollContent then
        local label = uiElements.scrollContent:Append("UILabel")
        label.Text = "[" .. sender .. "] " .. text
        label.TextAlignH = "Left"
        label.TextColor = (sender == "ME") and "Global.White" or "Global.Fuchsia"
        label.Height = 30
        uiElements.scrollArea.ScrollV = 10000 
    end
end

local function closeUI()
    local display = GetDisplayByIndex(0)
    local mainOverlay = display:GetMainOverlay()
    local overlay = mainOverlay:Find(overlayName)
    if overlay then 
        mainOverlay:Remove(overlay.Index)
        Printf("ClawChat: Ancienne interface fermée.")
    end
end

local function createUI()
    Printf("ClawChat: Création de l'interface...")
    closeUI()
    local display = GetDisplayByIndex(0)
    local mainOverlay = display:GetMainOverlay()
    
    local overlay = mainOverlay:Append("UIElement")
    overlay.Name = overlayName
    overlay.H, overlay.W, overlay.X, overlay.Y = 500, 400, 100, 100
    overlay.BackColor = "Global.Black"
    
    local grid = overlay:Append("UILayoutGrid")
    grid.Columns, grid.Rows = 1, 2
    grid[1].Height, grid[2].Height = "80%", "20%"
    
    local scrollArea = grid[1]:Append("UIScrollArea")
    uiElements.scrollArea = scrollArea
    
    local scrollContent = scrollArea:Append("UILayoutGrid")
    scrollContent.Columns = 1
    uiElements.scrollContent = scrollContent
    
    local bottomGrid = grid[2]:Append("UILayoutGrid")
    bottomGrid.Columns, bottomGrid.Rows = 2, 1
    bottomGrid[1].Width, bottomGrid[2].Width = "80%", "20%"
    
    local input = bottomGrid[1]:Append("UIInput")
    input.Text = ""
    uiElements.input = input
    
    local sendBtn = bottomGrid[2]:Append("UITextButton")
    sendBtn.Text = "SEND"
    sendBtn.BackColor = "Global.Purple"
    
    sendBtn:SetSignalFunction("OnClick", function()
        local text = input.Text
        if text ~= "" then
            addMessage("ME", text)
            local file = io.open(requestFile, "w")
            if file then
                file:write(string.format('{"question": "%s", "timestamp": %d}', text, os.time()))
                file:close()
                Printf("ClawChat: Question envoyée.")
            else
                Printf("ClawChat: ERREUR D'ÉCRITURE FICHIER !")
            end
            input.Text = ""
        end
    end)
    
    addMessage("SYSTEM", "ClawChat v1.1.3 Prêt.")
    Printf("ClawChat: Interface affichée.")
end

local function main()
    createUI()
    while true do
        local file = io.open(responseFile, "r")
        if file then
            local content = file:read("*all")
            file:close()
            local text = content:match('"response":%s*"([^"]+)"')
            local ts = tonumber(content:match('"timestamp":%s*(%d+)'))
            if text and ts and ts > lastResponseTime then
                lastResponseTime = ts
                addMessage("CLAW", text)
            end
        end
        coroutine.yield(0.5)
    end
end

return main

                