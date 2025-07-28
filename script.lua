if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Удаляем старый GUI если есть
if CoreGui:FindFirstChild("MobileFollowMini") then
    CoreGui.MobileFollowMini:Destroy()
end

-- Настройки
local settings = {
    speed = 16,
    speedHack = false,
    noClip = false,
    following = false,
    followTarget = nil
}

-- Создаем мобильный GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MobileFollowMini"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Основной фрейм
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0.8, 0, 0, 40)
MainFrame.Position = UDim2.new(0.5, 0, 0.1, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Заголовок с кнопкой развернуть/свернуть
local Title = Instance.new("TextButton")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
Title.BorderSizePixel = 0
Title.Text = "Mobile Follow Mini ▼"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Parent = MainFrame

-- Контент меню
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 0, 0)
ContentFrame.Position = UDim2.new(0, 0, 1, 5)
ContentFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
ContentFrame.BorderSizePixel = 0
ContentFrame.ClipsDescendants = true
ContentFrame.Parent = MainFrame

-- Функции для создания элементов
local function createButton(text, callback, parent)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, 35)
    button.Position = UDim2.new(0, 5, 0, 0)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.Parent = parent
    
    button.MouseButton1Click:Connect(callback)
    
    return button
end

local function createSlider(parent, min, max, value, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(0.5, -10, 0, 35)
    sliderFrame.Position = UDim2.new(0.5, 5, 0, 0)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = parent
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((value - min)/(max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    fill.BorderSizePixel = 0
    fill.Parent = sliderFrame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(1, 0, 1, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(value)
    valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 12
    valueLabel.Parent = sliderFrame
    
    local dragging = false
    
    local function updateValue(x)
        local percent = math.clamp((x - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X, 0, 1)
        local newValue = math.floor(min + (max - min) * percent)
        fill.Size = UDim2.new(percent, 0, 1, 0)
        valueLabel.Text = tostring(newValue)
        callback(newValue)
    end
    
    sliderFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateValue(input.Position.X + sliderFrame.AbsolutePosition.X)
        end
    end)
    
    sliderFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.Touch then
            updateValue(input.Position.X + sliderFrame.AbsolutePosition.X)
        end
    end)
    
    return sliderFrame
end

-- Создаем элементы меню
local speedHackButton = createButton("Speed Hack: OFF", function()
    settings.speedHack = not settings.speedHack
    speedHackButton.Text = "Speed Hack: "..(settings.speedHack and "ON" or "OFF")
end, ContentFrame)

local speedSlider = createSlider(speedHackButton, 1, 300, settings.speed, function(value)
    settings.speed = value
end)

local noClipButton = createButton("NoClip: OFF", function()
    settings.noClip = not settings.noClip
    noClipButton.Text = "NoClip: "..(settings.noClip and "ON" or "OFF")
end, ContentFrame)

local followButton = createButton("Follow Player: OFF", function()
    if not settings.followTarget then
        -- Простой выбор первого игрока (можно улучшить)
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                settings.followTarget = player
                break
            end
        end
    end
    
    settings.following = not settings.following
    followButton.Text = "Follow Player: "..(settings.following and "ON" or "OFF")
    
    if not settings.following then
        Camera.CameraType = Enum.CameraType.Custom
    end
end, ContentFrame)

local teleportButton = createButton("Teleport to Player", function()
    if settings.followTarget and settings.followTarget.Character then
        local hrp = settings.followTarget.Character:FindFirstChild("HumanoidRootPart")
        if hrp and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character:SetPrimaryPartCFrame(hrp.CFrame * CFrame.new(0, 0, 2))
        end
    end
end, ContentFrame)

-- Обработка слежения и функций
RunService.Heartbeat:Connect(function()
    -- Speed hack
    if settings.speedHack and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = settings.speed
        end
    end
    
    -- NoClip
    if settings.noClip and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
    
    -- Following
    if settings.following and settings.followTarget and settings.followTarget.Character then
        local targetHRP = settings.followTarget.Character:FindFirstChild("HumanoidRootPart")
        if targetHRP and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            Camera.CameraType = Enum.CameraType.Scriptable
            Camera.CFrame = targetHRP.CFrame * CFrame.new(0, 3, -5)
            LocalPlayer.Character:SetPrimaryPartCFrame(targetHRP.CFrame * CFrame.new(0, 0, 2))
        end
    end
end)

-- Развернуть/свернуть меню
local expanded = false
Title.MouseButton1Click:Connect(function()
    expanded = not expanded
    if expanded then
        ContentFrame.Visible = true
        ContentFrame.Size = UDim2.new(1, 0, 0, 180)
        Title.Text = "Mobile Follow Mini ▲"
    else
        ContentFrame.Visible = false
        ContentFrame.Size = UDim2.new(1, 0, 0, 0)
        Title.Text = "Mobile Follow Mini ▼"
    end
end)

-- Инициализация
ContentFrame.Visible = false
