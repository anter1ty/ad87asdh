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
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
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

-- Watermark with time and image
local watermark = Instance.new("TextLabel")
watermark.Text = "CXNT V1"
watermark.Size = UDim2.new(0, 250, 0, 30)
watermark.Position = UDim2.new(0, 10, 0, 0)
watermark.BackgroundTransparency = 1
watermark.TextColor3 = Color3.fromRGB(255, 255, 255)
watermark.TextTransparency = 0.2
watermark.Font = Enum.Font.GothamBold
watermark.TextSize = 16
watermark.TextXAlignment = Enum.TextXAlignment.Left
watermark.TextStrokeTransparency = 0.5
watermark.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
watermark.Parent = gui

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
                flyConnection = game:GetService("RunService").RenderStepped:Connect(function()
                    local camera = workspace.CurrentCamera
                    local lookVector = camera.CFrame.LookVector
                    local rightVector = camera.CFrame.RightVector

                    local moveDirection = Vector3.new(0, 0, 0)

                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
                        moveDirection = moveDirection + lookVector
                    end
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
                        moveDirection = moveDirection - lookVector
                    end
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
                        moveDirection = moveDirection + rightVector
                    end
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
                        moveDirection = moveDirection - rightVector
                    end
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection = moveDirection + Vector3.new(0, 1, 0)
                    end
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection = moveDirection - Vector3.new(0, 1, 0)
                    end

                    root.Velocity = moveDirection.Unit * flySpeed
                end)

                humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
            end
        else
            if flyConnection then
                flyConnection:Disconnect()
                local humanoid = player.Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Landing)
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

                for _, otherPlayer in pairs(game.Players:GetPlayers()) do
                    if otherPlayer ~= player and otherPlayer and otherPlayer.Character and 
                       otherPlayer.Character:FindFirstChild("HumanoidRootPart") and
                       otherPlayer.Character:FindFirstChild("Humanoid") and
                       otherPlayer.Character.Humanoid.Health > 0 then

                        local distance = (otherPlayer.Character.HumanoidRootPart.Position - myCharacter.HumanoidRootPart.Position).Magnitude
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
        local styles = {"DEFAULT", "DARK_RED_MOON", "BLUE_SKY", "GOLDEN_HOUR", "DRAIN", "BRIGHT", "NIGHT_STARS", "SUNSET", "ANIME_SKY", "PURPLE_NEBULA", "VAPORWAVE", "SPACE", "EMERALD_SKY", "SUNSET_PARADISE"}
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
