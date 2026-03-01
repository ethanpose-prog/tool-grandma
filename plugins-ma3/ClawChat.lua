-- ClawChat for grandMA3
-- Version: 1.0.0
-- Author: Picoclaw 🦞 (Ethan - Impact Vision)
-- Theme: Black & Purple

local pluginName = "ClawChat"
local overlayName = "ClawChatOverlay"
local requestFile = GetRootPath() .. "/plugins/ClawChat/request.json"
local responseFile = GetRootPath() .. "/plugins/ClawChat/response.json"

local messages = {}
local uiElements = {}

-- Helper to write JSON (minimalist)
local function writeJson(path, data)
    local file = io.open(path, "w")
    if file then
        file:write('{"text": "' .. data:gsub('"', '\\"') .. '"}')
        file:close()
        return true
    end
    return false
end

-- Helper to read JSON (minimalist)
local function readJson(path)
    local file = io.open(path, "r")
    if file then
        local content = file:read("*all")
        file:close()
        -- Simple extraction of "text" field
        local text = content:match('"text":%s*"([^"]+)"')
        if text then
            os.remove(path) -- Delete after reading
            return text
        end
    end
    return nil
end

local function addMessage(sender, text)
    table.insert(messages, {sender = sender, text = text})
    if uiElements.scrollContent then
        local label = uiElements.scrollContent:Append("UILabel")
        label.Text = "[" .. sender .. "] " .. text
        label.TextAlignH = "Left"
        label.TextColor = (sender == "ME") and "Global.White" or "Global.Fuchsia"
        label.BackColor = "Global.Transparent"
        label.Height = 30
        
        -- Auto-scroll to bottom
        uiElements.scrollArea.ScrollV = 10000 
    end
end

local function closeUI()
    local display = GetDisplayByIndex(0)
    local overlay = display:Find(overlayName)
    if overlay then
        overlay:Parent():Remove(overlay:Index())
    end
end

local function createUI()
    closeUI() -- Clean start
    
    local display = GetDisplayByIndex(0)
    local mainOverlay = display:GetMainOverlay()
    local overlay = mainOverlay:Append("UIElement")
    overlay.Name = overlayName
    overlay.H = 500
    overlay.W = 400
    overlay.X = 100
    overlay.Y = 100
    overlay.BackColor = "Global.Black"
    
    -- Main Grid
    local grid = overlay:Append("UILayoutGrid")
    grid.Columns = 1
    grid.Rows = 2
    grid[1].Height = "80%"
    grid[2].Height = "20%"
    
    -- Chat History (Scroll Area)
    local scrollArea = grid[1]:Append("UIScrollArea")
    scrollArea.BackColor = "Global.DarkGrey"
    uiElements.scrollArea = scrollArea
    
    local scrollContent = scrollArea:Append("UILayoutGrid")
    scrollContent.Columns = 1
    uiElements.scrollContent = scrollContent
    
    -- Bottom Bar (Input + Send)
    local bottomGrid = grid[2]:Append("UILayoutGrid")
    bottomGrid.Columns = 2
    bottomGrid.Rows = 1
    bottomGrid[1].Width = "80%"
    bottomGrid[2].Width = "20%"
    
    local input = bottomGrid[1]:Append("UIInput")
    input.Text = ""
    input.BackColor = "Global.Black"
    input.TextColor = "Global.White"
    uiElements.input = input
    
    local sendBtn = bottomGrid[2]:Append("UITextButton")
    sendBtn.Text = "SEND"
    sendBtn.BackColor = "Global.Purple"
    sendBtn.TextColor = "Global.White"
    
    -- Interaction
    sendBtn:SetSignalFunction("OnClick", function()
        local text = input.Text
        if text ~= "" then
            addMessage("ME", text)
            writeJson(requestFile, text)
            input.Text = ""
        end
    end)
    
    addMessage("SYSTEM", "ClawChat Connecté. Pose ta question.")
end

local function main()
    -- Create directory for communication if not exists
    local dir = GetRootPath() .. "/plugins/ClawChat"
    os.execute("mkdir -p " .. dir)

    createUI()
    
    -- Main Loop for Polling
    while true do
        local response = readJson(responseFile)
        if response then
            addMessage("CLAW", response)
        end
        coroutine.yield(0.5) -- Poll every 500ms
    end
end

return main
