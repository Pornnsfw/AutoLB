--!strict
--[[
    GlassHubUI.lua (Core Edition)
    Reusable Modern Roblox UI Library inspired by the Core UI design.
    
    Features:
      • Multi-Theme Support: CoreRed (Default), BoosterPurple, MidnightCyan, EmeraldGreen, GlassPurple, AmberOrange
      • Dynamic Theme Switching: Library.Themes, Window:SetTheme(nameOrTable)
      • Sidebar Navigation with active accent pill indicator & dual-line tab headers (Title + Subtitle)
      • Sidebar User Profile Card: avatar headshot, username, and status badge pill
      • Top Header: Breadcrumb navigation (APP // TAB), status subtitle, theme switcher, discord, close
      • Components:
          - Segmented / Pill Switcher (Free / Premium / Booster)
          - Feature Checklist Card with checkmarks and action button
          - Glass Card / Label (with left icon wrap, title, subtitle, right chevron/status)
          - Button (with ripple effect & smooth hover)
          - Toggle (sleek modern toggle switch with glowing bar)
          - Dropdown (single & multi-select with search and responsive dropdown list)
          - Slider (smooth draggable slider with value preview)
          - Textbox (clean input field with focus animations)
          - Toast Notifications & Confirm Dialogs
]]--

local Library = {}
Library.__index = Library

--------------------------------------------------------------------------------
-- 1. Built-in Asset Identifiers
--------------------------------------------------------------------------------
Library.Assets = {
    Shadow          = "rbxassetid://1316045217",
    Minimize        = "rbxassetid://13857987062",
    Close           = "rbxassetid://15082305656",
    Resize          = "rbxassetid://15082210525",
    Chevron         = "rbxassetid://14937709869",
    Arrow           = "rbxassetid://14923748517",
    Search          = "rbxassetid://13847222481",
    Textbox         = "rbxassetid://13868675087",
    GlowDot         = "rbxassetid://105506802034513",
    ImageLogo       = "rbxassetid://111362591084511",
    FloatingToggle  = "rbxassetid://99432006374500",
    Discord         = "rbxassetid://119690296342461",
    Theme           = "rbxassetid://14923748517",
    Home            = "rbxassetid://10723405374",
    User            = "rbxassetid://10747373176",
    Key             = "rbxassetid://10709790644",
    Clock           = "rbxassetid://10709791437",
    Check           = "rbxassetid://10709790644",
    Globe           = "rbxassetid://10734887376",
    Chat            = "rbxassetid://10734887852",
    Gear            = "rbxassetid://10734950309",
    Sliders         = "rbxassetid://10734950020",
    Terminal        = "rbxassetid://10734951847",
}

--------------------------------------------------------------------------------
-- 2. Theme Presets (Easily reusable across scripts)
--------------------------------------------------------------------------------
Library.Themes = {
    -- Reference Theme: Core Red (Dark charcoal + vibrant crimson red)
    CoreRed = {
        Background    = Color3.fromRGB(12, 13, 20),
        Sidebar       = Color3.fromRGB(15, 16, 24),
        Surface       = Color3.fromRGB(18, 20, 30),
        SurfaceHover  = Color3.fromRGB(26, 29, 44),
        Stroke        = Color3.fromRGB(32, 36, 52),
        StrokeSoft    = Color3.fromRGB(24, 27, 38),
        Text          = Color3.fromRGB(255, 255, 255),
        Muted         = Color3.fromRGB(140, 146, 165),
        Accent        = Color3.fromRGB(255, 43, 68),   -- Core Crimson Red
        AccentHover   = Color3.fromRGB(255, 75, 95),
        AccentSoft    = Color3.fromRGB(48, 16, 22),   -- Active tab / badge tint
        Success       = Color3.fromRGB(0, 229, 117),
        Warning       = Color3.fromRGB(255, 184, 0),
        Danger        = Color3.fromRGB(255, 43, 68),
    },
    
    -- Reference Theme: Booster Purple (Discord Nitro / Booster style)
    BoosterPurple = {
        Background    = Color3.fromRGB(12, 13, 20),
        Sidebar       = Color3.fromRGB(15, 16, 24),
        Surface       = Color3.fromRGB(18, 20, 30),
        SurfaceHover  = Color3.fromRGB(28, 24, 46),
        Stroke        = Color3.fromRGB(36, 32, 56),
        StrokeSoft    = Color3.fromRGB(26, 24, 40),
        Text          = Color3.fromRGB(255, 255, 255),
        Muted         = Color3.fromRGB(145, 140, 165),
        Accent        = Color3.fromRGB(144, 71, 254),  -- Royal Booster Purple
        AccentHover   = Color3.fromRGB(168, 105, 255),
        AccentSoft    = Color3.fromRGB(40, 20, 68),
        Success       = Color3.fromRGB(0, 229, 117),
        Warning       = Color3.fromRGB(255, 184, 0),
        Danger        = Color3.fromRGB(255, 70, 95),
    },

    -- Electric Midnight Cyan
    MidnightCyan = {
        Background    = Color3.fromRGB(10, 14, 22),
        Sidebar       = Color3.fromRGB(13, 18, 28),
        Surface       = Color3.fromRGB(16, 22, 34),
        SurfaceHover  = Color3.fromRGB(22, 32, 50),
        Stroke        = Color3.fromRGB(28, 42, 64),
        StrokeSoft    = Color3.fromRGB(20, 30, 46),
        Text          = Color3.fromRGB(255, 255, 255),
        Muted         = Color3.fromRGB(135, 155, 175),
        Accent        = Color3.fromRGB(0, 210, 255),   -- Electric Cyan
        AccentHover   = Color3.fromRGB(60, 225, 255),
        AccentSoft    = Color3.fromRGB(15, 45, 60),
        Success       = Color3.fromRGB(0, 229, 117),
        Warning       = Color3.fromRGB(255, 184, 0),
        Danger        = Color3.fromRGB(255, 70, 95),
    },

    -- Emerald Matrix Green
    EmeraldGreen = {
        Background    = Color3.fromRGB(10, 16, 14),
        Sidebar       = Color3.fromRGB(13, 20, 17),
        Surface       = Color3.fromRGB(16, 26, 22),
        SurfaceHover  = Color3.fromRGB(22, 38, 30),
        Stroke        = Color3.fromRGB(28, 50, 40),
        StrokeSoft    = Color3.fromRGB(20, 36, 28),
        Text          = Color3.fromRGB(255, 255, 255),
        Muted         = Color3.fromRGB(135, 165, 150),
        Accent        = Color3.fromRGB(16, 185, 129),  -- Emerald Green
        AccentHover   = Color3.fromRGB(34, 197, 94),
        AccentSoft    = Color3.fromRGB(18, 48, 36),
        Success       = Color3.fromRGB(16, 185, 129),
        Warning       = Color3.fromRGB(255, 184, 0),
        Danger        = Color3.fromRGB(255, 70, 95),
    },

    -- Classic Glass Purple (Aether style)
    GlassPurple = {
        Background    = Color3.fromRGB(20, 14, 32),
        Sidebar       = Color3.fromRGB(24, 16, 38),
        Surface       = Color3.fromRGB(36, 22, 56),
        SurfaceHover  = Color3.fromRGB(56, 34, 88),
        Stroke        = Color3.fromRGB(190, 105, 255),
        StrokeSoft    = Color3.fromRGB(125, 75, 185),
        Text          = Color3.fromRGB(255, 255, 255),
        Muted         = Color3.fromRGB(215, 185, 255),
        Accent        = Color3.fromRGB(180, 80, 255),
        AccentHover   = Color3.fromRGB(210, 120, 255),
        AccentSoft    = Color3.fromRGB(60, 30, 90),
        Success       = Color3.fromRGB(60, 240, 170),
        Warning       = Color3.fromRGB(255, 205, 70),
        Danger        = Color3.fromRGB(255, 85, 115),
    },
    
    -- Sunset Amber Orange
    AmberOrange = {
        Background    = Color3.fromRGB(14, 13, 18),
        Sidebar       = Color3.fromRGB(18, 16, 22),
        Surface       = Color3.fromRGB(24, 20, 28),
        SurfaceHover  = Color3.fromRGB(36, 28, 40),
        Stroke        = Color3.fromRGB(48, 36, 56),
        StrokeSoft    = Color3.fromRGB(32, 26, 40),
        Text          = Color3.fromRGB(255, 255, 255),
        Muted         = Color3.fromRGB(170, 155, 165),
        Accent        = Color3.fromRGB(255, 138, 36),
        AccentHover   = Color3.fromRGB(255, 165, 75),
        AccentSoft    = Color3.fromRGB(55, 28, 15),
        Success       = Color3.fromRGB(0, 229, 117),
        Warning       = Color3.fromRGB(255, 184, 0),
        Danger        = Color3.fromRGB(255, 60, 80),
    }
}

local THEME_ORDER = { "CoreRed", "BoosterPurple", "MidnightCyan", "EmeraldGreen", "GlassPurple", "AmberOrange" }

local function resolveTheme(themeInput: any): { [string]: Color3 }
    local base = Library.Themes.CoreRed
    local resolved = {}
    for k, v in pairs(base) do
        resolved[k] = v
    end

    if type(themeInput) == "string" and Library.Themes[themeInput] then
        for k, v in pairs(Library.Themes[themeInput]) do
            resolved[k] = v
        end
    elseif type(themeInput) == "table" then
        for k, v in pairs(themeInput) do
            resolved[k] = v
        end
    end

    return resolved
end

--------------------------------------------------------------------------------
-- 3. Core Roblox Services & Helpers
--------------------------------------------------------------------------------
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

local function tween(object: Instance, time: number, goal: { [string]: any })
    local info = TweenInfo.new(time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local anim = TweenService:Create(object, info, goal)
    anim:Play()
    return anim
end

local function make(className: string, props: { [string]: any }?, children: { Instance }?): any
    local object = Instance.new(className)
    if props then
        for key, value in pairs(props) do
            (object :: any)[key] = value
        end
    end
    if children then
        for _, child in ipairs(children) do
            child.Parent = object
        end
    end
    return object
end

local function corner(parent: Instance, radius: number)
    return make("UICorner", {
        CornerRadius = UDim.new(0, radius),
        Parent = parent,
    })
end

local function stroke(parent: Instance, color: Color3, thickness: number?, transparency: number?)
    return make("UIStroke", {
        Color = color,
        Thickness = thickness or 1,
        Transparency = transparency or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = parent,
    })
end

local function padding(parent: Instance, left: number, top: number, right: number, bottom: number)
    return make("UIPadding", {
        PaddingLeft = UDim.new(0, left),
        PaddingTop = UDim.new(0, top),
        PaddingRight = UDim.new(0, right),
        PaddingBottom = UDim.new(0, bottom),
        Parent = parent,
    })
end

local function list(parent: Instance, paddingSize: number, direction: Enum.FillDirection?)
    return make("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, paddingSize),
        FillDirection = direction or Enum.FillDirection.Vertical,
        Parent = parent,
    })
end

local function normalizeAsset(image: any): string
    if type(image) == "number" then
        return "rbxassetid://" .. tostring(image)
    end
    if type(image) == "string" then
        if image == "" then return "" end
        if image:find("rbxassetid://") or image:find("rbxthumb://") or image:find("http") then
            return image
        end
        if Library.Assets[image] then
            return Library.Assets[image]
        end
        return "rbxassetid://" .. image
    end
    return ""
end

local function getParentGui()
    if gethui then
        local ok, h = pcall(gethui)
        if ok and h then return h end
    end
    local ok, parent = pcall(function() return CoreGui end)
    if ok and parent then return parent end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local function updateCanvas(scroll: ScrollingFrame, layout: UIListLayout, extra: number?)
    local function refresh()
        scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + (extra or 18))
    end
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(refresh)
    refresh()
end

local function addRipple(button: GuiButton, color: Color3)
    button.ClipsDescendants = true
    button.MouseButton1Down:Connect(function(x, y)
        local ripple = make("Frame", {
            Name = "Ripple",
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromOffset(x - button.AbsolutePosition.X, y - button.AbsolutePosition.Y),
            Size = UDim2.fromOffset(0, 0),
            BackgroundColor3 = color,
            BackgroundTransparency = 0.65,
            BorderSizePixel = 0,
            ZIndex = button.ZIndex + 2,
            Parent = button,
        })
        corner(ripple, 100)
        local size = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2.2
        tween(ripple, 0.35, {
            Size = UDim2.fromOffset(size, size),
            BackgroundTransparency = 1,
        })
        task.delay(0.38, function()
            if ripple then ripple:Destroy() end
        end)
    end)
end

local function bindDrag(handle: GuiObject, target: GuiObject)
    local dragging = false
    local dragInput: InputObject? = nil
    local dragStart: Vector3? = nil
    local startPosition: UDim2? = nil

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPosition = target.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput and dragStart and startPosition then
            local delta = input.Position - dragStart
            target.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
        end
    end)
end

local function createIcon(parent: Instance, image: any, size: number, color: Color3, transparency: number?)
    local asset = normalizeAsset(image)
    return make("ImageLabel", {
        Name = "Icon",
        Size = UDim2.fromOffset(size, size),
        BackgroundTransparency = 1,
        Image = asset,
        ImageColor3 = color,
        ImageTransparency = transparency or 0,
        ScaleType = Enum.ScaleType.Fit,
        Visible = asset ~= "",
        Parent = parent,
    })
end

local function createText(parent: Instance, name: string, text: string, size: number, color: Color3, bold: boolean?, order: number?)
    return make("TextLabel", {
        Name = name,
        Text = text,
        Font = bold and Enum.Font.GothamBold or Enum.Font.GothamMedium,
        TextSize = size,
        TextColor3 = color,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        TextWrapped = true,
        TextStrokeColor3 = Color3.fromRGB(0, 0, 0),
        TextStrokeTransparency = bold and 0.65 or 0.8,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        LayoutOrder = order or 1,
        Parent = parent,
    })
end

--------------------------------------------------------------------------------
-- 4. Component Factory: Rows & Cards
--------------------------------------------------------------------------------
local function createCoreRow(self: any, parent: Instance, title: string, desc: string?, image: any?, height: number?)
    local iconAsset = normalizeAsset(image or "")
    local hasIcon = iconAsset ~= ""
    local leftInset = hasIcon and 54 or 16

    local row = make("TextButton", {
        Name = "CoreRow",
        Text = "",
        AutoButtonColor = false,
        Size = UDim2.new(1, 0, 0, height or 54),
        BackgroundColor3 = self.Theme.Surface,
        BackgroundTransparency = 0.05,
        BorderSizePixel = 0,
        LayoutOrder = 10,
        Parent = parent,
    })
    row.ClipsDescendants = true
    corner(row, 8)
    local rowStroke = stroke(row, self.Theme.Stroke, 1, 0.25)

    -- Subtle left edge glow
    local leftGlow = make("Frame", {
        Name = "LeftGlow",
        Position = UDim2.fromOffset(0, 8),
        Size = UDim2.new(0, 3, 1, -16),
        BackgroundColor3 = self.Theme.Accent,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Parent = row,
    })
    corner(leftGlow, 2)

    local iconWrap = make("Frame", {
        Name = "IconWrap",
        BackgroundColor3 = self.Theme.Sidebar,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(10, 9),
        Size = UDim2.fromOffset(34, 34),
        Visible = hasIcon,
        Parent = row,
    })
    corner(iconWrap, 8)
    stroke(iconWrap, self.Theme.StrokeSoft, 1, 0.2)
    local icon = createIcon(iconWrap, iconAsset, 18, self.Theme.Accent, 0.05)
    icon.AnchorPoint = Vector2.new(0.5, 0.5)
    icon.Position = UDim2.fromScale(0.5, 0.5)

    local textWrap = make("Frame", {
        Name = "TextWrap",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(leftInset, 8),
        Size = UDim2.new(1, -leftInset - 36, 1, -16),
        Parent = row,
    })
    list(textWrap, 2)

    local titleLabel = createText(textWrap, "Title", title, 11, self.Theme.Text, true, 1)
    if desc and desc ~= "" then
        createText(textWrap, "Desc", desc, 9, self.Theme.Muted, false, 2)
    end

    row.MouseEnter:Connect(function()
        tween(row, 0.16, { BackgroundColor3 = self.Theme.SurfaceHover, BackgroundTransparency = 0 })
        tween(rowStroke, 0.16, { Color = self.Theme.Accent, Transparency = 0.1 })
        tween(leftGlow, 0.16, { BackgroundTransparency = 0.1, Size = UDim2.new(0, 3.5, 1, -10), Position = UDim2.fromOffset(0, 5) })
    end)
    row.MouseLeave:Connect(function()
        tween(row, 0.16, { BackgroundColor3 = self.Theme.Surface, BackgroundTransparency = 0.05 })
        tween(rowStroke, 0.16, { Color = self.Theme.Stroke, Transparency = 0.25 })
        tween(leftGlow, 0.16, { BackgroundTransparency = 0.5, Size = UDim2.new(0, 3, 1, -16), Position = UDim2.fromOffset(0, 8) })
    end)

    return row
end

--------------------------------------------------------------------------------
-- 5. Page & Widget API Builder
--------------------------------------------------------------------------------
local function createPageApi(window: any, scroll: ScrollingFrame)
    local api = {}

    function api:Section(props: { [string]: any })
        props = props or {}
        local section = make("Frame", {
            Name = "Section",
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            LayoutOrder = props.Order or 10,
            Parent = scroll,
        })
        list(section, 6)

        local headerWrap = make("Frame", {
            Name = "SectionHeaderWrap",
            Size = UDim2.new(1, 0, 0, 18),
            BackgroundTransparency = 1,
            LayoutOrder = 1,
            Parent = section,
        })
        local hLayout = list(headerWrap, 6, Enum.FillDirection.Horizontal)
        hLayout.VerticalAlignment = Enum.VerticalAlignment.Center

        local dot = make("Frame", {
            Name = "SectionDot",
            Size = UDim2.fromOffset(5, 5),
            BackgroundColor3 = window.Theme.Accent,
            BorderSizePixel = 0,
            Parent = headerWrap,
        })
        corner(dot, 5)

        make("TextLabel", {
            Name = "SectionTitle",
            Text = string.upper(tostring(props.Title or "Section")),
            Font = Enum.Font.GothamBold,
            TextSize = 10,
            TextColor3 = window.Theme.Muted,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -16, 1, 0),
            Parent = headerWrap,
        })

        local sectionApi = createPageApi(window, section :: any)
        sectionApi.Root = section
        return sectionApi
    end

    function api:Label(props: { [string]: any })
        props = props or {}
        local row = createCoreRow(window, scroll, tostring(props.Title or "Label"), props.Desc or "", props.Image or "", props.Height or 52)
        local item = {}
        function item:SetTitle(value: string)
            local titleLabel = row:FindFirstChild("Title", true)
            if titleLabel and titleLabel:IsA("TextLabel") then titleLabel.Text = value end
        end
        function item:SetDesc(value: string)
            local descLabel = row:FindFirstChild("Desc", true)
            if descLabel and descLabel:IsA("TextLabel") then descLabel.Text = value end
        end
        function item:SetVisible(value: boolean)
            row.Visible = value
        end
        return item
    end

    function api:Button(props: { [string]: any })
        props = props or {}
        local callback = props.Callback or function() end
        local row = createCoreRow(window, scroll, tostring(props.Title or "Button"), props.Desc or "", props.Image or "Arrow", props.Height or 52)
        addRipple(row, window.Theme.Accent)

        local glyph = createIcon(row, props.RightIcon or "Arrow", 16, window.Theme.Muted, 0.1)
        glyph.AnchorPoint = Vector2.new(1, 0.5)
        glyph.Position = UDim2.new(1, -14, 0.5, 0)

        row.MouseButton1Click:Connect(function()
            task.spawn(callback)
        end)

        local item = {}
        function item:SetTitle(value: string)
            local titleLabel = row:FindFirstChild("Title", true)
            if titleLabel and titleLabel:IsA("TextLabel") then titleLabel.Text = value end
        end
        function item:SetVisible(value: boolean)
            row.Visible = value
        end
        return item
    end

    function api:Toggle(props: { [string]: any })
        props = props or {}
        local value = props.Value == true
        local callback = props.Callback or function() end
        local row = createCoreRow(window, scroll, tostring(props.Title or "Toggle"), props.Desc or "", props.Image or "", props.Height or 54)
        addRipple(row, window.Theme.Accent)

        local leftGlow = row:FindFirstChild("LeftGlow")

        local switch = make("Frame", {
            Name = "Switch",
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -14, 0.5, 0),
            Size = UDim2.fromOffset(42, 22),
            BackgroundColor3 = value and window.Theme.Success or window.Theme.StrokeSoft,
            BackgroundTransparency = value and 0.05 or 0.25,
            BorderSizePixel = 0,
            Parent = row,
        })
        corner(switch, 11)
        local switchStroke = stroke(switch, value and window.Theme.Success or window.Theme.StrokeSoft, 1.2, 0.2)

        local knob = make("Frame", {
            Name = "Knob",
            Size = UDim2.fromOffset(16, 16),
            Position = value and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
            BackgroundColor3 = window.Theme.Text,
            BorderSizePixel = 0,
            Parent = switch,
        })
        corner(knob, 9)

        local knobGlowDot = make("Frame", {
            Name = "KnobGlowDot",
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(5, 5),
            BackgroundColor3 = value and window.Theme.Success or window.Theme.StrokeSoft,
            BorderSizePixel = 0,
            Parent = knob,
        })
        corner(knobGlowDot, 5)

        local function setValue(nextValue: boolean, fire: boolean?)
            value = nextValue == true
            tween(switch, 0.16, {
                BackgroundColor3 = value and window.Theme.Success or window.Theme.StrokeSoft,
            })
            tween(switchStroke, 0.16, {
                Color = value and window.Theme.Success or window.Theme.StrokeSoft,
            })
            tween(knob, 0.16, {
                Position = value and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
            })
            tween(knobGlowDot, 0.16, {
                BackgroundColor3 = value and window.Theme.Success or window.Theme.StrokeSoft,
            })
            if leftGlow and leftGlow:IsA("Frame") then
                tween(leftGlow, 0.16, {
                    BackgroundColor3 = value and window.Theme.Success or window.Theme.Accent,
                    BackgroundTransparency = value and 0.1 or 0.5,
                })
            end
            if fire then
                task.spawn(function() callback(value) end)
            end
        end

        row.MouseButton1Click:Connect(function()
            setValue(not value, true)
        end)

        local item = {}
        function item:SetValue(nextVal: boolean) setValue(nextVal, false) end
        function item:GetValue() return value end
        function item:SetVisible(nextVal: boolean) row.Visible = nextVal end
        return item
    end

    function api:Dropdown(props: { [string]: any })
        props = props or {}
        local options = props.List or props.Options or {}
        local multi = props.Multi == true
        local title = tostring(props.Title or "Dropdown")
        local desc = tostring(props.Desc or "")
        local callback = props.Callback or function() end
        local selected = props.Value
        if selected == nil and not multi then
            selected = options[1]
        elseif selected == nil and multi then
            selected = {}
        end

        local container = make("Frame", {
            Name = "DropdownContainer",
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            LayoutOrder = 10,
            Parent = scroll,
        })
        list(container, 5)

        local row = createCoreRow(window, container, title, desc, props.Image or "", props.Height or 54)
        addRipple(row, window.Theme.Accent)

        local valueLabel = make("TextLabel", {
            Name = "Value",
            Text = multi and table.concat(selected, ", ") or tostring(selected or "Select"),
            Font = Enum.Font.GothamBold,
            TextSize = 10,
            TextColor3 = window.Theme.Accent,
            TextXAlignment = Enum.TextXAlignment.Right,
            TextTruncate = Enum.TextTruncate.AtEnd,
            TextStrokeColor3 = Color3.fromRGB(0, 0, 0),
            TextStrokeTransparency = 0.7,
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -38, 0.5, 0),
            Size = UDim2.fromOffset(props.ValueWidth or 130, 22),
            Parent = row,
        })

        local chevron = createIcon(row, "Chevron", 16, window.Theme.Muted, 0.1)
        chevron.AnchorPoint = Vector2.new(1, 0.5)
        chevron.Position = UDim2.new(1, -14, 0.5, 0)

        local listFrame = make("Frame", {
            Name = "DropdownList",
            Size = UDim2.new(1, 0, 0, 0),
            BackgroundColor3 = window.Theme.Sidebar,
            BackgroundTransparency = 0.05,
            BorderSizePixel = 0,
            ClipsDescendants = true,
            Visible = false,
            LayoutOrder = 11,
            Parent = container,
        })
        corner(listFrame, 8)
        stroke(listFrame, window.Theme.Stroke, 1, 0.25)
        padding(listFrame, 6, 6, 6, 6)
        local optionLayout = list(listFrame, 4)

        local open = false
        local buttons = {}

        local function getDropdownHeight()
            return optionLayout.AbsoluteContentSize.Y + 12
        end

        local function closeDropdown()
            open = false
            tween(listFrame, 0.15, { Size = UDim2.new(1, 0, 0, 0) })
            task.delay(0.16, function()
                if not open and listFrame.Parent then listFrame.Visible = false end
            end)
        end

        local function openDropdown()
            open = true
            listFrame.Visible = true
            listFrame.Size = UDim2.new(1, 0, 0, 0)
            tween(listFrame, 0.18, { Size = UDim2.new(1, 0, 0, getDropdownHeight()) })
        end

        local function selectedContains(val: any)
            if not multi or type(selected) ~= "table" then return selected == val end
            return table.find(selected, val) ~= nil
        end

        local function refreshValue()
            valueLabel.Text = multi and table.concat(selected, ", ") or tostring(selected or "Select")
            if valueLabel.Text == "" then valueLabel.Text = "Select" end
            for opt, btn in pairs(buttons) do
                local active = selectedContains(opt)
                btn.TextColor3 = active and window.Theme.Accent or window.Theme.Text
                btn.BackgroundColor3 = active and window.Theme.AccentSoft or window.Theme.Surface
            end
        end

        local function addOption(opt: any)
            local btn = make("TextButton", {
                Name = "Option",
                Text = "  " .. tostring(opt),
                Font = Enum.Font.GothamMedium,
                TextSize = 11,
                TextColor3 = selectedContains(opt) and window.Theme.Accent or window.Theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                AutoButtonColor = false,
                BackgroundColor3 = selectedContains(opt) and window.Theme.AccentSoft or window.Theme.Surface,
                BackgroundTransparency = 0.05,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 26),
                Parent = listFrame,
            })
            corner(btn, 6)
            addRipple(btn, window.Theme.Accent)
            buttons[opt] = btn

            btn.MouseButton1Click:Connect(function()
                if multi then
                    local pos = table.find(selected, opt)
                    if pos then table.remove(selected, pos) else table.insert(selected, opt) end
                else
                    selected = opt
                    closeDropdown()
                end
                refreshValue()
                callback(selected)
            end)
        end

        for _, opt in ipairs(options) do
            addOption(opt)
        end

        row.MouseButton1Click:Connect(function()
            if open then closeDropdown() else openDropdown() end
            tween(chevron, 0.16, { Rotation = open and 180 or 0 })
        end)

        local item = {}
        function item:SetValue(v: any) selected = v; refreshValue() end
        function item:GetValue() return selected end
        function item:SetVisible(v: boolean) container.Visible = v end
        return item
    end

    -- New Reference Component: Segmented / Pill Switcher (From Reference Images 2, 3, 4)
    function api:Segmented(props: { [string]: any })
        props = props or {}
        local options = props.Options or props.List or { "Option 1", "Option 2" }
        local selected = props.Value or options[1]
        local callback = props.Callback or function() end

        local row = make("Frame", {
            Name = "SegmentedContainer",
            Size = UDim2.new(1, 0, 0, 42),
            BackgroundColor3 = window.Theme.Sidebar,
            BackgroundTransparency = 0.05,
            BorderSizePixel = 0,
            LayoutOrder = 10,
            Parent = scroll,
        })
        corner(row, 9)
        stroke(row, window.Theme.StrokeSoft, 1, 0.25)
        padding(row, 4, 4, 4, 4)
        local segLayout = list(row, 4, Enum.FillDirection.Horizontal)
        segLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        segLayout.VerticalAlignment = Enum.VerticalAlignment.Center

        local buttons = {}
        local btnWidth = 1 / #options

        local function refreshSegmented()
            for opt, btn in pairs(buttons) do
                local active = opt == selected
                tween(btn, 0.16, {
                    BackgroundColor3 = active and window.Theme.Accent or window.Theme.Surface,
                    BackgroundTransparency = active and 0 or 0.4,
                })
                btn.TextColor3 = active and Color3.fromRGB(255, 255, 255) or window.Theme.Muted
            end
        end

        for _, opt in ipairs(options) do
            local btn = make("TextButton", {
                Name = "Segment_" .. tostring(opt),
                Text = tostring(opt),
                Font = Enum.Font.GothamBold,
                TextSize = 11,
                TextColor3 = opt == selected and Color3.fromRGB(255, 255, 255) or window.Theme.Muted,
                AutoButtonColor = false,
                BackgroundColor3 = opt == selected and window.Theme.Accent or window.Theme.Surface,
                BackgroundTransparency = opt == selected and 0 or 0.4,
                BorderSizePixel = 0,
                Size = UDim2.new(btnWidth, -4, 1, 0),
                Parent = row,
            })
            corner(btn, 7)
            addRipple(btn, Color3.fromRGB(255, 255, 255))
            buttons[opt] = btn

            btn.MouseButton1Click:Connect(function()
                selected = opt
                refreshSegmented()
                task.spawn(function() callback(selected) end)
            end)
        end

        local item = {}
        function item:SetValue(v: any) selected = v; refreshSegmented() end
        function item:GetValue() return selected end
        function item:SetVisible(v: boolean) row.Visible = v end
        return item
    end

    -- New Reference Component: Feature Checklist Card (From Reference Images 2, 3, 4)
    function api:FeatureCard(props: { [string]: any })
        props = props or {}
        local title = tostring(props.Title or "Feature Card")
        local badge = tostring(props.Badge or "")
        local items = props.Items or {}
        local buttonText = tostring(props.ButtonText or "Action")
        local callback = props.Callback or function() end

        local card = make("Frame", {
            Name = "FeatureCard",
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = window.Theme.Surface,
            BackgroundTransparency = 0.05,
            BorderSizePixel = 0,
            LayoutOrder = 10,
            Parent = scroll,
        })
        corner(card, 10)
        stroke(card, window.Theme.Stroke, 1, 0.25)
        padding(card, 12, 12, 12, 12)
        list(card, 8)

        -- Header Row: Title on left, Badge on right
        local headerRow = make("Frame", {
            Name = "HeaderRow",
            Size = UDim2.new(1, 0, 0, 24),
            BackgroundTransparency = 1,
            Parent = card,
        })
        createText(headerRow, "CardTitle", title, 13, window.Theme.Text, true)

        if badge ~= "" then
            local badgePill = make("Frame", {
                Name = "BadgePill",
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, 0, 0.5, 0),
                Size = UDim2.fromOffset(0, 20),
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundColor3 = window.Theme.AccentSoft,
                BorderSizePixel = 0,
                Parent = headerRow,
            })
            corner(badgePill, 6)
            padding(badgePill, 8, 2, 8, 2)
            stroke(badgePill, window.Theme.Accent, 1, 0.5)

            make("TextLabel", {
                Name = "BadgeText",
                Text = badge,
                Font = Enum.Font.GothamBold,
                TextSize = 9,
                TextColor3 = window.Theme.Accent,
                BackgroundTransparency = 1,
                Size = UDim2.fromOffset(0, 16),
                AutomaticSize = Enum.AutomaticSize.X,
                Parent = badgePill,
            })
        end

        -- Bullet items with green checkmarks
        for _, it in ipairs(items) do
            local itemRow = make("Frame", {
                Name = "ItemRow",
                Size = UDim2.new(1, 0, 0, 18),
                BackgroundTransparency = 1,
                Parent = card,
            })
            local hLayout = list(itemRow, 6, Enum.FillDirection.Horizontal)
            hLayout.VerticalAlignment = Enum.VerticalAlignment.Center

            local checkmark = make("TextLabel", {
                Name = "Checkmark",
                Text = "✓",
                Font = Enum.Font.GothamBold,
                TextSize = 12,
                TextColor3 = window.Theme.Success,
                BackgroundTransparency = 1,
                Size = UDim2.fromOffset(14, 16),
                Parent = itemRow,
            })

            make("TextLabel", {
                Name = "ItemText",
                Text = tostring(it),
                Font = Enum.Font.GothamMedium,
                TextSize = 10,
                TextColor3 = window.Theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -20, 1, 0),
                Parent = itemRow,
            })
        end

        -- Large Bottom Action Button
        if buttonText ~= "" then
            local actionBtn = make("TextButton", {
                Name = "ActionButton",
                Text = buttonText,
                Font = Enum.Font.GothamBold,
                TextSize = 11,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                AutoButtonColor = false,
                BackgroundColor3 = window.Theme.Accent,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 36),
                Parent = card,
            })
            corner(actionBtn, 8)
            addRipple(actionBtn, Color3.fromRGB(255, 255, 255))

            actionBtn.MouseEnter:Connect(function()
                tween(actionBtn, 0.16, { BackgroundColor3 = window.Theme.AccentHover })
            end)
            actionBtn.MouseLeave:Connect(function()
                tween(actionBtn, 0.16, { BackgroundColor3 = window.Theme.Accent })
            end)
            actionBtn.MouseButton1Click:Connect(function()
                task.spawn(callback)
            end)
        end

        local item = {}
        function item:SetVisible(v: boolean) card.Visible = v end
        return item
    end

    function api:Slider(props: { [string]: any })
        props = props or {}
        local min = tonumber(props.Min) or 0
        local max = tonumber(props.Max) or 100
        local value = tonumber(props.Value) or min
        local callback = props.Callback or function() end
        local row = createCoreRow(window, scroll, tostring(props.Title or "Slider"), props.Desc or "", props.Image or "", props.Height or 64)

        local bar = make("Frame", {
            Name = "Bar",
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -14, 0.5, 9),
            Size = UDim2.fromOffset(props.Width or 160, 5),
            BackgroundColor3 = window.Theme.StrokeSoft,
            BorderSizePixel = 0,
            Parent = row,
        })
        corner(bar, 4)

        local fill = make("Frame", {
            Name = "Fill",
            Size = UDim2.fromScale(0, 1),
            BackgroundColor3 = window.Theme.Accent,
            BorderSizePixel = 0,
            Parent = bar,
        })
        corner(fill, 4)

        local numberLabel = make("TextLabel", {
            Name = "Number",
            Text = tostring(value),
            Font = Enum.Font.GothamBold,
            TextSize = 10,
            TextColor3 = window.Theme.Accent,
            TextXAlignment = Enum.TextXAlignment.Right,
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -14, 0.5, -9),
            Size = UDim2.fromOffset(100, 16),
            Parent = row,
        })

        local dragging = false
        local function setValueFromAlpha(alpha: number, fire: boolean?)
            alpha = math.clamp(alpha, 0, 1)
            value = math.floor((min + ((max - min) * alpha)) + 0.5)
            fill.Size = UDim2.fromScale((value - min) / math.max(max - min, 1), 1)
            numberLabel.Text = tostring(value)
            if fire then callback(value) end
        end

        local function fromX(x: number)
            setValueFromAlpha((x - bar.AbsolutePosition.X) / math.max(bar.AbsoluteSize.X, 1), true)
        end

        bar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                fromX(input.Position.X)
            end
        end)
        bar.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                fromX(input.Position.X)
            end
        end)

        setValueFromAlpha((value - min) / math.max(max - min, 1), false)

        local item = {}
        function item:SetValue(v: number)
            value = math.clamp(v, min, max)
            setValueFromAlpha((value - min) / math.max(max - min, 1), false)
        end
        function item:GetValue() return value end
        function item:SetVisible(v: boolean) row.Visible = v end
        return item
    end

    function api:Textbox(props: { [string]: any })
        props = props or {}
        local callback = props.Callback or function() end
        local row = createCoreRow(window, scroll, tostring(props.Title or "Textbox"), props.Desc or "", props.Image or "Textbox", props.Height or 60)

        local box = make("TextBox", {
            Name = "Input",
            Text = tostring(props.Value or ""),
            PlaceholderText = tostring(props.Placeholder or "Enter text"),
            Font = Enum.Font.GothamMedium,
            TextSize = 11,
            TextColor3 = window.Theme.Text,
            PlaceholderColor3 = window.Theme.Muted,
            TextXAlignment = Enum.TextXAlignment.Left,
            ClearTextOnFocus = props.ClearTextOnFocus == true or props.ClearText == true,
            BackgroundColor3 = window.Theme.Sidebar,
            BackgroundTransparency = 0.1,
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -14, 0.5, 0),
            Size = UDim2.fromOffset(props.Width or 150, 28),
            Parent = row,
        })
        corner(box, 7)
        local boxStroke = stroke(box, window.Theme.StrokeSoft, 1, 0.3)
        padding(box, 8, 0, 8, 0)

        box.Focused:Connect(function()
            tween(boxStroke, 0.16, { Color = window.Theme.Accent, Transparency = 0.1 })
        end)
        box.FocusLost:Connect(function(enterPressed)
            tween(boxStroke, 0.16, { Color = window.Theme.StrokeSoft, Transparency = 0.3 })
            callback(box.Text, enterPressed)
        end)

        local item = {}
        function item:SetValue(v: string) box.Text = v end
        function item:GetValue() return box.Text end
        function item:SetPlaceholderText(v: string) box.PlaceholderText = v end
        function item:SetVisible(v: boolean) row.Visible = v end
        return item
    end

    api.Root = scroll
    return api
end

--------------------------------------------------------------------------------
-- 6. Main Window Factory (Reference Core Style)
--------------------------------------------------------------------------------
function Library:Window(props: { [string]: any })
    props = props or {}
    local self = setmetatable({}, Library)
    self.ThemeName = (type(props.Theme) == "string" and props.Theme) or "CoreRed"
    self.Theme = resolveTheme(props.Theme or "CoreRed")
    self.Tabs = {}
    self.SelectedTab = nil
    self.Keybind = (props.Config and props.Config.Keybind) or props.Keybind or Enum.KeyCode.RightControl

    local appTitle = tostring(props.Title or "CORE - v1.0")
    local guiName = props.Name or "CoreUI_Window"
    local existing = getParentGui():FindFirstChild(guiName)
    if existing then existing:Destroy() end

    local screenGui = make("ScreenGui", {
        Name = guiName,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = props.DisplayOrder or 999,
        Parent = getParentGui(),
    })
    if typeof(protectgui) == "function" then
        pcall(protectgui, screenGui)
    elseif typeof(syn) == "table" and typeof((syn :: any).protect_gui) == "function" then
        pcall((syn :: any).protect_gui, screenGui)
    end
    self.ScreenGui = screenGui

    local shadow = make("ImageLabel", {
        Name = "Shadow",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = props.Position or UDim2.fromScale(0.5, 0.5),
        Size = (props.Config and props.Config.Size) or props.Size or UDim2.fromOffset(620, 440),
        BackgroundTransparency = 1,
        Image = Library.Assets.Shadow,
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.4,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(10, 10, 118, 118),
        Parent = screenGui,
    })
    self.Shadow = shadow

    local root = make("Frame", {
        Name = "WindowRoot",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(1, -14, 1, -14),
        BackgroundColor3 = self.Theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = shadow,
    })
    corner(root, 12)
    stroke(root, self.Theme.Stroke, 1.2, 0.15)
    self.Root = root

    ----------------------------------------------------------------------------
    -- Left Sidebar (Reference style)
    ----------------------------------------------------------------------------
    local sidebarWidth = 172
    local sidebar = make("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, sidebarWidth, 1, 0),
        BackgroundColor3 = self.Theme.Sidebar,
        BorderSizePixel = 0,
        Parent = root,
    })
    self.Sidebar = sidebar

    -- Vertical separator line between sidebar and content
    local sideDivider = make("Frame", {
        Name = "SideDivider",
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, 0, 0, 0),
        Size = UDim2.new(0, 1, 1, 0),
        BackgroundColor3 = self.Theme.StrokeSoft,
        BorderSizePixel = 0,
        Parent = sidebar,
    })

    -- Sidebar Header: Logo + App Title
    local sideHeader = make("Frame", {
        Name = "SideHeader",
        Size = UDim2.new(1, 0, 0, 52),
        BackgroundTransparency = 1,
        Parent = sidebar,
    })
    bindDrag(sideHeader, shadow)

    local sideLogoWrap = make("Frame", {
        Name = "SideLogoWrap",
        Position = UDim2.fromOffset(14, 12),
        Size = UDim2.fromOffset(28, 28),
        BackgroundTransparency = 1,
        Parent = sideHeader,
    })
    local sideLogo = createIcon(sideLogoWrap, props.Icon or "ImageLogo", 22, self.Theme.Accent, 0)
    sideLogo.AnchorPoint = Vector2.new(0.5, 0.5)
    sideLogo.Position = UDim2.fromScale(0.5, 0.5)

    local sideAppTitle = make("TextLabel", {
        Name = "AppTitle",
        Text = appTitle,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextColor3 = self.Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(46, 0),
        Size = UDim2.new(1, -50, 1, 0),
        Parent = sideHeader,
    })

    -- Tabs Container (ScrollingFrame with space for profile card at bottom)
    local tabContainer = make("ScrollingFrame", {
        Name = "TabContainer",
        Position = UDim2.fromOffset(0, 52),
        Size = UDim2.new(1, 0, 1, -112),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = self.Theme.Stroke,
        CanvasSize = UDim2.fromOffset(0, 0),
        Parent = sidebar,
    })
    padding(tabContainer, 8, 6, 8, 6)
    local tabLayout = list(tabContainer, 6)
    updateCanvas(tabContainer, tabLayout, 8)

    -- Bottom User Profile Card (Reference Image 1 style)
    local profileCard = make("Frame", {
        Name = "ProfileCard",
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 8, 1, -8),
        Size = UDim2.new(1, -16, 0, 48),
        BackgroundColor3 = self.Theme.Surface,
        BorderSizePixel = 0,
        Parent = sidebar,
    })
    corner(profileCard, 8)
    stroke(profileCard, self.Theme.StrokeSoft, 1, 0.25)

    local pAvatarWrap = make("Frame", {
        Name = "AvatarWrap",
        Position = UDim2.fromOffset(7, 7),
        Size = UDim2.fromOffset(34, 34),
        BackgroundColor3 = self.Theme.Sidebar,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = profileCard,
    })
    corner(pAvatarWrap, 17)
    stroke(pAvatarWrap, self.Theme.Accent, 1, 0.25)

    local pAvatarImage = make("ImageLabel", {
        Name = "Avatar",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(LocalPlayer and LocalPlayer.UserId or 1) .. "&w=100&h=100",
        Parent = pAvatarWrap,
    })

    local pInfoWrap = make("Frame", {
        Name = "InfoWrap",
        Position = UDim2.fromOffset(48, 6),
        Size = UDim2.new(1, -54, 1, -12),
        BackgroundTransparency = 1,
        Parent = profileCard,
    })
    list(pInfoWrap, 2)

    local pUsernameLabel = make("TextLabel", {
        Name = "Username",
        Text = LocalPlayer and LocalPlayer.Name or "User",
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextColor3 = self.Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 15),
        Parent = pInfoWrap,
    })

    local pBadgePill = make("Frame", {
        Name = "BadgePill",
        Size = UDim2.fromOffset(0, 15),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = self.Theme.AccentSoft,
        BorderSizePixel = 0,
        Parent = pInfoWrap,
    })
    corner(pBadgePill, 4)
    padding(pBadgePill, 6, 1, 6, 1)

    local pBadgeText = make("TextLabel", {
        Name = "BadgeText",
        Text = "PREMIUM",
        Font = Enum.Font.GothamBold,
        TextSize = 8,
        TextColor3 = self.Theme.Accent,
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(0, 13),
        AutomaticSize = Enum.AutomaticSize.X,
        Parent = pBadgePill,
    })

    function self:UserProfile(userProps: { [string]: any })
        userProps = userProps or {}
        if userProps.Username then pUsernameLabel.Text = tostring(userProps.Username) end
        if userProps.Badge then pBadgeText.Text = string.upper(tostring(userProps.Badge)) end
        if userProps.AvatarId then
            pAvatarImage.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(userProps.AvatarId) .. "&w=100&h=100"
        end
        return {
            SetUsername = function(_, name: string) pUsernameLabel.Text = name end,
            SetBadge    = function(_, badge: string) pBadgeText.Text = string.upper(badge) end,
            SetAvatar   = function(_, id: number) pAvatarImage.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(id) .. "&w=100&h=100" end,
        }
    end

    ----------------------------------------------------------------------------
    -- Right Content Area
    ----------------------------------------------------------------------------
    local contentArea = make("Frame", {
        Name = "ContentArea",
        Position = UDim2.fromOffset(sidebarWidth, 0),
        Size = UDim2.new(1, -sidebarWidth, 1, 0),
        BackgroundTransparency = 1,
        Parent = root,
    })

    -- Top Header Bar (Breadcrumb + Controls)
    local topBar = make("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 52),
        BackgroundTransparency = 1,
        Parent = contentArea,
    })
    bindDrag(topBar, shadow)

    local breadcrumbWrap = make("Frame", {
        Name = "BreadcrumbWrap",
        Position = UDim2.fromOffset(14, 8),
        Size = UDim2.new(1, -130, 1, -16),
        BackgroundTransparency = 1,
        Parent = topBar,
    })
    list(breadcrumbWrap, 1)

    local breadcrumbLabel = make("TextLabel", {
        Name = "Breadcrumb",
        Text = string.upper(appTitle) .. " // START",
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextColor3 = self.Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 18),
        Parent = breadcrumbWrap,
    })

    local descLabelRef = make("TextLabel", {
        Name = "Subtitle",
        Text = tostring(props.Desc or props.Subtitle or "GAME: TDS"),
        Font = Enum.Font.GothamMedium,
        TextSize = 10,
        TextColor3 = self.Theme.Muted,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 15),
        Parent = breadcrumbWrap,
    })

    -- Top Right Window Action Buttons (Theme / Discord / Close)
    local controls = make("Frame", {
        Name = "Controls",
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -12, 0.5, 0),
        Size = UDim2.fromOffset(88, 28),
        BackgroundTransparency = 1,
        Parent = topBar,
    })
    list(controls, 6, Enum.FillDirection.Horizontal)

    local function makeTopBtn(name: string, icon: string, callback: () -> ())
        local btn = make("ImageButton", {
            Name = name,
            Image = normalizeAsset(icon),
            ImageColor3 = self.Theme.Muted,
            BackgroundColor3 = self.Theme.Surface,
            BackgroundTransparency = 0.2,
            BorderSizePixel = 0,
            Size = UDim2.fromOffset(26, 26),
            AutoButtonColor = false,
            Parent = controls,
        })
        corner(btn, 6)
        stroke(btn, self.Theme.StrokeSoft, 1, 0.3)

        btn.MouseEnter:Connect(function()
            tween(btn, 0.15, { BackgroundTransparency = 0, ImageColor3 = self.Theme.Text })
        end)
        btn.MouseLeave:Connect(function()
            tween(btn, 0.15, { BackgroundTransparency = 0.2, ImageColor3 = self.Theme.Muted })
        end)
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    -- Theme Switcher Button (Cycles through Themes easily!)
    makeTopBtn("ThemeBtn", "Theme", function()
        local currentIdx = table.find(THEME_ORDER, self.ThemeName) or 1
        local nextIdx = (currentIdx % #THEME_ORDER) + 1
        local nextThemeName = THEME_ORDER[nextIdx]
        self:SetTheme(nextThemeName)
        self:Notify({
            Title = "Theme Changed",
            Desc = "Switched theme to: " .. nextThemeName,
            Duration = 2,
        })
    end)

    -- Discord Button
    makeTopBtn("DiscordBtn", "Discord", function()
        if setclipboard then
            pcall(setclipboard, props.DiscordLink or "https://discord.gg")
            self:Notify({
                Title = "Discord Link Copied",
                Desc = "Copied invite link to clipboard!",
                Duration = 2,
            })
        end
    end)

    -- Close Button
    makeTopBtn("CloseBtn", "Close", function()
        screenGui:Destroy()
    end)

    -- Horizontal line below TopBar
    make("Frame", {
        Name = "TopBarDivider",
        Position = UDim2.new(0, 12, 0, 51),
        Size = UDim2.new(1, -24, 0, 1),
        BackgroundColor3 = self.Theme.StrokeSoft,
        BorderSizePixel = 0,
        Parent = contentArea,
    })

    -- Content Pages Container
    local pages = make("Frame", {
        Name = "Pages",
        Position = UDim2.fromOffset(12, 58),
        Size = UDim2.new(1, -24, 1, -66),
        BackgroundTransparency = 1,
        Parent = contentArea,
    })

    ----------------------------------------------------------------------------
    -- Methods: Theme, Title, Subtitle, Tab Selection
    ----------------------------------------------------------------------------
    function self:SetTitle(newTitle: string)
        appTitle = newTitle
        sideAppTitle.Text = newTitle
        if self.SelectedTab then
            breadcrumbLabel.Text = string.upper(appTitle) .. " // " .. string.upper(self.SelectedTab)
        end
    end

    function self:SetSubtitle(newSub: string)
        descLabelRef.Text = newSub
    end
    self.SetSub = self.SetSubtitle

    function self:SetTheme(themeNameOrTable: any)
        self.Theme = resolveTheme(themeNameOrTable)
        if type(themeNameOrTable) == "string" then
            self.ThemeName = themeNameOrTable
        end

        -- Refresh core accents & containers
        root.BackgroundColor3 = self.Theme.Background
        sidebar.BackgroundColor3 = self.Theme.Sidebar
        sideDivider.BackgroundColor3 = self.Theme.StrokeSoft
        sideLogo.ImageColor3 = self.Theme.Accent
        pAvatarWrap.UIStroke.Color = self.Theme.Accent
        pBadgePill.BackgroundColor3 = self.Theme.AccentSoft
        pBadgeText.TextColor3 = self.Theme.Accent

        -- Refresh tabs
        if self.SelectedTab then
            self:SelectTab(self.SelectedTab)
        end
    end

    function self:SelectTab(name: string)
        for tabName, tab in pairs(self.Tabs) do
            local selected = tabName == name
            tab.Page.Visible = selected

            tween(tab.Button, 0.16, {
                BackgroundColor3 = selected and self.Theme.AccentSoft or self.Theme.Sidebar,
                BackgroundTransparency = selected and 0.05 or 0.5,
            })
            if tab.Indicator then
                tween(tab.Indicator, 0.16, {
                    BackgroundTransparency = selected and 0 or 1,
                })
            end
            if tab.TitleLabel then
                tab.TitleLabel.TextColor3 = selected and self.Theme.Text or self.Theme.Muted
            end
            if tab.DescLabel then
                tab.DescLabel.TextColor3 = selected and self.Theme.Accent or Color3.fromRGB(110, 115, 130)
            end
            if tab.Icon then
                tab.Icon.ImageColor3 = selected and self.Theme.Accent or self.Theme.Muted
            end
        end
        self.SelectedTab = name
        breadcrumbLabel.Text = string.upper(appTitle) .. " // " .. string.upper(name)
    end

    ----------------------------------------------------------------------------
    -- Tab Creation (Reference Dual-Line + Left Pill Indicator)
    ----------------------------------------------------------------------------
    function self:Tab(tabProps: { [string]: any })
        tabProps = tabProps or {}
        local name = tostring(tabProps.Title or ("Tab " .. tostring(#self.Tabs + 1)))
        local subDesc = tostring(tabProps.Subtitle or tabProps.Desc or "Currently Active")
        local tabIconAsset = normalizeAsset(tabProps.Icon or "Home")
        local hasTabIcon = tabIconAsset ~= ""

        local tabButton = make("TextButton", {
            Name = "Tab_" .. name,
            Text = "",
            AutoButtonColor = false,
            Size = UDim2.new(1, 0, 0, 42),
            BackgroundColor3 = self.Theme.Sidebar,
            BackgroundTransparency = 0.5,
            BorderSizePixel = 0,
            Parent = tabContainer,
        })
        corner(tabButton, 8)
        addRipple(tabButton, self.Theme.Accent)

        -- Active left edge indicator pill (Reference style!)
        local tabIndicator = make("Frame", {
            Name = "ActiveIndicator",
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, 0, 0.5, 0),
            Size = UDim2.new(0, 3, 0.7, 0),
            BackgroundColor3 = self.Theme.Accent,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Parent = tabButton,
        })
        corner(tabIndicator, 2)

        local tabIcon = createIcon(tabButton, tabIconAsset, 18, self.Theme.Muted, 0.1)
        tabIcon.AnchorPoint = Vector2.new(0, 0.5)
        tabIcon.Position = UDim2.new(0, 12, 0.5, 0)

        local textWrap = make("Frame", {
            Name = "TextWrap",
            Position = UDim2.fromOffset(hasTabIcon and 36 or 12, 5),
            Size = UDim2.new(1, -(hasTabIcon and 42 or 18), 1, -10),
            BackgroundTransparency = 1,
            Parent = tabButton,
        })
        list(textWrap, 1)

        local titleLabel = make("TextLabel", {
            Name = "Title",
            Text = string.upper(name),
            Font = Enum.Font.GothamBold,
            TextSize = 10.5,
            TextColor3 = self.Theme.Muted,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 15),
            Parent = textWrap,
        })

        local descLabel = make("TextLabel", {
            Name = "Desc",
            Text = subDesc,
            Font = Enum.Font.GothamMedium,
            TextSize = 8.5,
            TextColor3 = Color3.fromRGB(110, 115, 130),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 13),
            Parent = textWrap,
        })

        local page = make("ScrollingFrame", {
            Name = "Page_" .. name,
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = self.Theme.Accent,
            CanvasSize = UDim2.fromOffset(0, 0),
            Visible = false,
            Parent = pages,
        })
        padding(page, 0, 0, 4, 0)
        local pageLayout = list(page, 8)
        updateCanvas(page, pageLayout, 18)

        local pageApi = createPageApi(self, page)
        pageApi.Name = name

        self.Tabs[name] = {
            Button      = tabButton,
            Indicator   = tabIndicator,
            TitleLabel  = titleLabel,
            DescLabel   = descLabel,
            Icon        = tabIcon,
            Page        = page,
            Api         = pageApi,
        }

        tabButton.MouseButton1Click:Connect(function()
            self:SelectTab(name)
        end)

        if not self.SelectedTab then
            self:SelectTab(name)
        end

        return pageApi
    end

    ----------------------------------------------------------------------------
    -- Notifications / Toasts
    ----------------------------------------------------------------------------
    function self:Notify(toastProps: { [string]: any })
        toastProps = toastProps or {}
        local toast = make("Frame", {
            Name = "Toast",
            AnchorPoint = Vector2.new(1, 1),
            Position = UDim2.new(1, -14, 1, -14),
            Size = UDim2.fromOffset(260, 64),
            BackgroundColor3 = self.Theme.Surface,
            BackgroundTransparency = 0.05,
            BorderSizePixel = 0,
            ZIndex = 50,
            Parent = root,
        })
        corner(toast, 8)
        stroke(toast, toastProps.Color or self.Theme.Accent, 1, 0.25)
        padding(toast, 12, 8, 12, 8)
        list(toast, 2)

        createText(toast, "ToastTitle", tostring(toastProps.Title or "Notification"), 11, toastProps.Color or self.Theme.Text, true, 1)
        createText(toast, "ToastDesc", tostring(toastProps.Desc or toastProps.Message or ""), 9, self.Theme.Muted, false, 2)

        toast.BackgroundTransparency = 1
        toast.Position = UDim2.new(1, 280, 1, -14)
        tween(toast, 0.2, {
            BackgroundTransparency = 0.05,
            Position = UDim2.new(1, -14, 1, -14),
        })

        task.delay(toastProps.Duration or 3, function()
            if toast.Parent then
                tween(toast, 0.2, {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, 280, 1, -14),
                })
                task.wait(0.22)
                if toast then toast:Destroy() end
            end
        end)
        return toast
    end

    function self:SetVisible(val: boolean)
        shadow.Visible = val
    end

    function self:Destroy()
        screenGui:Destroy()
    end

    -- Toggle keybind listener
    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == self.Keybind then
            shadow.Visible = not shadow.Visible
        end
    end)

    return self
end

return Library
