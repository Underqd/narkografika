--[[
  Dark Anime Style Graphics для Roblox
  Особенности:
  - Тёмная цветовая палитра
  - Розовое аниме-небо
  - Улучшенные тени
  - Стильные пост-эффекты
]]

local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

-- Конфигурация (тёмная тема + розовые акценты)
local config = {
    Enabled = true,
    CelShading = true,
    Outline = true,
    Bloom = true,
    ColorGrading = true,
    AnimeSky = true,
    
    -- Настройки CelShading
    ShadowColor = Color3.fromRGB(50, 50, 80),
    ShadowIntensity = 0.8,
    
    -- Настройки Outline
    OutlineColor = Color3.fromRGB(255, 100, 200), -- Розовая обводка
    OutlineThickness = 0.03,
    
    -- Настройки Bloom
    BloomIntensity = 0.6,
    BloomSize = 24,
    BloomThreshold = 0.8,
    BloomColor = Color3.fromRGB(255, 150, 200), -- Розовый bloom
    
    -- Настройки цвета
    Saturation = 1.1,
    Contrast = 1.15,
    Brightness = -0.1, -- Темнее
    
    -- Настройки неба
    SkyColor = Color3.fromRGB(40, 20, 50),
    AtmosphereColor = Color3.fromRGB(255, 150, 220),
    StarCount = 1000,
    
    -- Настройки освещения
    Ambient = Color3.fromRGB(50, 40, 70),
    OutdoorAmbient = Color3.fromRGB(80, 60, 100),
    ShadowSoftness = 0.3,
    ClockTime = 18 -- Вечернее время
}

-- Применяем настройки освещения
local function applyLighting()
    Lighting.GlobalShadows = true
    Lighting.Brightness = 1.5
    Lighting.OutdoorAmbient = config.OutdoorAmbient
    Lighting.Ambient = config.Ambient
    Lighting.ShadowSoftness = config.ShadowSoftness
    Lighting.ClockTime = config.ClockTime
    Lighting.ExposureCompensation = -0.25
    
    if config.AnimeSky then
        -- Удаляем старое небо
        for _, obj in ipairs(Lighting:GetChildren()) do
            if obj:IsA("Sky") then
                obj:Destroy()
            end
        end
        
        -- Создаём аниме-небо
        local sky = Instance.new("Sky")
        sky.SkyboxBk = "rbxassetid://2710425166"
        sky.SkyboxDn = "rbxassetid://2710425328"
        sky.SkyboxFt = "rbxassetid://2710425166"
        sky.SkyboxLf = "rbxassetid://2710425166"
        sky.SkyboxRt = "rbxassetid://2710425166"
        sky.SkyboxUp = "rbxassetid://2710425475"
        sky.StarCount = config.StarCount
        sky.Parent = Lighting
        
        -- Атмосфера
        local atmo = Instance.new("Atmosphere")
        atmo.Density = 0.3
        atmo.Offset = 0.25
        atmo.Color = config.AtmosphereColor
        atmo.Decay = Color3.fromRGB(100, 50, 120)
        atmo.Glare = 0.1
        atmo.Haze = 0.3
        atmo.Parent = Lighting
    end
end


local function applyPostProcessing()
    for _, effect in ipairs(Lighting:GetChildren()) do
        if effect:IsA("PostEffect") then
            effect:Destroy()
        end
    end

    if config.Bloom then
        local bloom = Instance.new("BloomEffect")
        bloom.Intensity = config.BloomIntensity
        bloom.Size = config.BloomSize
        bloom.Threshold = config.BloomThreshold
        bloom.Color = config.BloomColor
        bloom.Name = "AnimeBloom"
        bloom.Parent = Lighting
    end

    if config.ColorGrading then
        local colorCorrection = Instance.new("ColorCorrectionEffect")
        colorCorrection.Saturation = config.Saturation
        colorCorrection.Contrast = config.Contrast
        colorCorrection.Brightness = config.Brightness
        colorCorrection.TintColor = Color3.fromRGB(255, 220, 230) -- Лёгкий розовый оттенок
        colorCorrection.Name = "AnimeColorCorrection"
        colorCorrection.Parent = Lighting
    end
    
    local fog = Instance.new("FogEffect")
    fog.Color = Color3.fromRGB(80, 60, 100)
    fog.Start = 50
    fog.End = 500
    fog.Parent = Lighting
end

local function applyCelShading(character)
    if not character then return end
    
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Material = Enum.Material.SmoothPlastic
            
            if config.CelShading then
                local shading = part:FindFirstChild("AnimeShading") or Instance.new("SurfaceAppearance")
                shading.Name = "AnimeShading"
                shading.ColorMap = part.Color
                shading.MetalnessMap = "rbxassetid://0"
                shading.RoughnessMap = "rbxassetid://0"
                shading.NormalMap = "rbxassetid://0"
                shading.ShadingModel = Enum.ShadingModel.ForceField
                shading.Parent = part
            end
        end
    end
end


local function applyOutline(character)
    if not character or not config.Outline then return end
    
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            local outline = part:FindFirstChild("AnimeOutline") or Instance.new("SelectionBox")
            outline.Name = "AnimeOutline"
            outline.Adornee = part
            outline.LineThickness = config.OutlineThickness
            outline.Color3 = config.OutlineColor
            outline.Transparency = 0.15
            outline.Parent = part
        end
    end
end

-- UI панель (тёмная тема)
local function createUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "DarkAnimeGraphicsUI"
    ScreenGui.Parent = game:GetService("CoreGui")
    
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0.22, 0, 0.55, 0)
    Frame.Position = UDim2.new(0.01, 0, 0.2, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 15, 30)
    Frame.BackgroundTransparency = 0.15
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui
    
    local title = Instance.new("TextLabel")
    title.Text = "DARK ANIME STYLE"
    title.Size = UDim2.new(1, 0, 0.08, 0)
    title.Font = Enum.Font.GothamBold
    title.TextColor3 = Color3.fromRGB(255, 120, 200)
    title.BackgroundTransparency = 1
    title.Parent = Frame
    
    local yPos = 0.1
    local function createToggle(name, property)
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Size = UDim2.new(1, 0, 0.075, 0)
        toggleFrame.Position = UDim2.new(0, 0, yPos, 0)
        toggleFrame.BackgroundTransparency = 1
        toggleFrame.Parent = Frame
        
        local label = Instance.new("TextLabel")
        label.Text = name
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.Font = Enum.Font.Gotham
        label.TextColor3 = Color3.fromRGB(220, 180, 240)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.BackgroundTransparency = 1
        label.Parent = toggleFrame
        
        local toggle = Instance.new("TextButton")
        toggle.Size = UDim2.new(0.2, 0, 0.7, 0)
        toggle.Position = UDim2.new(0.75, 0, 0.15, 0)
        toggle.Text = config[property] and "ON" or "OFF"
        toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggle.BackgroundColor3 = config[property] and Color3.fromRGB(255, 100, 200) or Color3.fromRGB(80, 60, 100)
        toggle.BorderSizePixel = 0
        toggle.Font = Enum.Font.GothamMedium
        toggle.Parent = toggleFrame
        
        toggle.MouseButton1Click:Connect(function()
            config[property] = not config[property]
            toggle.Text = config[property] and "ON" or "OFF"
            toggle.BackgroundColor3 = config[property] and Color3.fromRGB(255, 100, 200) or Color3.fromRGB(80, 60, 100)
            setupGraphics()
        end)
        
        yPos = yPos + 0.075
    end
    
    -- Создаём переключатели
    createToggle("Cel Shading", "CelShading")
    createToggle("Character Outline", "Outline")
    createToggle("Bloom Effect", "Bloom")
    createToggle("Color Grading", "ColorGrading")
    createToggle("Anime Skybox", "AnimeSky")
    
    return ScreenGui
end

local function setupGraphics()
    applyLighting()
    applyPostProcessing()
    
    -- Обработка персонажей
    local function processCharacter(character)
        applyCelShading(character)
        applyOutline(character)
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            processCharacter(player.Character)
        end
        player.CharacterAdded:Connect(processCharacter)
    end

    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(processCharacter)
    end)
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F5 then
        local ui = game:GetService("CoreGui"):FindFirstChild("DarkAnimeGraphicsUI")
        if ui then
            ui:Destroy()
        else
            createUI()
        end
    end
end)

local animeNotify = function()
    local gui = Instance.new("ScreenGui")
    local frame = Instance.new("Frame")
    local text = Instance.new("TextLabel")
    
    gui.Name = "AnimeSoundNotify"
    gui.Parent = game.CoreGui
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    frame.Parent = gui
    frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    frame.Position = UDim2.new(0.5, -150, 1, -60)
    frame.Size = UDim2.new(0, 300, 0, 40)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    
    text.Parent = frame
    text.Text = "ENB IN"
    text.TextColor3 = Color3.fromRGB(255, 155, 155)
    text.TextScaled = true
    text.Font = Enum.Font.GothamBold
    text.BackgroundTransparency = 1
    text.Size = UDim2.new(1, 0, 1, 0)
    
    -- Анимация появления
    frame:TweenPosition(UDim2.new(0.5, -150, 1, -100), "Out", "Quad", 0.5, true)
    
    wait(4)
    
    -- Анимация исчезновения
    frame:TweenPosition(UDim2.new(0.5, -150, 1, -60), "In", "Quad", 0.5, true)
    wait(0.5)
    gui:Destroy()
end

setupGraphics()

if setupGraphics then
  animeNotify()
end

print("Dark Anime Style loaded! Press F5 to open settings")
