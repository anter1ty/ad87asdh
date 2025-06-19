-- Настройки
local menuTitle = "OmniSEX"
local toggleKey = Enum.KeyCode.Insert
local defaultWalkSpeed = 16
local autoShowMenu = true
local espEnabled = false
local spinEnabled = false
local spinSpeed = 10
local espColor = Color3.new(1, 1, 1)
local godModeEnabled = false
local lastSpeedChange = 0
local speedCooldown = 0.5
local antiDetectEnabled = false

-- Создаем индикатор загрузки
local loadingGui = Instance.new("ScreenGui")
loadingGui.Name = "LoadingIndicator"
loadingGui.Parent = game:GetService("CoreGui")

local loadingText = Instance.new("TextLabel")
loadingText.Text = "Идет загрузка скрипта OMNI..."
loadingText.Size = UDim2.new(0, 200, 0, 30)
loadingText.Position = UDim2.new(0, 10, 0, 10)
loadingText.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
loadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
loadingText.Font = Enum.Font.GothamBold
loadingText.TextSize = 14
loadingText.TextXAlignment = Enum.TextXAlignment.Left
loadingText.Parent = loadingGui

-- Основной интерфейс
local player = game:GetService("Players").LocalPlayer
local TweenService = game:GetService("TweenService")
local gui = Instance.new("ScreenGui")
gui.Name = "CXNT_Menu"
gui.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 600, 0, 600)
frame.Position = UDim2.new(0.5, -300, 0.5, -300)
frame.BackgroundColor3 = Color3.fromRGB(19, 19, 19)
frame.BorderSizePixel = 0
frame.Visible = false
frame.Parent = gui

-- Добавляем скругленные углы
local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 12)
frameCorner.Parent = frame

-- Добавляем обводку
local frameStroke = Instance.new("UIStroke")
frameStroke.Color = Color3.fromRGB(255, 0, 0)
frameStroke.Thickness = 2
frameStroke.Transparency = 0.3
frameStroke.Parent = frame

-- Добавляем тень с улучшенным эффектом
local shadow = Instance.new("Frame")
shadow.Size = UDim2.new(1, 20, 1, 20)
shadow.Position = UDim2.new(0, -10, 0, -10)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.7
shadow.BorderSizePixel = 0
shadow.ZIndex = frame.ZIndex - 1
shadow.Parent = gui

local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 12)
shadowCorner.Parent = shadow

-- Add gradient accent bar at top
local accentBar = Instance.new("Frame")
accentBar.Size = UDim2.new(1, 0, 0, 4)
accentBar.Position = UDim2.new(0, 0, 0, 0)
accentBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
accentBar.BorderSizePixel = 0
accentBar.Parent = frame

local accentCorner = Instance.new("UICorner")
accentCorner.CornerRadius = UDim.new(0, 12)
accentCorner.Parent = accentBar

-- Добавляем градиент к акцентной полосе
local accentGradient = Instance.new("UIGradient")
accentGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 100, 100)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
}
accentGradient.Parent = accentBar

-- Добавляем часы МСК
local timeLabel = Instance.new("TextLabel")
timeLabel.Size = UDim2.new(0, 120, 0, 20)
timeLabel.Position = UDim2.new(1, -130, 0, 5)
timeLabel.BackgroundTransparency = 1
timeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
timeLabel.Font = Enum.Font.GothamBold
timeLabel.TextSize = 14
timeLabel.TextXAlignment = Enum.TextXAlignment.Right
timeLabel.Parent = frame

-- Обновление времени
spawn(function()
    while wait(1) do
        local time = os.date("!*t")
        timeLabel.Text = string.format("", time.hour + 3, time.min, time.sec)
    end
end)

-- Красивый watermark с улучшенным дизайном
local watermark = Instance.new("TextLabel")
watermark.Text = "⚡ OMNI V3 ⚡"
watermark.Size = UDim2.new(0, 300, 0, 40)
watermark.Position = UDim2.new(0, 10, 0, 0)
watermark.BackgroundTransparency = 1
watermark.Font = Enum.Font.GothamBold
watermark.TextSize = 20
watermark.TextXAlignment = Enum.TextXAlignment.Left
watermark.TextStrokeTransparency = 0
watermark.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
watermark.Parent = gui

-- Скругленные углы для watermark
local watermarkCorner = Instance.new("UICorner")
watermarkCorner.CornerRadius = UDim.new(0, 8)
watermarkCorner.Parent = watermark

-- Расширенная цветовая палитра
local gradientColors = {
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 127)),   -- Розовый
    ColorSequenceKeypoint.new(0.15, Color3.fromRGB(255, 0, 0)),  -- Красный
    ColorSequenceKeypoint.new(0.3, Color3.fromRGB(255, 127, 0)), -- Оранжевый
    ColorSequenceKeypoint.new(0.45, Color3.fromRGB(255, 255, 0)), -- Желтый
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0, 255, 0)),   -- Зеленый
    ColorSequenceKeypoint.new(0.75, Color3.fromRGB(0, 127, 255)), -- Голубой
    ColorSequenceKeypoint.new(0.9, Color3.fromRGB(127, 0, 255)), -- Фиолетовый
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 255))    -- Пурпурный
}

local uiGradient = Instance.new("UIGradient")
uiGradient.Color = ColorSequence.new(gradientColors)
uiGradient.Parent = watermark

-- Плавная анимация градиента с переливами
local gradientOffset = 0
local gradientRotation = 0
game:GetService("RunService").RenderStepped:Connect(function()
    gradientOffset = (gradientOffset + 0.004) % 2
    gradientRotation = (gradientRotation + 0.5) % 360

    -- Плавное движение градиента
    uiGradient.Offset = Vector2.new(math.sin(gradientOffset * math.pi) * 0.5, 0)
    uiGradient.Rotation = gradientRotation

    -- Добавляем пульсацию размера текста
    local pulse = 20 + math.sin(tick() * 2) * 2
    watermark.TextSize = pulse
end)

-- Добавляем эффект свечения
local glowEffect = Instance.new("Frame")
glowEffect.Size = UDim2.new(1, 10, 1, 10)
glowEffect.Position = UDim2.new(0, -5, 0, -5)
glowEffect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
glowEffect.BackgroundTransparency = 0.9
glowEffect.BorderSizePixel = 0
glowEffect.ZIndex = watermark.ZIndex - 1
glowEffect.Parent = watermark

local glowCorner = Instance.new("UICorner")
glowCorner.CornerRadius = UDim.new(0, 12)
glowCorner.Parent = glowEffect

-- Анимация свечения
spawn(function()
    while wait(0.1) do
        local glow = 0.9 + math.sin(tick() * 3) * 0.1
        glowEffect.BackgroundTransparency = glow
    end
end)

-- MSK Time в левом нижнем углу с красивым дизайном
local mskTimeFrame = Instance.new("Frame")
mskTimeFrame.Size = UDim2.new(0, 200, 0, 50)
mskTimeFrame.Position = UDim2.new(0, 10, 1, -60)
mskTimeFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mskTimeFrame.BackgroundTransparency = 0.3
mskTimeFrame.BorderSizePixel = 0
mskTimeFrame.Parent = gui

-- Скругленные углы для времени
local timeCorner = Instance.new("UICorner")
timeCorner.CornerRadius = UDim.new(0, 12)
timeCorner.Parent = mskTimeFrame

-- Обводка для времени
local timeStroke = Instance.new("UIStroke")
timeStroke.Color = Color3.fromRGB(255, 0, 0)
timeStroke.Thickness = 2
timeStroke.Transparency = 0.4
timeStroke.Parent = mskTimeFrame

-- Градиент для фона времени
local timeGradient = Instance.new("UIGradient")
timeGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 15))
}
timeGradient.Rotation = 45
timeGradient.Parent = mskTimeFrame

local mskTime = Instance.new("TextLabel")
mskTime.Size = UDim2.new(1, 0, 1, 0)
mskTime.Position = UDim2.new(0, 0, 0, 0)
mskTime.BackgroundTransparency = 1
mskTime.TextColor3 = Color3.fromRGB(255, 255, 255)
mskTime.Font = Enum.Font.GothamBold
mskTime.TextSize = 18
mskTime.TextXAlignment = Enum.TextXAlignment.Center
mskTime.TextYAlignment = Enum.TextYAlignment.Center
mskTime.TextStrokeTransparency = 0
mskTime.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
mskTime.Parent = mskTimeFrame

-- Иконка часов
local clockIcon = Instance.new("TextLabel")
clockIcon.Size = UDim2.new(0, 20, 0, 20)
clockIcon.Position = UDim2.new(0, 10, 0, 15)
clockIcon.BackgroundTransparency = 1
clockIcon.Text = "🕒"
clockIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
clockIcon.Font = Enum.Font.GothamBold
clockIcon.TextSize = 16
clockIcon.TextXAlignment = Enum.TextXAlignment.Center
clockIcon.TextYAlignment = Enum.TextYAlignment.Center
clockIcon.Parent = mskTimeFrame

-- Обновление времени с красивой анимацией
spawn(function()
    while wait(1) do
        local time = os.date("!*t")
        local hours = (time.hour + 3) % 24
        local timeString = string.format("МСК %02d:%02d:%02d", hours, time.min, time.sec)
        
        -- Анимация изменения цвета при обновлении
        local originalColor = mskTime.TextColor3
        mskTime.TextColor3 = Color3.fromRGB(255, 100, 100)
        mskTime.Text = timeString
        
        -- Возвращаем обычный цвет
        wait(0.1)
        mskTime.TextColor3 = originalColor
        
        -- Анимация пульсации обводки
        local pulseTween = game:GetService("TweenService"):Create(
            timeStroke,
            TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {Transparency = 0.1}
        )
        pulseTween:Play()
        
        wait(0.5)
        
        local pulseTween2 = game:GetService("TweenService"):Create(
            timeStroke,
            TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {Transparency = 0.4}
        )
        pulseTween2:Play()
    end
end)

local title = Instance.new("TextLabel")
title.Text = menuTitle
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 10)
title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.BorderSizePixel = 0
title.Parent = frame

-- Скругленные углы для заголовка
local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = title

-- Обводка для заголовка
local titleStroke = Instance.new("UIStroke")
titleStroke.Color = Color3.fromRGB(255, 0, 0)
titleStroke.Thickness = 1
titleStroke.Transparency = 0.5
titleStroke.Parent = title



-- Функция для создания стилизованных кнопок
local function createStyledButton(text, size, position, parent)
    local button = Instance.new("TextButton")
    button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.GothamSemibold
    button.TextSize = 14
    button.BorderSizePixel = 0
    button.AutoButtonColor = false
    button.Text = text
    button.Size = size
    button.Position = position
    button.Parent = parent

    -- Скругленные углы
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button

    -- Обводка
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 0, 0)
    stroke.Thickness = 1
    stroke.Transparency = 0.6
    stroke.Parent = button

    -- Анимации при наведении
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        }):Play()
        TweenService:Create(stroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            Transparency = 0.2
        }):Play()
    end)

    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        }):Play()
        TweenService:Create(stroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            Transparency = 0.6
        }):Play()
    end)

    return button
end

-- Sky Customization
local skyButton = createStyledButton("SKY: DEFAULT", UDim2.new(0.4, -10, 0, 30), UDim2.new(0, 10, 0, 420), frame)
skyButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
skyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
skyButton.Font = Enum.Font.GothamSemibold
skyButton.TextSize = 14
skyButton.BorderSizePixel = 0
skyButton.AutoButtonColor = true

-- Add rounded corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = skyButton

-- Add hover effect
local originalColor = skyButton.BackgroundColor3
skyButton.MouseEnter:Connect(function()
    skyButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
end)
skyButton.MouseLeave:Connect(function()
    skyButton.BackgroundColor3 = originalColor
end)
skyButton.Text = "SKY: DEFAULT"
skyButton.Size = UDim2.new(0.4, -10, 0, 20)
skyButton.Position = UDim2.new(0, 10, 0, 420)
skyButton.Parent = frame

local currentSkyStyle = "DEFAULT"
local skyStyles = {
    ["RAINY_PARADISE"] = function()
        local lighting = game:GetService("Lighting")
        local sky = Instance.new("Sky")
        sky.Name = "CXNT_Sky"
        sky.SkyboxBk = "rbxassetid://8107841671"
        sky.SkyboxDn = "rbxassetid://8107841671"
        sky.SkyboxFt = "rbxassetid://8107841671"
        sky.SkyboxLf = "rbxassetid://8107841671"
        sky.SkyboxRt = "rbxassetid://8107841671"
        sky.SkyboxUp = "rbxassetid://8107841671"
        sky.Parent = lighting

        -- Configure lighting for rain effect
        lighting.ClockTime = 7
        lighting.Ambient = Color3.fromRGB(100, 100, 120)
        lighting.FogEnd = 1000
        lighting.FogStart = 0
        lighting.FogColor = Color3.fromRGB(192, 192, 192)

        -- Create rain particles
        local rainPart = Instance.new("Part")
        rainPart.Size = Vector3.new(1, 1, 1)
        rainPart.Transparency = 1
        rainPart.Anchored = true
        rainPart.CanCollide = false
        rainPart.Position = workspace.CurrentCamera.CFrame.Position + Vector3.new(0, 50, 0)
        rainPart.Parent = workspace

        local rain = Instance.new("ParticleEmitter")
        rain.Rate = 700
        rain.Speed = NumberRange.new(50, 70)
        rain.Velocity = Vector3.new(2, -50, 0)
        rain.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.1),
            NumberSequenceKeypoint.new(1, 0.1)
        })
        rain.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.7),
            NumberSequenceKeypoint.new(1, 0.7)
        })
        rain.Lifetime = NumberRange.new(1, 2)
        rain.SpreadAngle = Vector2.new(15, 15)
        rain.Texture = "rbxasset://textures/particles/sparkles_main.dds"
        rain.Color = ColorSequence.new(Color3.fromRGB(200, 200, 255))
        rain.Parent = rainPart

        -- Add thunder and rain sounds
        local thunderSound = Instance.new("Sound")
        thunderSound.SoundId = "rbxassetid://1255922107"
        thunderSound.Volume = 0.5
        thunderSound.Parent = workspace

        local rainSound = Instance.new("Sound")
        rainSound.SoundId = "rbxassetid://3381417815"
        rainSound.Volume = 0.3
        rainSound.Looped = true
        rainSound.Parent = workspace
        rainSound:Play()

        -- Thunder effect
        spawn(function()
            while wait(math.random(10, 30)) do
                if lighting:FindFirstChild("CXNT_Sky") then
                    lighting.Ambient = Color3.fromRGB(200, 200, 220)
                    thunderSound:Play()
                    wait(0.1)
                    lighting.Ambient = Color3.fromRGB(100, 100, 120)
                else
                    break
                end
            end
        end)
    end,
    ["DEFAULT"] = function()
        local lighting = game:GetService("Lighting")
        lighting.ClockTime = 14
        lighting.Ambient = Color3.fromRGB(200, 200, 200)
        if lighting:FindFirstChild("CXNT_Sky") then
            lighting.CXNT_Sky:Destroy()
        end
    end,
    ["DARK_RED_MOON"] = function()
        local lighting = game:GetService("Lighting")
        local sky = Instance.new("Sky")
        sky.Name = "CXNT_Sky"
        sky.SkyboxBk = "rbxassetid://12064107"
        sky.SkyboxDn = "rbxassetid://12064152"
        sky.SkyboxFt = "rbxassetid://12064121"
        sky.SkyboxLf = "rbxassetid://12063984"
        sky.SkyboxRt = "rbxassetid://12064115"
        sky.SkyboxUp = "rbxassetid://12064131"
        sky.Parent = lighting
        lighting.ClockTime = 0
        lighting.Ambient = Color3.fromRGB(199, 0, 0)
    end,
    ["BLUE_SKY"] = function()
        local lighting = game:GetService("Lighting")
        local sky = Instance.new("Sky")
        sky.Name = "CXNT_Sky"
        sky.SkyboxBk = "rbxassetid://226060119"
        sky.SkyboxDn = "rbxassetid://226060119"
        sky.SkyboxFt = "rbxassetid://226060119"
        sky.SkyboxLf = "rbxassetid://226060119"
        sky.SkyboxRt = "rbxassetid://226060119"
        sky.SkyboxUp = "rbxassetid://226060119"
        sky.Parent = lighting
        lighting.ClockTime = 14
        lighting.Ambient = Color3.fromRGB(100, 150, 255)
    end,
    ["GOLDEN_HOUR"] = function()
        local lighting = game:GetService("Lighting")
        local sky = Instance.new("Sky")
        sky.Name = "CXNT_Sky"
        sky.SkyboxBk = "rbxassetid://271042516"
        sky.SkyboxDn = "rbxassetid://271077243"
        sky.SkyboxFt = "rbxassetid://271042556"
        sky.SkyboxLf = "rbxassetid://271042310"
        sky.SkyboxRt = "rbxassetid://271042467"
        sky.SkyboxUp = "rbxassetid://271077958"
        sky.Parent = lighting
        lighting.ClockTime = 17.5
        lighting.Ambient = Color3.fromRGB(255, 200, 100)
    end,
    ["DRAIN"] = function()
        local lighting = game:GetService("Lighting")
        local sky = Instance.new("Sky")
        sky.Name = "CXNT_Sky"
        sky.SkyboxBk = "rbxassetid://8107841671"
        sky.SkyboxDn = "rbxassetid://8107841671"
        sky.SkyboxFt = "rbxassetid://8107841671"
        sky.SkyboxLf = "rbxassetid://8107841671"
        sky.SkyboxRt = "rbxassetid://8107841671"
        sky.SkyboxUp = "rbxassetid://8107841671"
        sky.Parent = lighting
        lighting.ClockTime = 14.5
        lighting.Ambient = Color3.fromRGB(150, 150, 150)
    end,
    ["BRIGHT"] = function()
        local lighting = game:GetService("Lighting")
        local sky = Instance.new("Sky")
        sky.Name = "CXNT_Sky"
        sky.SkyboxBk = "rbxassetid://13103737"
        sky.SkyboxDn = "rbxassetid://13103737"
        sky.SkyboxFt = "rbxassetid://13103737"
        sky.SkyboxLf = "rbxassetid://13103737"
        sky.SkyboxRt = "rbxassetid://13103737"
        sky.SkyboxUp = "rbxassetid://13103737"
        sky.Parent = lighting
        lighting.ClockTime = 14
        lighting.Ambient = Color3.fromRGB(255, 255, 255)
    end,
    ["NIGHT_STARS"] = function()
        local lighting = game:GetService("Lighting")
        local sky = Instance.new("Sky")
        sky.Name = "CXNT_Sky"
        sky.SkyboxBk = "rbxassetid://149397692"
        sky.SkyboxDn = "rbxassetid://149397686"
        sky.SkyboxFt = "rbxassetid://149397697"
        sky.SkyboxLf = "rbxassetid://149397684"
        sky.SkyboxRt = "rbxassetid://149397688"
        sky.SkyboxUp = "rbxassetid://149397702"
        sky.Parent = lighting
        lighting.ClockTime = 3
        lighting.Ambient = Color3.fromRGB(30, 30, 50)
    end,
    ["SUNSET"] = function()
        local lighting = game:GetService("Lighting")
        local sky = Instance.new("Sky")
        sky.Name = "CXNT_Sky"
        sky.SkyboxBk = "rbxassetid://323494035"
        sky.SkyboxDn = "rbxassetid://323494368"
        sky.SkyboxFt = "rbxassetid://323494130"
        sky.SkyboxLf = "rbxassetid://323494252"
        sky.SkyboxRt = "rbxassetid://323494067"
        sky.SkyboxUp = "rbxassetid://323493360"
        sky.Parent = lighting
        lighting.ClockTime = 17
        lighting.Ambient = Color3.fromRGB(255, 200, 150)
    end,
    ["ANIME_SKY"] = function()
        local lighting = game:GetService("Lighting")
        local sky = Instance.new("Sky")
        sky.Name = "CXNT_Sky"
        sky.SkyboxBk = "rbxassetid://6444884337"
        sky.SkyboxDn = "rbxassetid://6444884785"
        sky.SkyboxFt = "rbxassetid://6444884337"
        sky.SkyboxLf = "rbxassetid://6444884337"
        sky.SkyboxRt = "rbxassetid://6444884337"
        sky.SkyboxUp = "rbxassetid://6444884785"
        sky.Parent = lighting
        lighting.ClockTime = 14
        lighting.Ambient = Color3.fromRGB(255, 255, 255)
        lighting.Brightness = 2
        lighting.ColorShift_Top = Color3.fromRGB(255, 235, 235)
    end,
    ["EMERALD_SKY"] = function()
        local lighting = game:GetService("Lighting")
        local sky = Instance.new("Sky")
        sky.Name = "CXNT_Sky"
        sky.SkyboxBk = "rbxassetid://5420247395"
        sky.SkyboxDn = "rbxassetid://5420247395"
        sky.SkyboxFt = "rbxassetid://5420247395"
        sky.SkyboxLf = "rbxassetid://5420247395"
        sky.SkyboxRt = "rbxassetid://5420247395"
        sky.SkyboxUp = "rbxassetid://5420247395"
        sky.Parent = lighting
        lighting.ClockTime = 14
        lighting.Ambient = Color3.fromRGB(100, 255, 150)
    end,
    ["SUNSET_PARADISE"] = function()
        local lighting = game:GetService("Lighting")
        local sky = Instance.new("Sky")
        sky.Name = "CXNT_Sky"
        sky.SkyboxBk = "rbxassetid://600830446"
        sky.SkyboxDn = "rbxassetid://600831635"
        sky.SkyboxFt = "rbxassetid://600832720"
        sky.SkyboxLf = "rbxassetid://600886090"
        sky.SkyboxRt = "rbxassetid://600833862"
        sky.SkyboxUp = "rbxassetid://600835177"
        sky.Parent = lighting
        lighting.ClockTime = 17.8
        lighting.Ambient = Color3.fromRGB(255, 150, 100)
    end,

    ["PINK_SKY"] = function()
        local lighting = game:GetService("Lighting")
        local sky = Instance.new("Sky")
        sky.Name = "CXNT_Sky"
        sky.SkyboxBk = "rbxassetid://8202961731"
        sky.SkyboxDn = "rbxassetid://8202961731"
        sky.SkyboxFt = "rbxassetid://8202961731"
        sky.SkyboxLf = "rbxassetid://8202961731"
        sky.SkyboxRt = "rbxassetid://8202961731"
        sky.SkyboxUp = "rbxassetid://8202961731"
        sky.Parent = lighting
        lighting.ClockTime = 14
        lighting.Ambient = Color3.fromRGB(255, 192, 203)
    end,

    ["NIGHT_SKY_GALAXY"] = function()
        local lighting = game:GetService("Lighting")
        local sky = Instance.new("Sky")
        sky.Name = "CXNT_Sky"
        sky.SkyboxBk = "rbxassetid://15983996673"
        sky.SkyboxDn = "rbxassetid://15983996673"
        sky.SkyboxFt = "rbxassetid://15983996673"
        sky.SkyboxLf = "rbxassetid://15983996673"
        sky.SkyboxRt = "rbxassetid://15983996673"
        sky.SkyboxUp = "rbxassetid://15983996673"
        sky.Parent = lighting
        lighting.ClockTime = 0
        lighting.Ambient = Color3.fromRGB(20, 20, 40)
    end,

    ["LUCID_DREAMS"] = function()
        local lighting = game:GetService("Lighting")
        local sky = Instance.new("Sky")
        sky.Name = "CXNT_Sky"
        sky.SkyboxBk = "rbxassetid://8508116305"
        sky.SkyboxDn = "rbxassetid://8508116305"
        sky.SkyboxFt = "rbxassetid://8508116305"
        sky.SkyboxLf = "rbxassetid://8508116305"
        sky.SkyboxRt = "rbxassetid://8508116305"
        sky.SkyboxUp = "rbxassetid://8508116305"
        sky.Parent = lighting
        lighting.ClockTime = 14
        lighting.Ambient = Color3.fromRGB(150, 120, 255)
    end,

    ["MEME"] = function()
        local lighting = game:GetService("Lighting")
        local sky = Instance.new("Sky")
        sky.Name = "CXNT_Sky"
        sky.SkyboxBk = "rbxassetid://8668486438"
        sky.SkyboxDn = "rbxassetid://8668486438"
        sky.SkyboxFt = "rbxassetid://8668486438"
        sky.SkyboxLf = "rbxassetid://8668486438"
        sky.SkyboxRt = "rbxassetid://8668486438"
        sky.SkyboxUp = "rbxassetid://8668486438"
        sky.Parent = lighting
        lighting.ClockTime = 14
        lighting.Ambient = Color3.fromRGB(255, 255, 255)
    end,

    ["REALISTIC_V2"] = function()
        local lighting = game:GetService("Lighting")
        local sky = Instance.new("Sky")
        sky.Name = "CXNT_Sky"
        sky.SkyboxBk = "rbxassetid://8790041926"
        sky.SkyboxDn = "rbxassetid://8790041926"
        sky.SkyboxFt = "rbxassetid://8790041926"
        sky.SkyboxLf = "rbxassetid://8790041926"
        sky.SkyboxRt = "rbxassetid://8790041926"
        sky.SkyboxUp = "rbxassetid://8790041926"
        sky.Parent = lighting
        lighting.ClockTime = 14
        lighting.Ambient = Color3.fromRGB(255, 255, 255)
    end,

    ["OPIUM"] = function()
        local lighting = game:GetService("Lighting")
        local sky = Instance.new("Sky")
        sky.Name = "CXNT_Sky"
        sky.SkyboxBk = "rbxassetid://8107841671"
        sky.SkyboxDn = "rbxassetid://8107841671"
        sky.SkyboxFt = "rbxassetid://8107841671"
        sky.SkyboxLf = "rbxassetid://8107841671"
        sky.SkyboxRt = "rbxassetid://8107841671"
        sky.SkyboxUp = "rbxassetid://8107841671"
        sky.Parent = lighting

        lighting.ClockTime = 2
        lighting.Ambient = Color3.fromRGB(128, 0, 128)
        lighting.FogEnd = 500
        lighting.FogStart = 0
        lighting.FogColor = Color3.fromRGB(75, 0, 130)

        -- Add purple haze effect
        local atmosphere = Instance.new("Atmosphere")
        atmosphere.Density = 0.3
        atmosphere.Offset = 0.25
        atmosphere.Color = Color3.fromRGB(128, 0, 128)
        atmosphere.Decay = Color3.fromRGB(106, 0, 106)
        atmosphere.Glare = 0.3
        atmosphere.Haze = 2
        atmosphere.Parent = lighting

        -- Add bloom effect
        local bloom = Instance.new("BloomEffect")
        bloom.Intensity = 1
        bloom.Size = 24
        bloom.Threshold = 0.5
        bloom.Parent = lighting

        -- Add color correction
        local colorCorrection = Instance.new("ColorCorrectionEffect")
        colorCorrection.Brightness = 0.05
        colorCorrection.Contrast = 0.15
        colorCorrection.Saturation = 0.25
        colorCorrection.TintColor = Color3.fromRGB(200, 150, 255)
        colorCorrection.Parent = lighting
    end,
    ["PURPLE_NEBULA"] = function()
        local lighting = game:GetService("Lighting")
        local sky = Instance.new("Sky")
        sky.Name = "CXNT_Sky"
        sky.SkyboxBk = "rbxassetid://159454286"
        sky.SkyboxDn = "rbxassetid://159454296"
        sky.SkyboxFt = "rbxassetid://159454286"
        sky.SkyboxLf = "rbxassetid://159454293"
        sky.SkyboxRt = "rbxassetid://159454293"
        sky.SkyboxUp = "rbxassetid://159454288"
        sky.Parent = lighting
        lighting.ClockTime = 14
        lighting.Ambient = Color3.fromRGB(128, 0, 255)
    end,
    ["VAPORWAVE"] = function()
        local lighting = game:GetService("Lighting")
        local sky = Instance.new("Sky")
        sky.Name = "CXNT_Sky"
        sky.SkyboxBk = "rbxassetid://1417494402"
        sky.SkyboxDn = "rbxassetid://1417494643"
        sky.SkyboxFt = "rbxassetid://1417494402"
        sky.SkyboxLf = "rbxassetid://1417494402"
        sky.SkyboxRt = "rbxassetid://1417494402"
        sky.SkyboxUp = "rbxassetid://1417494643"
        sky.Parent = lighting
        lighting.ClockTime = 14
        lighting.Ambient = Color3.fromRGB(255, 100, 255)
    end,
    ["SPACE"] = function()
        local lighting = game:GetService("Lighting")
        local sky = Instance.new("Sky")
        sky.Name = "CXNT_Sky"
        sky.SkyboxBk = "rbxassetid://149397692"
        sky.SkyboxDn = "rbxassetid://149397686"
        sky.SkyboxFt = "rbxassetid://149397697"
        sky.SkyboxLf = "rbxassetid://149397684"
        sky.SkyboxRt = "rbxassetid://149397688"
        sky.SkyboxUp = "rbxassetid://149397702"
        sky.Parent = lighting
        lighting.ClockTime = 0
        lighting.Ambient = Color3.fromRGB(0, 0, 128)
    end
}

-- Кнопка ESP
local espButton = createStyledButton("ESP: OFF", UDim2.new(0.4, -10, 0, 30), UDim2.new(0, 10, 0, 90), frame)

local itemEspButton = createStyledButton("ITEM ESP: OFF", UDim2.new(0.4, -10, 0, 30), UDim2.new(0, 10, 0, 450), frame)

-- Voice Chat Button
local voiceChatButton = createStyledButton("VOICE CHAT: OFF", UDim2.new(0.4, -10, 0, 30), UDim2.new(0, 10, 0, 480), frame)

local noclipButton = createStyledButton("NOCLIP: OFF", UDim2.new(0.4, -10, 0, 30), UDim2.new(0, 10, 0, 120), frame)

-- Кнопка Spin
local spinButton = Instance.new("TextButton")
spinButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
spinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
spinButton.Font = Enum.Font.GothamSemibold
spinButton.TextSize = 14
spinButton.BorderSizePixel = 0
spinButton.AutoButtonColor = true

-- Add rounded corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = spinButton

-- Add hover effect
local originalColor = spinButton.BackgroundColor3
spinButton.MouseEnter:Connect(function()
    spinButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
end)
spinButton.MouseLeave:Connect(function()
    spinButton.BackgroundColor3 = originalColor
end)
spinButton.Text = "SPIN: OFF"
spinButton.Size = UDim2.new(0.4, -10, 0, 20)
spinButton.Position = UDim2.new(0, 10, 0, 150)
spinButton.Parent = frame

local godModeButton = Instance.new("TextButton")
godModeButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
godModeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
godModeButton.Font = Enum.Font.GothamSemibold
godModeButton.TextSize = 14
godModeButton.BorderSizePixel = 0
godModeButton.AutoButtonColor = true

-- Add rounded corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = godModeButton

-- Add hover effect
local originalColor = godModeButton.BackgroundColor3
godModeButton.MouseEnter:Connect(function()
    godModeButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
end)
godModeButton.MouseLeave:Connect(function()
    godModeButton.BackgroundColor3 = originalColor
end)
godModeButton.Text = "GODMODE: OFF"
godModeButton.Size = UDim2.new(0.4, -10, 0, 20)
godModeButton.Position = UDim2.new(0, 10, 0, 180)
godModeButton.Parent = frame

-- Graphics Quality Button
local graphicsButton = Instance.new("TextButton")
graphicsButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
graphicsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
graphicsButton.Font = Enum.Font.GothamSemibold
graphicsButton.TextSize = 14
graphicsButton.BorderSizePixel = 0
graphicsButton.AutoButtonColor = true

-- Add rounded corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = graphicsButton

-- Add hover effect
local originalColor = graphicsButton.BackgroundColor3
graphicsButton.MouseEnter:Connect(function()
    graphicsButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
end)
graphicsButton.MouseLeave:Connect(function()
    graphicsButton.BackgroundColor3 = originalColor
end)

graphicsButton.Text = "GRAPHICS: NORMAL"
graphicsButton.Size = UDim2.new(0.4, -10, 0, 20)
graphicsButton.Position = UDim2.new(0.6, 0, 0, 330)
graphicsButton.Parent = frame

local currentGraphics = "NORMAL"
local graphicsSettings = {
    ["POTATO"] = function()
        local lighting = game:GetService("Lighting")
        lighting.GlobalShadows = false
        lighting.ShadowSoftness = 0
        lighting.Technology = Enum.Technology.Compatibility
        settings().Rendering.QualityLevel = 1

        -- Remove all post effects
        for _, effect in pairs(lighting:GetChildren()) do
            if effect:IsA("PostEffect") then
                effect:Destroy()
            end
        end

        -- Set low quality terrain
        workspace.Terrain.WaterWaveSize = 0
        workspace.Terrain.WaterWaveSpeed = 0
        workspace.Terrain.WaterReflectance = 0
        workspace.Terrain.WaterTransparency = 0
    end,

    ["NORMAL"] = function()
        local lighting = game:GetService("Lighting")
        lighting.GlobalShadows = true
        lighting.ShadowSoftness = 0.5
        lighting.Technology = Enum.Technology.Future
        settings().Rendering.QualityLevel = 4

        workspace.Terrain.WaterWaveSize = 0.15
        workspace.Terrain.WaterWaveSpeed = 10
        workspace.Terrain.WaterReflectance = 0.05
        workspace.Terrain.WaterTransparency = 0.5
    end,

    ["ULTRA"] = function()
        local lighting = game:GetService("Lighting")
        lighting.GlobalShadows = true
        lighting.ShadowSoftness = 0.8
        lighting.Technology = Enum.Technology.Future
        settings().Rendering.QualityLevel = 21

        -- Set ultra realistic sky
        local sky = Instance.new("Sky")
        sky.Name = "CXNT_Sky"
        sky.SkyboxBk = "rbxassetid://8107841671"
        sky.SkyboxDn = "rbxassetid://8107841671"
        sky.SkyboxFt = "rbxassetid://8107841671"
        sky.SkyboxLf = "rbxassetid://8107841671"
        sky.SkyboxRt = "rbxassetid://8107841671"
        sky.SkyboxUp = "rbxassetid://8107841671"
        sky.SunAngularSize = 21
        sky.MoonAngularSize = 11
        sky.Parent = lighting

        -- Remove FPS cap
        setfpscap(9999999)

        -- Refined Bloom
        local bloom = Instance.new("BloomEffect")
        bloom.Intensity = 1.2
        bloom.Size = 32
        bloom.Threshold = 0.95
        bloom.Parent = lighting

        -- Enhanced Sun Rays
        local sunRays = Instance.new("SunRaysEffect")
        sunRays.Intensity = 0.25
        sunRays.Spread = 0.85
        sunRays.Parent = lighting

        -- Advanced Color Correction
        local colorCorrection = Instance.new("ColorCorrectionEffect")
        colorCorrection.Brightness = 0.05
        colorCorrection.Contrast = 0.2
        colorCorrection.Saturation = 0.25
        colorCorrection.TintColor = Color3.fromRGB(255, 255, 250)
        colorCorrection.Parent = lighting

        -- Subtle Depth of Field
        local depthOfField = Instance.new("DepthOfFieldEffect")
        depthOfField.FarIntensity = 0.1
        depthOfField.FocusDistance = 0.1
        depthOfField.InFocusRadius = 50
        depthOfField.NearIntensity = 0.4
        depthOfField.Parent = lighting

        -- Enhanced Atmosphere
        local atmosphere = Instance.new("Atmosphere")
        atmosphere.Density = 0.25
        atmosphere.Offset = 0.15
        atmosphere.Color = Color3.fromRGB(206, 227, 255)
        atmosphere.Decay = Color3.fromRGB(147, 178, 255)
        atmosphere.Glare = 0.3
        atmosphere.Haze = 0.9
        atmosphere.Parent = lighting

        -- HDR Effect
        local hdr = Instance.new("ColorCorrectionEffect")
        hdr.Name = "HDR"
        hdr.Brightness = 0.03
        hdr.Contrast = 0.05
        hdr.Saturation = 0.1
        hdr.TintColor = Color3.fromRGB(255, 250, 245)
        hdr.Parent = lighting

        -- Lens Distortion
        local lensDistortion = Instance.new("BloomEffect")
        lensDistortion.Name = "LensDistortion"
        lensDistortion.Intensity = 0.5
        lensDistortion.Size = 12
        lensDistortion.Threshold = 0.95
        lensDistortion.Parent = lighting

        -- Enhanced Water Effects
        workspace.Terrain.WaterWaveSize = 0.15
        workspace.Terrain.WaterWaveSpeed = 35
        workspace.Terrain.WaterReflectance = 1
        workspace.Terrain.WaterTransparency = 0.65

        -- Dynamic Reflections
        local reflectionSettings = {
            ["ReflectionIntensity"] = 1,
            ["BlurAmount"] = 0.5,
            ["FresnelTerm"] = 0.25
        }

        -- Add Particles for Enhanced Atmosphere
        local function createAtmosphericParticles(position)
            local particles = Instance.new("ParticleEmitter")
            particles.Rate = 5
            particles.Speed = NumberRange.new(0.1, 0.5)
            particles.Lifetime = NumberRange.new(2, 4)
            particles.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.1),
                NumberSequenceKeypoint.new(0.5, 0.2),
                NumberSequenceKeypoint.new(1, 0.1)
            })
            particles.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.2, 0.8),
                NumberSequenceKeypoint.new(0.8, 0.8),
                NumberSequenceKeypoint.new(1, 1)
            })
            particles.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
            })
            particles.Parent = position
        end

        -- Add atmospheric particles to the environment
        local atmosphereAnchors = {}
        for i = 1, 10 do
            local anchor = Instance.new("Part")
            anchor.Anchored = true
            anchor.CanCollide = false
            anchor.Transparency = 1
            anchor.Position = Vector3.new(
                math.random(-100, 100),
                math.random(20, 50),
                math.random(-100, 100)
            )
            anchor.Parent = workspace
            createAtmosphericParticles(anchor)
            table.insert(atmosphereAnchors, anchor)
        end

        -- Clean up previous particles after 5 seconds
        game:GetService("Debris"):AddItem(atmosphereAnchors[1].Parent, 5)
    end
}

graphicsButton.MouseButton1Click:Connect(function()
    local qualities = {"POTATO", "NORMAL", "ULTRA"}
    local currentIndex = table.find(qualities, currentGraphics)
    currentGraphics = qualities[currentIndex % #qualities + 1]
    graphicsButton.Text = "GRAPHICS: " .. currentGraphics
    graphicsSettings[currentGraphics]()
end)

local skyButton = Instance.new("TextButton")
skyButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
skyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
skyButton.Font = Enum.Font.GothamSemibold
skyButton.TextSize = 14
skyButton.BorderSizePixel = 0
skyButton.AutoButtonColor = true

-- Add rounded corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = skyButton

-- Add hover effect
local originalColor = skyButton.BackgroundColor3
skyButton.MouseEnter:Connect(function()
    skyButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
end)
skyButton.MouseLeave:Connect(function()
    skyButton.BackgroundColor3 = originalColor
end)
skyButton.Text = "SKY: DEFAULT"
skyButton.Size = UDim2.new(0.4, -10, 0, 20)
skyButton.Position = UDim2.new(0, 10, 0, 210)
skyButton.Parent = frame



local speedLabel = Instance.new("TextLabel")
speedLabel.Text = "SPEED PLAYER: " .. defaultWalkSpeed
speedLabel.Size = UDim2.new(1, -20, 0, 25)
speedLabel.Position = UDim2.new(0, 10, 0, 550)
speedLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextSize = 16
speedLabel.TextXAlignment = Enum.TextXAlignment.Center
speedLabel.BorderSizePixel = 0
speedLabel.Parent = frame

-- Скругленные углы для лейбла
local speedLabelCorner = Instance.new("UICorner")
speedLabelCorner.CornerRadius = UDim.new(0, 6)
speedLabelCorner.Parent = speedLabel

-- Обводка для лейбла
local speedLabelStroke = Instance.new("UIStroke")
speedLabelStroke.Color = Color3.fromRGB(255, 0, 0)
speedLabelStroke.Thickness = 1
speedLabelStroke.Transparency = 0.7
speedLabelStroke.Parent = speedLabel

local slider = Instance.new("Frame")
slider.Size = UDim2.new(1, -20, 0, 15)
slider.Position = UDim2.new(0, 10, 0, 585)
slider.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
slider.BorderSizePixel = 0
slider.Parent = frame

-- Скругленные углы для слайдера
local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(0, 8)
sliderCorner.Parent = slider

-- Обводка для слайдера
local sliderStroke = Instance.new("UIStroke")
sliderStroke.Color = Color3.fromRGB(255, 0, 0)
sliderStroke.Thickness = 1
sliderStroke.Transparency = 0.8
sliderStroke.Parent = slider

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(defaultWalkSpeed / 1000, 0, 1, 0)
sliderFill.Position = UDim2.new(0, 0, 0, 0)
sliderFill.BorderSizePixel = 0
sliderFill.Parent = slider

-- Градиентная заливка для слайдера
local sliderGradient = Instance.new("UIGradient")
sliderGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 100, 100)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
}
sliderGradient.Parent = sliderFill

-- Скругленные углы для заливки
local sliderFillCorner = Instance.new("UICorner")
sliderFillCorner.CornerRadius = UDim.new(0, 8)
sliderFillCorner.Parent = sliderFill

local sliderButton = Instance.new("TextButton")
sliderButton.Size = UDim2.new(0, 15, 0, 25)
sliderButton.Position = UDim2.new(defaultWalkSpeed / 1000, -8, 0, -5)
sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sliderButton.BorderSizePixel = 0
sliderButton.Text = ""
sliderButton.Parent = slider

-- Скругленные углы для кнопки слайдера
local sliderButtonCorner = Instance.new("UICorner")
sliderButtonCorner.CornerRadius = UDim.new(0, 8)
sliderButtonCorner.Parent = sliderButton

-- Обводка для кнопки слайдера
local sliderButtonStroke = Instance.new("UIStroke")
sliderButtonStroke.Color = Color3.fromRGB(255, 0, 0)
sliderButtonStroke.Thickness = 2
sliderButtonStroke.Parent = sliderButton

-- ESP Функции
local espObjects = {}
local itemEspObjects = {}
local colorPhase = 0
local colorSpeed = 0.01

-- Функция ESP для предметов с улучшенными визуальными эффектами
local function createItemEsp(item)
    if not item:IsA("BasePart") then return end

    -- Создаем красивый name label с рамкой
    local nameLabel = Instance.new("BillboardGui")
    nameLabel.Name = "CXNT_ITEM_LABEL"
    nameLabel.Size = UDim2.new(0, 200, 0, 60)
    nameLabel.StudsOffset = Vector3.new(0, item.Size.Y + 1, 0)
    nameLabel.AlwaysOnTop = true
    nameLabel.Parent = item

    -- Определяем тип предмета и его характеристики
    local itemName = item.Name:lower()
    local itemType = "unknown"
    local itemColor = Color3.fromRGB(255, 255, 255)
    local itemIcon = "📦"
    local itemRarity = "common"

    if itemName:find("weapon") or itemName:find("gun") or itemName:find("sword") or itemName:find("knife") then
        itemType = "weapon"
        itemColor = Color3.fromRGB(255, 50, 50)
        itemIcon = "⚔️"
        itemRarity = "rare"
    elseif itemName:find("ammo") or itemName:find("mag") then
        itemType = "ammo"
        itemColor = Color3.fromRGB(255, 255, 50)
        itemIcon = "💥"
        itemRarity = "common"
    elseif itemName:find("heal") or itemName:find("med") or itemName:find("bandage") then
        itemType = "heal"
        itemColor = Color3.fromRGB(50, 255, 50)
        itemIcon = "💚"
        itemRarity = "uncommon"
    elseif itemName:find("bond") or itemName:find("money") or itemName:find("cash") then
        itemType = "money"
        itemColor = Color3.fromRGB(50, 255, 255)
        itemIcon = "💰"
        itemRarity = "legendary"
    elseif itemName:find("armor") or itemName:find("vest") then
        itemType = "armor"
        itemColor = Color3.fromRGB(150, 150, 255)
        itemIcon = "🛡️"
        itemRarity = "epic"
    else
        itemType = "misc"
        itemColor = Color3.fromRGB(200, 200, 200)
        itemIcon = "📦"
        itemRarity = "common"
    end

    -- Фон для имени с градиентом в зависимости от редкости
    local nameBackground = Instance.new("Frame")
    nameBackground.Size = UDim2.new(0, 180, 0, 40)
    nameBackground.Position = UDim2.new(0.5, -90, 0, 5)
    nameBackground.BorderSizePixel = 0
    nameBackground.Parent = nameLabel

    -- Цвета по редкости
    local rarityColors = {
        common = {Color3.fromRGB(60, 60, 60), Color3.fromRGB(40, 40, 40)},
        uncommon = {Color3.fromRGB(60, 80, 60), Color3.fromRGB(40, 60, 40)},
        rare = {Color3.fromRGB(80, 60, 60), Color3.fromRGB(60, 40, 40)},
        epic = {Color3.fromRGB(80, 60, 120), Color3.fromRGB(60, 40, 100)},
        legendary = {Color3.fromRGB(120, 100, 60), Color3.fromRGB(100, 80, 40)}
    }

    nameBackground.BackgroundColor3 = rarityColors[itemRarity][1]
    nameBackground.BackgroundTransparency = 0.2

    -- Скругленные углы для имени
    local nameCorner = Instance.new("UICorner")
    nameCorner.CornerRadius = UDim.new(0, 10)
    nameCorner.Parent = nameBackground

    -- Обводка для имени с цветом по типу предмета
    local nameStroke = Instance.new("UIStroke")
    nameStroke.Color = itemColor
    nameStroke.Thickness = 2
    nameStroke.Transparency = 0.2
    nameStroke.Parent = nameBackground

    -- Градиент для фона имени
    local nameGradient = Instance.new("UIGradient")
    nameGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, rarityColors[itemRarity][1]),
        ColorSequenceKeypoint.new(1, rarityColors[itemRarity][2])
    }
    nameGradient.Rotation = 45
    nameGradient.Parent = nameBackground

    local nameText = Instance.new("TextLabel")
    nameText.Size = UDim2.new(1, 0, 1, 0)
    nameText.BackgroundTransparency = 1
    nameText.TextColor3 = itemColor
    nameText.TextStrokeTransparency = 0
    nameText.TextStrokeColor3 = Color3.new(0, 0, 0)
    nameText.Text = itemIcon .. " " .. item.Name .. " [" .. itemType:upper() .. "]"
    nameText.Font = Enum.Font.GothamBold
    nameText.TextSize = 14
    nameText.TextXAlignment = Enum.TextXAlignment.Center
    nameText.TextYAlignment = Enum.TextYAlignment.Center
    nameText.Parent = nameBackground

    -- Создаем красивое выделение предмета
    local highlight = Instance.new("BoxHandleAdornment")
    highlight.Name = "CXNT_ITEM_ESP"
    highlight.Adornee = item
    highlight.Color3 = itemColor
    highlight.Transparency = 0.2
    highlight.Size = item.Size + Vector3.new(0.2, 0.2, 0.2)
    highlight.AlwaysOnTop = true
    highlight.ZIndex = 10
    highlight.Parent = game.CoreGui

    -- Дополнительная обводка для лучшей видимости
    local outline = Instance.new("SelectionBox")
    outline.Name = "CXNT_ITEM_ESP_Outline"
    outline.Adornee = item
    outline.Color3 = Color3.fromRGB(255, 255, 255)
    outline.LineThickness = 0.1
    outline.Transparency = 0.1
    outline.SurfaceColor3 = itemColor
    outline.SurfaceTransparency = 0.8
    outline.Parent = game.CoreGui

    -- Создаем информационную панель с расстоянием
    local infoPanel = Instance.new("Frame")
    infoPanel.Size = UDim2.new(0, 120, 0, 20)
    infoPanel.Position = UDim2.new(0.5, -60, 1, 5)
    infoPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    infoPanel.BackgroundTransparency = 0.3
    infoPanel.BorderSizePixel = 0
    infoPanel.Parent = nameLabel

    local infoPanelCorner = Instance.new("UICorner")
    infoPanelCorner.CornerRadius = UDim.new(0, 6)
    infoPanelCorner.Parent = infoPanel

    local distanceText = Instance.new("TextLabel")
    distanceText.Size = UDim2.new(1, 0, 1, 0)
    distanceText.BackgroundTransparency = 1
    distanceText.TextColor3 = Color3.fromRGB(255, 255, 255)
    distanceText.TextStrokeTransparency = 0
    distanceText.TextStrokeColor3 = Color3.new(0, 0, 0)
    distanceText.Text = "0m"
    distanceText.Font = Enum.Font.Gotham
    distanceText.TextSize = 12
    distanceText.TextXAlignment = Enum.TextXAlignment.Center
    distanceText.TextYAlignment = Enum.TextYAlignment.Center
    distanceText.Parent = infoPanel

    -- Анимация мерцания для редких предметов
    if itemRarity == "legendary" or itemRarity == "epic" then
        spawn(function()
            while nameText.Parent do
                local glowTween = game:GetService("TweenService"):Create(
                    nameStroke,
                    TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
                    {Transparency = 0.05}
                )
                glowTween:Play()
                wait(3)
                if not nameText.Parent then break end
                glowTween:Cancel()
            end
        end)

        -- Добавляем частицы для легендарных предметов
        if itemRarity == "legendary" then
            local particle = Instance.new("ParticleEmitter")
            particle.Rate = 20
            particle.Speed = NumberRange.new(1, 3)
            particle.Lifetime = NumberRange.new(1, 2)
            particle.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.2),
                NumberSequenceKeypoint.new(0.5, 0.4),
                NumberSequenceKeypoint.new(1, 0.2)
            })
            particle.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.2, 0.6),
                NumberSequenceKeypoint.new(0.8, 0.6),
                NumberSequenceKeypoint.new(1, 1)
            })
            particle.Color = ColorSequence.new(itemColor)
            particle.SpreadAngle = Vector2.new(360, 360)
            particle.Texture = "rbxasset://textures/particles/sparkles_main.dds"
            particle.Parent = item
        end
    end

    -- Анимация пульсации для обеих частей
    spawn(function()
        while highlight.Parent and outline.Parent do
            local pulseTween1 = game:GetService("TweenService"):Create(
                highlight,
                TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
                {Transparency = 0.05}
            )
            local pulseTween2 = game:GetService("TweenService"):Create(
                outline,
                TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
                {Transparency = 0.05}
            )
            pulseTween1:Play()
            pulseTween2:Play()
            wait(4)
            if not highlight.Parent or not outline.Parent then break end
            pulseTween1:Cancel()
            pulseTween2:Cancel()
        end
    end)

    -- Обновление расстояния в реальном времени
    spawn(function()
        while distanceText.Parent do
            local character = game.Players.LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local distance = (item.Position - character.HumanoidRootPart.Position).Magnitude
                distanceText.Text = math.floor(distance) .. "m"
                
                -- Изменяем цвет текста в зависимости от расстояния
                if distance < 10 then
                    distanceText.TextColor3 = Color3.fromRGB(50, 255, 50) -- Зеленый - близко
                elseif distance < 25 then
                    distanceText.TextColor3 = Color3.fromRGB(255, 255, 50) -- Желтый - средне
                else
                    distanceText.TextColor3 = Color3.fromRGB(255, 100, 100) -- Красный - далеко
                end
            end
            wait(0.5)
        end
    end)

    itemEspObjects[item] = {
        highlight = highlight, 
        outline = outline,
        label = nameLabel, 
        distanceText = distanceText,
        itemType = itemType,
        itemRarity = itemRarity
    }
end

local function toggleItemEsp()
    local itemEspEnabled = not (next(itemEspObjects) ~= nil)

    -- Clean up existing ESP
    for item, objects in pairs(itemEspObjects) do
        if not item or not item.Parent then
            if objects.highlight then objects.highlight:Destroy() end
            if objects.outline then objects.outline:Destroy() end
            if objects.label then objects.label:Destroy() end
            itemEspObjects[item] = nil
        end
    end

    if itemEspEnabled then
        -- Clean up when items are removed
        workspace.DescendantRemoving:Connect(function(item)
            if itemEspObjects[item] then
                if itemEspObjects[item].highlight then itemEspObjects[item].highlight:Destroy() end
                if itemEspObjects[item].outline then itemEspObjects[item].outline:Destroy() end
                if itemEspObjects[item].label then itemEspObjects[item].label:Destroy() end
                itemEspObjects[item] = nil
            end
        end)

        -- Ищем все интерактивные предметы в игре с расширенным списком
        for _, item in pairs(workspace:GetDescendants()) do
            -- Проверяем является ли предмет интерактивным (расширенная проверка)
            if item:IsA("BasePart") and 
               (item.Name:lower():find("item") or 
                item.Name:lower():find("pickup") or 
                item.Name:lower():find("tool") or
                item.Name:lower():find("weapon") or 
                item.Name:lower():find("gun") or
                item.Name:lower():find("sword") or
                item.Name:lower():find("knife") or
                item.Name:lower():find("ammo") or
                item.Name:lower():find("mag") or
                item.Name:lower():find("heal") or
                item.Name:lower():find("med") or
                item.Name:lower():find("bandage") or
                item.Name:lower():find("bond") or
                item.Name:lower():find("money") or
                item.Name:lower():find("cash") or
                item.Name:lower():find("coin") or
                item.Name:lower():find("gem") or
                item.Name:lower():find("loot") or
                item.Name:lower():find("collect") or
                item.Name:lower():find("resource") or
                item.Name:lower():find("armor") or
                item.Name:lower():find("vest") or
                item.Name:lower():find("drop") or
                item.Name:lower():find("supply")) then
                createItemEsp(item)
            end
        end

        -- Следим за новыми предметами с улучшенной проверкой
        workspace.DescendantAdded:Connect(function(item)
            if itemEspEnabled and item:IsA("BasePart") and
               (item.Name:lower():find("item") or 
                item.Name:lower():find("pickup") or 
                item.Name:lower():find("tool") or
                item.Name:lower():find("weapon") or
                item.Name:lower():find("gun") or
                item.Name:lower():find("sword") or
                item.Name:lower():find("knife") or
                item.Name:lower():find("ammo") or
                item.Name:lower():find("mag") or
                item.Name:lower():find("heal") or
                item.Name:lower():find("med") or
                item.Name:lower():find("bandage") or
                item.Name:lower():find("bond") or
                item.Name:lower():find("money") or
                item.Name:lower():find("cash") or
                item.Name:lower():find("coin") or
                item.Name:lower():find("gem") or
                item.Name:lower():find("loot") or
                item.Name:lower():find("collect") or
                item.Name:lower():find("resource") or
                item.Name:lower():find("armor") or
                item.Name:lower():find("vest") or
                item.Name:lower():find("drop") or
                item.Name:lower():find("supply")) then
                createItemEsp(item)
            end
        end)

        -- Обновление цветов ESP предметов (как у игроков)
        spawn(function()
            while itemEspEnabled do
                colorPhase = (colorPhase + colorSpeed * 1.5) % 1
                local hue = colorPhase * 360
                
                local function HSVtoRGB(h, s, v)
                    local r, g, b
                    local i = math.floor(h / 60) % 6
                    local f = h / 60 - i
                    local p = v * (1 - s)
                    local q = v * (1 - f * s)
                    local t = v * (1 - (1 - f) * s)
                    
                    if i == 0 then
                        r, g, b = v, t, p
                    elseif i == 1 then
                        r, g, b = q, v, p
                    elseif i == 2 then
                        r, g, b = p, v, t
                    elseif i == 3 then
                        r, g, b = p, q, v
                    elseif i == 4 then
                        r, g, b = t, p, v
                    elseif i == 5 then
                        r, g, b = v, p, q
                    end
                    
                    return Color3.new(r, g, b)
                end

                for item, objects in pairs(itemEspObjects) do
                    if objects.highlight and objects.highlight.Parent then
                        -- Только легендарные предметы получают радужный эффект
                        if objects.itemRarity == "legendary" then
                            local rainbowColor = HSVtoRGB(hue, 0.8, 1)
                            objects.highlight.Color3 = rainbowColor
                            if objects.outline then
                                objects.outline.Color3 = rainbowColor
                            end
                        end
                    end
                end
                wait(0.1)
            end
        end)
    else
        -- Удаляем ESP с предметов
        for _, objects in pairs(itemEspObjects) do
            if objects.highlight then objects.highlight:Destroy() end
            if objects.outline then objects.outline:Destroy() end
            if objects.label then objects.label:Destroy() end
        end
        itemEspObjects = {}
    end

    return itemEspEnabled
end

local lastUpdate = 0
local updateInterval = 0.05 -- Faster updates for smoother animation

local function updateEspColor()
    local currentTime = tick()
    if currentTime - lastUpdate < updateInterval then return end

    lastUpdate = currentTime
    colorPhase = (colorPhase + colorSpeed * 2) % 1
    
    -- Создаем радужный эффект
    local hue = colorPhase * 360
    local function HSVtoRGB(h, s, v)
        local r, g, b
        local i = math.floor(h / 60) % 6
        local f = h / 60 - i
        local p = v * (1 - s)
        local q = v * (1 - f * s)
        local t = v * (1 - (1 - f) * s)
        
        if i == 0 then
            r, g, b = v, t, p
        elseif i == 1 then
            r, g, b = q, v, p
        elseif i == 2 then
            r, g, b = p, v, t
        elseif i == 3 then
            r, g, b = p, q, v
        elseif i == 4 then
            r, g, b = t, p, v
        elseif i == 5 then
            r, g, b = v, p, q
        end
        
        return Color3.new(r, g, b)
    end
    
    espColor = HSVtoRGB(hue, 0.8, 1)

    for target, parts in pairs(espObjects) do
        local isPlayer = game.Players:GetPlayerFromCharacter(target)
        for _, part in ipairs(parts) do
            if part and part.Parent then
                if part:IsA("SelectionBox") then
                    part.Color3 = isPlayer and espColor or Color3.fromRGB(255, 50, 50)
                    part.SurfaceColor3 = part.Color3
                elseif part.Name == "CXNT_NameLabel" then
                    -- Обновляем цвет текста имени
                    local nameText = part:FindFirstChild("Frame") and part.Frame:FindFirstChild("TextLabel")
                    if nameText then
                        nameText.TextColor3 = isPlayer and espColor or Color3.fromRGB(255, 100, 100)
                    end
                end
            end
        end
    end
end

local function createEsp(target, isPlayer)
    if isPlayer and target == game.Players.LocalPlayer then return end

    local function setupEsp(character)
        if not character then return end
        local parts = {}

        -- Remove old ESP if exists
        if espObjects[target] then
            removeEsp(target)
        end

        -- Создаем красивый name label с рамкой
        local nameLabel = Instance.new("BillboardGui")
        nameLabel.Name = "CXNT_NameLabel"
        nameLabel.Size = UDim2.new(0, 200, 0, 60)
        nameLabel.StudsOffset = Vector3.new(0, 4, 0)
        nameLabel.AlwaysOnTop = true
        nameLabel.Parent = character:WaitForChild("Head")

        -- Фон для имени
        local nameBackground = Instance.new("Frame")
        nameBackground.Size = UDim2.new(0, 180, 0, 35)
        nameBackground.Position = UDim2.new(0.5, -90, 0, 5)
        nameBackground.BackgroundColor3 = isPlayer and Color3.fromRGB(30, 30, 30) or Color3.fromRGB(50, 20, 20)
        nameBackground.BackgroundTransparency = 0.3
        nameBackground.BorderSizePixel = 0
        nameBackground.Parent = nameLabel

        -- Скругленные углы для имени
        local nameCorner = Instance.new("UICorner")
        nameCorner.CornerRadius = UDim.new(0, 8)
        nameCorner.Parent = nameBackground

        -- Обводка для имени
        local nameStroke = Instance.new("UIStroke")
        nameStroke.Color = isPlayer and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(255, 50, 50)
        nameStroke.Thickness = 2
        nameStroke.Transparency = 0.3
        nameStroke.Parent = nameBackground

        -- Градиент для фона имени
        local nameGradient = Instance.new("UIGradient")
        nameGradient.Color = isPlayer and ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 60)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 40))
        } or ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 30, 30)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 20, 20))
        }
        nameGradient.Rotation = 45
        nameGradient.Parent = nameBackground

        local nameText = Instance.new("TextLabel")
        nameText.Size = UDim2.new(1, 0, 1, 0)
        nameText.BackgroundTransparency = 1
        nameText.TextColor3 = isPlayer and Color3.fromRGB(100, 255, 255) or Color3.fromRGB(255, 100, 100)
        nameText.TextStrokeTransparency = 0
        nameText.TextStrokeColor3 = Color3.new(0, 0, 0)
        nameText.Text = isPlayer and "👤 " .. target.Name or "🤖 " .. target.Name
        nameText.Font = Enum.Font.GothamBold
        nameText.TextSize = 16
        nameText.TextXAlignment = Enum.TextXAlignment.Center
        nameText.TextYAlignment = Enum.TextYAlignment.Center
        nameText.Parent = nameBackground

        -- Анимация мерцания для имени
        spawn(function()
            while nameText.Parent do
                local glowTween = game:GetService("TweenService"):Create(
                    nameStroke,
                    TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
                    {Transparency = 0.1}
                )
                glowTween:Play()
                wait(2)
                if not nameText.Parent then break end
                glowTween:Cancel()
            end
        end)

        table.insert(parts, nameLabel)

        local function addHighlight(part)
            if part:IsA("BasePart") then
                -- Используем BoxHandleAdornment для лучшей видимости через стены
                local highlight = Instance.new("BoxHandleAdornment")
                highlight.Name = "CXNT_ESP"
                highlight.Adornee = part
                highlight.Color3 = isPlayer and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(255, 50, 50)
                highlight.Transparency = 0.3
                highlight.Size = part.Size + Vector3.new(0.05, 0.05, 0.05)
                highlight.AlwaysOnTop = true
                highlight.ZIndex = 10
                highlight.Parent = game.CoreGui

                -- Дополнительная обводка для лучшей видимости
                local outline = Instance.new("SelectionBox")
                outline.Name = "CXNT_ESP_Outline"
                outline.Adornee = part
                outline.Color3 = isPlayer and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(255, 255, 255)
                outline.LineThickness = 0.15
                outline.Transparency = 0.1
                outline.SurfaceTransparency = 1
                outline.Parent = game.CoreGui

                -- Анимация пульсации для обеих частей
                spawn(function()
                    while highlight.Parent and outline.Parent do
                        local pulseTween1 = game:GetService("TweenService"):Create(
                            highlight,
                            TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
                            {Transparency = 0.1}
                        )
                        local pulseTween2 = game:GetService("TweenService"):Create(
                            outline,
                            TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
                            {Transparency = 0.05}
                        )
                        pulseTween1:Play()
                        pulseTween2:Play()
                        wait(3)
                        if not highlight.Parent or not outline.Parent then break end
                        pulseTween1:Cancel()
                        pulseTween2:Cancel()
                    end
                end)

                table.insert(parts, highlight)
                table.insert(parts, outline)
            end
        end

        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                addHighlight(part)
            end
        end

        character.DescendantAdded:Connect(function(part)
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                addHighlight(part)
            end
        end)

        espObjects[target] = parts
    end

    if isPlayer then
        setupEsp(target.Character)
        target.CharacterAdded:Connect(setupEsp)
    else
        setupEsp(target)
    end
end

local function removeEsp(player)
    if espObjects[player] then
        for _, part in ipairs(espObjects[player]) do
            if part and part.Parent then
                part:Destroy()
            end
        end
        espObjects[player] = nil
    end
end

-- Очистка ESP при смене сервера
game:GetService("Players").PlayerRemoving:Connect(function(player)
    removeEsp(player)
end)

game:GetService("CoreGui").DescendantRemoving:Connect(function(obj)
    if obj.Name == "CXNT_ESP" or obj.Name == "CXNT_NameLabel" then
        obj:Destroy()
    end
end)

local function toggleEsp()
    espEnabled = not espEnabled
    espButton.Text = "ESP: " .. (espEnabled and "ON" or "OFF")

    if espEnabled then
        -- ESP for players
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                createEsp(player, true)
            end
        end

        -- Add ESP for new players joining
        game.Players.PlayerAdded:Connect(function(newPlayer)
            if espEnabled and newPlayer ~= game.Players.LocalPlayer then
                createEsp(newPlayer, true)
            end
        end)

        -- Remove ESP when players leave
        game.Players.PlayerRemoving:Connect(function(leavingPlayer)
            if espObjects[leavingPlayer] then
                removeEsp(leavingPlayer)
            end
        end)

        -- ESP for mobs/NPCs
        for _, mob in ipairs(workspace:GetDescendants()) do
            if mob:IsA("Model") and mob:FindFirstChild("Humanoid") and 
               not game.Players:GetPlayerFromCharacter(mob) then
                createEsp(mob, false)
            end
        end

        -- Watch for new mobs
        workspace.DescendantAdded:Connect(function(descendant)
            if espEnabled and descendant:IsA("Model") and 
               descendant:FindFirstChild("Humanoid") and
               not game.Players:GetPlayerFromCharacter(descendant) then
                createEsp(descendant, false)
            end
        end)

        game.Players.PlayerAdded:Connect(function(player)
            player.CharacterAdded:Connect(function()
                if espEnabled then
                    createEsp(player)
                end
            end)
        end)

        -- Запускаем анимацию цвета
        game:GetService("RunService").RenderStepped:Connect(updateEspColor)
    else
        for player in pairs(espObjects) do
            removeEsp(player)
        end
    end
end

-- Spin Функции
local spinConnections = {}

local function toggleSpin()
    spinEnabled = not spinEnabled
    spinButton.Text = "SPIN: " .. (spinEnabled and "ON" or "OFF")

    local character = player.Character
    if not character then return end

    if spinEnabled then
        -- Сохраняем оригинальное положение частей тела
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then return end

        -- Отключаем поворот корневой части для физики
        humanoidRootPart.Anchored = false -- Fixed: Allow movement

        -- Создаем соединение для вращения
        local conn = game:GetService("RunService").RenderStepped:Connect(function(dt)
            if not character or not humanoidRootPart then return end

            -- Вращаем только визуальную модель, не затрагивая камеру
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part ~= humanoidRootPart then
                    local cf = part.CFrame
                    part.CFrame = cf * CFrame.Angles(0, dt * spinSpeed, 0)
                end
            end
        end)

        spinConnections[character] = conn

        -- Обработчик для нового персонажа
        player.CharacterAdded:Connect(function(newChar)
            if spinEnabled then
                wait(1) -- Ждем загрузку персонажа
                toggleSpin() -- Выключаем и включаем снова для нового персонажа
                toggleSpin()
            end
        end)
    else
        -- Восстанавливаем оригинальное состояние
        for char, conn in pairs(spinConnections) do
            conn:Disconnect()
            local humanoidRootPart = char:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                humanoidRootPart.Anchored = false
            end
        end
        spinConnections = {}
    end
end

-- Voice Chat System
local voiceChatEnabled = false
local voiceChatUsers = {}
local currentLobby = nil
local voiceChatConnections = {}
local microphoneActive = false
local voiceVolume = 0.5

-- Определение лобби игрока
local function getCurrentLobby()
    local lobbyId = game.JobId or game.PlaceId
    return lobbyId
end

-- Создание голосового чата
local function createVoiceChat()
    -- Создаем основное GUI для голосового чата
    local voiceGui = Instance.new("ScreenGui")
    voiceGui.Name = "CXNT_VoiceChat"
    voiceGui.Parent = game:GetService("CoreGui")

    -- Главная панель голосового чата
    local voiceFrame = Instance.new("Frame")
    voiceFrame.Size = UDim2.new(0, 300, 0, 200)
    voiceFrame.Position = UDim2.new(1, -320, 0, 100)
    voiceFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    voiceFrame.BorderSizePixel = 0
    voiceFrame.Parent = voiceGui

    local voiceCorner = Instance.new("UICorner")
    voiceCorner.CornerRadius = UDim.new(0, 12)
    voiceCorner.Parent = voiceFrame

    local voiceStroke = Instance.new("UIStroke")
    voiceStroke.Color = Color3.fromRGB(255, 0, 0)
    voiceStroke.Thickness = 2
    voiceStroke.Transparency = 0.3
    voiceStroke.Parent = voiceFrame

    -- Заголовок
    local voiceTitle = Instance.new("TextLabel")
    voiceTitle.Text = "🎙️ VOICE CHAT"
    voiceTitle.Size = UDim2.new(1, 0, 0, 30)
    voiceTitle.Position = UDim2.new(0, 0, 0, 0)
    voiceTitle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    voiceTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    voiceTitle.Font = Enum.Font.GothamBold
    voiceTitle.TextSize = 16
    voiceTitle.Parent = voiceFrame

    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = voiceTitle

    -- Список пользователей
    local usersList = Instance.new("ScrollingFrame")
    usersList.Size = UDim2.new(1, -10, 0, 120)
    usersList.Position = UDim2.new(0, 5, 0, 35)
    usersList.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    usersList.BorderSizePixel = 0
    usersList.ScrollBarThickness = 6
    usersList.Parent = voiceFrame

    local usersCorner = Instance.new("UICorner")
    usersCorner.CornerRadius = UDim.new(0, 8)
    usersCorner.Parent = usersList

    local usersLayout = Instance.new("UIListLayout")
    usersLayout.SortOrder = Enum.SortOrder.LayoutOrder
    usersLayout.Padding = UDim.new(0, 2)
    usersLayout.Parent = usersList

    -- Кнопка микрофона
    local micButton = Instance.new("TextButton")
    micButton.Size = UDim2.new(0.48, 0, 0, 25)
    micButton.Position = UDim2.new(0, 5, 1, -30)
    micButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    micButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    micButton.Font = Enum.Font.GothamSemibold
    micButton.TextSize = 12
    micButton.Text = "🎤 MIC: OFF"
    micButton.BorderSizePixel = 0
    micButton.Parent = voiceFrame

    local micCorner = Instance.new("UICorner")
    micCorner.CornerRadius = UDim.new(0, 6)
    micCorner.Parent = micButton

    -- Слайдер громкости
    local volumeLabel = Instance.new("TextLabel")
    volumeLabel.Size = UDim2.new(0.48, 0, 0, 25)
    volumeLabel.Position = UDim2.new(0.52, 0, 1, -30)
    volumeLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    volumeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    volumeLabel.Font = Enum.Font.GothamSemibold
    volumeLabel.TextSize = 12
    volumeLabel.Text = "🔊 VOL: 50%"
    volumeLabel.BorderSizePixel = 0
    volumeLabel.Parent = voiceFrame

    local volumeCorner = Instance.new("UICorner")
    volumeCorner.CornerRadius = UDim.new(0, 6)
    volumeCorner.Parent = volumeLabel

    return voiceGui, usersList, micButton, volumeLabel
end

-- Обновление списка пользователей в голосовом чате
local function updateVoiceChatUsers(usersList)
    -- Очищаем старый список
    for _, child in pairs(usersList:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end

    -- Добавляем текущих пользователей
    local yOffset = 0
    for playerId, userData in pairs(voiceChatUsers) do
        local userFrame = Instance.new("Frame")
        userFrame.Size = UDim2.new(1, -5, 0, 25)
        userFrame.Position = UDim2.new(0, 0, 0, yOffset)
        userFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        userFrame.BorderSizePixel = 0
        userFrame.Parent = usersList

        local userCorner = Instance.new("UICorner")
        userCorner.CornerRadius = UDim.new(0, 6)
        userCorner.Parent = userFrame

        local userLabel = Instance.new("TextLabel")
        userLabel.Size = UDim2.new(0.7, 0, 1, 0)
        userLabel.Position = UDim2.new(0, 5, 0, 0)
        userLabel.BackgroundTransparency = 1
        userLabel.TextColor3 = userData.speaking and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 255, 255)
        userLabel.Font = Enum.Font.Gotham
        userLabel.TextSize = 12
        userLabel.Text = userData.name
        userLabel.TextXAlignment = Enum.TextXAlignment.Left
        userLabel.Parent = userFrame

        local statusIcon = Instance.new("TextLabel")
        statusIcon.Size = UDim2.new(0.3, 0, 1, 0)
        statusIcon.Position = UDim2.new(0.7, 0, 0, 0)
        statusIcon.BackgroundTransparency = 1
        statusIcon.TextColor3 = userData.micActive and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
        statusIcon.Font = Enum.Font.Gotham
        statusIcon.TextSize = 12
        statusIcon.Text = userData.micActive and "🎤" or "🔇"
        statusIcon.TextXAlignment = Enum.TextXAlignment.Center
        statusIcon.Parent = userFrame

        yOffset = yOffset + 27
    end

    usersList.CanvasSize = UDim2.new(0, 0, 0, yOffset)
end

-- Симуляция передачи голоса
local function simulateVoiceTransmission(targetPlayerId, audioData)
    -- Эмуляция отправки аудио данных
    local success = math.random() > 0.1 -- 90% успешность передачи
    
    if success and voiceChatUsers[targetPlayerId] then
        -- Воспроизводим звук у получателя
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://131961136" -- Звук микрофона
        sound.Volume = voiceVolume * 0.3
        sound.PlaybackSpeed = 0.8 + math.random() * 0.4
        sound.Parent = workspace
        sound:Play()
        
        game:GetService("Debris"):AddItem(sound, 2)
        
        -- Обновляем статус говорения
        voiceChatUsers[targetPlayerId].speaking = true
        spawn(function()
            wait(0.5)
            if voiceChatUsers[targetPlayerId] then
                voiceChatUsers[targetPlayerId].speaking = false
            end
        end)
    end
end

-- Обработка голосового ввода
local function handleVoiceInput()
    if not microphoneActive then return end
    
    -- Симуляция записи голоса
    local audioData = {
        timestamp = tick(),
        playerId = player.UserId,
        lobbyId = currentLobby
    }
    
    -- Отправляем голос всем пользователям в лобби
    for playerId, userData in pairs(voiceChatUsers) do
        if playerId ~= player.UserId and userData.lobbyId == currentLobby then
            simulateVoiceTransmission(playerId, audioData)
        end
    end
    
    -- Визуальная индикация говорения
    if voiceChatUsers[player.UserId] then
        voiceChatUsers[player.UserId].speaking = true
        spawn(function()
            wait(0.3)
            if voiceChatUsers[player.UserId] then
                voiceChatUsers[player.UserId].speaking = false
            end
        end)
    end
end

-- Подключение к голосовому чату
local function connectToVoiceChat()
    currentLobby = getCurrentLobby()
    
    -- Добавляем себя в список пользователей
    voiceChatUsers[player.UserId] = {
        name = player.Name,
        micActive = false,
        speaking = false,
        lobbyId = currentLobby
    }
    
    -- Добавляем других игроков из того же лобби
    for _, otherPlayer in pairs(game.Players:GetPlayers()) do
        if otherPlayer ~= player then
            voiceChatUsers[otherPlayer.UserId] = {
                name = otherPlayer.Name,
                micActive = false,
                speaking = false,
                lobbyId = currentLobby
            }
        end
    end
end

-- Отключение от голосового чата
local function disconnectFromVoiceChat()
    voiceChatUsers = {}
    microphoneActive = false
    
    -- Удаляем GUI
    local voiceGui = game:GetService("CoreGui"):FindFirstChild("CXNT_VoiceChat")
    if voiceGui then
        voiceGui:Destroy()
    end
    
    -- Отключаем все соединения
    for _, connection in pairs(voiceChatConnections) do
        connection:Disconnect()
    end
    voiceChatConnections = {}
end

-- Функция переключения голосового чата
local function toggleVoiceChat()
    voiceChatEnabled = not voiceChatEnabled
    voiceChatButton.Text = "VOICE CHAT: " .. (voiceChatEnabled and "ON" or "OFF")
    
    if voiceChatEnabled then
        -- Создаем интерфейс голосового чата
        local voiceGui, usersList, micButton, volumeLabel = createVoiceChat()
        
        -- Подключаемся к голосовому чату
        connectToVoiceChat()
        
        -- Обновляем список пользователей
        updateVoiceChatUsers(usersList)
        
        -- Обработчик кнопки микрофона
        micButton.MouseButton1Click:Connect(function()
            microphoneActive = not microphoneActive
            micButton.Text = "🎤 MIC: " .. (microphoneActive and "ON" or "OFF")
            micButton.BackgroundColor3 = microphoneActive and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(40, 40, 40)
            
            if voiceChatUsers[player.UserId] then
                voiceChatUsers[player.UserId].micActive = microphoneActive
            end
        end)
        
        -- Обработчик изменения громкости
        volumeLabel.MouseButton1Click:Connect(function()
            voiceVolume = (voiceVolume + 0.25) % 1.25
            if voiceVolume == 0 then voiceVolume = 0.25 end
            volumeLabel.Text = "🔊 VOL: " .. math.floor(voiceVolume * 100) .. "%"
        end)
        
        -- Обработчик голосового ввода (по клавише V)
        local inputConnection = game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
            if not gameProcessed and input.KeyCode == Enum.KeyCode.V and microphoneActive then
                handleVoiceInput()
            end
        end)
        table.insert(voiceChatConnections, inputConnection)
        
        -- Периодическое обновление списка пользователей
        local updateConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if voiceChatEnabled then
                updateVoiceChatUsers(usersList)
                
                -- Проверяем новых игроков в лобби
                for _, newPlayer in pairs(game.Players:GetPlayers()) do
                    if not voiceChatUsers[newPlayer.UserId] and newPlayer ~= player then
                        voiceChatUsers[newPlayer.UserId] = {
                            name = newPlayer.Name,
                            micActive = false,
                            speaking = false,
                            lobbyId = currentLobby
                        }
                    end
                end
            end
        end)
        table.insert(voiceChatConnections, updateConnection)
        
        -- Уведомление о подключении
        local notification = Instance.new("TextLabel")
        notification.Text = "🎙️ Voice Chat подключен! Нажмите V для говорения"
        notification.Size = UDim2.new(0, 350, 0, 50)
        notification.Position = UDim2.new(0.5, -175, 0, 50)
        notification.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        notification.TextColor3 = Color3.fromRGB(0, 0, 0)
        notification.Font = Enum.Font.GothamBold
        notification.TextSize = 14
        notification.BorderSizePixel = 0
        notification.TextWrapped = true
        notification.Parent = game:GetService("CoreGui")
        
        local notifCorner = Instance.new("UICorner")
        notifCorner.CornerRadius = UDim.new(0, 8)
        notifCorner.Parent = notification
        
        game:GetService("Debris"):AddItem(notification, 3)
        
    else
        disconnectFromVoiceChat()
    end
end

-- Основные функции
local function updateSpeed(value)
    local currentTime = tick()
    if currentTime - lastSpeedChange < speedCooldown then
        return
    end

    value = math.clamp(value, 1, 1000)
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = value
    end

    lastSpeedChange = currentTime
    speedLabel.Text = "SPEED PLAYER: " .. math.floor(value)
    sliderFill.Size = UDim2.new(value / 1000, 0, 1, 0)
    sliderButton.Position = UDim2.new(value / 1000, -5, 0, -5)
end

local function toggleMenu(visible)
    if visible then
        frame.Visible = true
        frame.Size = UDim2.new(0, 0, 0, 0)
        frame.Position = UDim2.new(0.5, 0, 0.5, 0)

        -- Анимация появления меню
        TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 600, 0, 600),
            Position = UDim2.new(0.5, -300, 0.5, -300)
        }):Play()

        -- Анимация тени
        shadow.BackgroundTransparency = 1
        TweenService:Create(shadow, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            BackgroundTransparency = 0.7
        }):Play()
    else
        -- Анимация исчезновения меню
        TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }):Play()

        -- Анимация тени
        TweenService:Create(shadow, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundTransparency = 1
        }):Play()

        wait(0.3)
        frame.Visible = false
    end
end

-- Оптимизация телепортации
local function optimizeTeleport()
    local teleportService = game:GetService("TeleportService")
    local replicatedStorage = game:GetService("ReplicatedStorage")

    -- Предварительная загрузка следующего места
    teleportService.LocalPlayerArrivedFromTeleport:Connect(function(loadingPlayer, teleportData)
        if teleportData then
            task.spawn(function()
                preloadAssets()
                optimizeServerLoading()
            end)
        end
    end)
end

local function onInput(input, gameProcessed)
    if input.KeyCode == toggleKey and not gameProcessed then
        toggleMenu(not frame.Visible)
    end
end

-- Инициализируем оптимизацию телепортации
optimizeTeleport()



local function onSliderDrag()
    local isDragging = false
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local dragConnection
    local endConnection

    sliderButton.MouseButton1Down:Connect(function()
        isDragging = true

        if dragConnection then dragConnection:Disconnect() end
        if endConnection then endConnection:Disconnect() end

        dragConnection = RunService.RenderStepped:Connect(function()
            if not isDragging then return end

            local mousePos = UserInputService:GetMouseLocation()
            local sliderStart = slider.AbsolutePosition.X
            local sliderWidth = slider.AbsoluteSize.X
            local relativeX = math.clamp((mousePos.X - sliderStart) / sliderWidth, 0, 1)
            local newValue = math.floor(relativeX * 1000)

            if newValue < 1 then newValue = 1 end
            if newValue > 1000 then newValue = 1000 end

            updateSpeed(newValue)
        end)

        endConnection = UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                isDragging = false
                if dragConnection then
                    dragConnection:Disconnect()
                end
                if endConnection then
                    endConnection:Disconnect()
                end
            end
        end)
    end)
end

-- Инициализация
local function toggleGodMode()
    godModeEnabled = not godModeEnabled
    godModeButton.Text = "GODMODE: " .. (godModeEnabled and "ON" or "OFF")

    local function applyGodMode(character)
        if not character then return end
        local humanoid = character:WaitForChild("Humanoid")

        -- Отключаем старый connection если он существует
        if humanoid.HealthChangedConnection then
            humanoid.HealthChangedConnection:Disconnect()
        end

        if godModeEnabled then
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge

            -- Создаем новый connection для автоматического лечения
            humanoid.HealthChangedConnection = humanoid.HealthChanged:Connect(function(health)
                if godModeEnabled and health < humanoid.MaxHealth then
                    humanoid.Health = 100000
                end
            end)
        else
            humanoid.MaxHealth = 100
            humanoid.Health = 100
        end
    end

    if player.Character then
        applyGodMode(player.Character)
    end

    player.CharacterAdded:Connect(function(character)
        if godModeEnabled then
            applyGodMode(character)
        end
    end)
end

-- Noclip функционал
local noclipEnabled = false
local function toggleNoclip()
    noclipEnabled = not noclipEnabled
    noclipButton.Text = "NOCLIP: " .. (noclipEnabled and "ON" or "OFF")

    local character = player.Character or player.CharacterAdded:Wait()
    local noclipLoop

    if noclipEnabled then
        noclipLoop = game:GetService("RunService").Stepped:Connect(function()
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    else
        if noclipLoop then
            noclipLoop:Disconnect()
        end
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- Функция превращения в свинью
local function morphToPig()
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local character = player.Character
    if not character then return end

    -- Сохраняем текущее положение
    local currentPosition = character.HumanoidRootPart.CFrame

    -- Меняем размеры и цвета всех частей тела
    local parts = {
        Head = {size = Vector3.new(2, 1.8, 1.8), color = Color3.fromRGB(255, 192, 203)},
        Torso = {size = Vector3.new(2.5, 2.5, 2), color = Color3.fromRGB(255, 192, 203)},
        ["Left Arm"] = {size = Vector3.new(1, 2, 1), color = Color3.fromRGB(255, 192, 203)},
        ["Right Arm"] = {size = Vector3.new(1, 2, 1), color = Color3.fromRGB(255, 192, 203)},
        ["Left Leg"] = {size = Vector3.new(1, 2, 1), color = Color3.fromRGB(255, 192, 203)},
        ["Right Leg"] = {size = Vector3.new(1, 2, 1), color = Color3.fromRGB(255, 192, 203)}
    }

    for partName, data in pairs(parts) do
        local part = character:FindFirstChild(partName)
        if part and part:IsA("BasePart") then
            part.Size = data.size
            part.Color = data.color
            part.Material = Enum.Material.Plastic
        end
    end

    -- Добавляем уши
    local ears = {
        Left = {pos = CFrame.new(-0.5, 0.7, -0.2)},
        Right = {pos = CFrame.new(0.5, 0.7, -0.2)}
    }

    for earName, data in pairs(ears) do
        local ear = Instance.new("Part")
        ear.Name = earName.."Ear"
        ear.Size = Vector3.new(0.8, 0.8, 0.3)
        ear.Color = Color3.fromRGB(255, 182, 193)
        ear.CanCollide = false
        ear.Material = Enum.Material.Plastic

        local weld = Instance.new("Weld")
        weld.Part0 = character.Head
        weld.Part1 = ear
        weld.C0 = data.pos
        weld.Parent = ear

        ear.Parent = character
    end

    -- Добавляем улучшенный пятачок
    local snout = Instance.new("Part")
    snout.Name = "PigSnout"
    snout.Size = Vector3.new(0.7, 0.7, 0.5)
    snout.Color = Color3.fromRGB(255, 150, 150)
    snout.CanCollide = false
    snout.Material = Enum.Material.Plastic

    local weld = Instance.new("Weld")
    weld.Part0 = character.Head
    weld.Part1 = snout
    weld.C0 = CFrame.new(0, -0.2, -1)
    weld.Parent = snout

    snout.Parent = character

    -- Добавляем хвостик
    local tail = Instance.new("Part")
    tail.Name = "PigTail"
    tail.Size = Vector3.new(0.3, 0.3, 0.3)
    tail.Color = Color3.fromRGB(255, 192, 203)
    tail.CanCollide = false
    tail.Material = Enum.Material.Plastic

    local tailWeld = Instance.new("Weld")
    tailWeld.Part0 = character.Torso
    tailWeld.Part1 = tail
    tailWeld.C0 = CFrame.new(0, -0.5, 1) * CFrame.Angles(0, 0, math.rad(45))
    tailWeld.Parent = tail

    tail.Parent = character

    -- Обновляем анимации
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = 16
        humanoid.JumpPower = 35
    end

    -- Возвращаем персонажа на исходную позицию
    character.HumanoidRootPart.CFrame = currentPosition
end

-- Кнопка для превращения в свинью
local pigButton = Instance.new("TextButton")
pigButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
pigButton.TextColor3 = Color3.fromRGB(255, 255, 255)
pigButton.Font = Enum.Font.GothamSemibold
pigButton.TextSize = 14
pigButton.BorderSizePixel = 0
pigButton.AutoButtonColor = true

-- Add rounded corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = pigButton

-- Add hover effect
local originalColor = pigButton.BackgroundColor3
pigButton.MouseEnter:Connect(function()
    pigButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
end)
pigButton.MouseLeave:Connect(function()
    pigButton.BackgroundColor3 = originalColor
end)
pigButton.Text = "MORPH TO PIG"
pigButton.Size = UDim2.new(0.4, -10, 0, 20)
pigButton.Position = UDim2.new(0, 10, 0, 240)
pigButton.Parent = frame

-- Infinity Jump
-- SuperSpeed settings
local superSpeedEnabled = false
local superSpeedMultiplier = 3

-- Teleport settings
local lastClickPosition = nil

-- Knockback function

local infinityJumpEnabled = false
local infinityJumpButton = Instance.new("TextButton")
infinityJumpButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
infinityJumpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
infinityJumpButton.Font = Enum.Font.GothamSemibold
infinityJumpButton.TextSize = 14
infinityJumpButton.BorderSizePixel = 0
infinityJumpButton.AutoButtonColor = true

-- Add rounded corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = infinityJumpButton

-- Add hover effect
local originalColor = infinityJumpButton.BackgroundColor3
infinityJumpButton.MouseEnter:Connect(function()
    infinityJumpButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
end)
infinityJumpButton.MouseLeave:Connect(function()
    infinityJumpButton.BackgroundColor3 = originalColor
end)
infinityJumpButton.Text = "INFINITY JUMP: OFF"
infinityJumpButton.Position = UDim2.new(0, 10, 0, 390)
infinityJumpButton.Size = UDim2.new(0.4, -10, 0, 20)
infinityJumpButton.Position = UDim2.new(0, 10, 0, 270)
infinityJumpButton.Parent = frame

local function toggleInfinityJump()
    infinityJumpEnabled = not infinityJumpEnabled
    infinityJumpButton.Text = "INFINITY JUMP: " .. (infinityJumpEnabled and "ON" or "OFF")
end

game:GetService("UserInputService").JumpRequest:Connect(function()
    if infinityJumpEnabled then
        local character = player.Character
        if character and character:FindFirstChildOfClass("Humanoid") then
            character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
        end
    end
end)

-- Функция для отключения всех функций
local function disableAllFeatures()
    -- Отключаем ESP
    espEnabled = false
    espButton.Text = "ESP: OFF"
    for player in pairs(espObjects) do
        removeEsp(player)
    end

    -- Отключаем Item ESP
    if next(itemEspObjects) then
        for _, objects in pairs(itemEspObjects) do
            if objects.highlight then objects.highlight:Destroy() end
            if objects.label then objects.label:Destroy() end
        end
        itemEspObjects = {}
        itemEspButton.Text = "ITEM ESP: OFF"
    end

    -- Отключаем Noclip
    noclipEnabled = false
    noclipButton.Text = "NOCLIP: OFF"

    -- Отключаем Spin
    spinEnabled = false
    spinButton.Text = "SPIN: OFF"
    for char, conn in pairs(spinConnections) do
        conn:Disconnect()
        local humanoidRootPart = char:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            humanoidRootPart.Anchored = false
        end
    end
    spinConnections = {}

    -- Отключаем GodMode
    godModeEnabled = false
    godModeButton.Text = "GODMODE: OFF"

    -- Отключаем Auto Heal
    autoHealEnabled = false
    if healConnection then
        healConnection:Disconnect()
        healConnection = nil
    end
    autoHealButton.Text = "AUTO HEAL: OFF"

    -- Сбрасываем небо на стандартное
    skyStyles["DEFAULT"]()
    skyButton.Text = "SKY: DEFAULT"

    -- Отключаем все остальные функции...
    frame.Visible = false
end

-- Инициализация
local function initialize()
    spawn(function()
        -- Отслеживаем смену сервера
        game:GetService("CoreGui").ChildRemoved:Connect(function(child)
            if child == gui then
                disableAllFeatures()
            end
        end)
    end)

    spawn(function()
        -- Очищаем существующие ESP объекты при телепортации
        game:GetService("Players").PlayerRemoving:Connect(function(player)
            if espObjects[player] then
                for _, part in ipairs(espObjects[player]) do
                    if part and part.Parent then
                        part:Destroy()
                    end
                end
                espObjects[player] = nil
            end
        end)
    end)

    loadingGui:Destroy()

    -- Handle player leaving
    game.Players.PlayerRemoving:Connect(function(leavingPlayer)
        if espObjects[leavingPlayer] then
            removeEsp(leavingPlayer)
        end
    end)

    if player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = defaultWalkSpeed
        end
    end

    game:GetService("UserInputService").InputBegan:Connect(onInput)
    sliderButton.MouseButton1Down:Connect(onSliderDrag)

    espButton.MouseButton1Click:Connect(toggleEsp)
    itemEspButton.MouseButton1Click:Connect(function()
        local isEnabled = toggleItemEsp()
        itemEspButton.Text = "ITEM ESP: " .. (isEnabled and "ON" or "OFF")
    end)
    
    voiceChatButton.MouseButton1Click:Connect(toggleVoiceChat)
    spinButton.MouseButton1Click:Connect(toggleSpin)
    godModeButton.MouseButton1Click:Connect(toggleGodMode)



    noclipButton.MouseButton1Click:Connect(toggleNoclip)




    -- Click Teleport button
    local teleportButton = Instance.new("TextButton")
teleportButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.Font = Enum.Font.GothamSemibold
teleportButton.TextSize = 14
teleportButton.BorderSizePixel = 0
teleportButton.AutoButtonColor = true

-- Add rounded corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = teleportButton

-- Add hover effect
local originalColor = teleportButton.BackgroundColor3
teleportButton.MouseEnter:Connect(function()
    teleportButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
end)
teleportButton.MouseLeave:Connect(function()
    teleportButton.BackgroundColor3 = originalColor
end)
    teleportButton.Text = "CLICK TELEPORT: OFF"
    teleportButton.Size = UDim2.new(0.4, -10, 0, 20)
    teleportButton.Position = UDim2.new(0, 10, 0, 300)
    teleportButton.Parent = frame

    local teleportEnabled = false
    teleportButton.MouseButton1Click:Connect(function()
        teleportEnabled = not teleportEnabled
        teleportButton.Text = "CLICK TELEPORT: " .. (teleportEnabled and "ON" or "OFF")

        if teleportEnabled then
            game:GetService("UserInputService").InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 and teleportEnabled then
                    local mouse = player:GetMouse()
                    local character = player.Character
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
                    end
                end
            end)
        end
    end)

    -- Pig morph button
    pigButton.MouseButton1Click:Connect(morphToPig)
    infinityJumpButton.MouseButton1Click:Connect(toggleInfinityJump)

    -- Fly Button
    local flyButton = Instance.new("TextButton")
flyButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.Font = Enum.Font.GothamSemibold
flyButton.TextSize = 14
flyButton.BorderSizePixel = 0
flyButton.AutoButtonColor = true

-- Add rounded corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = flyButton

-- Add hover effect
local originalColor = flyButton.BackgroundColor3
flyButton.MouseEnter:Connect(function()
    flyButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
end)
flyButton.MouseLeave:Connect(function()
    flyButton.BackgroundColor3 = originalColor
end)
    flyButton.Text = "FLY: OFF"
    flyButton.Size = UDim2.new(0.4, -10, 0, 20)
    flyButton.Position = UDim2.new(0, 10, 0, 330)
    flyButton.Parent = frame

    local flyEnabled = false
    local flySpeed = 50
    local flyConnection

    flyButton.MouseButton1Click:Connect(function()
        flyEnabled = not flyEnabled
        flyButton.Text = "FLY: " .. (flyEnabled and "ON" or "OFF")

        if flyEnabled then
            local char = player.Character
            local humanoid = char:FindFirstChild("Humanoid")
            local root = char:FindFirstChild("HumanoidRootPart")

            if humanoid and root then
                root.Anchored = true

                flyConnection = game:GetService("RunService").RenderStepped:Connect(function()
                    local camera = workspace.CurrentCamera
                    local lookVector = camera.CFrame.LookVector
                    local rightVector = camera.CFrame.RightVector

                    local moveDirection = Vector3.new(0, 0, 0)
                    local moved = false

                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
                        moveDirection = moveDirection + lookVector
                        moved = true
                    end
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
                        moveDirection = moveDirection - lookVector
                        moved = true
                    end
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
                        moveDirection = moveDirection + rightVector
                        moved = true
                    end
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
                        moveDirection = moveDirection - rightVector
                        moved = true
                    end
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection = moveDirection + Vector3.new(0, 1, 0)
                        moved = true
                    end
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection = moveDirection - Vector3.new(0, 1, 0)
                        moved = true
                    end

                    if moved then
                        root.CFrame = root.CFrame + moveDirection.Unit * (flySpeed * 0.1)
                    end
                end)

                humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
            end
        else
            if flyConnection then
                flyConnection:Disconnect()
                flyConnection = nil
                local humanoid = player.Character:FindFirstChild("Humanoid")
                local root = player.Character:FindFirstChild("HumanoidRootPart")
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Landing)
                end
                if root then
                    root.Anchored = false
                    root.Velocity = Vector3.new(0, 0, 0)
                end
            end
        end
    end)


    -- Invisibility Button
    local invisibilityButton = Instance.new("TextButton")
invisibilityButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
invisibilityButton.TextColor3 = Color3.fromRGB(255, 255, 255)
invisibilityButton.Font = Enum.Font.GothamSemibold
invisibilityButton.TextSize = 14
invisibilityButton.BorderSizePixel = 0
invisibilityButton.AutoButtonColor = true

-- Add rounded corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = invisibilityButton

-- Add hover effect
local originalColor = invisibilityButton.BackgroundColor3
invisibilityButton.MouseEnter:Connect(function()
    invisibilityButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
end)
invisibilityButton.MouseLeave:Connect(function()
    invisibilityButton.BackgroundColor3 = originalColor
end)
    invisibilityButton.Text = "INVISIBILITY: OFF"
    invisibilityButton.Size = UDim2.new(0.4, -10, 0, 20)
    invisibilityButton.Position = UDim2.new(0, 10, 0, 360)
    invisibilityButton.Parent = frame

    local isInvisible = false
    local invisibilityConnection

    invisibilityButton.MouseButton1Click:Connect(function()
        isInvisible = not isInvisible
        invisibilityButton.Text = "INVISIBILITY: " .. (isInvisible and "ON" or "OFF")

        local char = player.Character
        if char then
            -- Обновляем прозрачность
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") or part:IsA("Decal") then
                    part.Transparency = isInvisible and 1 or 0
                end
            end

            -- Управляем обнаружением мобами
            if isInvisible then
                invisibilityConnection = game:GetService("RunService").Heartbeat:Connect(function()
                    local character = player.Character
                    if not character then return end
                    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                    if not humanoidRootPart then return end

                    for _, mob in pairs(workspace:GetDescendants()) do
                        if mob:IsA("Model") and mob:FindFirstChild("Humanoid") and 
                           not game.Players:GetPlayerFromCharacter(mob) then

                            local mobHumanoid = mob:FindFirstChild("Humanoid")
                            local mobRoot = mob:FindFirstChild("HumanoidRootPart")

                            if mobHumanoid and mobRoot then
                                -- Заставляем моба идти в противоположном направлении
                                local direction = (mobRoot.Position - humanoidRootPart.Position).Unit
                                local targetPos = mobRoot.Position + direction * 50
                                mobHumanoid:MoveTo(targetPos)

                                -- Отключаем атаку
                                mobHumanoid.AutoRotate = false
                                for _, state in pairs(Enum.HumanoidStateType:GetEnumItems()) do
                                    if state.Name:match("Attack") then
                                        mobHumanoid:SetStateEnabled(state, false)
                                    end
                                end
                            end
                        end
                    end
                end)
            else
                -- Восстанавливаем нормальное поведение мобов
                if invisibilityConnection then
                    invisibilityConnection:Disconnect()
                end

                for _, mob in pairs(workspace:GetDescendants()) do
                    if mob:IsA("Model") and mob:FindFirstChild("Humanoid") and 
                       not game.Players:GetPlayerFromCharacter(mob) then

                        local mobHumanoid = mob:FindFirstChild("Humanoid")
                        if mobHumanoid then
                            mobHumanoid.AutoRotate = true
                            for _, state in pairs(Enum.HumanoidStateType:GetEnumItems()) do
                                mobHumanoid:SetStateEnabled(state, true)
                            end
                        end
                    end
                end
            end
        end
    end)

    -- Rapid Attack Button
    -- Auto Heal Button
    local autoHealButton = Instance.new("TextButton")
autoHealButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
autoHealButton.TextColor3 = Color3.fromRGB(255, 255, 255)
autoHealButton.Font = Enum.Font.GothamSemibold
autoHealButton.TextSize = 14
autoHealButton.BorderSizePixel = 0
autoHealButton.AutoButtonColor = true

-- Add rounded corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = autoHealButton

-- Add hover effect
local originalColor = autoHealButton.BackgroundColor3
autoHealButton.MouseEnter:Connect(function()
    autoHealButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
end)
autoHealButton.MouseLeave:Connect(function()
    autoHealButton.BackgroundColor3 = originalColor
end)
    autoHealButton.Text = "AUTO HEAL: OFF"
    autoHealButton.Size = UDim2.new(0.4, -10, 0, 20)
    autoHealButton.Position = UDim2.new(0, 10, 0, 390)
    autoHealButton.Parent = frame

    -- Aimbot Button
    local aimbotButton = Instance.new("TextButton")
aimbotButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
aimbotButton.TextColor3 = Color3.fromRGB(255, 255, 255)
aimbotButton.Font = Enum.Font.GothamSemibold
aimbotButton.TextSize = 14
aimbotButton.BorderSizePixel = 0
aimbotButton.AutoButtonColor = true

-- Add rounded corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = aimbotButton

-- Add hover effect
local originalColor = aimbotButton.BackgroundColor3
aimbotButton.MouseEnter:Connect(function()
    aimbotButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
end)
aimbotButton.MouseLeave:Connect(function()
    aimbotButton.BackgroundColor3 = originalColor
end)
    aimbotButton.Text = "AIMBOT: OFF"
    aimbotButton.Size = UDim2.new(0.4, -10, 0, 20)
    aimbotButton.Position = UDim2.new(0.6, 0, 0, 90)
    aimbotButton.Parent = frame

    -- Mob Aimbot Button
    local mobAimbotButton = Instance.new("TextButton")
mobAimbotButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
mobAimbotButton.TextColor3 = Color3.fromRGB(255, 255, 255)
mobAimbotButton.Font = Enum.Font.GothamSemibold
mobAimbotButton.TextSize = 14
mobAimbotButton.BorderSizePixel = 0
mobAimbotButton.AutoButtonColor = true

-- Add rounded corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = mobAimbotButton

-- Add hover effect
local originalColor = mobAimbotButton.BackgroundColor3
mobAimbotButton.MouseEnter:Connect(function()
    mobAimbotButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
end)
mobAimbotButton.MouseLeave:Connect(function()
    mobAimbotButton.BackgroundColor3 = originalColor
end)
    mobAimbotButton.Text = "MOB AIMBOT: OFF"
    mobAimbotButton.Size = UDim2.new(0.4, -10, 0, 20)
    mobAimbotButton.Position = UDim2.new(0.6, 0, 0, 120)
    mobAimbotButton.Parent = frame

    -- Auto Collect Button
    local autoCollectButton = Instance.new("TextButton")
autoCollectButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
autoCollectButton.TextColor3 = Color3.fromRGB(255, 255, 255)
autoCollectButton.Font = Enum.Font.GothamSemibold
autoCollectButton.TextSize = 14
autoCollectButton.BorderSizePixel = 0
autoCollectButton.AutoButtonColor = true

-- Add rounded corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = autoCollectButton

-- Add hover effect
local originalColor = autoCollectButton.BackgroundColor3
autoCollectButton.MouseEnter:Connect(function()
    autoCollectButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
end)
autoCollectButton.MouseLeave:Connect(function()
    autoCollectButton.BackgroundColor3 = originalColor
end)
    autoCollectButton.Text = "AUTO COLLECT: OFF"
    autoCollectButton.Size = UDim2.new(0.4, -10, 0, 20)
    autoCollectButton.Position = UDim2.new(0.6, 0, 0, 150)
    autoCollectButton.Parent = frame

    -- Rapid Attack Button
    local rapidAttackButton = Instance.new("TextButton")
rapidAttackButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
rapidAttackButton.TextColor3 = Color3.fromRGB(255, 255, 255)
rapidAttackButton.Font = Enum.Font.GothamSemibold
rapidAttackButton.TextSize = 14
rapidAttackButton.BorderSizePixel = 0
rapidAttackButton.AutoButtonColor = true

-- Add rounded corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = rapidAttackButton

-- Add hover effect
local originalColor = rapidAttackButton.BackgroundColor3
rapidAttackButton.MouseEnter:Connect(function()
    rapidAttackButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
end)
rapidAttackButton.MouseLeave:Connect(function()
    rapidAttackButton.BackgroundColor3 = originalColor
end)
    rapidAttackButton.Text = "RAPID ATTACK: OFF"
    rapidAttackButton.Size = UDim2.new(0.4, -10, 0, 20)
    rapidAttackButton.Position = UDim2.new(0.6, 0, 0, 180)
    rapidAttackButton.Parent = frame

    -- Auto Shoot Button
    local autoShootButton = Instance.new("TextButton")
autoShootButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
autoShootButton.TextColor3 = Color3.fromRGB(255, 255, 255)
autoShootButton.Font = Enum.Font.GothamSemibold
autoShootButton.TextSize = 14
autoShootButton.BorderSizePixel = 0
autoShootButton.AutoButtonColor = true

-- Add rounded corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = autoShootButton

-- Add hover effect
local originalColor = autoShootButton.BackgroundColor3
autoShootButton.MouseEnter:Connect(function()
    autoShootButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
end)
autoShootButton.MouseLeave:Connect(function()
    autoShootButton.BackgroundColor3 = originalColor
end)
    autoShootButton.Text = "AUTO SHOOT: OFF"
    autoShootButton.Size = UDim2.new(0.4, -10, 0, 20)
    autoShootButton.Position = UDim2.new(0.6, 0, 0, 210)
    autoShootButton.Parent = frame

    -- Ammo Hack Button
    -- AI Control Button
local aiControlButton = Instance.new("TextButton")
aiControlButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
aiControlButton.TextColor3 = Color3.fromRGB(255, 255, 255)
aiControlButton.Font = Enum.Font.GothamSemibold
aiControlButton.TextSize = 14
aiControlButton.BorderSizePixel = 0
aiControlButton.AutoButtonColor = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = aiControlButton

local originalColor = aiControlButton.BackgroundColor3
aiControlButton.MouseEnter:Connect(function()
    aiControlButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
end)
aiControlButton.MouseLeave:Connect(function()
    aiControlButton.BackgroundColor3 = originalColor
end)

aiControlButton.Text = "AI CONTROL: OFF"
aiControlButton.Size = UDim2.new(0.4, -10, 0, 20)
aiControlButton.Position = UDim2.new(0.6, 0, 0, 450)
aiControlButton.Parent = frame

local aiEnabled = false
local aiMemory = {}
local lastPosition = nil
local lastHealth = 100
local learningRate = 0.25  -- Increased learning rate
local updateInterval = 0.05 -- Faster updates
local lastUpdate = 0
local cachedEnemies = {}
local lastCacheUpdate = 0
local cacheUpdateInterval = 0.5 -- Faster cache updates
local experiencePoints = 0
local aiLevel = 1
local nextLevelExp = 100
local aiPersonality = {
    aggression = 0.5,
    caution = 0.5,
    curiosity = 0.8,
    helpfulness = 0.7
}
local aiMood = "neutral"
local aiLastAction = tick()
local aiActionCooldown = 0.1
local aiKnowledge = {
    combatExperience = 0,
    explorationData = {},
    itemMemory = {},
    playerInteractions = {}
}

-- Cached workspace
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

-- AI Stats that improve with learning
local aiStats = {
    attackDamage = 10,
    defenseBonus = 0,
    criticalChance = 5,
    dodgeChance = 5,
    experienceMultiplier = 1,
    healthRegen = 1
}

local function updateAIStats()
    aiStats.attackDamage = 10 + (aiLevel * 2)
    aiStats.defenseBonus = aiLevel
    aiStats.criticalChance = 5 + (aiLevel * 0.5)
    aiStats.dodgeChance = 5 + (aiLevel * 0.5)
    aiStats.experienceMultiplier = 1 + (aiLevel * 0.1)
    aiStats.healthRegen = 1 + (aiLevel * 0.2)
end

local function gainExperience(amount)
    experiencePoints = experiencePoints + (amount * aiStats.experienceMultiplier)
    if experiencePoints >= nextLevelExp then
        aiLevel = aiLevel + 1
        experiencePoints = experiencePoints - nextLevelExp
        nextLevelExp = nextLevelExp * 1.5
        updateAIStats()

        -- Visual feedback for level up
        local levelUpText = Instance.new("TextLabel")
        levelUpText.Text = "AI Level Up! Level " .. aiLevel
        levelUpText.Size = UDim2.new(0, 200, 0, 50)
        levelUpText.Position = UDim2.new(0.5, -100, 0.3, 0)
        levelUpText.BackgroundTransparency = 1
        levelUpText.TextColor3 = Color3.new(1, 1, 0)
        levelUpText.TextStrokeTransparency = 0
        levelUpText.Font = Enum.Font.GothamBold
        levelUpText.TextSize = 24
        levelUpText.Parent = game.Players.LocalPlayer.PlayerGui

        game:GetService("Debris"):AddItem(levelUpText, 2)
    end
end

local function getClosestEnemy()
    local currentTime = tick()

    -- Update cache if needed
    if currentTime - lastCacheUpdate > cacheUpdateInterval then
        cachedEnemies = {}
        local character = player.Character
        if not character then return nil end

        -- Use spatial hashing for more efficient enemy detection
        local characterPos = character.PrimaryPart.Position
        local searchRadius = 100

        for _, obj in ipairs(Workspace:GetPartBoundsInRadius(characterPos, searchRadius)) do
            local model = obj:FindFirstAncestorWhichIsA("Model")
            if model and model:FindFirstChild("Humanoid") and 
               model:FindFirstChild("HumanoidRootPart") and
               model ~= character and
               model.Humanoid.Health > 0 then
                table.insert(cachedEnemies, model)
            end
        end

        lastCacheUpdate = currentTime
    end

    -- Find closest enemy from cache
    local closest = nil
    local minDistance = math.huge
    local character = player.Character
    if not character then return nil end

    for _, enemy in ipairs(cachedEnemies) do
        if enemy.Parent and enemy.Humanoid.Health > 0 then
            local distance = (enemy.HumanoidRootPart.Position - character.PrimaryPart.Position).Magnitude
            if distance < minDistance then
                minDistance = distance
                closest = enemy
            end
        end
    end

    return closest
end

local function collectNearbyItems()
    local character = player.Character
    if not character then return end

    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    for _, item in pairs(workspace:GetDescendants()) do
        if item:IsA("BasePart") and 
           (item.Name:lower():find("item") or 
            item.Name:lower():find("pickup") or 
            item.Name:lower():find("weapon") or 
            item.Name:lower():find("heal")) then

            local distance = (item.Position - rootPart.Position).Magnitude
            if distance < 20 then
                item.CFrame = rootPart.CFrame
            end
        end
    end
end

local function updateAIMemory(action, reward)
    table.insert(aiMemory, {
        action = action,
        reward = reward
    })
    if #aiMemory > 1000 then
        table.remove(aiMemory, 1)
    end
end

local function getBestAction()
    if #aiMemory == 0 then return "explore" end

    local actionScores = {}
    local timeWeight = math.sin(tick() * 0.1) * 0.2 + 0.8 -- Time-based variation

    -- Factor in AI personality and mood
    local moodModifier = {
        happy = 1.2,
        neutral = 1.0,
        cautious = 0.8,
        aggressive = 1.5
    }

    -- Calculate weighted scores
    for _, memory in pairs(aiMemory) do
        local baseScore = memory.reward
        local personalityMod = 1.0

        if memory.action == "attack" then
            personalityMod = aiPersonality.aggression
        elseif memory.action == "explore" then
            personalityMod = aiPersonality.curiosity
        elseif memory.action == "help" then
            personalityMod = aiPersonality.helpfulness
        elseif memory.action == "defend" then
            personalityMod = aiPersonality.caution
        end

        local moodMod = moodModifier[aiMood] or 1.0
        local finalScore = baseScore * personalityMod * moodMod * timeWeight

        actionScores[memory.action] = (actionScores[memory.action] or 0) + finalScore
    end

    -- Add random exploration factor
    local explorationChance = 0.1 + (1 - aiPersonality.caution) * 0.2
    if math.random() < explorationChance then
        local actions = {"explore", "search_items", "interact", "practice_combat", "observe"}
        return actions[math.random(#actions)]
    end

    -- Find best action
    local bestAction = "explore"
    local bestScore = -math.huge
    for action, score in pairs(actionScores) do
        if score > bestScore then
            bestScore = score
            bestAction = action
        end
    end

    -- Update AI mood based on success
    if bestScore > 10 then
        aiMood = "happy"
    elseif bestScore < 0 then
        aiMood = "cautious"
    end

    -- Record the decision in knowledge base
    table.insert(aiKnowledge.playerInteractions, {
        time = tick(),
        action = bestAction,
        score = bestScore
    })

    return bestAction
end

local function performAction(action)
    local character = player.Character
    if not character then return end

    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then return end

    -- Add random delays and human-like behavior
    local function humanDelay()
        wait(math.random() * 0.5 + 0.1) -- Random delay between 0.1-0.6 seconds
    end

    -- Simulate human-like mouse movement
    local function simulateMouseMovement()
        local camera = workspace.CurrentCamera
        local startCF = camera.CFrame
        local endCF = CFrame.new(camera.CFrame.Position, rootPart.Position + Vector3.new(
            math.random(-5, 5),
            math.random(0, 3),
            math.random(-5, 5)
        ))

        for i = 0, 1, 0.1 do
            camera.CFrame = startCF:Lerp(endCF, i)
            wait(0.02)
        end
    end

    if action == "explore" then
        -- More natural exploration patterns with smooth movement
        local points = workspace:GetPartBoundsInRadius(rootPart.Position, 100)
        if #points > 0 then
            -- Select a reasonable target point
            local targetPoint = points[math.random(#points)]
            local targetPos = targetPoint.Position + Vector3.new(0, 3, 0)

            -- Calculate direction to target
            local direction = (targetPos - rootPart.Position).Unit
            local targetCF = CFrame.new(rootPoint.Position, targetPos)

            -- Smooth rotation to face target
            local rotationDuration = 0.5
            local startCF = rootPart.CFrame
            for i = 0, 1, 0.1 do
                rootPart.CFrame = startCF:Lerp(targetCF, i)
                wait(rotationDuration/10)
            end

            -- Move towards target with natural walking
            humanoid:MoveTo(targetPos)

            -- Occasional natural jumping while walking (not too frequent)
            spawn(function()
                while (rootPart.Position - targetPos).Magnitude > 5 do
                    if math.random() < 0.1 then -- 10% chance to jump
                        wait(math.random(2, 4)) -- Wait between jumps
                        humanoid.Jump = true
                        wait(1) -- Wait for jump to complete
                    end
                    wait(0.5)
                end
            end)

            -- Wait until close to target before next action
            wait(1)

            -- Choose interesting points to explore (like a real player would)
            local potentialTargets = {}
            for _, point in ipairs(points) do
                local score = 0

                -- Prefer elevated positions (players like high ground)
                if point.Position.Y > rootPart.Position.Y then
                    score = score + 2
                end

                -- Prefer points near items or interactive objects
                for _, obj in pairs(workspace:GetPartsInPart(point)) do
                    if obj.Name:lower():find("item") or obj.Name:lower():find("pickup") then
                        score = score + 3
                    end
                end

                -- Avoid obvious traps or dangerous areas
                local dangerousObjects = workspace:GetPartsInPart(point)
                for _, obj in pairs(dangerousObjects) do
                    if obj.Name:lower():find("trap") or obj.Name:lower():find("damage") then
                        score = score - 5
                    end
                end

                table.insert(potentialTargets, {point = point, score = score})
            end

            -- Choose target based on scores (weighted random selection)
            table.sort(potentialTargets, function(a, b) return a.score > b.score end)
            local target = potentialTargets[math.random(1, math.min(3, #potentialTargets))].point
            local distance = (target.Position - rootPart.Position).Magnitude

            -- Break long movements into smaller segments
            if distance > 30 then
                local segments = math.ceil(distance / 30)
                for i = 1, segments do
                    local segmentPos = rootPart.Position:Lerp(target.Position, i/segments)
                    humanoid:MoveTo(segmentPos + Vector3.new(0, 5, 0))
                    wait(math.random() * 0.5 + 0.3)

                    -- Occasionally look around while moving
                    if math.random() < 0.2 then
                        simulateMouseMovement()
                    end
                end
            else
                humanoid:MoveTo(target.Position + Vector3.new(0, 5, 0))
            end
        end

    elseif action == "search_items" then
        -- Look for valuable items
        for _, item in pairs(workspace:GetDescendants()) do
            if item:IsA("BasePart") and item.Name:lower():match("item") then
                local distance = (item.Position - rootPart.Position).Magnitude
                if distance < 50 then
                    humanoid:MoveTo(item.Position)
                    aiKnowledge.itemMemory[item] = tick()
                    break
                end
            end
        end

    elseif action == "practice_combat" then
        -- Advanced human-like combat behavior
        local tool = character:FindFirstChildOfClass("Tool")
        if tool then
            -- Simulate realistic combat decision making
            local enemies = {}
            local nearbyCovers = {}

            -- Find enemies and potential cover spots
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and 
                   obj ~= character and obj:FindFirstChild("HumanoidRootPart") then
                    local distance = (obj.HumanoidRootPart.Position - rootPart.Position).Magnitude
                    table.insert(enemies, {
                        model = obj,
                        distance = distance,
                        health = obj.Humanoid.Health,
                        isAggressive = obj:FindFirstChildOfClass("Tool") ~= nil
                    })
                elseif obj:IsA("BasePart") and obj.Size.Y > 3 and obj.CanCollide then
                    -- Identify potential cover spots
                    table.insert(nearbyCovers, obj)
                end
            end

            -- Sort enemies by threat level
            table.sort(enemies, function(a, b)
                local threatA = (a.isAggressive and 2 or 1) * (100/a.distance) * (a.health/100)
                local threatB = (b.isAggressive and 2 or 1) * (100/b.distance) * (b.health/100)
                return threatA > threatB
            end)

            if #enemies > 0 then
                local target = enemies[1].model
                local targetRoot = target.HumanoidRootPart
                local targetDistance = enemies[1].distance

                -- Combat strategy based on situation
                if targetDistance < 10 then
                    -- Close combat behavior
                    if math.random() < 0.4 then
                        -- Dodge or jump
                        humanoid.Jump = true
                        local dodgeDir = Vector3.new(math.random(-1, 1), 0, math.random(-1, 1)).Unit * 8
                        humanoid:MoveTo(rootPart.Position + dodgeDir)
                    end
                elseif targetDistance < 30 then
                    -- Mid-range combat
                    if #nearbyCovers > 0 and math.random() < 0.3 then
                        -- Use cover strategically
                        local cover = nearbyCovers[math.random(#nearbyCovers)]
                        humanoid:MoveTo(cover.Position + (cover.Position - targetRoot.Position).Unit * 5)
                    end
                else
                    -- Long-range combat
                    if math.random() < 0.6 then
                        -- Find high ground or better position
                        local bestPos = rootPart.Position
                        for _, cover in ipairs(nearbyCovers) do
                            if cover.Position.Y > bestPos.Y then
                                bestPos = cover.Position
                            end
                        end
                        humanoid:MoveTo(bestPos + Vector3.new(0, 2, 0))
                    end
                end

                -- Realistic aiming behavior
                local aimTime = math.random() * 0.2 + 0.1
                local startCF = workspace.CurrentCamera.CFrame
                local targetPos = targetRoot.Position + Vector3.new(
                    math.random(-0.5, 0.5),
                    math.random(0, 1),
                    math.random(-0.5, 0.5)
                )
                local endCF = CFrame.new(workspace.CurrentCamera.CFrame.Position, targetPos)

                -- Smooth aim movement
                for i = 0, 1, 0.1 do
                    workspace.CurrentCamera.CFrame = startCF:Lerp(endCF, i)
                    wait(aimTime/10)
                end

                -- Add random aim shake
                local shakeIntensity = math.random() * 0.2
                workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame * CFrame.new(
                    math.random(-shakeIntensity, shakeIntensity),
                    math.random(-shakeIntensity, shakeIntensity),
                    0
                )

                -- Attack with human-like timing
                if math.random() < 0.8 then
                    tool:Activate()
                    wait(math.random() * 0.2 + 0.1)
                end

                aiKnowledge.combatExperience = aiKnowledge.combatExperience + 1
            end

            if #enemies > 0 then
                local target = enemies[math.random(#enemies)]
                local targetRoot = target.HumanoidRootPart

                -- Simulate human aiming
                local aimTime = math.random() * 0.3 + 0.1
                local startCF = workspace.CurrentCamera.CFrame
                local endCF = CFrame.new(workspace.CurrentCamera.CFrame.Position, targetRoot.Position)

                for i = 0, 1, 0.1 do
                    workspace.CurrentCamera.CFrame = startCF:Lerp(endCF, i)
                    wait(aimTime/10)
                end

                -- Add random inaccuracy to aim
                local inaccuracy = Vector3.new(
                    math.random(-1, 1),
                    math.random(-1, 1),
                    math.random(-1, 1)
                ) * (1 - math.min(aiKnowledge.combatExperience/100, 0.9))

                tool:Activate()
                aiKnowledge.combatExperience = aiKnowledge.combatExperience + 1

                -- Random combat movement
                if math.random() < 0.7 then
                    local dodgeDir = Vector3.new(math.random(-1, 1), 0, math.random(-1, 1)).Unit * 10
                    humanoid:MoveTo(rootPart.Position + dodgeDir)
                end
            end
        end

    elseif action == "observe" then
        -- Observe surroundings and learn
        local nearbyPlayers = {}
        for _, player in pairs(game.Players:GetPlayers()) do
            if player.Character and player.Character ~= character then
                local distance = (player.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
                if distance < 50 then
                    table.insert(nearbyPlayers, player)
                end
            end
        end

        -- Learn from players
        for _, observed in pairs(nearbyPlayers) do
            if observed.Character then
                local tool = observed.Character:FindFirstChildOfClass("Tool")
                if tool then
                    aiKnowledge.playerInteractions[observed.Name] = {
                        lastSeen = tick(),
                        tool = tool.Name
                    }
                end
            end
        end
    end

    aiLastAction = tick()
end

aiControlButton.MouseButton1Click:Connect(function()
    aiEnabled = not aiEnabled
    aiControlButton.Text = "AI CONTROL: " .. (aiEnabled and "ON" .. " (Level " .. aiLevel .. " | " .. aiMood .. ")" or "OFF")

    if aiEnabled then
        -- Main AI loop
        spawn(function()
            while aiEnabled do
                local currentTime = tick()
                if currentTime - lastUpdate < updateInterval then
                    RunService.Heartbeat:Wait()
                    continue
                end
                lastUpdate = currentTime

                local character = player.Character
                if character then
                    local humanoid = character:FindFirstChild("Humanoid")
                    local rootPart = character:FindFirstChild("HumanoidRootPart")

                    if humanoid and rootPart then
                        local currentHealth = humanoid.Health
                        local currentPos = rootPart.Position

                        -- Check if stuck or blocked
                        local lastPositions = {}
                        local stuckThreshold = 3 -- Number of checks before considering stuck
                        local stuckDistance = 1 -- Minimum distance to move to not be considered stuck

                        -- Add current position to history
                        table.insert(lastPositions, currentPos)
                        if #lastPositions > stuckThreshold then
                            table.remove(lastPositions, 1)

                            -- Check if stuck
                            local isStuck = true
                            for i = 1, #lastPositions - 1 do
                                if (lastPositions[i] - lastPositions[i + 1]).Magnitude > stuckDistance then
                                    isStuck = false
                                    break
                                end
                            end

                            -- Check for obstacles
                            local rayOrigin = rootPart.Position
                            local rayDirection = rootPart.CFrame.LookVector * 4
                            local raycastParams = RaycastParams.new()
                            raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                            raycastParams.FilterDescendantsInstances = {character}

                            local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)

                            -- Jump if stuck or obstacle detected
                            if isStuck or raycastResult then
                                humanoid.Jump = true
                                -- Add upward force for better jumping
                                rootPart.Velocity = Vector3.new(
                                    rootPart.Velocity.X,
                                    50, -- Jump force
                                    rootPart.Velocity.Z
                                )
                                -- Try to move in a slightly different direction
                                local randomAngle = math.rad(math.random(-45, 45))
                                local newDirection = CFrame.Angles(0, randomAngle, 0) * rayDirection
                                humanoid:MoveTo(rootPart.Position + newDirection)
                            end
                        end

                        -- Check for idle state
                        local lastMovementTime = lastMovementTime or tick()
                        local idleThreshold = 3 -- 15 seconds threshold

                        if (currentPos - (lastPosition or currentPos)).Magnitude < 0.1 then
                            if tick() - lastMovementTime > idleThreshold then
                                -- Generate random direction and distance
                                local randomAngle = math.random() * math.pi * 2
                                local randomDistance = math.random(20, 50)
                                local newPos = currentPos + Vector3.new(
                                    math.cos(randomAngle) * randomDistance,
                                    0,
                                    math.sin(randomAngle) * randomDistance
                                )

                                -- Move to new position
                                humanoid:MoveTo(newPos)

                                -- Play random animation
                                if #animations > 0 then
                                    local randomAnim = animations[math.random(1, #animations)]
                                    local animation = Instance.new("Animation")
                                    animation.AnimationId = randomAnim.id
                                    local animTrack = humanoid:LoadAnimation(animation)
                                    animTrack:Play()
                                end

                                lastMovementTime = tick()
                            end
                        else
                            lastMovementTime = tick()
                        end

                        -- Player friendship system
                        for _, otherPlayer in pairs(game.Players:GetPlayers()) do
                            if otherPlayer ~= player and otherPlayer.Character then
                                local distance = (otherPlayer.Character.HumanoidRootPart.Position - currentPos).Magnitude

                                if distance < 10 then
                                    -- Friendly behavior
                                    aiMood = "happy"
                                    local randomAction = math.random(1, 3)

                                    if randomAction == 1 then
                                        -- Wave animation
                                        local waveAnim = Instance.new("Animation")
                                        waveAnim.AnimationId = "rbxassetid://507770239"
                                        local animTrack = humanoid:LoadAnimation(waveAnim)
                                        animTrack:Play()
                                    elseif randomAction == 2 then
                                        -- Follow player
                                        humanoid:MoveTo(otherPlayer.Character.HumanoidRootPart.Position)
                                    elseif randomAction == 3 then
                                        -- Dance animation
                                        local danceAnim = Instance.new("Animation")
                                        danceAnim.AnimationId = "rbxassetid://507771019"
                                        local animTrack = humanoid:LoadAnimation(danceAnim)
                                        animTrack:Play()
                                    end

                                    -- Store friendship data
                                    aiKnowledge.playerInteractions[otherPlayer.Name] = {
                                        lastInteraction = tick(),
                                        friendshipLevel = (aiKnowledge.playerInteractions[otherPlayer.Name] and 
                                            aiKnowledge.playerInteractions[otherPlayer.Name].friendshipLevel or 0) + 1
                                    }
                                end
                            end
                        end

                        -- Apply learned improvements
                        if currentHealth < humanoid.MaxHealth then
                            humanoid.Health = math.min(humanoid.MaxHealth, currentHealth + aiStats.healthRegen)
                        end

                        -- Calculate reward and learn from experience
                        if lastPosition and lastHealth then
                            local reward = 0
                            reward = reward + (currentHealth - lastHealth) * 2
                            reward = reward + (currentPos - lastPosition).Magnitude * 0.1

                            -- Additional rewards for successful actions
                            if currentHealth > lastHealth then
                                reward = reward + 5 -- Healing reward
                                gainExperience(10)
                            end
                            if lastHealth > currentHealth then
                                reward = reward - 2 -- Penalty for taking damage
                            end
                        end

                        -- Strategic decision making
                        local enemy = getClosestEnemy()
                        if enemy then
                            local enemyDistance = (enemy.HumanoidRootPart.Position - rootPart.Position).Magnitude
                            local enemyHealth = enemy.Humanoid.Health

                            -- Calculate threat level
                            local threatLevel = (enemyHealth / enemy.Humanoid.MaxHealth) * (100 / enemyDistance)

                            if currentHealth < 50 or threatLevel > 1.5 then
                                -- Strategic retreat and healing
                                local safeSpots = {}
                                for _, part in ipairs(Workspace:GetPartBoundsInRadius(rootPart.Position, 100)) do
                                    if part.CanCollide and part.Position.Y > rootPart.Position.Y then
                                        table.insert(safeSpots, part)
                                    end
                                end

                                local safeSpot = safeSpots[math.random(1, #safeSpots)] or rootPart
                                local retreatPos = safeSpot.Position + Vector3.new(0, 5, 0)

                                humanoid:MoveTo(retreatPos)
                                updateAIMemory("strategic_retreat", 15)
                                gainExperience(5)
                            else
                                -- Tactical combat
                                local tool = character:FindFirstChildOfClass("Tool")
                                if tool then
                                    -- Calculate optimal attack position
                                    local attackPos = enemy.HumanoidRootPart.Position + 
                                        (rootPart.Position - enemy.HumanoidRootPart.Position).Unit * 8

                                    -- Execute attack with learned improvements
                                    if math.random(1, 100) <= aiStats.criticalChance then
                                        -- Critical hit
                                        tool:Activate()
                                        gainExperience(20)
                                        updateAIMemory("critical_strike", 25)
                                    else
                                        tool:Activate()
                                        gainExperience(10)
                                        updateAIMemory("attack", 10)
                                    end

                                    humanoid:MoveTo(attackPos)
                                end
                            end
                        else
                            -- Intelligent exploration
                            local explorationRadius = 50 + aiLevel * 2
                            local points = {}

                            -- Find strategic points
                            for _, part in ipairs(Workspace:GetPartBoundsInRadius(rootPart.Position, explorationRadius)) do
                                if part.CanCollide and not part:FindFirstAncestorWhichIsA("Model") then
                                    table.insert(points, part.Position)
                                end
                            end

                            if #points > 0 then
                                local targetPos = points[math.random(1, #points)] + Vector3.new(0, 5, 0)
                                humanoid:MoveTo(targetPos)
                                collectNearbyItems()
                                updateAIMemory("explore", 5)
                                gainExperience(2)
                            end
                        end

                        lastPosition = currentPos
                        lastHealth = currentHealth

                        -- Update AI level display
                        aiControlButton.Text = "AI CONTROL: ON (Level " .. aiLevel .. ")"
                    end
                end
                RunService.Heartbeat:Wait()
            end
        end)
    end
end)

local ammoHackButton = Instance.new("TextButton")
ammoHackButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ammoHackButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ammoHackButton.Font = Enum.Font.GothamSemibold
ammoHackButton.TextSize = 14
ammoHackButton.BorderSizePixel = 0
ammoHackButton.AutoButtonColor = true

-- Add rounded corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = ammoHackButton

-- Add hover effect
local originalColor = ammoHackButton.BackgroundColor3
ammoHackButton.MouseEnter:Connect(function()
    ammoHackButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
end)
ammoHackButton.MouseLeave:Connect(function()
    ammoHackButton.BackgroundColor3 = originalColor
end)
    ammoHackButton.Text = "INFINITE AMMO: OFF"
    ammoHackButton.Size = UDim2.new(0.4, -10, 0, 20)
    ammoHackButton.Position = UDim2.new(0.6, 0, 0, 240)
    ammoHackButton.Parent = frame

    -- Animation Button
    local animationButton = Instance.new("TextButton")
    animationButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    animationButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    animationButton.Font = Enum.Font.GothamSemibold
    animationButton.TextSize = 14
    animationButton.BorderSizePixel = 0
    animationButton.AutoButtonColor = true

    -- Add rounded corners
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = animationButton

    -- Add hover effect
    local originalColor = animationButton.BackgroundColor3
    animationButton.MouseEnter:Connect(function()
        animationButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end)
    animationButton.MouseLeave:Connect(function()
        animationButton.BackgroundColor3 = originalColor
    end)
    animationButton.Text = "ANIMATION: NONE"
    animationButton.Size = UDim2.new(0.4, -10, 0, 20)
    animationButton.Position = UDim2.new(0.6, 0, 0, 360)
    animationButton.Parent = frame

    local animations = {
        {name = "Arm Turbine", id = "rbxassetid://259438880"},
        {name = "Moon Dance", id = "rbxassetid://27789359"},
        {name = "Insane", id = "rbxassetid://33796059"},
        {name = "Party Time", id = "rbxassetid://33796059"},
        {name = "Zombie Arms", id = "rbxassetid://183294396"},
        {name = "Laugh", id = "rbxassetid://129423131"},
        {name = "Charleston", id = "rbxassetid://429703734"},
        {name = "Cry", id = "rbxassetid://180612465"},
        {name = "Weird Float", id = "rbxassetid://248336459"},
        {name = "Spin", id = "rbxassetid://188632011"},
        {name = "Gangnam Style", id = "rbxassetid://429730430"},
        {name = "Rotation", id = "rbxassetid://136801964"},
    }

    local currentAnimation = nil
    local currentAnimIndex = 0
    local animationTrack = nil

    animationButton.MouseButton1Click:Connect(function()
        if animationTrack then
            animationTrack:Stop()
            animationTrack = nil
        end

        currentAnimIndex = (currentAnimIndex % #animations) + 1
        local anim = animations[currentAnimIndex]

        local character = player.Character
        if character and character:FindFirstChild("Humanoid") then
            local animation = Instance.new("Animation")
            animation.AnimationId = anim.id
            animationTrack = character.Humanoid:LoadAnimation(animation)
            animationTrack:Play()
            animationButton.Text = "ANIMATION: " .. anim.name
        end
    end)

    -- Stop animation when character dies or respawns
    player.CharacterAdded:Connect(function()
        if animationTrack then
            animationTrack:Stop()
            animationTrack = nil
        end
        animationButton.Text = "ANIMATION: NONE"
    end)

    local ammoHackEnabled = false
    local ammoHackConnection

    ammoHackButton.MouseButton1Click:Connect(function()
        ammoHackEnabled = not ammoHackEnabled
        ammoHackButton.Text = "INFINITE AMMO: " .. (ammoHackEnabled and "ON" or "OFF")

        if ammoHackEnabled then
            ammoHackConnection = game:GetService("RunService").Heartbeat:Connect(function()
                local character = player.Character
                if not character then return end

                -- Поиск всех оружий в инвентаре
                for _, tool in pairs(character:GetChildren()) do
                    if tool:IsA("Tool") then
                        -- Список всех возможных имен для патронов и магазинов
                        local ammoNames = {
                            "Ammo", "PistolAmmo", "RifleAmmo", "ShotgunAmmo", "Bullets", "Magazine",
                            "ClipSize", "StoredAmmo", "LoadedAmmo", "AmmoCount", "BulletsLeft",
                            "CurrentAmmo", "MaxAmmo", "AmmoInMag", "AmmoInClip", "TotalAmmo",
                            "PrimaryAmmo", "SecondaryAmmo", "ReserveAmmo", "MagazineAmmo"
                        }

                        -- Рекурсивный поиск и изменение всех значений патронов
                        local function setInfiniteAmmo(obj)
                            for _, v in pairs(obj:GetDescendants()) do
                                -- Проверяем имя объекта
                                for _, ammoName in ipairs(ammoNames) do
                                    if v.Name:lower():find(ammoName:lower()) then
                                        if v:IsA("NumberValue") or v:IsA("IntValue") then
                                            v.Value = math.huge
                                        elseif v:IsA("Property") then
                                            v = math.huge
                                        end
                                    end
                                end

                                -- Проверяем специальные конфигурации
                                if v.Name == "Config" or v.Name == "Settings" or v.Name == "GunStats" then
                                    setInfiniteAmmo(v)
                                end
                            end
                        end

                        -- Применяем к текущему оружию
                        setInfiniteAmmo(tool)

                        -- Перехватываем события изменения патронов
                        tool.Changed:Connect(function()
                            if ammoHackEnabled then
                                setInfiniteAmmo(tool)
                            end
                        end)
                    end
                end
            end)

            -- Отслеживаем новое оружие в инвентаре
            character.ChildAdded:Connect(function(newTool)
                if ammoHackEnabled and newTool:IsA("Tool") then
                    wait() -- Ждем загрузки всех свойств
                    setInfiniteAmmo(newTool)
                end
            end)
        else
            if ammoHackConnection then
                ammoHackConnection:Disconnect()
            end
        end
    end)

    local rapidAttackEnabled = false
    local rapidAttackConnection
    -- Auto Heal Function
    local autoHealEnabled = false
    local healConnection

    local characterAddedConnection

    autoHealButton.MouseButton1Click:Connect(function()
        autoHealEnabled = not autoHealEnabled
        autoHealButton.Text = "AUTO HEAL: " .. (autoHealEnabled and "ON" or "OFF")

        -- Отключаем старые подключения
        if healConnection then
            healConnection:Disconnect()
            healConnection = nil
        end
        if characterAddedConnection then
            characterAddedConnection:Disconnect()
            characterAddedConnection = nil
        end

        if autoHealEnabled then
            -- Функция для настройки автохила на персонаже
            local function setupAutoHeal(char)
                if not char then return end
                local humanoid = char:WaitForChild("Humanoid")
                if not humanoid then return end

                -- Отключаем старое подключение если оно существует
                if healConnection then
                    healConnection:Disconnect()
                end

                humanoid.MaxHealth = math.huge
                humanoid.Health = math.huge

                -- Обновляем текст над головой
                local healthGui = Instance.new("BillboardGui")
                healthGui.Name = "HealthDisplay"
                healthGui.Size = UDim2.new(0, 100, 0, 40)
                healthGui.StudsOffset = Vector3.new(0, 2, 0)
                healthGui.AlwaysOnTop = true
                healthGui.Parent = char

                local healthLabel = Instance.new("TextLabel")
                healthLabel.Size = UDim2.new(1, 0, 1, 0)
                healthLabel.BackgroundTransparency = 1
                healthLabel.TextColor3 = Color3.new(0, 1, 0)
                healthLabel.Text = "∞ HP"
                healthLabel.TextScaled = true
                healthLabel.Font = Enum.Font.GothamBold
                healthLabel.Parent = healthGui

                healConnection = humanoid.HealthChanged:Connect(function(health)
                    if autoHealEnabled then
                        task.wait() -- Небольшая задержка для стабильности
                        if humanoid and humanoid.Parent and autoHealEnabled then
                            humanoid.Health = math.huge
                            healthLabel.Text = "∞ HP"
                        end
                    end
                end)
            end

            -- Устанавливаем автохил на текущем персонаже
            if player.Character then
                setupAutoHeal(player.Character)
            end

            -- Подключаемся к событию появления нового персонажа
            characterAddedConnection = player.CharacterAdded:Connect(setupAutoHeal)
        end
    end)

    -- Aimbot functionality
    local aimbotEnabled = false
    local aimbotConnection
    local targetPlayer = nil

    aimbotButton.MouseButton1Click:Connect(function()
        aimbotEnabled = not aimbotEnabled
        aimbotButton.Text = "AIMBOT: " .. (aimbotEnabled and "ON" or "OFF")

        if aimbotEnabled then
            aimbotConnection = game:GetService("RunService").RenderStepped:Connect(function()
                local nearestDistance = math.huge
                local nearestPlayer = nil
                local myCharacter = player.Character
                if not myCharacter or not myCharacter:FindFirstChild("HumanoidRootPart") then return end

                local myHead = myCharacter:FindFirstChild("Head")
                if not myHead then return end

                for _, otherPlayer in pairs(game.Players:GetPlayers()) do
                    if otherPlayer ~= player and otherPlayer.Character and 
                       otherPlayer.Character:FindFirstChild("HumanoidRootPart") and
                       otherPlayer.Character:FindFirstChild("Humanoid") and
                       otherPlayer.Character:FindFirstChild("Head") and
                       otherPlayer.Character.Humanoid.Health > 0 then

                        local otherHead = otherPlayer.Character.Head
                        local distance = (otherHead.Position - myHead.Position).Magnitude

                        -- Проверяем видимость игрока (нет ли стен между нами)
                        local ray = Ray.new(myHead.Position, (otherHead.Position - myHead.Position))
                        local hit, hitPos = workspace:FindPartOnRayWithIgnoreList(ray, {myCharacter, otherPlayer.Character})

                        -- Если луч не встретил препятствий или попал прямо в игрока
                        if not hit or (hit and hit:IsDescendantOf(otherPlayer.Character)) then
                            -- Приоритет видимым игрокам - уменьшаем дистанцию
                            distance = distance * 0.5
                        end

                        if distance < nearestDistance then
                            nearestDistance = distance
                            nearestPlayer = otherPlayer
                        end
                    end
                end

                if nearestPlayer and nearestPlayer.Character then
                    local head = nearestPlayer.Character:FindFirstChild("Head")
                    if head then
                        workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, head.Position)
                    end
                end
            end)
        else
            if aimbotConnection then
                aimbotConnection:Disconnect()
            end
        end
    end)

    -- Mob Aimbot functionality
    local mobAimbotEnabled = false
    local mobAimbotConnection

    mobAimbotButton.MouseButton1Click:Connect(function()
        mobAimbotEnabled = not mobAimbotEnabled
        mobAimbotButton.Text = "MOB AIMBOT: " .. (mobAimbotEnabled and "ON" or "OFF")

        if mobAimbotEnabled then
            mobAimbotConnection = game:GetService("RunService").RenderStepped:Connect(function()
                local nearestDistance = math.huge
                local nearestMob = nil
                local myCharacter = player.Character
                if not myCharacter or not myCharacter:FindFirstChild("HumanoidRootPart") then return end

                for _, mob in ipairs(workspace:GetDescendants()) do
                    if mob:IsA("Model") and mob:FindFirstChild("Humanoid") and 
                       mob:FindFirstChild("HumanoidRootPart") and
                       not game.Players:GetPlayerFromCharacter(mob) and
                       mob.Humanoid.Health > 0 then

                        local distance = (mob.HumanoidRootPart.Position - myCharacter.HumanoidRootPart.Position).Magnitude
                        if distance < nearestDistance then
                            nearestDistance = distance
                            nearestMob = mob
                        end
                    end
                end

                if nearestMob then
                    local head = nearestMob:FindFirstChild("Head")
                    if head then
                        workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, head.Position)
                    end
                end
            end)
        else
            if mobAimbotConnection then
                mobAimbotConnection:Disconnect()
            end
        end
    end)

    -- Auto Collect functionality
    local autoCollectEnabled = false
    local autoCollectConnection

    autoCollectButton.MouseButton1Click:Connect(function()
        autoCollectEnabled = not autoCollectEnabled
        autoCollectButton.Text = "AUTO COLLECT: " .. (autoCollectEnabled and "ON" or "OFF")

        if autoCollectEnabled then
            autoCollectConnection = game:GetService("RunService").Heartbeat:Connect(function()
                local character = player.Character
                if not character or not character:FindFirstChild("HumanoidRootPart") then return end

                local rootPart = character.HumanoidRootPart
                local collectRadius = 250 -- Увеличенный радиус сбора предметов

                for _, item in pairs(workspace:GetDescendants()) do
                    if item:IsA("BasePart") and 
                       (item.Name:lower():find("item") or 
                        item.Name:lower():find("pickup") or 
                        item.Name:lower():find("collect") or
                        item.Name:lower():find("coin") or
                        item.Name:lower():find("gem") or
                        item.Name:lower():find("resource") or
                        item.Name:lower():find("drop") or
                        item.Name:lower():find("weapon") or
                        item.Name:lower():find("gun") or
                        item.Name:lower():find("ammo") or
                        item.Name:lower():find("bond") or
                        item.Name:lower():find("bandage") or
                        item.Name:lower():find("knife") or
                        item.Name:lower():find("sword") or
                        item.Name:lower():find("med") or
                        item.Name:lower():find("heal")) then

                        local distance = (item.Position - rootPart.Position).Magnitude
                        if distance <= collectRadius then
                            item.CFrame = rootPart.CFrame
                        end
                    end
                end
            end)
        else
            if autoCollectConnection then
                autoCollectConnection:Disconnect()
            end
        end
    end)

    rapidAttackButton.MouseButton1Click:Connect(function()
        rapidAttackEnabled = not rapidAttackEnabled
        rapidAttackButton.Text = "RAPID ATTACK: " .. (rapidAttackEnabled and "ON" or "OFF")

        if rapidAttackEnabled then
            rapidAttackConnection = game:GetService("RunService").Heartbeat:Connect(function()
                local mouse = player:GetMouse()
                if mouse.Target and mouse.Target.Parent then
                    local humanoid = mouse.Target.Parent:FindFirstChild("Humanoid")
                    if humanoid then
                        humanoid.Health = humanoid.Health - 1
                    end
                end
            end)
        else
            if rapidAttackConnection then
                rapidAttackConnection:Disconnect()
            end
        end
    end)

    -- Sky customization
    skyButton.MouseButton1Click:Connect(function()
        local styles = {"RAINY_PARADISE", "DEFAULT", "DARK_RED_MOON", "BLUE_SKY", "GOLDEN_HOUR", "DRAIN", "BRIGHT", "NIGHT_STARS", "SUNSET", "ANIME_SKY", "PURPLE_NEBULA", "VAPORWAVE", "SPACE", "EMERALD_SKY", "SUNSET_PARADISE", "OPIUM", "MEME", "REALISTIC_V2"}
        local currentIndex = table.find(styles, currentSkyStyle)
        currentSkyStyle = styles[currentIndex % #styles + 1]
        skyButton.Text = "SKY: " .. currentSkyStyle
        skyStyles[currentSkyStyle]()
    end)

    player.CharacterAdded:Connect(function(character)
        character:WaitForChild("Humanoid")
        updateSpeed(tonumber(string.match(speedLabel.Text, "%d+")) or defaultWalkSpeed)
    end)

    -- Auto Shoot functionality
    local autoShootEnabled = false
    local autoShootConnection

    -- Wall Bang functionality
    local wallBangButton = Instance.new("TextButton")
wallBangButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
wallBangButton.TextColor3 = Color3.fromRGB(255, 255, 255)
wallBangButton.Font = Enum.Font.GothamSemibold
wallBangButton.TextSize = 14
wallBangButton.BorderSizePixel = 0
wallBangButton.AutoButtonColor = true

-- Add rounded corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = wallBangButton

-- Add hover effect
local originalColor = wallBangButton.BackgroundColor3
wallBangButton.MouseEnter:Connect(function()
    wallBangButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
end)
wallBangButton.MouseLeave:Connect(function()
    wallBangButton.BackgroundColor3 = originalColor
end)
    wallBangButton.Text = "WALL BANG: OFF"
    wallBangButton.Size = UDim2.new(0.4, -10, 0, 20)
    wallBangButton.Position = UDim2.new(0.6, 0, 0, 270)
    wallBangButton.Parent = frame

    -- Auto Farm Button
    local autoFarmButton = Instance.new("TextButton")
    autoFarmButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    autoFarmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    autoFarmButton.Font = Enum.Font.GothamSemibold
    autoFarmButton.TextSize = 14
    autoFarmButton.BorderSizePixel = 0
    autoFarmButton.AutoButtonColor = true

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = autoFarmButton

    local originalColor = autoFarmButton.BackgroundColor3
    autoFarmButton.MouseEnter:Connect(function()
        autoFarmButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end)
    autoFarmButton.MouseLeave:Connect(function()
        autoFarmButton.BackgroundColor3 = originalColor
    end)

    autoFarmButton.Text = "AUTO FARM: OFF"
    autoFarmButton.Size = UDim2.new(0.4, -10, 0, 20)
    autoFarmButton.Position = UDim2.new(0.6, 0, 0, 390)
    autoFarmButton.Parent = frame

    -- Clone Button
    local cloneButton = Instance.new("TextButton")
    cloneButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    cloneButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    cloneButton.Font = Enum.Font.GothamSemibold
    cloneButton.TextSize = 14
    cloneButton.BorderSizePixel = 0
    cloneButton.AutoButtonColor = true

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = cloneButton

    local originalColor = cloneButton.BackgroundColor3
    cloneButton.MouseEnter:Connect(function()
        cloneButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end)
    cloneButton.MouseLeave:Connect(function()
        cloneButton.BackgroundColor3 = originalColor
    end)

    cloneButton.Text = "CLONE ARMY: OFF"
    cloneButton.Size = UDim2.new(0.4, -10, 0, 20)
    cloneButton.Position = UDim2.new(0.6, 0, 0, 420)
    cloneButton.Parent = frame

    -- LAG Button
    local lagButton = Instance.new("TextButton")
    lagButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    lagButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    lagButton.Font = Enum.Font.GothamSemibold
    lagButton.TextSize = 14
    lagButton.BorderSizePixel = 0
    lagButton.AutoButtonColor = true

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = lagButton

    local originalColor = lagButton.BackgroundColor3
    lagButton.MouseEnter:Connect(function()
        lagButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end)
    lagButton.MouseLeave:Connect(function()
        lagButton.BackgroundColor3 = originalColor
    end)

    lagButton.Text = "LAG: OFF"
    lagButton.Size = UDim2.new(0.4, -10, 0, 20)
    lagButton.Position = UDim2.new(0.6, 0, 0, 480)
    lagButton.Parent = frame

    local lagEnabled = false
    local lagConnection

    lagButton.MouseButton1Click:Connect(function()
        lagEnabled = not lagEnabled
        lagButton.Text = "LAG: " .. (lagEnabled and "ON" or "OFF")

        if lagEnabled then
            -- Create network lag effect that only affects others
            spawn(function()
                while lagEnabled do
                    local character = player.Character
                    if character then
                        local root = character:FindFirstChild("HumanoidRootPart")
                        if root then
                            -- Store our real position
                            local realPos = root.Position
                            local realCFrame = root.CFrame

                            -- Create lag effect for others
                            local randomOffset = Vector3.new(
                                math.random(-5, 5),
                                0,
                                math.random(-5, 5)
                            )

                            -- Network manipulation to show different positions to others
                            game:GetService("NetworkClient"):SetOutgoingKBPSLimit(1)
                            root.Position = realPos + randomOffset

                            -- Immediately restore our view without affecting others
                            game:GetService("RunService").RenderStepped:Wait()
                            root.CFrame = realCFrame

                            -- Reset network limit
                            game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge)
                        end
                    end
                    wait(0.1)
                end
            end)

            -- Smooth movement for us, laggy for others
            lagConnection = game:GetService("RunService").Heartbeat:Connect(function()
                local character = player.Character
                if character then
                    local root = character:FindFirstChild("HumanoidRootPart")
                    if root then
                        -- Create fake network lag for others only
                        local fakeDelay = math.random() * 0.5
                        spawn(function()
                            wait(fakeDelay)
                            -- This update will be seen by others with delay
                            root.Position = root.Position + Vector3.new(math.random(-3, 3), 0, math.random(-3, 3))
                        end)
                    end
                end
            end)
        else
            if lagConnection then
                lagConnection:Disconnect()
            end
        end
    end)

    local clonesEnabled = false
    local clones = {}

    cloneButton.MouseButton1Click:Connect(function()
        clonesEnabled = not clonesEnabled
        cloneButton.Text = "CLONE ARMY: " .. (clonesEnabled and "ON" or "OFF")

        if clonesEnabled then
            local character = player.Character
            if not character then return end

            -- Remove existing clones
            for _, clone in pairs(clones) do
                if clone and clone.Parent then
                    clone:Destroy()
                end
            end
            clones = {}

            -- Create 1000 clones
            for i = 1, 1000 do
                local clone = character:Clone()
                clone.Name = "Clone_" .. i

                -- Remove scripts and sounds from clone
                for _, item in pairs(clone:GetDescendants()) do
                    if item:IsA("Script") or item:IsA("LocalScript") or item:IsA("Sound") then
                        item:Destroy()
                    end
                end

                -- Position clone in a spiral pattern around the player
                local angle = i * 0.1
                local radius = 5 + i * 0.1
                local x = math.cos(angle) * radius
                local z = math.sin(angle) * radius

                local rootPart = clone:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    rootPart.CFrame = character.HumanoidRootPart.CFrame * CFrame.new(x, 0, z)
                end

                -- Make clones follow the player
                local humanoid = clone:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = 16
                    spawn(function()
                        while clonesEnabled and clone and clone.Parent and character and character.Parent do
                            if humanoid and character:FindFirstChild("HumanoidRootPart") then
                                humanoid:MoveTo(character.HumanoidRootPart.Position + Vector3.new(x, 0, z))
                            end
                            wait(0.1)
                        end
                    end)
                end

                clone.Parent = workspace
                table.insert(clones, clone)
            end
        else
            -- Remove all clones
            for _, clone in pairs(clones) do
                if clone and clone.Parent then
                    clone:Destroy()
                end
            end
            clones = {}
        end
    end)

    local autoFarmEnabled = false
    local autoFarmConnection

    autoFarmButton.MouseButton1Click:Connect(function()
        autoFarmEnabled = not autoFarmEnabled
        autoFarmButton.Text = "AUTO FARM: " .. (autoFarmEnabled and "ON" or "OFF")

        if autoFarmEnabled then
            -- Create notification UI
            local notification = Instance.new("TextLabel")
            notification.Size = UDim2.new(0, 200, 0, 50)
            notification.Position = UDim2.new(1, -220, 0, 10)
            notification.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            notification.TextColor3 = Color3.fromRGB(255, 255, 255)
            notification.Font = Enum.Font.GothamBold
            notification.TextSize = 14
            notification.TextWrapped = true
            notification.BackgroundTransparency = 0.3
            notification.Parent = frame

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 6)
            corner.Parent = notification

            autoFarmConnection = game:GetService("RunService").Heartbeat:Connect(function()
                if not autoFarmEnabled then return end

                -- Try to find and modify common resource values
                local resourceTypes = {
                    "Money", "Coins", "Cash", "Points", "Gold", "Gems", "XP",
                    "Experience", "Tokens", "Credits", "Resources", "Materials",
                    "Energy", "Power", "Level", "Score", "Currency"
                }

                -- Update notification
                notification.Text = "Auto Farming: +1,000,000 every minute"

                -- Search for resources in common locations
                local function addResources()
                    -- Player stats/data
                    if player:FindFirstChild("leaderstats") then
                        for _, stat in pairs(player.leaderstats:GetChildren()) do
                            if stat:IsA("IntValue") or stat:IsA("NumberValue") then
                                stat.Value = stat.Value + 1000000
                            end
                        end
                    end

                    -- Check player's backpack/inventory
                    for _, item in pairs(player.Backpack:GetChildren()) do
                        for _, resourceName in pairs(resourceTypes) do
                            local resource = item:FindFirstChild(resourceName)
                            if resource and (resource:IsA("IntValue") or resource:IsA("NumberValue")) then
                                resource.Value = resource.Value + 1000000
                            end
                        end
                    end

                    -- Check character
                    if player.Character then
                        for _, resourceName in pairs(resourceTypes) do
                            local resource = player.Character:FindFirstChild(resourceName)
                            if resource and (resource:IsA("IntValue") or resource:IsA("NumberValue")) then
                                resource.Value = resource.Value + 1000000
                            end
                        end
                    end

                    -- Try to fire common remote events for resources
                    local remoteEvents = {"AddMoney", "AddCoins", "AddResources", "CollectResource", "GainResource"}
                    for _, eventName in pairs(remoteEvents) do
                        local event = game:GetService("ReplicatedStorage"):FindFirstChild(eventName)
                        if event and event:IsA("RemoteEvent") then
                            event:FireServer(1000000)
                        end
                    end
                end

                -- Add resources every minute
                spawn(function()
                    while autoFarmEnabled do
                        addResources()
                        wait(60)
                    end
                end)
            end)
        else
            if autoFarmConnection then
                autoFarmConnection:Disconnect()
            end
            -- Remove notification if it exists
            for _, child in pairs(frame:GetChildren()) do
                if child:IsA("TextLabel") and child.Text:find("Auto Farming") then
                    child:Destroy()
                end
            end
        end
    end)

    -- TROLLING Button
    local trollingButton = Instance.new("TextButton")
    trollingButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    trollingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    trollingButton.Font = Enum.Font.GothamSemibold
    trollingButton.TextSize = 14
    trollingButton.BorderSizePixel = 0
    trollingButton.AutoButtonColor = true

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = trollingButton

    local originalColor = trollingButton.BackgroundColor3
    trollingButton.MouseEnter:Connect(function()
        trollingButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end)
    trollingButton.MouseLeave:Connect(function()
        trollingButton.BackgroundColor3 = originalColor
    end)

    trollingButton.Text = "TROLLING: OFF"
    trollingButton.Size = UDim2.new(0.4, -10, 0, 20)
    trollingButton.Position = UDim2.new(0.6, 0, 0, 300)
    trollingButton.Parent = frame

    local trollingEnabled = false
    local trollingConnection
    local animationTrack

    trollingButton.MouseButton1Click:Connect(function()
        trollingEnabled = not trollingEnabled
        trollingButton.Text = "TROLLING: " .. (trollingEnabled and "ON" or "OFF")

        local character = player.Character
        if not character then return end

        if trollingEnabled then
            -- Change character model to female
            local function createFemaleCharacter()
                -- Base body parts
                local torso = character:FindFirstChild("Torso")
                if torso then
                    torso.Size = Vector3.new(2, 2, 1)
                    torso.Color = Color3.fromRGB(255, 226, 205)
                end

                local head = character:FindFirstChild("Head")
                if head then
                    head.Size = Vector3.new(1.2, 1.2, 1.2)
                    head.Color = Color3.fromRGB(255, 226, 205)
                end

                -- Limbs
                local limbs = {
                    ["Left Arm"] = Vector3.new(0.8, 2, 0.8),
                    ["Right Arm"] = Vector3.new(0.8, 2, 0.8),
                    ["Left Leg"] = Vector3.new(0.9, 2, 0.9),
                    ["Right Leg"] = Vector3.new(0.9, 2, 0.9)
                }

                for limbName, size in pairs(limbs) do
                    local limb = character:FindFirstChild(limbName)
                    if limb then
                        limb.Size = size
                        limb.Color = Color3.fromRGB(255, 226, 205)
                    end
                end

                -- Add hair
                local hair = Instance.new("Part")
                hair.Name = "Hair"
                hair.Size = Vector3.new(1.3, 1.5, 1.3)
                hair.Color = Color3.fromRGB(218, 154, 48)
                hair.CanCollide = false

                local weld = Instance.new("Weld")
                weld.Part0 = head
                weld.Part1 = hair
                weld.C0 = CFrame.new(0, 0.7, 0)
                weld.Parent = hair
                hair.Parent = character
            end

            createFemaleCharacter()

            -- Create and play music
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxassetid://6823597327"
            sound.Volume = 0.8
            sound.Looped = true
            sound.Parent = character.HumanoidRootPart
            sound:Play()

            local animation = Instance.new("Animation")
            animation.AnimationId = "rbxassetid://3333499508" -- Fun dance animation

            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                local animator = humanoid:FindFirstChild("Animator") or Instance.new("Animator")
                animator.Parent = humanoid

                animationTrack = animator:LoadAnimation(animation)
                animationTrack:Play()
                animationTrack:AdjustSpeed(1.2) -- Dance speed
                animationTrack.Looped = true -- Make the dance loop

                -- Анализ окружения и препятствий
                local function analyzeEnvironment(character)
                    local obstacles = {}
                    local players = {}
                    local rootPart = character:FindFirstChild("HumanoidRootPart")
                    if not rootPart then return obstacles, players end

                    -- Поиск препятствий и игроков в радиусе
                    local searchRadius = 50
                    local nearbyObjects = workspace:GetPartBoundsInRadius(rootPart.Position, searchRadius)

                    for _, obj in ipairs(nearbyObjects) do
                        -- Проверка препятствий
                        if obj.CanCollide and obj.Name ~= "HumanoidRootPart" then
                            table.insert(obstacles, obj)
                        end

                        -- Поиск игроков
                        local model = obj.Parent
                        if model and model:FindFirstChild("Humanoid") and game.Players:GetPlayerFromCharacter(model) then
                            table.insert(players, model)
                        end
                    end

                    return obstacles, players
                end

                -- Танцевальные анимации
                local danceAnimations = {
                    {id = "rbxassetid://507771019", name = "Dance1"},
                    {id = "rbxassetid://507771955", name = "Dance2"},
                    {id = "rbxassetid://507772104", name = "Dance3"},
                    {id = "rbxassetid://507776043", name = "Dance4"},
                }

                -- Функция для выполнения случайного танца
                local function performRandomDance(humanoid)
                    local randomDance = danceAnimations[math.random(#danceAnimations)]
                    local animation = Instance.new("Animation")
                    animation.AnimationId = randomDance.id
                    local animTrack = humanoid:LoadAnimation(animation)
                    animTrack:Play()
                    wait(math.random(3, 6)) -- Танцуем 3-6 секунд
                    animTrack:Stop()
                end

                -- Основной цикл анализа и взаимодействия
                spawn(function()
                    while trollingEnabled do
                        local character = player.Character
                        if character then
                            local humanoid = character:FindFirstChild("Humanoid")
                            local rootPart = character:FindFirstChild("HumanoidRootPart")

                            if humanoid and rootPart then
                                local obstacles, nearbyPlayers = analyzeEnvironment(character)

                                -- Обход препятствий
                                for _, obstacle in ipairs(obstacles) do
                                    local distance = (obstacle.Position - rootPart.Position).Magnitude
                                    if distance < 5 then
                                        -- Уклоняемся от препятствия
                                        local avoidanceDirection = (rootPart.Position - obstacle.Position).Unit
                                        local targetPos = rootPart.Position + avoidanceDirection * 10
                                        humanoid:MoveTo(targetPos)
                                    end
                                end

                                -- Взаимодействие с игроками
                                for _, nearbyPlayer in ipairs(nearbyPlayers) do
                                    local distance = (nearbyPlayer.HumanoidRootPart.Position - rootPart.Position).Magnitude
                                    if distance < 10 and math.random() < 0.3 then -- 30% шанс начать танцевать
                                        -- Подходим к игроку
                                        local targetPos = nearbyPlayer.HumanoidRootPart.Position + Vector3.new(math.random(-3, 3), 0, math.random(-3, 3))
                                        humanoid:MoveTo(targetPos)
                                        wait(1)
                                        -- Танцуем
                                        performRandomDance(humanoid)
                                    end
                                end
                            end
                        end
                        wait(1)
                    end
                end)

                -- AI Intelligence System
                local aiState = {
                    lastAction = tick(),
                    actionCooldown = 0.5,
                    locations = {},
                    targets = {},
                    mood = "neutral",
                    intelligence = 0,
                    experience = 0
                }

                -- Random movement patterns
                local function generateRandomMovement()
                    local patterns = {
                        zigzag = function(root)
                            local amplitude = math.random(5, 15)
                            local frequency = math.random(2, 5)
                            local direction = Vector3.new(math.random(-1, 1), 0, math.random(-1, 1)).Unit
                            return root.Position + direction * amplitude + Vector3.new(
                                math.sin(tick() * frequency) * amplitude,
                                0,
                                math.cos(tick() * frequency) * amplitude
                            )
                        end,
                        circle = function(root)
                            local radius = math.random(5, 10)
                            local angle = tick() * math.random(1, 3)
                            return root.Position + Vector3.new(
                                math.cos(angle) * radius,
                                0,
                                math.sin(angle) * radius
                            )
                        end,
                        patrol = function(root)
                            local distance = math.random(10, 30)
                            local angle = math.random() * math.pi * 2
                            return root.Position + Vector3.new(
                                math.cos(angle) * distance,
                                0,
                                math.sin(angle) * distance
                            )
                        end
                    }

                    return patterns[({
                        "zigzag", "circle", "patrol"
                    })[math.random(1, 3)]]
                end

                -- AI Learning System
                local function updateAIIntelligence()
                    aiState.intelligence = math.min(aiState.intelligence + 0.1, 100)
                    aiState.experience = aiState.experience + 1

                    -- Adapt behavior based on intelligence
                    if aiState.intelligence > 50 then
                        aiState.actionCooldown = math.max(0.2, aiState.actionCooldown - 0.01)
                    end
                end

                -- Intelligent movement system
                spawn(function()
                    while trollingEnabled do
                        local character = player.Character
                        if character then
                            local humanoid = character:FindFirstChild("Humanoid")
                            local rootPart = character:FindFirstChild("HumanoidRootPart")

                            if humanoid and rootPart then
                                -- Generate intelligent movement
                                local movePattern = generateRandomMovement()
                                local targetPosition = movePattern(rootPart)

                                -- Check for obstacles
                                local ray = Ray.new(rootPart.Position, (targetPosition - rootPart.Position).Unit * 10)
                                local hit = workspace:FindPartOnRay(ray, character)

                                if hit then
                                    -- Avoid obstacle
                                    targetPosition = rootPart.Position + Vector3.new(
                                        math.random(-10, 10),
                                        0,
                                        math.random(-10, 10)
                                    )
                                end

                                -- Move to target
                                humanoid:MoveTo(targetPosition)

                                -- Occasional jumping
                                if math.random() < 0.1 then
                                    humanoid.Jump = true
                                end

                                -- Update AI intelligence
                                updateAIIntelligence()

                                -- Dynamic interaction with environment
                                local nearbyPlayers = {}
                                for _, otherPlayer in pairs(game.Players:GetPlayers()) do
                                    if otherPlayer ~= player and otherPlayer.Character then
                                        local distance = (otherPlayer.Character:GetPrimaryPartCFrame().Position - rootPart.Position).Magnitude
                                        if distance < 20 then
                                            table.insert(nearbyPlayers, otherPlayer)
                                        end
                                    end
                                end

                                -- Social interaction
                                if #nearbyPlayers > 0 and math.random() < 0.3 then
                                    local targetPlayer = nearbyPlayers[math.random(#nearbyPlayers)]
                                    humanoid:MoveTo(targetPlayer.Character:GetPrimaryPartCFrame().Position)
                                    wait(1)
                                    performRandomDance(humanoid)
                                end
                            end
                        end
                        wait(aiState.actionCooldown)
                    end
                end)

                -- Add screen effects
                local screenGui = Instance.new("ScreenGui")
                screenGui.Name = "TrollingEffects"
                screenGui.Parent = player.PlayerGui

                local redFlash = Instance.new("Frame")
                redFlash.Size = UDim2.new(1, 0, 1, 0)
                redFlash.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                redFlash.BackgroundTransparency = 0.7
                redFlash.Parent = screenGui

                trollingConnection = game:GetService("RunService").Heartbeat:Connect(function()
                    if character:FindFirstChild("HumanoidRootPart") then
                        local root = character.HumanoidRootPart

                        -- Screen shake effect
                        local camera = workspace.CurrentCamera
                        local intensity = 1.5
                        camera.CFrame = camera.CFrame * CFrame.new(
                            math.random(-intensity, intensity) * 0.1,
                            math.random(-intensity, intensity) * 0.1,
                            math.random(-intensity, intensity) * 0.1
                        )

                        -- Red flash pulsing
                        redFlash.BackgroundTransparency = 0.7 + math.sin(tick() * 5) * 0.2

                        -- Particle effects
                        local particle = Instance.new("ParticleEmitter")
                        particle.Texture = "rbxasset://textures/particles/fire_main.dds"
                        particle.Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 100, 0)),
                            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
                        })
                        particle.Rate = 50
                        particle.Speed = NumberRange.new(5, 8)
                        particle.Lifetime = NumberRange.new(0.5, 1)
                        particle.SpreadAngle = Vector2.new(-180, 180)
                        particle.Parent = root
                        game:GetService("Debris"):AddItem(particle, 0.1)
                    end
                end)
            end
        else
            if trollingConnection then
                trollingConnection:Disconnect()
            end
            if animationTrack then
                animationTrack:Stop()
            end
            -- Stop and remove music
            if character and character:FindFirstChild("HumanoidRootPart") then
                local sound = character.HumanoidRootPart:FindFirstChild("Sound")
                if sound then
                    sound:Stop()
                    sound:Destroy()
                end
            end
            -- Remove screen effects
            if player.PlayerGui:FindFirstChild("TrollingEffects") then
                player.PlayerGui.TrollingEffects:Destroy()
            end
            -- Reset camera
            if workspace.CurrentCamera then
                workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position)
            end
        end
    end)

    local wallBangEnabled = false
    local wallBangConnection

    wallBangButton.MouseButton1Click:Connect(function()
        wallBangEnabled = not wallBangEnabled
        wallBangButton.Text = "WALL BANG: " .. (wallBangEnabled and "ON" or "OFF")

        if wallBangEnabled then
            wallBangConnection = game:GetService("RunService").Heartbeat:Connect(function()
                if game:GetService("UserInputService"):IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                    local character = player.Character
                    if not character then return end

                    local tool = character:FindFirstChildOfClass("Tool")
                    if not tool then return end

                    -- Отключаем анимации и эффекты отдачи
                    for _, obj in pairs(tool:GetDescendants()) do
                        if obj:IsA("Animation") then
                            obj:Stop()
                        elseif obj:IsA("ValueBase") and (obj.Name:lower():match("recoil") or obj.Name:lower():match("spread")) then
                            obj.Value = 0
                        end
                    end

                    -- Отключаем перезарядку
                    local ammoValue = tool:FindFirstChild("Ammo") or tool:FindFirstChild("StoredAmmo") or tool:FindFirstChild("Magazine")
                    if ammoValue and ammoValue:IsA("ValueBase") then
                        ammoValue.Value = 999999
                    end

                    -- Получаем позицию мыши в мире
                    local mouse = player:GetMouse()
                    local camera = workspace.CurrentCamera
                    local mouseRay = camera:ScreenPointToRay(mouse.X, mouse.Y)
                    local rayOrigin = mouseRay.Origin
                    local rayDirection = mouseRay.Direction * 1000 -- Увеличиваем дальность луча

                    -- Ищем всех потенциальных противников за стенами
                    for _, target in pairs(workspace:GetDescendants()) do
                        if target:IsA("Model") and target:FindFirstChild("Humanoid") and target ~= character then
                            local targetHRP = target:FindFirstChild("HumanoidRootPart")
                            if targetHRP then
                                -- Проверяем, находится ли цель в направлении взгляда
                                local targetPos = targetHRP.Position
                                local toTarget = (targetPos - rayOrigin).Unit
                                local dot = toTarget:Dot(rayDirection.Unit)

                                if dot > 0.7 then -- Цель находится примерно в направлении взгляда
                                    -- Стреляем через стены
                                    local fireFunction = tool:FindFirstChild("Fire") or tool:FindFirstChild("Shoot") or tool:FindFirstChild("Attack")
                                    if fireFunction and fireFunction:IsA("RemoteEvent") then
                                        fireFunction:FireServer(targetPos)
                                    else
                                        tool:Activate()
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        else
            if infiniteFireConnection then
                infiniteFireConnection:Disconnect()
            end
        end
    end)

    autoShootButton.MouseButton1Click:Connect(function()
        autoShootEnabled = not autoShootEnabled
        autoShootButton.Text = "AUTO SHOOT: " .. (autoShootEnabled and "ON" or "OFF")

        if autoShootEnabled then
            autoShootConnection = game:GetService("RunService").Heartbeat:Connect(function()
                local character = player.Character
                if not character then return end

                local tool = character:FindFirstChildOfClass("Tool")
                if not tool then return end

                local rootPart = character:FindFirstChild("HumanoidRootPart")
                if not rootPart then return end

                -- Улучшенный поиск мобов
                for _, mob in pairs(workspace:GetDescendants()) do
                    if mob:IsA("Model") and 
                       mob:FindFirstChild("Humanoid") and 
                       mob:FindFirstChild("HumanoidRootPart") and
                       not game.Players:GetPlayerFromCharacter(mob) and
                       mob.Humanoid.Health > 0 then

                        local mobRoot = mob.HumanoidRootPart
                        local distance = (mobRoot.Position - rootPart.Position).Magnitude

                        if distance < 300 then -- Увеличенная дальность стрельбы
                            local mobHead = mob:FindFirstChild("Head") or mobRoot

                            -- Мгновенный поворот к цели
                            rootPart.CFrame = CFrame.new(rootPart.Position, mobHead.Position)

                            -- Стреляем без задержки
                            local fireFunction = tool:FindFirstChild("Fire") or tool:FindFirstChild("Shoot") or tool:FindFirstChild("Attack")
                            if fireFunction and fireFunction:IsA("RemoteEvent") then
                                fireFunction:FireServer(mobHead.Position)
                            else
                                tool:Activate()
                            end

                            -- Непрерывная стрельба без задержки
                        end
                    end
                end
            end)
        else
            if autoShootConnection then
                autoShootConnection:Disconnect()
            end
        end
    end)

    if autoShowMenu then
        toggleMenu(true)
    end
end

spawn(function()
    wait(0.5)
    initialize()
end)
