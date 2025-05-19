-- Настройки
local menuTitle = "CXNT"
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
loadingText.Text = "Идет загрузка скрипта CXNT..."
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
local gui = Instance.new("ScreenGui")
gui.Name = "CXNT_Menu"
gui.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 600, 0, 600)
frame.Position = UDim2.new(0.5, -300, 0.5, -300)
frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
frame.BorderSizePixel = 0
frame.Visible = false
frame.Parent = gui

-- Add red accent bar at top
local accentBar = Instance.new("Frame")
accentBar.Size = UDim2.new(1, 0, 0, 3)
accentBar.Position = UDim2.new(0, 0, 0, 0)
accentBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
accentBar.BorderSizePixel = 0
accentBar.Parent = frame

-- Добавляем тень
local shadow = Instance.new("ImageLabel")
shadow.Size = UDim2.new(1, 20, 1, 20)
shadow.Position = UDim2.new(0, -10, 0, -10)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxasset://textures/ui/dialog_shadow.png"
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 10, 10)
shadow.Parent = frame

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
        timeLabel.Text = string.format("МСК: %02d:%02d:%02d", time.hour + 3, time.min, time.sec)
    end
end)

-- Watermark with gradient animation
local watermark = Instance.new("TextLabel")
watermark.Text = "CXNT V2"
watermark.Size = UDim2.new(0, 250, 0, 30)
watermark.Position = UDim2.new(0, 10, 0, 0)
watermark.BackgroundTransparency = 1
watermark.Font = Enum.Font.GothamBold
watermark.TextSize = 16
watermark.TextXAlignment = Enum.TextXAlignment.Left
watermark.TextColor3 = Color3.fromRGB(255, 0, 0)  -- Set to red
watermark.TextStrokeTransparency = 0
watermark.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
watermark.Parent = gui

-- Gradient animation
local gradientColors = {
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),    -- Red
    ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 165, 0)), -- Orange
    ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 255, 0)), -- Yellow
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0, 255, 0)),   -- Green
    ColorSequenceKeypoint.new(0.8, Color3.fromRGB(0, 0, 255)),   -- Blue
    ColorSequenceKeypoint.new(1, Color3.fromRGB(128, 0, 128))    -- Purple
}

local uiGradient = Instance.new("UIGradient")
uiGradient.Color = ColorSequence.new(gradientColors)
uiGradient.Parent = watermark

-- Animate gradient
local gradientOffset = 0
game:GetService("RunService").RenderStepped:Connect(function()
    gradientOffset = (gradientOffset + 0.002) % 1
    uiGradient.Offset = Vector2.new(gradientOffset, 0)
end)

-- Add clickable image under watermark
local imageButton = Instance.new("ImageButton")
imageButton.Size = UDim2.new(0, 50, 0, 50)  -- Small size for the image
imageButton.Position = UDim2.new(0, 10, 0, 35)  -- Position under watermark
imageButton.Image = "rbxassetid://15729160523"  -- Using Roblox asset ID
imageButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)  -- White background
imageButton.BackgroundTransparency = 0.5  -- Semi-transparent background
imageButton.ScaleType = Enum.ScaleType.Fit
imageButton.Parent = gui

-- Add click functionality
imageButton.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- MSK Time next to watermark
local mskTime = Instance.new("TextLabel")
mskTime.Size = UDim2.new(0, 150, 0, 30)
mskTime.Position = UDim2.new(0, 100, 0, 0)
mskTime.BackgroundTransparency = 1
mskTime.TextColor3 = Color3.fromRGB(255, 255, 255)
mskTime.TextTransparency = 0.2
mskTime.Font = Enum.Font.GothamBold
mskTime.TextSize = 16
mskTime.TextXAlignment = Enum.TextXAlignment.Left
mskTime.TextStrokeTransparency = 0.5
mskTime.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
mskTime.Parent = gui

-- Update MSK time
spawn(function()
    while wait(1) do
        local time = os.date("!*t")
        local hours = (time.hour + 3) % 24
        mskTime.Text = string.format("МСК %02d:%02d:%02d", hours, time.min, time.sec)
    end
end)

local title = Instance.new("TextLabel")
title.Text = menuTitle
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = frame



-- Sky Customization
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
local espButton = Instance.new("TextButton")
espButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
espButton.TextColor3 = Color3.fromRGB(255, 255, 255)
espButton.Font = Enum.Font.GothamSemibold
espButton.TextSize = 14
espButton.BorderSizePixel = 0
espButton.AutoButtonColor = true

-- Add rounded corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = espButton

-- Add hover effect
local originalColor = espButton.BackgroundColor3
espButton.MouseEnter:Connect(function()
    espButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
end)
espButton.MouseLeave:Connect(function()
    espButton.BackgroundColor3 = originalColor
end)
espButton.Text = "ESP: OFF"
espButton.Size = UDim2.new(0.4, -10, 0, 20)
espButton.Position = UDim2.new(0, 10, 0, 90)

local itemEspButton = Instance.new("TextButton")
itemEspButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
itemEspButton.TextColor3 = Color3.fromRGB(255, 255, 255)
itemEspButton.Font = Enum.Font.GothamSemibold
itemEspButton.TextSize = 14
itemEspButton.BorderSizePixel = 0
itemEspButton.AutoButtonColor = true

-- Add rounded corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = itemEspButton

-- Add hover effect
local originalColor = itemEspButton.BackgroundColor3
itemEspButton.MouseEnter:Connect(function()
    itemEspButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
end)
itemEspButton.MouseLeave:Connect(function()
    itemEspButton.BackgroundColor3 = originalColor
end)
itemEspButton.Text = "ITEM ESP: OFF"
itemEspButton.Size = UDim2.new(0.4, -10, 0, 20)
itemEspButton.Position = UDim2.new(0, 10, 0, 450)
itemEspButton.Parent = frame
espButton.Parent = frame

local noclipButton = Instance.new("TextButton")
noclipButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
noclipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
noclipButton.Font = Enum.Font.GothamSemibold
noclipButton.TextSize = 14
noclipButton.BorderSizePixel = 0
noclipButton.AutoButtonColor = true

-- Add rounded corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = noclipButton

-- Add hover effect
local originalColor = noclipButton.BackgroundColor3
noclipButton.MouseEnter:Connect(function()
    noclipButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
end)
noclipButton.MouseLeave:Connect(function()
    noclipButton.BackgroundColor3 = originalColor
end)
noclipButton.Text = "NOCLIP: OFF"
noclipButton.Size = UDim2.new(0.4, -10, 0, 20)
noclipButton.Position = UDim2.new(0, 10, 0, 120)
noclipButton.Parent = frame

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
speedLabel.Size = UDim2.new(1, -20, 0, 20)
speedLabel.Position = UDim2.new(0, 10, 0, 520)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 14
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = frame

local slider = Instance.new("Frame")
slider.Size = UDim2.new(1, -20, 0, 10)
slider.Position = UDim2.new(0, 10, 0, 530)
slider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
slider.BorderSizePixel = 0
slider.Parent = frame

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(defaultWalkSpeed / 100, 0, 1, 0)
sliderFill.Position = UDim2.new(0, 0, 0, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
sliderFill.BorderSizePixel = 0
sliderFill.Parent = slider

local sliderButton = Instance.new("TextButton")
sliderButton.Size = UDim2.new(0, 10, 0, 20)
sliderButton.Position = UDim2.new(defaultWalkSpeed / 100, -5, 0, -5)
sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sliderButton.BorderSizePixel = 0
sliderButton.Text = ""
sliderButton.Parent = slider

-- ESP Функции
local espObjects = {}
local itemEspObjects = {}
local colorPhase = 0
local colorSpeed = 0.01

-- Функция ESP для предметов
local function createItemEsp(item)
    if not item:IsA("BasePart") then return end

    local highlight = Instance.new("BoxHandleAdornment")
    highlight.Name = "CXNT_ITEM_ESP"
    highlight.Adornee = item
    highlight.AlwaysOnTop = true
    highlight.ZIndex = 10
    highlight.Size = item.Size + Vector3.new(0.1, 0.1, 0.1)
    highlight.Transparency = 0.7

    -- Определяем цвет в зависимости от типа предмета
    local itemName = item.Name:lower()
    if itemName:find("weapon") or itemName:find("gun") or itemName:find("sword") or itemName:find("knife") then
        highlight.Color3 = Color3.new(1, 0, 0) -- Красный для оружия
    elseif itemName:find("ammo") then
        highlight.Color3 = Color3.new(1, 1, 0) -- Желтый для патронов
    elseif itemName:find("heal") or itemName:find("med") or itemName:find("bandage") then
        highlight.Color3 = Color3.new(0, 1, 0) -- Зеленый для медикаментов
    elseif itemName:find("bond") then
        highlight.Color3 = Color3.new(0, 0, 1) -- Синий для бондов
    else
        highlight.Color3 = Color3.new(1, 1, 1) -- Белый для остальных предметов
    end

    highlight.Parent = game.CoreGui

    -- Добавляем название предмета
    local label = Instance.new("BillboardGui")
    label.Name = "CXNT_ITEM_LABEL"
    label.Size = UDim2.new(0, 100, 0, 20)
    label.StudsOffset = Vector3.new(0, item.Size.Y + 0.5, 0)
    label.AlwaysOnTop = true
    label.Parent = item

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.new(1,1, 1)
    text.TextStrokeTransparency = 0
    text.TextStrokeColor3 = Color3.new(0, 0, 0)
    text.Text = item.Name
    text.Font = Enum.Font.GothamBold
    text.TextSize = 14
    text.Parent = label

    itemEspObjects[item] = {highlight = highlight, label = label}
end

local function toggleItemEsp()
    local itemEspEnabled = not (next(itemEspObjects) ~= nil)

    -- Clean up existing ESP
    for item, objects in pairs(itemEspObjects) do
        if not item or not item.Parent then
            if objects.highlight then objects.highlight:Destroy() end
            if objects.label then objects.label:Destroy() end
            itemEspObjects[item] = nil
        end
    end

    if itemEspEnabled then
        -- Clean up when items are removed
        workspace.DescendantRemoving:Connect(function(item)
            if itemEspObjects[item] then
                if itemEspObjects[item].highlight then itemEspObjects[item].highlight:Destroy() end
                if itemEspObjects[item].label then itemEspObjects[item].label:Destroy() end
                itemEspObjects[item] = nil
            end
        end)

        -- Ищем все интерактивные предметы в игре
        for _, item in pairs(workspace:GetDescendants()) do
            -- Проверяем является ли предмет интерактивным (можно настроить под конкретную игру)
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
                item.Name:lower():find("loot") or
                item.Name:lower():find("collect")) then
                createItemEsp(item)
            end
        end

        -- Следим за новыми предметами
        workspace.DescendantAdded:Connect(function(item)
            if itemEspEnabled and item:IsA("BasePart") and
               (item.Name:lower():find("item") or 
                item.Name:lower():find("pickup") or 
                item.Name:lower():find("tool") or
                item.Name:lower():find("weapon") or
                item.Name:lower():find("ammo") or
                item.Name:lower():find("heal")) then
                createItemEsp(item)
            end
        end)
    else
        -- Удаляем ESP с предметов
        for _, objects in pairs(itemEspObjects) do
            if objects.highlight then objects.highlight:Destroy() end
            if objects.label then objects.label:Destroy() end
        end
        itemEspObjects = {}
    end

    return itemEspEnabled
end

local lastUpdate = 0
local updateInterval = 0.1 -- Update every 0.1 seconds instead of every frame

local function updateEspColor()
    local currentTime = tick()
    if currentTime - lastUpdate < updateInterval then return end

    lastUpdate = currentTime
    colorPhase = (colorPhase + colorSpeed) % 1
    local brightness = 0.5 + 0.5 * math.sin(colorPhase * math.pi * 2)
    espColor = Color3.new(brightness, brightness, brightness)

    for player, parts in pairs(espObjects) do
        for _, part in ipairs(parts) do
            if part and part.Parent then
                part.Color = espColor
            end
        end
    end
end

local function createEsp(target, isPlayer)
    if isPlayer and target == game.Players.LocalPlayer then return end

    local function setupEsp(character)
        if not character then return end
        local parts = {}

        -- Red for mobs/NPCs, white for players
        local espColorToUse = isPlayer and Color3.new(1, 1, 1) or Color3.new(1, 0, 0)

        -- Remove old ESP if exists
        if espObjects[target] then
            removeEsp(target)
        end

        -- Create name label at the top
        local nameLabel = Instance.new("BillboardGui")
    nameLabel.Name = "CXNT_NameLabel"
    nameLabel.Size = UDim2.new(0, 200, 0, 50)
    nameLabel.StudsOffset = Vector3.new(0, 3, 0)
    nameLabel.AlwaysOnTop = true
    nameLabel.Parent = character:WaitForChild("Head")

    local nameText = Instance.new("TextLabel")
    nameText.Size = UDim2.new(1, 0, 1, 0)
    nameText.BackgroundTransparency = 1
    nameText.TextColor3 = Color3.new(1, 1, 1)
    nameText.TextStrokeTransparency = 0
    nameText.TextStrokeColor3 = Color3.new(0, 0, 0)
    nameText.Text = target.Name
    nameText.Font = Enum.Font.GothamBold
    nameText.TextSize = 14
    nameText.Parent = nameLabel

    table.insert(parts, nameLabel)

    local function addHighlight(part)
        if part:IsA("BasePart") then
            local highlight = Instance.new("BoxHandleAdornment")
            highlight.Name = "CXNT_ESP"
            highlight.Adornee = part
            highlight.AlwaysOnTop = true
            highlight.ZIndex = 10
            highlight.Size = part.Size + Vector3.new(0.1, 0.1, 0.1)
            highlight.Transparency = 0.7
            highlight.Color3 = espColor
            highlight.Parent = game.CoreGui

            table.insert(parts, highlight)
        end
    end

    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            addHighlight(part)
        end
    end

    character.DescendantAdded:Connect(function(part)
        if part:IsA("BasePart") then
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
    frame.Visible = visible
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
    
    if action == "explore" then
        -- Find interesting locations
        local points = workspace:GetPartBoundsInRadius(rootPart.Position, 100)
        if #points > 0 then
            local target = points[math.random(#points)]
            humanoid:MoveTo(target.Position + Vector3.new(0, 5, 0))
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
        -- Practice combat moves
        local animations = humanoid:GetPlayingAnimationTracks()
        for _, anim in pairs(animations) do
            anim:Stop()
        end
        
        local tool = character:FindFirstChildOfClass("Tool")
        if tool then
            tool:Activate()
            aiKnowledge.combatExperience = aiKnowledge.combatExperience + 1
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
