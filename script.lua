if not game:IsLoaded() then game.Loaded:Wait() end

-- Сервисы
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Удаляем старое меню если есть
if game.CoreGui:FindFirstChild("PremiumHackMenu") then
    game.CoreGui.PremiumHackMenu:Destroy()
end

-- Настройки
local settings = {
    speed = 16,
    speedHack = false,
    noClip = false,
    following = false,
    followTarget = nil,
    cameraDistance = 8,
    cameraAngleX = 0,
    cameraAngleY = 20,
    activeTab = "Main",
    minimized = false
}

-- Переменные
local noClipParts = {}
local cameraConnection = nil
local followConnection = nil
local speedConnection = nil

-- Цвета
local colors = {
    background = Color3.fromRGB(30, 30, 40),
    header = Color3.fromRGB(25, 25, 35),
    button = Color3.fromRGB(45, 45, 55),
    buttonHover = Color3.fromRGB(55, 55, 65),
    buttonActive = Color3.fromRGB(0, 120, 215),
    text = Color3.fromRGB(240, 240, 240),
    scrollBar = Color3.fromRGB(80, 80, 80),
    tabActive = Color3.fromRGB(0, 100, 180),
    tabInactive = Color3.fromRGB(40, 40, 50)
}

-- Создаем GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PremiumHackMenu"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Основное окно
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 350)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -175)
MainFrame.BackgroundColor3 = colors.background
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Скругление углов
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = MainFrame

-- Тень
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.8
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)
shadow.Parent = MainFrame

-- Заголовок
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = colors.header
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.6, 0, 1, 0)
Title.Position = UDim2.new(0.2, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "PREMIUM HACKS"
Title.TextColor3 = colors.text
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.Parent = TitleBar

-- Кнопка свернуть
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0.2, 0, 1, 0)
MinimizeButton.Position = UDim2.new(0, 0, 0, 0)
MinimizeButton.BackgroundColor3 = colors.button
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Text = "_"
MinimizeButton.TextColor3 = colors.text
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 14
MinimizeButton.Parent = TitleBar

-- Эффекты кнопок
local function buttonEffects(button)
    button.MouseEnter:Connect(function()
        if button ~= MinimizeButton and button ~= CloseButton then
            button.BackgroundColor3 = colors.buttonHover
        end
    end)
    
    button.MouseLeave:Connect(function()
        if button ~= MinimizeButton and button ~= CloseButton then
            button.BackgroundColor3 = colors.button
        end
    end)
end

buttonEffects(MinimizeButton)

-- Кнопка закрыть
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0.2, 0, 1, 0)
CloseButton.Position = UDim2.new(0.8, 0, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "X"
CloseButton.TextColor3 = colors.text
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 14
CloseButton.Parent = TitleBar

-- Вкладки
local TabsFrame = Instance.new("Frame")
TabsFrame.Size = UDim2.new(1, 0, 0, 30)
TabsFrame.Position = UDim2.new(0, 0, 0, 30)
TabsFrame.BackgroundTransparency = 1
TabsFrame.Parent = MainFrame

local MainTabButton = Instance.new("TextButton")
MainTabButton.Size = UDim2.new(0.33, -2, 1, 0)
MainTabButton.Position = UDim2.new(0, 0, 0, 0)
MainTabButton.BackgroundColor3 = colors.tabActive
MainTabButton.BorderSizePixel = 0
MainTabButton.Text = "Main"
MainTabButton.TextColor3 = colors.text
MainTabButton.Font = Enum.Font.Gotham
MainTabButton.TextSize = 14
MainTabButton.Parent = TabsFrame

buttonEffects(MainTabButton)

local MovementTabButton = Instance.new("TextButton")
MovementTabButton.Size = UDim2.new(0.33, -2, 1, 0)
MovementTabButton.Position = UDim2.new(0.33, 0, 0, 0)
MovementTabButton.BackgroundColor3 = colors.tabInactive
MovementTabButton.BorderSizePixel = 0
MovementTabButton.Text = "Movement"
MovementTabButton.TextColor3 = colors.text
MovementTabButton.Font = Enum.Font.Gotham
MovementTabButton.TextSize = 14
MovementTabButton.Parent = TabsFrame

buttonEffects(MovementTabButton)

local VisualTabButton = Instance.new("TextButton")
VisualTabButton.Size = UDim2.new(0.33, -2, 1, 0)
VisualTabButton.Position = UDim2.new(0.66, 0, 0, 0)
VisualTabButton.BackgroundColor3 = colors.tabInactive
VisualTabButton.BorderSizePixel = 0
VisualTabButton.Text = "Visual"
VisualTabButton.TextColor3 = colors.text
VisualTabButton.Font = Enum.Font.Gotham
VisualTabButton.TextSize = 14
VisualTabButton.Parent = TabsFrame

buttonEffects(VisualTabButton)

-- Контент вкладок
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -10, 1, -70)
ContentFrame.Position = UDim2.new(0, 5, 0, 65)
ContentFrame.BackgroundTransparency = 1
ContentFrame.ClipsDescendants = true
ContentFrame.Parent = MainFrame

-- Вкладка Main
local MainTab = Instance.new("ScrollingFrame")
MainTab.Name = "MainTab"
MainTab.Size = UDim2.new(1, 0, 1, 0)
MainTab.BackgroundTransparency = 1
MainTab.ScrollBarThickness = 5
MainTab.ScrollBarImageColor3 = colors.scrollBar
MainTab.CanvasSize = UDim2.new(0, 0, 0, 300)
MainTab.Visible = true
MainTab.Parent = ContentFrame

-- Вкладка Movement
local MovementTab = Instance.new("ScrollingFrame")
MovementTab.Name = "MovementTab"
MovementTab.Size = UDim2.new(1, 0, 1, 0)
MovementTab.BackgroundTransparency = 1
MovementTab.ScrollBarThickness = 5
MovementTab.ScrollBarImageColor3 = colors.scrollBar
MovementTab.CanvasSize = UDim2.new(0, 0, 0, 200)
MovementTab.Visible = false
MovementTab.Parent = ContentFrame

-- Вкладка Visual
local VisualTab = Instance.new("ScrollingFrame")
VisualTab.Name = "VisualTab"
VisualTab.Size = UDim2.new(1, 0, 1, 0)
VisualTab.BackgroundTransparency = 1
VisualTab.ScrollBarThickness = 5
VisualTab.ScrollBarImageColor3 = colors.scrollBar
VisualTab.CanvasSize = UDim2.new(0, 0, 0, 150)
VisualTab.Visible = false
VisualTab.Parent = ContentFrame

-- Функции для создания элементов UI
local function createButton(parent, text, sizeY)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.9, 0, 0, sizeY or 35)
    button.Position = UDim2.new(0.05, 0, 0, 0)
    button.BackgroundColor3 = colors.button
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = colors.text
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button
    
    buttonEffects(button)
    
    return button
end

local function createInput(parent, placeholder)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.9, 0, 0, 30)
    frame.Position = UDim2.new(0.05, 0, 0, 0)
    frame.BackgroundColor3 = colors.button
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0.7, 0, 0.8, 0)
    box.Position = UDim2.new(0.15, 0, 0.1, 0)
    box.BackgroundTransparency = 1
    box.Text = ""
    box.PlaceholderText = placeholder
    box.TextColor3 = colors.text
    box.Font = Enum.Font.Gotham
    box.TextSize = 14
    box.Parent = frame
    
    return box
end

-- Элементы вкладки Main
local PlayerList = Instance.new("ScrollingFrame")
PlayerList.Size = UDim2.new(0.9, 0, 0, 120)
PlayerList.Position = UDim2.new(0.05, 0, 0, 10)
PlayerList.BackgroundColor3 = colors.button
PlayerList.BorderSizePixel = 0
PlayerList.ScrollBarThickness = 5
PlayerList.ScrollBarImageColor3 = colors.scrollBar
PlayerList.AutomaticCanvasSize = Enum.AutomaticSize.Y
PlayerList.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerList.Parent = MainTab

local listCorner = Instance.new("UICorner")
listCorner.CornerRadius = UDim.new(0, 6)
listCorner.Parent = PlayerList

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.Parent = PlayerList

local FollowButton = createButton(MainTab, "Follow Player: OFF", 35)
FollowButton.Position = UDim2.new(0.05, 0, 0, 140)

local TeleportButton = createButton(MainTab, "Teleport to Player", 35)
TeleportButton.Position = UDim2.new(0.05, 0, 0, 185)

local ModeFrame = Instance.new("Frame")
ModeFrame.Size = UDim2.new(0.9, 0, 0, 35)
ModeFrame.Position = UDim2.new(0.05, 0, 0, 230)
ModeFrame.BackgroundTransparency = 1
ModeFrame.Parent = MainTab

local TeleportMode = createButton(ModeFrame, "Teleport", 35)
TeleportMode.Size = UDim2.new(0.45, 0, 1, 0)
TeleportMode.Position = UDim2.new(0, 0, 0, 0)
TeleportMode.BackgroundColor3 = colors.buttonActive

local CameraMode = createButton(ModeFrame, "Camera", 35)
CameraMode.Size = UDim2.new(0.45, 0, 1, 0)
CameraMode.Position = UDim2.new(0.55, 0, 0, 0)

-- Элементы вкладки Movement
local SpeedBox = createInput(MovementTab, "Enter speed (16-300)")
SpeedBox.Parent.Position = UDim2.new(0.05, 0, 0, 10)

local SpeedButton = createButton(MovementTab, "Set Speed", 35)
SpeedButton.Position = UDim2.new(0.05, 0, 0, 50)

local SpeedHackButton = createButton(MovementTab, "Speed Hack: OFF", 35)
SpeedHackButton.Position = UDim2.new(0.05, 0, 0, 95)

local NoClipButton = createButton(MovementTab, "NoClip: OFF", 35)
NoClipButton.Position = UDim2.new(0.05, 0, 0, 140)

-- Элементы вкладки Visual
local TransparencySlider = createButton(VisualTab, "NoClip Transparency: 50%", 35)
TransparencySlider.Position = UDim2.new(0.05, 0, 0, 10)

-- Функции
local function UpdatePlayerList()
    for _, child in ipairs(PlayerList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local PlayerButton = createButton(PlayerList, player.Name, 25)
            PlayerButton.Name = player.Name
            PlayerButton.TextXAlignment = Enum.TextXAlignment.Left
            PlayerButton.TextSize = 12
            
            PlayerButton.MouseButton1Click:Connect(function()
                for _, btn in ipairs(PlayerList:GetChildren()) do
                    if btn:IsA("TextButton") then
                        btn.BackgroundColor3 = colors.button
                    end
                end
                PlayerButton.BackgroundColor3 = colors.buttonActive
                settings.followTarget = player
            end)
        end
    end
end

local function ToggleNoClip()
    settings.noClip = not settings.noClip
    NoClipButton.Text = "NoClip: "..(settings.noClip and "ON" or "OFF")
    NoClipButton.BackgroundColor3 = settings.noClip and colors.buttonActive or colors.button
    
    if settings.noClip then
        -- Включаем NoClip
        if LocalPlayer.Character then
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                    noClipParts[part] = true
                end
            end
        end
        
        -- Подключаем обработчик добавления новых частей
        table.insert(noClipParts, LocalPlayer.CharacterAdded:Connect(function(char)
            wait(0.5)
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                    noClipParts[part] = true
                end
            end
        end))
    else
        -- Выключаем NoClip
        for part, _ in pairs(noClipParts) do
            if part and part.Parent then
                part.CanCollide = true
            end
        end
        noClipParts = {}
    end
end

local function SetSpeed()
    local newSpeed = tonumber(SpeedBox.Text)
    if newSpeed and newSpeed >= 16 and newSpeed <= 300 then
        settings.speed = newSpeed
        if settings.speedHack and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = settings.speed
            end
        end
    else
        SpeedBox.Text = ""
        SpeedBox.PlaceholderText = "Invalid speed (16-300)"
    end
end

local function ToggleSpeedHack()
    settings.speedHack = not settings.speedHack
    SpeedHackButton.Text = "Speed Hack: "..(settings.speedHack and "ON" or "OFF")
    SpeedHackButton.BackgroundColor3 = settings.speedHack and colors.buttonActive or colors.button
    
    if speedConnection then speedConnection:Disconnect() end
    
    if settings.speedHack then
        speedConnection = RunService.Heartbeat:Connect(function()
            if LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = settings.speed
                end
            end
        end)
    elseif LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 16
        end
    end
end

local function SetFollowMode(mode)
    if mode == "Teleport" then
        settings.followMode = "Teleport"
        TeleportMode.BackgroundColor3 = colors.buttonActive
        CameraMode.BackgroundColor3 = colors.button
    else
        settings.followMode = "Camera"
        TeleportMode.BackgroundColor3 = colors.button
        CameraMode.BackgroundColor3 = colors.buttonActive
    end
end

local function StartFollowing()
    if not settings.followTarget then 
        warn("No player selected!")
        return 
    end
    
    settings.following = true
    FollowButton.Text = "Following "..settings.followTarget.Name
    FollowButton.BackgroundColor3 = colors.buttonActive
    
    if followConnection then followConnection:Disconnect() end
    
    if settings.followMode == "Teleport" then
        followConnection = RunService.Heartbeat:Connect(function()
            if not settings.following or not settings.followTarget or not settings.followTarget.Character then
                return
            end
            
            local targetHRP = settings.followTarget.Character:FindFirstChild("HumanoidRootPart")
            if targetHRP and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character:SetPrimaryPartCFrame(targetHRP.CFrame * CFrame.new(0, 0, 2))
            end
        end)
    else
        if cameraConnection then cameraConnection:Disconnect() end
        
        Camera.CameraType = Enum.CameraType.Scriptable
        cameraConnection = RunService.RenderStepped:Connect(function()
            if not settings.following or not settings.followTarget or not settings.followTarget.Character then
                return
            end
            
            local targetHRP = settings.followTarget.Character:FindFirstChild("HumanoidRootPart")
            if targetHRP then
                local angleCFrame = CFrame.Angles(
                    math.rad(settings.cameraAngleY),
                    math.rad(settings.cameraAngleX),
                    0
                )
                
                local offset = angleCFrame * CFrame.new(0, 0, settings.cameraDistance)
                Camera.CFrame = targetHRP.CFrame * offset * CFrame.Angles(0, math.pi, 0)
            end
        end)
    end
end

local function StopFollowing()
    settings.following = false
    FollowButton.Text = "Follow Player"
    FollowButton.BackgroundColor3 = colors.button
    
    if followConnection then followConnection:Disconnect() end
    if cameraConnection then cameraConnection:Disconnect() end
    
    Camera.CameraType = Enum.CameraType.Custom
end

local function TeleportToPlayer()
    if settings.followTarget and settings.followTarget.Character then
        local hrp = settings.followTarget.Character:FindFirstChild("HumanoidRootPart")
        if hrp and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character:SetPrimaryPartCFrame(hrp.CFrame * CFrame.new(0, 0, 2))
        end
    end
end

local function SwitchTab(tabName)
    settings.activeTab = tabName
    MainTab.Visible = false
    MovementTab.Visible = false
    VisualTab.Visible = false
    
    MainTabButton.BackgroundColor3 = colors.tabInactive
    MovementTabButton.BackgroundColor3 = colors.tabInactive
    VisualTabButton.BackgroundColor3 = colors.tabInactive
    
    if tabName == "Main" then
        MainTab.Visible = true
        MainTabButton.BackgroundColor3 = colors.tabActive
    elseif tabName == "Movement" then
        MovementTab.Visible = true
        MovementTabButton.BackgroundColor3 = colors.tabActive
    elseif tabName == "Visual" then
        VisualTab.Visible = true
        VisualTabButton.BackgroundColor3 = colors.tabActive
    end
end

local function ToggleMinimize()
    settings.minimized = not settings.minimized
    
    if settings.minimized then
        MainFrame.Size = UDim2.new(0, 320, 0, 30)
        ContentFrame.Visible = false
        MinimizeButton.Text = "+"
    else
        MainFrame.Size = UDim2.new(0, 320, 0, 350)
        ContentFrame.Visible = true
        MinimizeButton.Text = "_"
    end
end

-- Вращение камеры
local cameraRotating = false
local lastTouchPos = nil

UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch and settings.following and settings.followMode == "Camera" then
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
        settings.cameraAngleX = (settings.cameraAngleX - delta.X * 0.5) % 360
        settings.cameraAngleY = math.clamp(settings.cameraAngleY + delta.Y * 0.2, -80, 80)
        lastTouchPos = input.Position
    end
end)

-- Подключение событий
Players.PlayerAdded:Connect(UpdatePlayerList)
Players.PlayerRemoving:Connect(UpdatePlayerList)
TeleportMode.MouseButton1Click:Connect(function() SetFollowMode("Teleport") end)
CameraMode.MouseButton1Click:Connect(function() SetFollowMode("Camera") end)
FollowButton.MouseButton1Click:Connect(function()
    if settings.following then
        StopFollowing()
    else
        StartFollowing()
    end
end)
TeleportButton.MouseButton1Click:Connect(TeleportToPlayer)
SpeedButton.MouseButton1Click:Connect(SetSpeed)
SpeedHackButton.MouseButton1Click:Connect(ToggleSpeedHack)
NoClipButton.MouseButton1Click:Connect(ToggleNoClip)
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    if speedConnection then speedConnection:Disconnect() end
    if noClipParts then 
        for part, _ in pairs(noClipParts) do
            if part and part.Parent then
                part.CanCollide = true
            end
        end
    end
    if followConnection then followConnection:Disconnect() end
    if cameraConnection then cameraConnection:Disconnect() end
end)
MainTabButton.MouseButton1Click:Connect(function() SwitchTab("Main") end)
MovementTabButton.MouseButton1Click:Connect(function() SwitchTab("Movement") end)
VisualTabButton.MouseButton1Click:Connect(function() SwitchTab("Visual") end)
MinimizeButton.MouseButton1Click:Connect(ToggleMinimize)

-- Инициализация
UpdatePlayerList()
SetFollowMode("Teleport")
SwitchTab("Main")
