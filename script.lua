if not game:IsLoaded() then game.Loaded:Wait() end
-- 5
-- Сервисы
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Удаляем старое меню если есть
if game.CoreGui:FindFirstChild("MobileHackMenu") then
    game.CoreGui.MobileHackMenu:Destroy()
end

-- Настройки
local settings = {
    speed = 16,
    speedHack = false,
    noClip = false,
    following = false,
    followTarget = nil,
    cameraDistance = 5,
    cameraAngleX = 0,
    cameraAngleY = 20,
    minimized = false
}

-- Переменные
local noClipConnections = {}
local cameraConnection = nil
local followConnection = nil
local speedConnection = nil

-- Создаем GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MobileHackMenu"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Основное окно
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 250)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Заголовок с кнопками
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.6, 0, 1, 0)
Title.Position = UDim2.new(0.2, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "MOBILE HACKS"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.Parent = TitleBar

-- Кнопка свернуть
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

-- Кнопка закрыть
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

-- Контент
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 1, -30)
ContentFrame.Position = UDim2.new(0, 0, 0, 30)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Список игроков
local PlayerList = Instance.new("ScrollingFrame")
PlayerList.Size = UDim2.new(0.9, 0, 0, 100)
PlayerList.Position = UDim2.new(0.05, 0, 0, 10)
PlayerList.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
PlayerList.BorderSizePixel = 0
PlayerList.ScrollBarThickness = 5
PlayerList.AutomaticCanvasSize = Enum.AutomaticSize.Y
PlayerList.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerList.Parent = ContentFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.Parent = PlayerList

-- Поле ввода скорости
local SpeedFrame = Instance.new("Frame")
SpeedFrame.Size = UDim2.new(0.9, 0, 0, 30)
SpeedFrame.Position = UDim2.new(0.05, 0, 0, 120)
SpeedFrame.BackgroundTransparency = 1
SpeedFrame.Parent = ContentFrame

local SpeedBox = Instance.new("TextBox")
SpeedBox.Size = UDim2.new(0.6, 0, 1, 0)
SpeedBox.Position = UDim2.new(0, 0, 0, 0)
SpeedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
SpeedBox.BorderSizePixel = 0
SpeedBox.Text = tostring(settings.speed)
SpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedBox.Font = Enum.Font.Gotham
SpeedBox.TextSize = 14
SpeedBox.PlaceholderText = "Speed"
SpeedBox.Parent = SpeedFrame

local SpeedButton = Instance.new("TextButton")
SpeedButton.Size = UDim2.new(0.35, 0, 1, 0)
SpeedButton.Position = UDim2.new(0.65, 0, 0, 0)
SpeedButton.BackgroundColor3 = Color3.fromRGB(70, 70, 80)
SpeedButton.BorderSizePixel = 0
SpeedButton.Text = "Set Speed"
SpeedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedButton.Font = Enum.Font.Gotham
SpeedButton.TextSize = 14
SpeedButton.Parent = SpeedFrame

-- Кнопки функций
local NoClipButton = Instance.new("TextButton")
NoClipButton.Size = UDim2.new(0.9, 0, 0, 30)
NoClipButton.Position = UDim2.new(0.05, 0, 0, 160)
NoClipButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
NoClipButton.BorderSizePixel = 0
NoClipButton.Text = "NoClip: OFF"
NoClipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
NoClipButton.Font = Enum.Font.Gotham
NoClipButton.TextSize = 14
NoClipButton.Parent = ContentFrame

local FollowButton = Instance.new("TextButton")
FollowButton.Size = UDim2.new(0.9, 0, 0, 30)
FollowButton.Position = UDim2.new(0.05, 0, 0, 200)
FollowButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
FollowButton.BorderSizePixel = 0
FollowButton.Text = "Follow Player"
FollowButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FollowButton.Font = Enum.Font.Gotham
FollowButton.TextSize = 14
FollowButton.Parent = ContentFrame

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
            PlayerButton.Size = UDim2.new(1, -10, 0, 25)
            PlayerButton.Position = UDim2.new(0, 5, 0, 0)
            PlayerButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
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
                        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
                    end
                end
                PlayerButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
                settings.followTarget = player
            end)
        end
    end
end

local function ToggleNoClip()
    settings.noClip = not settings.noClip
    NoClipButton.Text = "NoClip: " .. (settings.noClip and "ON" or "OFF")
    NoClipButton.BackgroundColor3 = settings.noClip and Color3.fromRGB(0, 150, 100) or Color3.fromRGB(60, 60, 70)
    
    -- Очищаем предыдущие соединения
    for _, conn in pairs(noClipConnections) do
        conn:Disconnect()
    end
    noClipConnections = {}
    
    if settings.noClip then
        local function enableNoClip()
            if not LocalPlayer.Character then return end
            
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if not humanoid then return end
            
            -- Отключаем коллизии для всех частей персонажа
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
            
            -- Постоянно проверяем новые части
            table.insert(noClipConnections, LocalPlayer.Character.DescendantAdded:Connect(function(part)
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end))
        end
        
        -- Подключаемся к событиям
        table.insert(noClipConnections, LocalPlayer.CharacterAdded:Connect(enableNoClip))
        if LocalPlayer.Character then
            enableNoClip()
        end
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
        SpeedBox.Text = tostring(settings.speed)
    end
end

local function ToggleFollow()
    if settings.following then
        -- Останавливаем слежение
        settings.following = false
        FollowButton.Text = "Follow Player"
        FollowButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        
        if followConnection then
            followConnection:Disconnect()
            followConnection = nil
        end
        
        if cameraConnection then
            cameraConnection:Disconnect()
            cameraConnection = nil
            Camera.CameraType = Enum.CameraType.Custom
        end
    else
        -- Начинаем слежение
        if not settings.followTarget then
            warn("No player selected!")
            return
        end
        
        settings.following = true
        FollowButton.Text = "Following "..settings.followTarget.Name
        FollowButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        
        -- Режим камеры от третьего лица
        Camera.CameraType = Enum.CameraType.Scriptable
        
        cameraConnection = RunService.RenderStepped:Connect(function()
            if not settings.following or not settings.followTarget or not settings.followTarget.Character then
                return
            end
            
            local targetHRP = settings.followTarget.Character:FindFirstChild("HumanoidRootPart")
            if targetHRP then
                -- Вычисляем позицию камеры
                local angleCFrame = CFrame.Angles(
                    math.rad(settings.cameraAngleY),
                    math.rad(settings.cameraAngleX),
                    0
                )
                
                local offset = angleCFrame * CFrame.new(0, 0, settings.cameraDistance)
                Camera.CFrame = targetHRP.CFrame * offset
            end
        end)
    end
end

local function ToggleMinimize()
    settings.minimized = not settings.minimized
    
    if settings.minimized then
        MainFrame.Size = UDim2.new(0, 300, 0, 30)
        ContentFrame.Visible = false
        MinimizeButton.Text = "+"
    else
        MainFrame.Size = UDim2.new(0, 300, 0, 250)
        ContentFrame.Visible = true
        MinimizeButton.Text = "_"
    end
end

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
        settings.cameraAngleX = (settings.cameraAngleX - delta.X * 0.5) % 360
        settings.cameraAngleY = math.clamp(settings.cameraAngleY + delta.Y * 0.2, -80, 80)
        lastTouchPos = input.Position
    end
end)

-- Подключение событий
Players.PlayerAdded:Connect(UpdatePlayerList)
Players.PlayerRemoving:Connect(UpdatePlayerList)
NoClipButton.MouseButton1Click:Connect(ToggleNoClip)
SpeedButton.MouseButton1Click:Connect(SetSpeed)
FollowButton.MouseButton1Click:Connect(ToggleFollow)
MinimizeButton.MouseButton1Click:Connect(ToggleMinimize)
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    -- Отключаем все соединения
    for _, conn in pairs(noClipConnections) do
        conn:Disconnect()
    end
    if followConnection then followConnection:Disconnect() end
    if cameraConnection then cameraConnection:Disconnect() end
    if speedConnection then speedConnection:Disconnect() end
end)

-- Инициализация
UpdatePlayerList()
