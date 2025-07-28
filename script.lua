if not game:IsLoaded() then game.Loaded:Wait() end

-- Сервисы
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Удаляем старое меню если есть
if game.CoreGui:FindFirstChild("UltimateMobileHack") then
    game.CoreGui.UltimateMobileHack:Destroy()
end

-- Настройки
local settings = {
    speed = 16,
    speedHack = false,
    noClip = false,
    flying = false,
    flySpeed = 1,
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
local flyConnection = nil
local bodyGyro = nil
local bodyVelocity = nil

-- Создаем GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltimateMobileHack"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Основное окно
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 350)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Заголовок
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.6, 0, 1, 0)
Title.Position = UDim2.new(0.2, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ULTIMATE MOBILE HACK"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Кнопки управления окном
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0.2, 0, 1, 0)
MinimizeButton.Position = UDim2.new(0, 0, 0, 0)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Text = "_"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 14
MinimizeButton.Parent = TitleBar

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0.2, 0, 1, 0)
CloseButton.Position = UDim2.new(0.8, 0, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
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
MainTabButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
MainTabButton.BorderSizePixel = 0
MainTabButton.Text = "Main"
MainTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MainTabButton.Font = Enum.Font.Gotham
MainTabButton.TextSize = 14
MainTabButton.Parent = TabsFrame

local MovementTabButton = Instance.new("TextButton")
MovementTabButton.Size = UDim2.new(0.33, -2, 1, 0)
MovementTabButton.Position = UDim2.new(0.33, 0, 0, 0)
MovementTabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
MovementTabButton.BorderSizePixel = 0
MovementTabButton.Text = "Movement"
MovementTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MovementTabButton.Font = Enum.Font.Gotham
MovementTabButton.TextSize = 14
MovementTabButton.Parent = TabsFrame

local VisualTabButton = Instance.new("TextButton")
VisualTabButton.Size = UDim2.new(0.33, -2, 1, 0)
VisualTabButton.Position = UDim2.new(0.66, 0, 0, 0)
VisualTabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
VisualTabButton.BorderSizePixel = 0
VisualTabButton.Text = "Visual"
VisualTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
VisualTabButton.Font = Enum.Font.Gotham
VisualTabButton.TextSize = 14
VisualTabButton.Parent = TabsFrame

-- Контент вкладок
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 1, -60)
ContentFrame.Position = UDim2.new(0, 0, 0, 60)
ContentFrame.BackgroundTransparency = 1
ContentFrame.ClipsDescendants = true
ContentFrame.Parent = MainFrame

-- Вкладка Main
local MainTab = Instance.new("ScrollingFrame")
MainTab.Name = "MainTab"
MainTab.Size = UDim2.new(1, 0, 1, 0)
MainTab.BackgroundTransparency = 1
MainTab.ScrollBarThickness = 5
MainTab.CanvasSize = UDim2.new(0, 0, 0, 300)
MainTab.Visible = true
MainTab.Parent = ContentFrame

-- Вкладка Movement
local MovementTab = Instance.new("ScrollingFrame")
MovementTab.Name = "MovementTab"
MovementTab.Size = UDim2.new(1, 0, 1, 0)
MovementTab.BackgroundTransparency = 1
MovementTab.ScrollBarThickness = 5
MovementTab.CanvasSize = UDim2.new(0, 0, 0, 250)
MovementTab.Visible = false
MovementTab.Parent = ContentFrame

-- Вкладка Visual
local VisualTab = Instance.new("ScrollingFrame")
VisualTab.Name = "VisualTab"
VisualTab.Size = UDim2.new(1, 0, 1, 0)
VisualTab.BackgroundTransparency = 1
VisualTab.ScrollBarThickness = 5
VisualTab.CanvasSize = UDim2.new(0, 0, 0, 150)
VisualTab.Visible = false
VisualTab.Parent = ContentFrame

-- Функции для создания элементов UI
local function createButton(parent, text, sizeY)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.9, 0, 0, sizeY or 35)
    button.Position = UDim2.new(0.05, 0, 0, 0)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
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

local function createSlider(parent, text, min, max, value, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(0.9, 0, 0, 50)
    sliderFrame.Position = UDim2.new(0.05, 0, 0, 0)
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

-- Элементы вкладки Main
local PlayerList = Instance.new("ScrollingFrame")
PlayerList.Size = UDim2.new(0.9, 0, 0, 120)
PlayerList.Position = UDim2.new(0.05, 0, 0, 10)
PlayerList.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
PlayerList.BorderSizePixel = 0
PlayerList.ScrollBarThickness = 5
PlayerList.AutomaticCanvasSize = Enum.AutomaticSize.Y
PlayerList.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerList.Parent = MainTab

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
TeleportMode.BackgroundColor3 = Color3.fromRGB(0, 120, 215)

local CameraMode = createButton(ModeFrame, "Camera", 35)
CameraMode.Size = UDim2.new(0.45, 0, 1, 0)
CameraMode.Position = UDim2.new(0.55, 0, 0, 0)

-- Элементы вкладки Movement
local SpeedHackButton = createButton(MovementTab, "Speed Hack: OFF", 35)
SpeedHackButton.Position = UDim2.new(0.05, 0, 0, 10)

local speedSlider = createSlider(MovementTab, "Speed", 16, 300, settings.speed, function(value)
    settings.speed = value
    if settings.speedHack and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = value
        end
    end
end)
speedSlider.Position = UDim2.new(0.05, 0, 0, 55)

local NoClipButton = createButton(MovementTab, "NoClip: OFF", 35)
NoClipButton.Position = UDim2.new(0.05, 0, 0, 115)

local FlyButton = createButton(MovementTab, "Fly: OFF", 35)
FlyButton.Position = UDim2.new(0.05, 0, 0, 160)

local flySpeedSlider = createSlider(MovementTab, "Fly Speed", 1, 50, settings.flySpeed, function(value)
    settings.flySpeed = value
end)
flySpeedSlider.Position = UDim2.new(0.05, 0, 0, 205)

-- Элементы вкладки Visual
local TransparencySlider = createSlider(VisualTab, "NoClip Transparency", 0.1, 0.9, 0.5, function(value)
    settings.noClipTransparency = value
    for part, _ in pairs(noClipParts) do
        if part and part.Parent then
            part.LocalTransparencyModifier = value
        end
    end
end)
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
                        btn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
                    end
                end
                PlayerButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
                settings.followTarget = player
            end)
        end
    end
end

local function SetFollowMode(mode)
    if mode == "Teleport" then
        settings.followMode = "Teleport"
        TeleportMode.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
        CameraMode.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    else
        settings.followMode = "Camera"
        TeleportMode.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        CameraMode.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    end
end

local function StartFollowing()
    if not settings.followTarget then 
        warn("No player selected!")
        return 
    end
    
    settings.following = true
    FollowButton.Text = "Following "..settings.followTarget.Name
    FollowButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    
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
    FollowButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    
    if followConnection then followConnection:Disconnect() end
    if cameraConnection then cameraConnection:Disconnect() end
    
    Camera.CameraType = Enum.CameraType.Custom
end

local function ToggleSpeedHack()
    settings.speedHack = not settings.speedHack
    SpeedHackButton.Text = "Speed Hack: "..(settings.speedHack and "ON" or "OFF")
    SpeedHackButton.BackgroundColor3 = settings.speedHack and Color3.fromRGB(0, 150, 100) or Color3.fromRGB(60, 60, 70)
    
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

local function ToggleNoClip()
    settings.noClip = not settings.noClip
    NoClipButton.Text = "NoClip: "..(settings.noClip and "ON" or "OFF")
    NoClipButton.BackgroundColor3 = settings.noClip and Color3.fromRGB(0, 150, 100) or Color3.fromRGB(60, 60, 70)
    
    if settings.noClip then
        if LocalPlayer.Character then
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end

local function ToggleFly()
    settings.flying = not settings.flying
    FlyButton.Text = "Fly: "..(settings.flying and "ON" or "OFF")
    FlyButton.BackgroundColor3 = settings.flying and Color3.fromRGB(0, 150, 100) or Color3.fromRGB(60, 60, 70)
    
    if flyConnection then flyConnection:Disconnect() end
    if bodyGyro then bodyGyro:Destroy() end
    if bodyVelocity then bodyVelocity:Destroy() end
    
    if settings.flying then
        if not LocalPlayer.Character then return end
        
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        
        humanoid.PlatformStand = true
        
        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.P = 9e4
        bodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bodyGyro.cframe = LocalPlayer.Character.HumanoidRootPart.CFrame
        bodyGyro.Parent = LocalPlayer.Character.HumanoidRootPart
        
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.velocity = Vector3.new(0, 0.1, 0)
        bodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
        bodyVelocity.Parent = LocalPlayer.Character.HumanoidRootPart
        
        flyConnection = RunService.Heartbeat:Connect(function()
            if not settings.flying or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                return
            end
            
            local root = LocalPlayer.Character.HumanoidRootPart
            local cam = workspace.CurrentCamera
            
            local moveDirection = Vector3.new(0, 0, 0)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDirection = moveDirection + (cam.CFrame.LookVector * settings.flySpeed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDirection = moveDirection - (cam.CFrame.LookVector * settings.flySpeed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDirection = moveDirection - (cam.CFrame.RightVector * settings.flySpeed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDirection = moveDirection + (cam.CFrame.RightVector * settings.flySpeed)
            end
            
            bodyVelocity.velocity = moveDirection
            bodyGyro.cframe = cam.CFrame
        end)
    else
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.PlatformStand = false
            end
        end
    end
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
    
    MainTabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    MovementTabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    VisualTabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    
    if tabName == "Main" then
        MainTab.Visible = true
        MainTabButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    elseif tabName == "Movement" then
        MovementTab.Visible = true
        MovementTabButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    elseif tabName == "Visual" then
        VisualTab.Visible = true
        VisualTabButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
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
SpeedHackButton.MouseButton1Click:Connect(ToggleSpeedHack)
NoClipButton.MouseButton1Click:Connect(ToggleNoClip)
FlyButton.MouseButton1Click:Connect(ToggleFly)
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    if speedConnection then speedConnection:Disconnect() end
    if noClipConnection then noClipConnection:Disconnect() end
    if flyConnection then flyConnection:Disconnect() end
    if followConnection then followConnection:Disconnect() end
    if cameraConnection then cameraConnection:Disconnect() end
    if bodyGyro then bodyGyro:Destroy() end
    if bodyVelocity then bodyVelocity:Destroy() end
end)
MainTabButton.MouseButton1Click:Connect(function() SwitchTab("Main") end)
MovementTabButton.MouseButton1Click:Connect(function() SwitchTab("Movement") end)
VisualTabButton.MouseButton1Click:Connect(function() SwitchTab("Visual") end)
MinimizeButton.MouseButton1Click:Connect(ToggleMinimize)

-- Инициализация
UpdatePlayerList()
SetFollowMode("Teleport")
SwitchTab("Main")
