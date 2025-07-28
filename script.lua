if not game:IsLoaded() then game.Loaded:Wait() end
-- 5555
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Удаляем старый GUI если есть
if CoreGui:FindFirstChild("UltraMobileMenu") then
    CoreGui.UltraMobileMenu:Destroy()
end

-- Настройки
local settings = {
    speed = 16,
    speedHack = false,
    noClip = false,
    following = false,
    followTarget = nil,
    cameraDistance = 5,
    cameraAngle = 0
}

-- Создаем мобильный GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltraMobileMenu"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Основной фрейм
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0.75, 0, 0, 40)
MainFrame.Position = UDim2.new(0.5, 0, 0.1, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Заголовок
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Position = UDim2.new(0.15, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "MOBILE HACK MENU"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Кнопка закрытия
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0.15, 0, 1, 0)
CloseButton.Position = UDim2.new(0.85, 0, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 18
CloseButton.Parent = TitleBar

-- Кнопка развернуть/свернуть
local ExpandButton = Instance.new("TextButton")
ExpandButton.Size = UDim2.new(0.15, 0, 1, 0)
ExpandButton.Position = UDim2.new(0, 0, 0, 0)
ExpandButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
ExpandButton.BorderSizePixel = 0
ExpandButton.Text = "≡"
ExpandButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ExpandButton.Font = Enum.Font.GothamBold
ExpandButton.TextSize = 20
ExpandButton.Parent = TitleBar

-- Контент меню
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 0, 0)
ContentFrame.Position = UDim2.new(0, 0, 1, 0)
ContentFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ContentFrame.BorderSizePixel = 0
ContentFrame.ClipsDescendants = true
ContentFrame.Parent = MainFrame

-- Функции для создания элементов
local function createButton(text, parent, height)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, height or 40)
    button.Position = UDim2.new(0, 5, 0, 0)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button
    
    return button
end

local function createSlider(parent, min, max, value)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, -10, 0, 30)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = parent
    
    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(1, 0, 0, 10)
    slider.Position = UDim2.new(0, 0, 0.5, 0)
    slider.AnchorPoint = Vector2.new(0, 0.5)
    slider.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    slider.BorderSizePixel = 0
    slider.Parent = sliderFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = slider
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((value - min)/(max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    fill.BorderSizePixel = 0
    fill.Parent = slider
    
    local corner2 = Instance.new("UICorner")
    corner2.CornerRadius = UDim.new(0, 5)
    corner2.Parent = fill
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 50, 0, 20)
    valueLabel.Position = UDim2.new(1, 5, 0.5, 0)
    valueLabel.AnchorPoint = Vector2.new(0, 0.5)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(value)
    valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 12
    valueLabel.TextXAlignment = Enum.TextXAlignment.Left
    valueLabel.Parent = sliderFrame
    
    local dragging = false
    
    local function updateValue(x)
        local percent = math.clamp((x - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
        local newValue = math.floor(min + (max - min) * percent)
        fill.Size = UDim2.new(percent, 0, 1, 0)
        valueLabel.Text = tostring(newValue)
        return newValue
    end
    
    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            settings.speed = updateValue(input.Position.X + slider.AbsolutePosition.X)
        end
    end)
    
    slider.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.Touch then
            settings.speed = updateValue(input.Position.X + slider.AbsolutePosition.X)
        end
    end)
    
    return sliderFrame
end

-- Создаем элементы меню
local function addSection(title, parent)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, -10, 0, 40)
    section.BackgroundTransparency = 1
    section.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = " "..string.upper(title)
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = section
    
    return section
end

-- Секция Speed Hack
local speedSection = addSection("speed hack", ContentFrame)
local speedButton = createButton("SPEED HACK: OFF", speedSection, 35)
speedButton.Size = UDim2.new(0.45, -5, 1, 0)

local speedSlider = createSlider(speedSection, 1, 300, settings.speed)
speedSlider.Position = UDim2.new(0.55, 5, 0, 0)

speedButton.MouseButton1Click:Connect(function()
    settings.speedHack = not settings.speedHack
    speedButton.Text = "SPEED HACK: "..(settings.speedHack and "ON" or "OFF")
    speedButton.BackgroundColor3 = settings.speedHack and Color3.fromRGB(0, 150, 100) or Color3.fromRGB(50, 50, 60)
end)

-- Секция NoClip
local noClipSection = addSection("no clip", ContentFrame)
local noClipButton = createButton("NO CLIP: OFF", noClipSection, 35)
noClipButton.MouseButton1Click:Connect(function()
    settings.noClip = not settings.noClip
    noClipButton.Text = "NO CLIP: "..(settings.noClip and "ON" or "OFF")
    noClipButton.BackgroundColor3 = settings.noClip and Color3.fromRGB(0, 150, 100) or Color3.fromRGB(50, 50, 60)
end)

-- Секция Follow
local followSection = addSection("player follow", ContentFrame)
local followButton = createButton("FOLLOW PLAYER: OFF", followSection, 35)
followButton.MouseButton1Click:Connect(function()
    if not settings.followTarget then
        -- Автовыбор первого игрока
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                settings.followTarget = player
                break
            end
        end
    end
    
    settings.following = not settings.following
    followButton.Text = "FOLLOW PLAYER: "..(settings.following and "ON" or "OFF")
    followButton.BackgroundColor3 = settings.following and Color3.fromRGB(0, 150, 100) or Color3.fromRGB(50, 50, 60)
    
    if not settings.following then
        Camera.CameraType = Enum.CameraType.Custom
    end
end)

-- Секция телепортации
local teleportSection = addSection("teleport", ContentFrame)
local teleportButton = createButton("TELEPORT TO PLAYER", teleportSection, 35)
teleportButton.MouseButton1Click:Connect(function()
    if settings.followTarget and settings.followTarget.Character then
        local hrp = settings.followTarget.Character:FindFirstChild("HumanoidRootPart")
        if hrp and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character:SetPrimaryPartCFrame(hrp.CFrame * CFrame.new(0, 0, 2))
        end
    end
end)

-- Обработка функций
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
            Camera.CFrame = targetHRP.CFrame * CFrame.new(0, 3, -settings.cameraDistance) * CFrame.Angles(0, settings.cameraAngle, 0)
            LocalPlayer.Character:SetPrimaryPartCFrame(targetHRP.CFrame * CFrame.new(0, 0, 2))
        end
    end
end)

-- Вращение камеры
local cameraRotating = false
local lastTouchPos = nil

UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch and settings.following then
        cameraRotating = true
        lastTouchPos = input.Position
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        cameraRotating = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if cameraRotating and input.UserInputType == Enum.UserInputType.Touch and lastTouchPos then
        local delta = input.Position - lastTouchPos
        settings.cameraAngle = settings.cameraAngle + delta.X * 0.01
        settings.cameraDistance = math.clamp(settings.cameraDistance - delta.Y * 0.1, 2, 15)
        lastTouchPos = input.Position
    end
end)

-- Управление меню
local expanded = false
local function toggleMenu()
    expanded = not expanded
    if expanded then
        ContentFrame.Visible = true
        ContentFrame.Size = UDim2.new(1, 0, 0, 210)
        ExpandButton.Text = "▼"
        MainFrame.Size = UDim2.new(0.75, 0, 0, 250)
    else
        ContentFrame.Visible = false
        ContentFrame.Size = UDim2.new(1, 0, 0, 0)
        ExpandButton.Text = "≡"
        MainFrame.Size = UDim2.new(0.75, 0, 0, 40)
    end
end

ExpandButton.MouseButton1Click:Connect(toggleMenu)
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    Camera.CameraType = Enum.CameraType.Custom
end)

-- Инициализация
toggleMenu() -- Сворачиваем меню при старте
