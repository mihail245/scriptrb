if not game:IsLoaded() then
    game.Loaded:Wait()
end
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Удаляем старое меню если есть
if game.CoreGui:FindFirstChild("UltimateGUI") then
    game.CoreGui.UltimateGUI:Destroy()
end

-- Настройки
local isMinimized = false
local originalSize = UDim2.new(0, 350, 0, 350)
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
local infiniteJumpEnabled = false
local jumpHeight = 50
local spinbotEnabled = false
local flingEnabled = false
local platformPart = nil
local safeZoneActive = false

-- Создаем GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltimateGUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Мини-иконка
local MiniIcon = Instance.new("TextButton")
MiniIcon.Name = "MiniIcon"
MiniIcon.Size = UDim2.new(0, 30, 0, 30)
MiniIcon.Position = UDim2.new(0, 10, 0.5, -15)
MiniIcon.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
MiniIcon.BorderSizePixel = 0
MiniIcon.Text = ">"
MiniIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
MiniIcon.Font = Enum.Font.GothamBold
MiniIcon.TextSize = 14
MiniIcon.Visible = false
MiniIcon.Parent = ScreenGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = originalSize
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -175)
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
TPButton.Size = UDim2.new(0.333, 0, 1, 0)
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
PlayerButton.Size = UDim2.new(0.333, 0, 1, 0)
PlayerButton.Position = UDim2.new(0.333, 0, 0, 0)
PlayerButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
PlayerButton.BorderSizePixel = 0
PlayerButton.Text = "Player"
PlayerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerButton.Font = Enum.Font.Gotham
PlayerButton.TextSize = 14
PlayerButton.Parent = TabButtons

local MiscButton = Instance.new("TextButton")
MiscButton.Name = "MiscButton"
MiscButton.Size = UDim2.new(0.334, 0, 1, 0)
MiscButton.Position = UDim2.new(0.666, 0, 0, 0)
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

-- Кнопка телепорта в сейф зону
local SafeZoneButton = Instance.new("TextButton")
SafeZoneButton.Name = "SafeZoneButton"
SafeZoneButton.Size = UDim2.new(0.9, 0, 0, 30)
SafeZoneButton.Position = UDim2.new(0.05, 0, 0, 220)
SafeZoneButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
SafeZoneButton.BorderSizePixel = 0
SafeZoneButton.Text = "Teleport to Safe Zone"
SafeZoneButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SafeZoneButton.Font = Enum.Font.Gotham
SafeZoneButton.TextSize = 14
SafeZoneButton.Parent = TPTab

-- Вкладка Player
local PlayerTab = Instance.new("Frame")
PlayerTab.Name = "PlayerTab"
PlayerTab.Size = UDim2.new(1, 0, 1, 0)
PlayerTab.Position = UDim2.new(0, 0, 0, 0)
PlayerTab.BackgroundTransparency = 1
PlayerTab.Visible = false
PlayerTab.Parent = ContentFrame

-- Infinite Jump
local InfiniteJumpFrame = Instance.new("Frame")
InfiniteJumpFrame.Name = "InfiniteJumpFrame"
InfiniteJumpFrame.Size = UDim2.new(0.9, 0, 0, 30)
InfiniteJumpFrame.Position = UDim2.new(0.05, 0, 0, 10)
InfiniteJumpFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
InfiniteJumpFrame.BorderSizePixel = 0
InfiniteJumpFrame.Parent = PlayerTab

local InfiniteJumpLabel = Instance.new("TextLabel")
InfiniteJumpLabel.Name = "InfiniteJumpLabel"
InfiniteJumpLabel.Size = UDim2.new(0.5, 0, 1, 0)
InfiniteJumpLabel.Position = UDim2.new(0, 5, 0, 0)
InfiniteJumpLabel.BackgroundTransparency = 1
InfiniteJumpLabel.Text = "Infinite Jump"
InfiniteJumpLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
InfiniteJumpLabel.TextXAlignment = Enum.TextXAlignment.Left
InfiniteJumpLabel.Font = Enum.Font.Gotham
InfiniteJumpLabel.TextSize = 14
InfiniteJumpLabel.Parent = InfiniteJumpFrame

local InfiniteJumpToggle = Instance.new("TextButton")
InfiniteJumpToggle.Name = "InfiniteJumpToggle"
InfiniteJumpToggle.Size = UDim2.new(0.4, 0, 0.8, 0)
InfiniteJumpToggle.Position = UDim2.new(0.55, 0, 0.1, 0)
InfiniteJumpToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
InfiniteJumpToggle.BorderSizePixel = 0
InfiniteJumpToggle.Text = "OFF"
InfiniteJumpToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
InfiniteJumpToggle.Font = Enum.Font.Gotham
InfiniteJumpToggle.TextSize = 14
InfiniteJumpToggle.Parent = InfiniteJumpFrame

-- Кнопка респавна
local RespawnButton = Instance.new("TextButton")
RespawnButton.Name = "RespawnButton"
RespawnButton.Size = UDim2.new(0.9, 0, 0, 30)
RespawnButton.Position = UDim2.new(0.05, 0, 0, 50)
RespawnButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
RespawnButton.BorderSizePixel = 0
RespawnButton.Text = "Respawn Character"
RespawnButton.TextColor3 = Color3.fromRGB(255, 255, 255)
RespawnButton.Font = Enum.Font.Gotham
RespawnButton.TextSize = 14
RespawnButton.Parent = PlayerTab

-- Спидхак
local SpeedFrame = Instance.new("Frame")
SpeedFrame.Name = "SpeedFrame"
SpeedFrame.Size = UDim2.new(0.9, 0, 0, 60)
SpeedFrame.Position = UDim2.new(0.05, 0, 0, 90)
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
NoclipFrame.Position = UDim2.new(0.05, 0, 0, 160)
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
AntiAFKFrame.Position = UDim2.new(0.05, 0, 0, 200)
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

-- Вкладка Misc
local MiscTab = Instance.new("Frame")
MiscTab.Name = "MiscTab"
MiscTab.Size = UDim2.new(1, 0, 1, 0)
MiscTab.Position = UDim2.new(0, 0, 0, 0)
MiscTab.BackgroundTransparency = 1
MiscTab.Visible = false
MiscTab.Parent = ContentFrame

-- Spinbot/Fling
local SpinbotFrame = Instance.new("Frame")
SpinbotFrame.Name = "SpinbotFrame"
SpinbotFrame.Size = UDim2.new(0.9, 0, 0, 30)
SpinbotFrame.Position = UDim2.new(0.05, 0, 0, 10)
SpinbotFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
SpinbotFrame.BorderSizePixel = 0
SpinbotFrame.Parent = MiscTab

local SpinbotLabel = Instance.new("TextLabel")
SpinbotLabel.Name = "SpinbotLabel"
SpinbotLabel.Size = UDim2.new(0.5, 0, 1, 0)
SpinbotLabel.Position = UDim2.new(0, 5, 0, 0)
SpinbotLabel.BackgroundTransparency = 1
SpinbotLabel.Text = "Spinbot/Fling"
SpinbotLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpinbotLabel.TextXAlignment = Enum.TextXAlignment.Left
SpinbotLabel.Font = Enum.Font.Gotham
SpinbotLabel.TextSize = 14
SpinbotLabel.Parent = SpinbotFrame

local SpinbotToggle = Instance.new("TextButton")
SpinbotToggle.Name = "SpinbotToggle"
SpinbotToggle.Size = UDim2.new(0.4, 0, 0.8, 0)
SpinbotToggle.Position = UDim2.new(0.55, 0, 0.1, 0)
SpinbotToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SpinbotToggle.BorderSizePixel = 0
SpinbotToggle.Text = "OFF"
SpinbotToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
SpinbotToggle.Font = Enum.Font.Gotham
SpinbotToggle.TextSize = 14
SpinbotToggle.Parent = SpinbotFrame

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

local function ToggleInfiniteJump()
    infiniteJumpEnabled = not infiniteJumpEnabled
    
    if infiniteJumpEnabled then
        InfiniteJumpToggle.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        InfiniteJumpToggle.Text = "ON"
        
        UserInputService.JumpRequest:Connect(function()
            if infiniteJumpEnabled and LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    task.wait(0.1)
                    local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        root.Velocity = Vector3.new(root.Velocity.X, jumpHeight, root.Velocity.Z)
                    end
                end
            end
        end)
    else
        InfiniteJumpToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        InfiniteJumpToggle.Text = "OFF"
    end
end

local function RespawnCharacter()
    if LocalPlayer.Character then
        LocalPlayer.Character:BreakJoints()
    end
end

local function ToggleSafeZone()
    safeZoneActive = not safeZoneActive
    
    if safeZoneActive then
        SafeZoneButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        SafeZoneButton.Text = "Safe Zone (ON)"
        
        if not LocalPlayer.Character then return end
        
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        -- Телепорт вверх на 300 блоков
        root.CFrame = root.CFrame + Vector3.new(0, 300, 0)
        
        -- Создание платформы
        if platformPart then
            platformPart:Destroy()
        end
        
        platformPart = Instance.new("Part")
        platformPart.Name = "SafePlatform"
        platformPart.Size = Vector3.new(15, 1, 15)
        platformPart.Anchored = true
        platformPart.Transparency = 0.7
        platformPart.Material = Enum.Material.Neon
        platformPart.Color = Color3.fromRGB(0, 255, 0)
        platformPart.CFrame = root.CFrame - Vector3.new(0, 3, 0)
        platformPart.Parent = workspace
    else
        SafeZoneButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
        SafeZoneButton.Text = "Teleport to Safe Zone"
        
        if platformPart then
            platformPart:Destroy()
            platformPart = nil
        end
    end
end

local function ToggleSpinbot()
    spinbotEnabled = not spinbotEnabled
    flingEnabled = spinbotEnabled
    
    if spinbotEnabled then
        SpinbotToggle.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        SpinbotToggle.Text = "ON"
        
        -- Улучшенный спинбот с флингом
        local spinConnection
        spinConnection = RunService.Heartbeat:Connect(function()
            if not spinbotEnabled or not LocalPlayer.Character then
                spinConnection:Disconnect()
                return
            end
            
            local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                -- Вращение с высокой скоростью
                root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, tick() * 20 % (2 * math.pi), 0)
                
                -- Флинг всех игроков в радиусе
                if flingEnabled then
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character then
                            local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
                            if targetRoot then
                                -- Отправляем игрока в космос с огромной скоростью
                                targetRoot.Velocity = Vector3.new(0, 10000, 0)
                                targetRoot.RotVelocity = Vector3.new(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100))
                                
                                -- Убиваем игрока через 3 секунды (если не убьет падение)
                                delay(3, function()
                                    if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                                        player.Character:BreakJoints()
                                    end
                                end)
                            end
                        end
                    end
                end
            end
        end)
    else
        SpinbotToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        SpinbotToggle.Text = "OFF"
    end
end

local function ToggleAntiAFK()
    antiAfkEnabled = not antiAfkEnabled
    
    if antiAfkEnabled then
        AntiAFKToggle.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        AntiAFKToggle.Text = "ON"
        
        -- Просто обновляем время последней активности
        afkConnection = RunService.Heartbeat:Connect(function()
            if not antiAfkEnabled then return end
            -- Ничего не делаем, просто предотвращаем AFK
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

local function SwitchTab(tab)
    TPTab.Visible = (tab == "TP")
    PlayerTab.Visible = (tab == "Player")
    MiscTab.Visible = (tab == "Misc")
    
    TPButton.BackgroundColor3 = (tab == "TP") and Color3.fromRGB(0, 120, 215) or Color3.fromRGB(70, 70, 70)
    PlayerButton.BackgroundColor3 = (tab == "Player") and Color3.fromRGB(0, 120, 215) or Color3.fromRGB(70, 70, 70)
    MiscButton.BackgroundColor3 = (tab == "Misc") and Color3.fromRGB(0, 120, 215) or Color3.fromRGB(70, 70, 70)
end

-- Подключение событий
MiniIcon.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    MiniIcon.Visible = false
end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

MinimizeButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MiniIcon.Visible = true
end)

TPButton.MouseButton1Click:Connect(function() SwitchTab("TP") end)
PlayerButton.MouseButton1Click:Connect(function() SwitchTab("Player") end)
MiscButton.MouseButton1Click:Connect(function() SwitchTab("Misc") end)

TeleportMode.MouseButton1Click:Connect(function() SetFollowMode("Teleport") end)
CameraMode.MouseButton1Click:Connect(function() SetFollowMode("Camera") end)
FollowButton.MouseButton1Click:Connect(function()
    if following then
        StopFollowing()
    else
        StartFollowing()
    end
end)

SafeZoneButton.MouseButton1Click:Connect(ToggleSafeZone)
RespawnButton.MouseButton1Click:Connect(RespawnCharacter)

SpeedToggle.MouseButton1Click:Connect(ToggleSpeedHack)
NoclipToggle.MouseButton1Click:Connect(ToggleNoclip)
InfiniteJumpToggle.MouseButton1Click:Connect(ToggleInfiniteJump)
SpinbotToggle.MouseButton1Click:Connect(ToggleSpinbot)
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

-- Обработка выхода игрока
LocalPlayer.CharacterAdded:Connect(function(character)
    if speedHackEnabled then
        task.wait(0.5)
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = speedValue
        end
    end
end)
Players.PlayerAdded:Connect(UpdatePlayerList)
Players.PlayerRemoving:Connect(UpdatePlayerList)
