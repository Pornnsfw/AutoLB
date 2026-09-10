--[[
    CombinedData
    Location: brain/<conversation-id>/scratch/CombinedData.lua
    Description:
        Provides a single API that merges the SimpleOwnershipChecker,
        SkillInfoFetcher, and InventoryController checks.
        • Tower ownership & Golden perks detection via InventoryController and UI.
        • Skill‑tree extraction from Workspace["1"] … Workspace["17"].
        • Coins, Gems and Level getters with local player value fallbacks.
        • All helpers operate on the **local player only**.
        • Lightweight and synchronous; suitable for mobile and third‑party
          executors.
]]--

local Players = game:GetService("Players")--
local Workspace = game:GetService("Workspace")--
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ---------------------------------------------------------------------
-- Core helpers (local player, PlayerGui, number parsing)
-- ---------------------------------------------------------------------
local function getLocalPlayer()
    local lp = Players.LocalPlayer--
    if not lp then
        pcall(function()
            Players:GetPropertyChangedSignal("LocalPlayer"):Wait()--
        end)
        lp = Players.LocalPlayer--
    end
    return lp
end

local function getPlayerGui(timeout)
    local lp = getLocalPlayer()
    if not lp then return nil end
    return lp:FindFirstChild("PlayerGui")
end

local function parseNumber(str)
    if not str then return 0 end
    local cleaned = tostring(str):gsub("<[^>]+>", ""):match("[%d,]+")
    cleaned = cleaned and cleaned:gsub("%D", "") or ""
    return tonumber(cleaned) or 0
end

-- ---------------------------------------------------------------------
-- Tower ownership & InventoryController
-- ---------------------------------------------------------------------
local CombinedData = {}
CombinedData.__index = CombinedData

local InventoryController = nil
pcall(function()
    InventoryController = require(ReplicatedStorage.Client.Interfaces.LegacyInterface.Controllers.InventoryController)
end)

local SkillTreeData = {
    [1] = { Name = "Enhanced Optics" },
    [2] = { Name = "Resourcefulness" },
    [3] = { Name = "Fortify" },
    [4] = { Name = "Over-Heal" },
    [5] = { Name = "Fight Dirty" },
    [6] = { Name = "Extreme Conditioning" },
    [7] = { Name = "Stonks" },
    [8] = { Name = "Expanded Barracks" },
    [9] = { Name = "Improved Gunpowder" },
    [10] = { Name = "Beefed Up Minions" },
    [11] = { Name = "Precision" },
    [12] = { Name = "Scavenger" },
    [13] = { Name = "Accelerator" },
    [14] = { Name = "Re-enforcements" },
    [15] = { Name = "Bigger Budget" },
    [16] = { Name = "Bandages" },
    [17] = { Name = "Scholar" },
}

CombinedData.SkillTreeData = SkillTreeData

local function getScrollingContainer(idx)
    local pgui = getPlayerGui()
    if not pgui then return nil end
    local path = {
        "ReactUniversalInventoryView",
        "Holder",
        "windowFrame",
        "towersInventoryFrame",
        "towerContainer",
        idx .. "scrolling"
    }
    local node = pgui
    for _, childName in ipairs(path) do
        node = node:FindFirstChild(childName)
        if not node then return nil end
    end
    return node
end

function CombinedData:IsTowerOwned(towerName)
    if not towerName or towerName == "" then return false end
    for i = 1, 7 do
        local container = getScrollingContainer(i)
        if container then
            local towerNode = container:FindFirstChild(towerName)
            if towerNode then
                local main = towerNode:FindFirstChild("main")
                if main then
                    local amount = main:FindFirstChild("amountLeft")
                    if amount then
                        return true
                    end
                end
            end
        end
    end
    return false
end

-- Checks if a tower has golden perks via InventoryController
function CombinedData:IsGoldenOwned(towerName)
    if InventoryController and type(InventoryController.getItems) == "function" then
        local success, items = pcall(function()
            return InventoryController:getItems()
        end)
        if success and items then
            for _, item in pairs(items) do
                if type(item) == "table" and item.type == "tower" and item.name == towerName then
                    return item.golden == true
                end
            end
        end
    end
    return false
end

-- ---------------------------------------------------------------------
-- Coins / Gems / Level (Lobby HUD with LocalPlayer Value Fallbacks)
-- ---------------------------------------------------------------------
local function getLobbyHud()
    local pgui = getPlayerGui()
    if not pgui then return nil end
    return pgui:FindFirstChild("ReactLobbyHud")
end

function CombinedData:GetLevel()
    local hud = getLobbyHud()
    if hud then
        local curLvl = hud:FindFirstChild("currentLevel", true)
            or (hud:FindFirstChild("Frame", true) and hud.Frame:FindFirstChild("centerElements", true) and hud.Frame.centerElements:FindFirstChild("level", true) and hud.Frame.centerElements.level:FindFirstChild("content", true) and hud.Frame.centerElements.level.content:FindFirstChild("currentLevel", true))

        if curLvl and curLvl:IsA("TextLabel") then
            local txt = curLvl.Text
            return parseNumber(txt), txt
        end
    end

    local lp = getLocalPlayer()
    if lp then
        local val = lp:FindFirstChild("Level")
        if val and val:IsA("ValueBase") then
            local v = val.Value
            return tonumber(v) or parseNumber(v), tostring(v)
        end
    end

    return 0, "0"
end

function CombinedData:GetCoins()
    local hud = getLobbyHud()
    if hud then
        local path = {"Frame", "leftElements", "currencies", "coins", "content", "currency", "currencyValue"}--
        local node = hud
        for _, child in ipairs(path) do
            node = node:FindFirstChild(child, true) or (node and node:FindFirstChild(child))--
            if not node then break end--
        end
        if node and node:IsA("TextLabel") then
            local txt = node.Text--
            return parseNumber(txt), txt--
        end
    end

    local lp = getLocalPlayer()
    if lp then
        local val = lp:FindFirstChild("Coins") or lp:FindFirstChild("Gold")
        if val and val:IsA("ValueBase") then
            local v = val.Value
            return tonumber(v) or parseNumber(v), tostring(v)
        end
    end

    return 0, "0"
end

function CombinedData:GetGems()
    local hud = getLobbyHud()
    if hud then
        local path = {"Frame", "leftElements", "currencies", "gems", "content", "currency", "currencyValue"}--
        local node = hud
        for _, child in ipairs(path) do
            node = node:FindFirstChild(child, true) or (node and node:FindFirstChild(child))--
            if not node then break end--
        end
        if node and node:IsA("TextLabel") then
            local txt = node.Text--
            return parseNumber(txt), txt--
        end
    end

    local lp = getLocalPlayer()
    if lp then
        local val = lp:FindFirstChild("Gems") or lp:FindFirstChild("Diamonds")
        if val and val:IsA("ValueBase") then
            local v = val.Value
            return tonumber(v) or parseNumber(v), tostring(v)
        end
    end

    return 0, "0"
end

-- ---------------------------------------------------------------------
-- Skill‑tree extraction
-- ---------------------------------------------------------------------
function CombinedData:GetSkillTree()
    local list = {}
    for i = 1, 17 do
        local tile = Workspace:FindFirstChild(tostring(i))
        if tile then
            local surfaceGui = tile:FindFirstChild("TileSurfaceGui")
            if surfaceGui then
                local frame = surfaceGui:FindFirstChild("Frame")
                if frame then
                    local nameLabel  = frame:FindFirstChild("SkillName")
                    local levelLabel = frame:FindFirstChild("SkillLevel")
                    
                    local name = nameLabel and nameLabel:IsA("TextLabel") and nameLabel.Text or ("Skill #" .. i)
                    local lvlStr = levelLabel and levelLabel:IsA("TextLabel") and levelLabel.Text or "0"
                    
                    local formattedLvl = lvlStr
                    local numericLvl = parseNumber(lvlStr)
                    
                    if string.upper(lvlStr):find("MAX") then
                        formattedLvl = "MAX" .. (numericLvl > 0 and numericLvl or "")
                    end

                    table.insert(list, {
                        Id = tostring(i),
                        Name = name,
                        Level = numericLvl,
                        LevelFormatted = formattedLvl,
                    })
                end
            end
        end
    end
    return list
end

-- ---------------------------------------------------------------------
-- Requirements Validation API
-- ---------------------------------------------------------------------
function CombinedData:CheckRequirements(requirements)
    local missing = {}
    local passed = true

    -- 1. Check Level
    if requirements.Level then
        local currentLevel = self:GetLevel()
        if currentLevel < requirements.Level then
            passed = false
            table.insert(missing, string.format("Level: required %d, current %d", requirements.Level, currentLevel))
        end
    end

    -- 2. Check Skill Tree
    if requirements.SkillTree and type(requirements.SkillTree) == "table" then
        local currentSkills = {}
        for _, skill in ipairs(self:GetSkillTree()) do
            currentSkills[skill.Name] = skill.Level
        end

        for skillName, requiredLvl in pairs(requirements.SkillTree) do
            local currentLvl = currentSkills[skillName] or 0
            if currentLvl < requiredLvl then
                passed = false
                table.insert(missing, string.format("Skill '%s': required level %d, current %d", skillName, requiredLvl, currentLvl))
            end
        end
    end

    -- 3. Check Coins
    if requirements.Coins then
        local currentCoins = self:GetCoins()
        if currentCoins < requirements.Coins then
            passed = false
            table.insert(missing, string.format("Coins: required %d, current %d", requirements.Coins, currentCoins))
        end
    end

    -- 4. Check Gems
    if requirements.Gems then
        local currentGems = self:GetGems()
        if currentGems < requirements.Gems then
            passed = false
            table.insert(missing, string.format("Gems: required %d, current %d", requirements.Gems, currentGems))
        end
    end

    -- 5. Check Towers
    if requirements.Towers and type(requirements.Towers) == "table" then
        for _, towerName in ipairs(requirements.Towers) do
            if not self:IsTowerOwned(towerName) then
                passed = false
                table.insert(missing, string.format("Missing Tower: %s", towerName))
            end
        end
    end

    -- 6. Check Golden Towers / Skins
    if requirements.Golden and type(requirements.Golden) == "table" then
        for _, towerName in ipairs(requirements.Golden) do
            if not self:IsGoldenOwned(towerName) then
                passed = false
                table.insert(missing, string.format("%s - not owned", towerName))
            end
        end
    end

    return passed, missing
end

return CombinedData--
