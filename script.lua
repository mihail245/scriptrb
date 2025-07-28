if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Удаляем старый GUI если есть
if CoreGui:FindFirstChild("MobileFollowGUI") then
    CoreGui.MobileFollowGUI:Destroy()
end

-- Настройки
local settings = {
    speed = 16,
    speedHack = false,
    noClip = false,
    cameraRotation = Vector2.new(0, 0),
    cameraDistance = 5,
    followMode = "Teleport",
    followTarget = nil,
    following = false
}

-- Создаем мобильный GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MobileFollowGUI"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Основной фрейм
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(1, -20, 0, 40)
MainFrame.Position = UDim2.new(0.5, -10, 0, 10)
MainFrame.AnchorPoint = Vector2.new(0.5, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "Mobile Follow v2"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Parent = MainFrame

-- Кнопка развернуть/свернуть
local ExpandButton = Instance.new("TextButton")
ExpandButton.Size = UDim2.new(0, 40, 1, 0)
ExpandButton.Position = UDim2.new(1, -40, 0, 0)
ExpandButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
ExpandButton.BorderSizePixel = 0
ExpandButton.Text = "▼"
ExpandButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ExpandButton.Font = Enum.Font.GothamBold
ExpandButton.TextSize = 16
ExpandButton.Parent = MainFrame

-- Расширенный контент
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 0, 0)
ContentFrame.Position = UDim2.new(0, 0, 1, 5)
ContentFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
ContentFrame.BorderSizePixel = 0
ContentFrame.ClipsDescendants = true
ContentFrame.Parent = MainFrame

-- Функции
local function updateContentSize()
    local height = 0
    for _, child in ipairs(ContentFrame:GetChildren()) do
        if child:IsA("Frame") and child.Visible then
            height = height + child.AbsoluteSize.Y + 5
        end
    end
    ContentFrame.Size = UDim2.new(1, 0, 0, height)
end

local function createSection(title)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, -10, 0, 0)
    section.Position = UDim2.new(0, 5, 0, 0)
    section.BackgroundTransparency = 1
    section.Parent = ContentFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = title
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = section
    
    return section
end

local function createButton(parent, text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 30)
    button.Position = UDim2.new(0, 0, 0, 0)
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

local function createSlider(parent, text, min, max, value, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, 0, 0, 40)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = text..": "..value
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sliderFrame
    
    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(1, 0, 0, 10)
    slider.Position = UDim2.new(0, 0, 0, 25)
    slider.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    slider.BorderSizePixel = 0
    slider.Parent = sliderFrame
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((value - min)/(max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    fill.BorderSizePixel = 0
    fill.Parent = slider
    
    local dragging = false
    
    local function updateValue(x)
        local percent = math.clamp((x - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
        local newValue = math.floor(min + (max - min) * percent)
        fill.Size = UDim2.new(percent, 0, 1, 0)
        label.Text = text..": "..newValue
        callback(newValue)
    end
    
    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateValue(input.Position.X + slider.AbsolutePosition.X)
        end
    end)
    
    slider.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.Touch then
            updateValue(input.Position.X + slider.AbsolutePosition.X)
        end
    end)
    
    return sliderFrame
end

-- Секция игроков
local playersSection = createSection("Players")
playersSection.Size = UDim2.new(1, 0, 0, 120)

local playerList = Instance.new("ScrollingFrame")
playerList.Size = UDim2.new(1, 0, 0, 100)
playerList.Position = UDim2.new(0, 0, 0, 20)
playerList.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
playerList.BorderSizePixel = 0
playerList.ScrollBarThickness = 4
playerList.AutomaticCanvasSize = Enum.AutomaticSize.Y
playerList.CanvasSize = UDim2.new(0, 0, 0, 0)
playerList.Parent = playersSection

local playerListLayout = Instance.new("UIListLayout")
playerListLayout.Padding = UDim.new(0, 5)
playerListLayout.Parent = playerList

local function updatePlayerList()
    for _, child in ipairs(playerList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local button = createButton(playerList, player.Name, function()
                settings.followTarget = player
            end)
            button.Size = UDim2.new(1, -10, 0, 30)
            button.Position = UDim2.new(0, 5, 0, 0)
        end
    end
end

-- Секция режимов
local modeSection = createSection("Follow Mode")
local teleportButton = createButton(modeSection, "Teleport", function()
    settings.followMode = "Teleport"
    teleportButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    cameraButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
end)
teleportButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)

local cameraButton = createButton(modeSection, "Camera", function()
    settings.followMode = "Camera"
    cameraButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    teleportButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
end)

-- Секция управления
local controlSection = createSection("Controls")
local followButton = createButton(controlSection, "Start Following", function()
    if settings.following then
        settings.following = false
        followButton.Text = "Start Following"
        Camera.CameraType = Enum.CameraType.Custom
    else
        if settings.followTarget then
            settings.following = true
            followButton.Text = "Stop Following"
        end
    end
end)

local teleportOnceButton = createButton(controlSection, "Teleport Once", function()
    if settings.followTarget and settings.followTarget.Character then
        local hrp = settings.followTarget.Character:FindFirstChild("HumanoidRootPart")
        if hrp and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character:SetPrimaryPartCFrame(hrp.CFrame * CFrame.new(0, 0, 1.5))
        end
    end
end)

-- Секция настроек
local settingsSection = createSection("Settings")
createSlider(settingsSection, "Speed", 1, 50, settings.speed, function(value)
    settings.speed = value
end)

local speedHackToggle = createButton(settingsSection, "Speed Hack: OFF", function()
    settings.speedHack = not settings.speedHack
    speedHackToggle.Text = "Speed Hack: "..(settings.speedHack and "ON" or "OFF")
end)

local noClipToggle = createButton(settingsSection, "NoClip: OFF", function()
    settings.noClip = not settings.noClip
    noClipToggle.Text = "NoClip: "..(settings.noClip and "ON" or "OFF")
end)

-- Обработка слежения
RunService.Heartbeat:Connect(function()
    if settings.following and settings.followTarget and settings.followTarget.Character then
        local targetHRP = settings.followTarget.Character:FindFirstChild("HumanoidRootPart")
        if targetHRP then
            if settings.followMode == "Teleport" then
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character:SetPrimaryPartCFrame(targetHRP.CFrame * CFrame.new(0, 0, 1.5))
                end
            else
                Camera.CameraType = Enum.CameraType.Scriptable
                Camera.CFrame = targetHRP.CFrame * CFrame.new(0, 2, -settings.cameraDistance) * CFrame.Angles(settings.cameraRotation.Y, settings.cameraRotation.X, 0)
            end
        end
    end
    
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
end)

-- Вращение камеры
local cameraRotating = false
local lastTouchPos = nil

UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        cameraRotating = true
        lastTouchPos = input.Position
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        cameraRotating = false
        lastTouchPos = nil
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if cameraRotating and input.UserInputType == Enum.UserInputType.Touch and lastTouchPos then
        local delta = input.Position - lastTouchPos
        settings.cameraRotation = settings.cameraRotation + Vector2.new(delta.X * 0.01, delta.Y * 0.01)
        lastTouchPos = input.Position
    end
end)

-- Развернуть/свернуть GUI
local expanded = false
ExpandButton.MouseButton1Click:Connect(function()
    expanded = not expanded
    if expanded then
        ContentFrame.Visible = true
        ExpandButton.Text = "▲"
        updateContentSize()
    else
        ContentFrame.Visible = false
        ExpandButton.Text = "▼"
        ContentFrame.Size = UDim2.new(1, 0, 0, 0)
    end
end)

-- Инициализация
updatePlayerList()
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)
updateContentSize()
ContentFrame.Visible = false
