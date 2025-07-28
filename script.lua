-- Проверяем загрузку игры
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Сервисы
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")
local TextChatService = game:GetService("TextChatService")
local HttpService = game:GetService("HttpService")

-- Удаляем старое меню если есть
if game.CoreGui:FindFirstChild("UltimateGUI") then
    game.CoreGui.UltimateGUI:Destroy()
end

-- Настройки
local isMinimized = false
local originalSize = UDim2.new(0, 350, 0, 300)
local minimizedSize = UDim2.new(0, 350, 0, 30)
local following = false
local followMode = "Teleport"
local followTarget = nil
local speedHackEnabled = false
local speedValue = 32
local noclipEnabled = false
local noclipConnection = nil
local antiAfkEnabled = false
local afkInterval = 10 -- minutes
local afkConnection = nil
local chatLogEnabled = true
local filteredWords = {"badword1", "badword2"} -- Добавьте свои запрещенные слова

-- Создаем GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltimateGUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = originalSize
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -150)
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
Title.Text = "Ultimate Menu"
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

-- Вкладки
local TabButtons = Instance.new("Frame")
TabButtons.Name = "TabButtons"
TabButtons.Size = UDim2.new(1, 0, 0, 30)
TabButtons.Position = UDim2.new(0, 0, 0, 30)
TabButtons.BackgroundTransparency = 1
TabButtons.Parent = MainFrame

local TPButton = Instance.new("TextButton")
TPButton.Name = "TPButton"
TPButton.Size = UDim2.new(0.25, 0, 1, 0)
TPButton.Position = UDim2.new(0, 0, 0, 0)
TPButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
TPButton.BorderSizePixel = 0
TPButton.Text = "TP"
TPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TPButton.Font = Enum.Font.Gotham
TPButton.TextSize = 14
TPButton.Parent = TabButtons

local PlayerButton = Instance.new("TextButton")
PlayerButton.Name = "PlayerButton"
PlayerButton.Size = UDim2.new(0.25, 0, 1, 0)
PlayerButton.Position = UDim2.new(0.25, 0, 0, 0)
PlayerButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
PlayerButton.BorderSizePixel = 0
PlayerButton.Text = "Player"
PlayerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerButton.Font = Enum.Font.Gotham
PlayerButton.TextSize = 14
PlayerButton.Parent = TabButtons

local ChatButton = Instance.new("TextButton")
ChatButton.Name = "ChatButton"
ChatButton.Size = UDim2.new(0.25, 0, 1, 0)
ChatButton.Position = UDim2.new(0.5, 0, 0, 0)
ChatButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
ChatButton.BorderSizePixel = 0
ChatButton.Text = "Chat"
ChatButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ChatButton.Font = Enum.Font.Gotham
ChatButton.TextSize = 14
ChatButton.Parent = TabButtons

local MiscButton = Instance.new("TextButton")
MiscButton.Name = "MiscButton"
MiscButton.Size = UDim2.new(0.25, 0, 1, 0)
MiscButton.Position = UDim2.new(0.75, 0, 0, 0)
MiscButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
MiscButton.BorderSizePixel = 0
MiscButton.Text = "Misc"
MiscButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MiscButton.Font = Enum.Font.Gotham
MiscButton.TextSize = 14
MiscButton.Parent = TabButtons

-- Основное содержимое
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, 0, 1, -60)
ContentFrame.Position = UDim2.new(0, 0, 0, 60)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Visible = true
ContentFrame.Parent = MainFrame

-- Вкладка TP
local TPTab = Instance.new("Frame")
TPTab.Name = "TPTab"
TPTab.Size = UDim2.new(1, 0, 1, 0)
TPTab.Position = UDim2.new(0, 0, 0, 0)
TPTab.BackgroundTransparency = 1
TPTab.Visible = true
TPTab.Parent = ContentFrame

-- Список игроков
local PlayerList = Instance.new("ScrollingFrame")
PlayerList.Name = "PlayerList"
PlayerList.Size = UDim2.new(0.9, 0, 0, 120)
PlayerList.Position = UDim2.new(0.05, 0, 0, 10)
PlayerList.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
PlayerList.BorderSizePixel = 0
PlayerList.ScrollBarThickness = 5
PlayerList.AutomaticCanvasSize = Enum.AutomaticSize.Y
PlayerList.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerList.Parent = TPTab

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.Parent = PlayerList

-- Режимы слежения
local ModeFrame = Instance.new("Frame")
ModeFrame.Name = "ModeFrame"
ModeFrame.Size = UDim2.new(0.9, 0, 0, 30)
ModeFrame.Position = UDim2.new(0.05, 0, 0, 140)
ModeFrame.BackgroundTransparency = 1
ModeFrame.Parent = TPTab

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

-- Кнопки управления
local FollowButton = Instance.new("TextButton")
FollowButton.Name = "FollowButton"
FollowButton.Size = UDim2.new(0.9, 0, 0, 30)
FollowButton.Position = UDim2.new(0.05, 0, 0, 180)
FollowButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
FollowButton.BorderSizePixel = 0
FollowButton.Text = "Follow Player"
FollowButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FollowButton.Font = Enum.Font.Gotham
FollowButton.TextSize = 14
FollowButton.Parent = TPTab

-- Вкладка Player
local PlayerTab = Instance.new("Frame")
PlayerTab.Name = "PlayerTab"
PlayerTab.Size = UDim2.new(1, 0, 1, 0)
PlayerTab.Position = UDim2.new(0, 0, 0, 0)
PlayerTab.BackgroundTransparency = 1
PlayerTab.Visible = false
PlayerTab.Parent = ContentFrame

-- Спидхак
local SpeedFrame = Instance.new("Frame")
SpeedFrame.Name = "SpeedFrame"
SpeedFrame.Size = UDim2.new(0.9, 0, 0, 60)
SpeedFrame.Position = UDim2.new(0.05, 0, 0, 10)
SpeedFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
SpeedFrame.BorderSizePixel = 0
SpeedFrame.Parent = PlayerTab

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Name = "SpeedLabel"
SpeedLabel.Size = UDim2.new(0.5, 0, 0, 30)
SpeedLabel.Position = UDim2.new(0, 5, 0, 0)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Speed Hack"
SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.TextSize = 14
SpeedLabel.Parent = SpeedFrame

local SpeedToggle = Instance.new("TextButton")
SpeedToggle.Name = "SpeedToggle"
SpeedToggle.Size = UDim2.new(0.4, 0, 0, 25)
SpeedToggle.Position = UDim2.new(0.55, 0, 0, 3)
SpeedToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SpeedToggle.BorderSizePixel = 0
SpeedToggle.Text = "OFF"
SpeedToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedToggle.Font = Enum.Font.Gotham
SpeedToggle.TextSize = 14
SpeedToggle.Parent = SpeedFrame

local SpeedBox = Instance.new("TextBox")
SpeedBox.Name = "SpeedBox"
SpeedBox.Size = UDim2.new(0.9, 0, 0, 25)
SpeedBox.Position = UDim2.new(0.05, 0, 0, 30)
SpeedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SpeedBox.BorderSizePixel = 0
SpeedBox.Text = tostring(speedValue)
SpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedBox.Font = Enum.Font.Gotham
SpeedBox.TextSize = 14
SpeedBox.Parent = SpeedFrame

-- Ноуклип
local NoclipFrame = Instance.new("Frame")
NoclipFrame.Name = "NoclipFrame"
NoclipFrame.Size = UDim2.new(0.9, 0, 0, 30)
NoclipFrame.Position = UDim2.new(0.05, 0, 0, 80)
NoclipFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
NoclipFrame.BorderSizePixel = 0
NoclipFrame.Parent = PlayerTab

local NoclipLabel = Instance.new("TextLabel")
NoclipLabel.Name = "NoclipLabel"
NoclipLabel.Size = UDim2.new(0.5, 0, 1, 0)
NoclipLabel.Position = UDim2.new(0, 5, 0, 0)
NoclipLabel.BackgroundTransparency = 1
NoclipLabel.Text = "Noclip"
NoclipLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
NoclipLabel.TextXAlignment = Enum.TextXAlignment.Left
NoclipLabel.Font = Enum.Font.Gotham
NoclipLabel.TextSize = 14
NoclipLabel.Parent = NoclipFrame

local NoclipToggle = Instance.new("TextButton")
NoclipToggle.Name = "NoclipToggle"
NoclipToggle.Size = UDim2.new(0.4, 0, 0.8, 0)
NoclipToggle.Position = UDim2.new(0.55, 0, 0.1, 0)
NoclipToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
NoclipToggle.BorderSizePixel = 0
NoclipToggle.Text = "OFF"
NoclipToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
NoclipToggle.Font = Enum.Font.Gotham
NoclipToggle.TextSize = 14
NoclipToggle.Parent = NoclipFrame

-- Анти-АФК
local AntiAFKFrame = Instance.new("Frame")
AntiAFKFrame.Name = "AntiAFKFrame"
AntiAFKFrame.Size = UDim2.new(0.9, 0, 0, 60)
AntiAFKFrame.Position = UDim2.new(0.05, 0, 0, 120)
AntiAFKFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
AntiAFKFrame.BorderSizePixel = 0
AntiAFKFrame.Parent = PlayerTab

local AntiAFKLabel = Instance.new("TextLabel")
AntiAFKLabel.Name = "AntiAFKLabel"
AntiAFKLabel.Size = UDim2.new(0.5, 0, 0, 30)
AntiAFKLabel.Position = UDim2.new(0, 5, 0, 0)
AntiAFKLabel.BackgroundTransparency = 1
AntiAFKLabel.Text = "Anti-AFK (min)"
AntiAFKLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
AntiAFKLabel.TextXAlignment = Enum.TextXAlignment.Left
AntiAFKLabel.Font = Enum.Font.Gotham
AntiAFKLabel.TextSize = 14
AntiAFKLabel.Parent = AntiAFKFrame

local AntiAFKToggle = Instance.new("TextButton")
AntiAFKToggle.Name = "AntiAFKToggle"
AntiAFKToggle.Size = UDim2.new(0.4, 0, 0, 25)
AntiAFKToggle.Position = UDim2.new(0.55, 0, 0, 3)
AntiAFKToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
AntiAFKToggle.BorderSizePixel = 0
AntiAFKToggle.Text = "OFF"
AntiAFKToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
AntiAFKToggle.Font = Enum.Font.Gotham
AntiAFKToggle.TextSize = 14
AntiAFKToggle.Parent = AntiAFKFrame

local AntiAFKBox = Instance.new("TextBox")
AntiAFKBox.Name = "AntiAFKBox"
AntiAFKBox.Size = UDim2.new(0.9, 0, 0, 25)
AntiAFKBox.Position = UDim2.new(0.05, 0, 0, 30)
AntiAFKBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
AntiAFKBox.BorderSizePixel = 0
AntiAFKBox.Text = tostring(afkInterval)
AntiAFKBox.TextColor3 = Color3.fromRGB(255, 255, 255)
AntiAFKBox.Font = Enum.Font.Gotham
AntiAFKBox.TextSize = 14
AntiAFKBox.Parent = AntiAFKFrame

-- Вкладка Chat
local ChatTab = Instance.new("Frame")
ChatTab.Name = "ChatTab"
ChatTab.Size = UDim2.new(1, 0, 1, 0)
ChatTab.Position = UDim2.new(0, 0, 0, 0)
ChatTab.BackgroundTransparency = 1
ChatTab.Visible = false
ChatTab.Parent = ContentFrame

local ChatLogFrame = Instance.new("ScrollingFrame")
ChatLogFrame.Name = "ChatLogFrame"
ChatLogFrame.Size = UDim2.new(0.9, 0, 0, 200)
ChatLogFrame.Position = UDim2.new(0.05, 0, 0, 10)
ChatLogFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ChatLogFrame.BorderSizePixel = 0
ChatLogFrame.ScrollBarThickness = 5
ChatLogFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ChatLogFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ChatLogFrame.Parent = ChatTab

local ChatLogLayout = Instance.new("UIListLayout")
ChatLogLayout.Padding = UDim.new(0, 5)
ChatLogLayout.Parent = ChatLogFrame

local ChatLogLabel = Instance.new("TextLabel")
ChatLogLabel.Name = "ChatLogLabel"
ChatLogLabel.Size = UDim2.new(0.9, 0, 0, 20)
ChatLogLabel.Position = UDim2.new(0.05, 0, 0, 220)
ChatLogLabel.BackgroundTransparency = 1
ChatLogLabel.Text = "Chat Log (last 50 messages)"
ChatLogLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
ChatLogLabel.TextXAlignment = Enum.TextXAlignment.Left
ChatLogLabel.Font = Enum.Font.Gotham
ChatLogLabel.TextSize = 12
ChatLogLabel.Parent = ChatTab

-- Вкладка Misc
local MiscTab = Instance.new("Frame")
MiscTab.Name = "MiscTab"
MiscTab.Size = UDim2.new(1, 0, 1, 0)
MiscTab.Position = UDim2.new(0, 0, 0, 0)
MiscTab.BackgroundTransparency = 1
MiscTab.Visible = false
MiscTab.Parent = ContentFrame

-- Координаты
local CoordsFrame = Instance.new("Frame")
CoordsFrame.Name = "CoordsFrame"
CoordsFrame.Size = UDim2.new(0.9, 0, 0, 80)
CoordsFrame.Position = UDim2.new(0.05, 0, 0, 10)
CoordsFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
CoordsFrame.BorderSizePixel = 0
CoordsFrame.Parent = MiscTab

local CoordsLabel = Instance.new("TextLabel")
CoordsLabel.Name = "CoordsLabel"
CoordsLabel.Size = UDim2.new(1, -10, 0, 30)
CoordsLabel.Position = UDim2.new(0, 5, 0, 0)
CoordsLabel.BackgroundTransparency = 1
CoordsLabel.Text = "Player Coordinates"
CoordsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
CoordsLabel.TextXAlignment = Enum.TextXAlignment.Left
CoordsLabel.Font = Enum.Font.Gotham
CoordsLabel.TextSize = 14
CoordsLabel.Parent = CoordsFrame

local CoordsDisplay = Instance.new("TextLabel")
CoordsDisplay.Name = "CoordsDisplay"
CoordsDisplay.Size = UDim2.new(1, -10, 0, 40)
CoordsDisplay.Position = UDim2.new(0, 5, 0, 35)
CoordsDisplay.BackgroundTransparency = 1
CoordsDisplay.Text = "X: 0, Y: 0, Z: 0"
CoordsDisplay.TextColor3 = Color3.fromRGB(200, 200, 255)
CoordsDisplay.TextXAlignment = Enum.TextXAlignment.Left
CoordsDisplay.Font = Enum.Font.Gotham
CoordsDisplay.TextSize = 12
CoordsDisplay.Parent = CoordsFrame

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
        local connection
        connection = RunService.Heartbeat:Connect(function()
            if not following or not followTarget or not followTarget.Character then
                connection:Disconnect()
                return
            end
            
            local targetHRP = followTarget.Character:FindFirstChild("HumanoidRootPart")
            if targetHRP and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local offset = CFrame.new(0, 0, 1.5)
                LocalPlayer.Character:SetPrimaryPartCFrame(targetHRP.CFrame * offset)
            end
        end)
    else
        Camera.CameraType = Enum.CameraType.Scriptable
        local connection
        connection = RunService.RenderStepped:Connect(function()
            if not following or not followTarget or not followTarget.Character then
                connection:Disconnect()
                return
            end
            
            local targetHRP = followTarget.Character:FindFirstChild("HumanoidRootPart")
            if targetHRP then
                Camera.CFrame = targetHRP.CFrame * CFrame.new(0, 2, -5) * CFrame.Angles(0, math.pi, 0)
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
        SpeedToggle.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        SpeedToggle.Text = "ON"
        
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = speedValue
        end
        
        LocalPlayer.CharacterAdded:Connect(function(character)
            task.wait(0.5)
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid and speedHackEnabled then
                humanoid.WalkSpeed = speedValue
            end
        end)
    else
        SpeedToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        SpeedToggle.Text = "OFF"
        
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 16
        end
    end
end

local function ToggleNoclip()
    noclipEnabled = not noclipEnabled
    
    if noclipEnabled then
        NoclipToggle.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        NoclipToggle.Text = "ON"
        
        if noclipConnection then
            noclipConnection:Disconnect()
        end
        
        noclipConnection = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        NoclipToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        NoclipToggle.Text = "OFF"
        
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
    end
end

local function ToggleAntiAFK()
    antiAfkEnabled = not antiAfkEnabled
    
    if antiAfkEnabled then
        AntiAFKToggle.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        AntiAFKToggle.Text = "ON"
        
        if afkConnection then
            afkConnection:Disconnect()
        end
        
        local function AntiAFKAction()
            if LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    task.wait(0.5)
                    humanoid:ChangeState(Enum.HumanoidStateType.Running)
                end
            end
        end
        
        -- Первое срабатывание сразу
        AntiAFKAction()
        
        -- Затем по таймеру
        afkConnection = RunService.Heartbeat:Connect(function()
            if not antiAfkEnabled then return end
            task.wait(afkInterval * 60)
            AntiAFKAction()
        end)
    else
        AntiAFKToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        AntiAFKToggle.Text = "OFF"
        
        if afkConnection then
            afkConnection:Disconnect()
            afkConnection = nil
        end
    end
end

local function AddChatMessage(message)
    if not ChatLogFrame then return end
    
    -- Очистка старых сообщений (максимум 50)
    while #ChatLogFrame:GetChildren() > 50 do
        ChatLogFrame:GetChildren()[2]:Destroy()
    end
    
    local MessageLabel = Instance.new("TextLabel")
    MessageLabel.Name = "Message_"..tick()
    MessageLabel.Size = UDim2.new(1, -10, 0, 20)
    MessageLabel.Position = UDim2.new(0, 5, 0, 0)
    MessageLabel.BackgroundTransparency = 1
    MessageLabel.Text = message
    MessageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    MessageLabel.TextXAlignment = Enum.TextXAlignment.Left
    MessageLabel.Font = Enum.Font.Gotham
    MessageLabel.TextSize = 12
    MessageLabel.TextWrapped = true
    MessageLabel.Parent = ChatLogFrame
    
    -- Автоскролл вниз
    ChatLogFrame.CanvasPosition = Vector2.new(0, ChatLogFrame.AbsoluteCanvasSize.Y)
end

local function FilterMessage(message)
    -- Проверка на запрещенные слова
    local lowerMessage = string.lower(message)
    for _, word in ipairs(filteredWords) do
        if string.find(lowerMessage, string.lower(word)) then
            return true
        end
    end
    return false
end

local function SetupChatLogger()
    -- Логирование новых сообщений
    if TextChatService.OnIncomingMessage then
        TextChatService.OnIncomingMessage:Connect(function(message)
            if not chatLogEnabled then return end
            
            local text = message.Text
            local sender = message.TextSource
            local isFiltered = FilterMessage(text)
            
            if not isFiltered then
                AddChatMessage("["..sender.Name.."]: "..text)
            end
        end)
    else
        warn("Chat logging not supported in this game")
    end
end

local function UpdateCoordinates()
    if not CoordsDisplay then return end
    
    local function Update()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local pos = LocalPlayer.Character.HumanoidRootPart.Position
            CoordsDisplay.Text = string.format("X: %.1f, Y: %.1f, Z: %.1f", pos.X, pos.Y, pos.Z)
        else
            CoordsDisplay.Text = "X: 0, Y: 0, Z: 0"
        end
    end
    
    -- Первое обновление
    Update()
    
    -- Постоянное обновление
    RunService.Heartbeat:Connect(Update)
end

local function SwitchTab(tab)
    TPTab.Visible = (tab == "TP")
    PlayerTab.Visible = (tab == "Player")
    ChatTab.Visible = (tab == "Chat")
    MiscTab.Visible = (tab == "Misc")
    
    TPButton.BackgroundColor3 = (tab == "TP") and Color3.fromRGB(0, 120, 215) or Color3.fromRGB(70, 70, 70)
    PlayerButton.BackgroundColor3 = (tab == "Player") and Color3.fromRGB(0, 120, 215) or Color3.fromRGB(70, 70, 70)
    ChatButton.BackgroundColor3 = (tab == "Chat") and Color3.fromRGB(0, 120, 215) or Color3.fromRGB(70, 70, 70)
    MiscButton.BackgroundColor3 = (tab == "Misc") and Color3.fromRGB(0, 120, 215) or Color3.fromRGB(70, 70, 70)
end

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
    if noclipConnection then
        noclipConnection:Disconnect()
    end
    if afkConnection then
        afkConnection:Disconnect()
    end
end)
TPButton.MouseButton1Click:Connect(function() SwitchTab("TP") end)
PlayerButton.MouseButton1Click:Connect(function() SwitchTab("Player") end)
ChatButton.MouseButton1Click:Connect(function() SwitchTab("Chat") end)
MiscButton.MouseButton1Click:Connect(function() SwitchTab("Misc") end)
SpeedToggle.MouseButton1Click:Connect(ToggleSpeedHack)
NoclipToggle.MouseButton1Click:Connect(ToggleNoclip)
AntiAFKToggle.MouseButton1Click:Connect(ToggleAntiAFK)

SpeedBox.FocusLost:Connect(function()
    local newSpeed = tonumber(SpeedBox.Text)
    if newSpeed and newSpeed > 0 then
        speedValue = newSpeed
        if speedHackEnabled then
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = speedValue
            end
        end
    else
        SpeedBox.Text = tostring(speedValue)
    end
end)

AntiAFKBox.FocusLost:Connect(function()
    local newInterval = tonumber(AntiAFKBox.Text)
    if newInterval and newInterval > 0 then
        afkInterval = newInterval
    else
        AntiAFKBox.Text = tostring(afkInterval)
    end
end)

-- Инициализация
UpdatePlayerList()
SetFollowMode("Teleport")
SwitchTab("TP")
SetupChatLogger()
UpdateCoordinates()

-- Добавляем тестовое сообщение в чат
AddChatMessage("Chat logger initialized!")
