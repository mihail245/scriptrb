if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")

-- Удаляем старое меню если есть
if game.CoreGui:FindFirstChild("EnhancedFollowGUI") then
    game.CoreGui.EnhancedFollowGUI:Destroy()
end

-- Настройки
local isMinimized = false
local originalSize = UDim2.new(0, 300, 0, 250) -- Увеличили высоту для новых функций
local minimizedSize = UDim2.new(0, 300, 0, 30)
local following = false
local followMode = "Teleport"
local followTarget = nil
local speedHackEnabled = false
local noClipEnabled = false
local currentSpeed = 16
local cameraAngle = 0
local cameraDistance = 5

-- Создаем GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EnhancedFollowGUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = originalSize
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Color3.fromRGB(80, 80, 80)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Enhanced Follower"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.Parent = TitleBar

-- Кнопки управления окном
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 30, 1, 0)
MinimizeButton.Position = UDim2.new(1, -60, 0, 0)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Text = "_"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 14
MinimizeButton.Parent = TitleBar

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 1, 0)
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 14
CloseButton.Parent = TitleBar

-- Основное содержимое
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, 0, 1, -30)
ContentFrame.Position = UDim2.new(0, 0, 0, 30)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Visible = true
ContentFrame.Parent = MainFrame

-- Список игроков
local PlayerList = Instance.new("ScrollingFrame")
PlayerList.Name = "PlayerList"
PlayerList.Size = UDim2.new(0.9, 0, 0, 100) -- Уменьшили высоту для новых функций
PlayerList.Position = UDim2.new(0.05, 0, 0, 10)
PlayerList.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
PlayerList.BorderSizePixel = 0
PlayerList.ScrollBarThickness = 5
PlayerList.AutomaticCanvasSize = Enum.AutomaticSize.Y
PlayerList.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerList.Parent = ContentFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.Parent = PlayerList

-- Режимы слежения
local ModeFrame = Instance.new("Frame")
ModeFrame.Name = "ModeFrame"
ModeFrame.Size = UDim2.new(0.9, 0, 0, 30)
ModeFrame.Position = UDim2.new(0.05, 0, 0, 120)
ModeFrame.BackgroundTransparency = 1
ModeFrame.Parent = ContentFrame

local TeleportMode = Instance.new("TextButton")
TeleportMode.Name = "TeleportMode"
TeleportMode.Size = UDim2.new(0.45, 0, 1, 0)
TeleportMode.Position = UDim2.new(0, 0, 0, 0)
TeleportMode.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
TeleportMode.BorderSizePixel = 0
TeleportMode.Text = "Teleport"
TeleportMode.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportMode.Font = Enum.Font.Gotham
TeleportMode.TextSize = 14
TeleportMode.Parent = ModeFrame

local CameraMode = Instance.new("TextButton")
CameraMode.Name = "CameraMode"
CameraMode.Size = UDim2.new(0.45, 0, 1, 0)
CameraMode.Position = UDim2.new(0.55, 0, 0, 0)
CameraMode.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
CameraMode.BorderSizePixel = 0
CameraMode.Text = "Camera"
CameraMode.TextColor3 = Color3.fromRGB(255, 255, 255)
CameraMode.Font = Enum.Font.Gotham
CameraMode.TextSize = 14
CameraMode.Parent = ModeFrame

-- Новые функции: Speed Hack и NoClip
local FunctionFrame = Instance.new("Frame")
FunctionFrame.Name = "FunctionFrame"
FunctionFrame.Size = UDim2.new(0.9, 0, 0, 30)
FunctionFrame.Position = UDim2.new(0.05, 0, 0, 160)
FunctionFrame.BackgroundTransparency = 1
FunctionFrame.Parent = ContentFrame

local SpeedHackButton = Instance.new("TextButton")
SpeedHackButton.Name = "SpeedHackButton"
SpeedHackButton.Size = UDim2.new(0.45, 0, 1, 0)
SpeedHackButton.Position = UDim2.new(0, 0, 0, 0)
SpeedHackButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
SpeedHackButton.BorderSizePixel = 0
SpeedHackButton.Text = "Speed: "..currentSpeed
SpeedHackButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedHackButton.Font = Enum.Font.Gotham
SpeedHackButton.TextSize = 14
SpeedHackButton.Parent = FunctionFrame

local NoClipButton = Instance.new("TextButton")
NoClipButton.Name = "NoClipButton"
NoClipButton.Size = UDim2.new(0.45, 0, 1, 0)
NoClipButton.Position = UDim2.new(0.55, 0, 0, 0)
NoClipButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
NoClipButton.BorderSizePixel = 0
NoClipButton.Text = "NoClip: OFF"
NoClipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
NoClipButton.Font = Enum.Font.Gotham
NoClipButton.TextSize = 14
NoClipButton.Parent = FunctionFrame

-- Кнопки управления
local FollowButton = Instance.new("TextButton")
FollowButton.Name = "FollowButton"
FollowButton.Size = UDim2.new(0.9, 0, 0, 30)
FollowButton.Position = UDim2.new(0.05, 0, 0, 200)
FollowButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
FollowButton.BorderSizePixel = 0
FollowButton.Text = "Follow Player"
FollowButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FollowButton.Font = Enum.Font.Gotham
FollowButton.TextSize = 14
FollowButton.Parent = ContentFrame

local TeleportOnceButton = Instance.new("TextButton")
TeleportOnceButton.Name = "TeleportOnceButton"
TeleportOnceButton.Size = UDim2.new(0.9, 0, 0, 30)
TeleportOnceButton.Position = UDim2.new(0.05, 0, 0, 235)
TeleportOnceButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
TeleportOnceButton.BorderSizePixel = 0
TeleportOnceButton.Text = "Teleport Once"
TeleportOnceButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportOnceButton.Font = Enum.Font.Gotham
TeleportOnceButton.TextSize = 14
TeleportOnceButton.Parent = ContentFrame

-- Функции
local function UpdatePlayerList()
    for _, child in ipairs(PlayerList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local PlayerButton = Instance.new("TextButton")
            PlayerButton.Name = player.Name
            PlayerButton.Size = UDim2.new(1, -10, 0, 25)
            PlayerButton.Position = UDim2.new(0, 5, 0, 0)
            PlayerButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            PlayerButton.BorderSizePixel = 0
            PlayerButton.Text = player.Name
            PlayerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            PlayerButton.Font = Enum.Font.Gotham
            PlayerButton.TextSize = 12
            PlayerButton.TextXAlignment = Enum.TextXAlignment.Left
            PlayerButton.Parent = PlayerList
            
            PlayerButton.MouseButton1Click:Connect(function()
                for _, btn in ipairs(PlayerList:GetChildren()) do
                    if btn:IsA("TextButton") then
                        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                    end
                end
                PlayerButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
                followTarget = player
            end)
        end
    end
end

local function SetFollowMode(mode)
    followMode = mode
    if mode == "Teleport" then
        TeleportMode.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
        CameraMode.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    else
        TeleportMode.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        CameraMode.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    end
end

local function StartFollowing()
    if not followTarget then 
        warn("No player selected!")
        return 
    end
    
    following = true
    FollowButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    FollowButton.Text = "Following "..followTarget.Name
    
    if followMode == "Teleport" then
        -- Режим плотного слежения телепортом
        local connection
        connection = RunService.Heartbeat:Connect(function()
            if not following or not followTarget or not followTarget.Character then
                connection:Disconnect()
                return
            end
            
            local targetHRP = followTarget.Character:FindFirstChild("HumanoidRootPart")
            if targetHRP and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                -- Телепортируемся прямо за спину игрока
                local offset = CFrame.new(0, 0, 1.5)
                LocalPlayer.Character:SetPrimaryPartCFrame(targetHRP.CFrame * offset)
            end
        end)
    else
        -- Режим камеры с возможностью вращения
        Camera.CameraType = Enum.CameraType.Scriptable
        local connection
        connection = RunService.RenderStepped:Connect(function()
            if not following or not followTarget or not followTarget.Character then
                connection:Disconnect()
                return
            end
            
            local targetHRP = followTarget.Character:FindFirstChild("HumanoidRootPart")
            if targetHRP then
                local cameraCFrame = targetHRP.CFrame * CFrame.new(0, 2, -cameraDistance)
                cameraCFrame = cameraCFrame * CFrame.Angles(0, cameraAngle, 0)
                Camera.CFrame = cameraCFrame
            end
        end)
    end
end

local function StopFollowing()
    following = false
    FollowButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    FollowButton.Text = "Follow Player"
    Camera.CameraType = Enum.CameraType.Custom
end

local function ToggleMinimize()
    isMinimized = not isMinimized
    
    if isMinimized then
        MainFrame.Size = minimizedSize
        ContentFrame.Visible = false
        MinimizeButton.Text = "+"
    else
        MainFrame.Size = originalSize
        ContentFrame.Visible = true
        MinimizeButton.Text = "_"
    end
end

local function ToggleSpeedHack()
    speedHackEnabled = not speedHackEnabled
    if speedHackEnabled then
        SpeedHackButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    else
        SpeedHackButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16 -- Возвращаем стандартную скорость
            end
        end
    end
end

local function ToggleNoClip()
    noClipEnabled = not noClipEnabled
    if noClipEnabled then
        NoClipButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
        NoClipButton.Text = "NoClip: ON"
    else
        NoClipButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        NoClipButton.Text = "NoClip: OFF"
    end
end

local function TeleportToPlayer()
    if followTarget and followTarget.Character then
        local hrp = followTarget.Character:FindFirstChild("HumanoidRootPart")
        if hrp and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character:SetPrimaryPartCFrame(hrp.CFrame * CFrame.new(0, 0, 2))
        end
    end
end

-- Обработка Speed Hack и NoClip
RunService.Heartbeat:Connect(function()
    -- Speed Hack
    if speedHackEnabled and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = currentSpeed
        end
    end
    
    -- NoClip
    if noClipEnabled and LocalPlayer.Character then
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
    if input.UserInputType == Enum.UserInputType.Touch and following and followMode == "Camera" then
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
        cameraAngle = cameraAngle + delta.X * 0.01
        cameraDistance = math.clamp(cameraDistance - delta.Y * 0.1, 2, 15)
        lastTouchPos = input.Position
    end
end)

-- Настройка скорости через ползунок
local speedSliderDragging = false
SpeedHackButton.MouseButton1Down:Connect(function(x, y)
    speedSliderDragging = true
    local percent = math.clamp((x - SpeedHackButton.AbsolutePosition.X) / SpeedHackButton.AbsoluteSize.X, 0, 1)
    currentSpeed = math.floor(16 + (300 - 16) * percent)
    SpeedHackButton.Text = "Speed: "..currentSpeed
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        speedSliderDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if speedSliderDragging and input.UserInputType == Enum.UserInputType.Touch then
        local percent = math.clamp((input.Position.X - SpeedHackButton.AbsolutePosition.X) / SpeedHackButton.AbsoluteSize.X, 0, 1)
        currentSpeed = math.floor(16 + (300 - 16) * percent)
        SpeedHackButton.Text = "Speed: "..currentSpeed
    end
end)

-- Подключение событий
Players.PlayerAdded:Connect(UpdatePlayerList)
Players.PlayerRemoving:Connect(UpdatePlayerList)
TeleportMode.MouseButton1Click:Connect(function() SetFollowMode("Teleport") end)
CameraMode.MouseButton1Click:Connect(function() SetFollowMode("Camera") end)
FollowButton.MouseButton1Click:Connect(function()
    if following then
        StopFollowing()
    else
        StartFollowing()
    end
end)
MinimizeButton.MouseButton1Click:Connect(ToggleMinimize)
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    StopFollowing()
end)
SpeedHackButton.MouseButton1Click:Connect(ToggleSpeedHack)
NoClipButton.MouseButton1Click:Connect(ToggleNoClip)
TeleportOnceButton.MouseButton1Click:Connect(TeleportToPlayer)

-- Инициализация
UpdatePlayerList()
SetFollowMode("Teleport")
