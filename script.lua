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
local GuiService = game:GetService("GuiService")

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
local filteredWords = {"badword1", "badword2"}
local infiniteJumpEnabled = false
local jumpHeight = 50
local showCoords = true
local spinbotEnabled = false
local flingEnabled = false

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
InfiniteJumpFrame.Size = UDim2.new(0.9, 0, 0, 60)
InfiniteJumpFrame.Position = UDim2.new(0.05, 0, 0, 10)
InfiniteJumpFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
InfiniteJumpFrame.BorderSizePixel = 0
InfiniteJumpFrame.Parent = PlayerTab

local InfiniteJumpLabel = Instance.new("TextLabel")
InfiniteJumpLabel.Name = "InfiniteJumpLabel"
InfiniteJumpLabel.Size = UDim2.new(0.5, 0, 0, 30)
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
InfiniteJumpToggle.Size = UDim2.new(0.4, 0, 0, 25)
InfiniteJumpToggle.Position = UDim2.new(0.55, 0, 0, 3)
InfiniteJumpToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
InfiniteJumpToggle.BorderSizePixel = 0
InfiniteJumpToggle.Text = "OFF"
InfiniteJumpToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
InfiniteJumpToggle.Font = Enum.Font.Gotham
InfiniteJumpToggle.TextSize = 14
InfiniteJumpToggle.Parent = InfiniteJumpFrame

local JumpHeightBox = Instance.new("TextBox")
JumpHeightBox.Name = "JumpHeightBox"
JumpHeightBox.Size = UDim2.new(0.9, 0, 0, 25)
JumpHeightBox.Position = UDim2.new(0.05, 0, 0, 30)
JumpHeightBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
JumpHeightBox.BorderSizePixel = 0
JumpHeightBox.Text = tostring(jumpHeight)
JumpHeightBox.TextColor3 = Color3.fromRGB(255, 255, 255)
JumpHeightBox.Font = Enum.Font.Gotham
JumpHeightBox.TextSize = 14
JumpHeightBox.Parent = InfiniteJumpFrame

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
SpinbotFrame.Size = UDim2.new(0.9, 0, 0, 60)
SpinbotFrame.Position = UDim2.new(0.05, 0, 0, 10)
SpinbotFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
SpinbotFrame.BorderSizePixel = 0
SpinbotFrame.Parent = MiscTab

local SpinbotLabel = Instance.new("TextLabel")
SpinbotLabel.Name = "SpinbotLabel"
SpinbotLabel.Size = UDim2.new(0.5, 0, 0, 30)
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
SpinbotToggle.Size = UDim2.new(0.4, 0, 0, 25)
SpinbotToggle.Position = UDim2.new(0.55, 0, 0, 3)
SpinbotToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SpinbotToggle.BorderSizePixel = 0
SpinbotToggle.Text = "OFF"
SpinbotToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
SpinbotToggle.Font = Enum.Font.Gotham
SpinbotToggle.TextSize = 14
SpinbotToggle.Parent = SpinbotFrame

-- Координаты внизу экрана
local CoordsDisplayBottom = Instance.new("TextLabel")
CoordsDisplayBottom.Name = "CoordsDisplayBottom"
CoordsDisplayBottom.Size = UDim2.new(0, 200, 0, 20)
CoordsDisplayBottom.Position = UDim2.new(0, 10, 1, -30)
CoordsDisplayBottom.BackgroundTransparency = 1
CoordsDisplayBottom.Text = "X: 0, Y: 0, Z: 0"
CoordsDisplayBottom.TextColor3 = Color3.fromRGB(255, 255, 255)
CoordsDisplayBottom.TextXAlignment = Enum.TextXAlignment.Left
CoordsDisplayBottom.Font = Enum.Font.Gotham
CoordsDisplayBottom.TextSize = 12
CoordsDisplayBottom.Visible = false
CoordsDisplayBottom.Parent = ScreenGui

-- Функции
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

local function ToggleSpinbot()
    spinbotEnabled = not spinbotEnabled
    flingEnabled = spinbotEnabled -- Активируем флинг вместе со спинботом
    
    if spinbotEnabled then
        SpinbotToggle.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        SpinbotToggle.Text = "ON"
        
        local spinConnection
        spinConnection = RunService.Heartbeat:Connect(function()
            if not spinbotEnabled or not LocalPlayer.Character then
                spinConnection:Disconnect()
                return
            end
            
            local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                -- Вращение
                root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(30), 0)
                
                -- Флинг (отбрасывание при касании)
                if flingEnabled then
                    for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.Velocity = Vector3.new(math.random(-100,100), 1000, math.random(-100,100))
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

-- Обновленный Anti-AFK (рандомные действия)
local function ToggleAntiAFK()
    antiAfkEnabled = not antiAfkEnabled
    
    if antiAfkEnabled then
        AntiAFKToggle.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        AntiAFKToggle.Text = "ON"
        
        local actions = {
            function() -- Прыжок
                if LocalPlayer.Character then
                    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end
            end,
            function() -- Движение
                if LocalPlayer.Character then
                    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid:Move(Vector3.new(math.random(-1,1), 0, math.random(-1,1)))
                    end
                end
            end,
            function() -- Эмоция
                if LocalPlayer.Character then
                    local animate = LocalPlayer.Character:FindFirstChild("Animate")
                    if animate then
                        animate.idle.Animation1.AnimationId = "rbxassetid://"..tostring(math.random(1000000,9999999))
                    end
                end
            end
        }
        
        afkConnection = RunService.Heartbeat:Connect(function()
            if not antiAfkEnabled then return end
            task.wait(afkInterval * 60)
            actions[math.random(1,#actions)]()
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

-- Подключение событий
MiniIcon.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    MiniIcon.Visible = false
end)

CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MiniIcon.Visible = true
end)

InfiniteJumpToggle.MouseButton1Click:Connect(ToggleInfiniteJump)
SpinbotToggle.MouseButton1Click:Connect(ToggleSpinbot)
AntiAFKToggle.MouseButton1Click:Connect(ToggleAntiAFK)

JumpHeightBox.FocusLost:Connect(function()
    local newHeight = tonumber(JumpHeightBox.Text)
    if newHeight and newHeight > 0 then
        jumpHeight = newHeight
    else
        JumpHeightBox.Text = tostring(jumpHeight)
    end
end)

-- Обновление координат
RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local pos = LocalPlayer.Character.HumanoidRootPart.Position
        local text = string.format("X: %.1f, Y: %.1f, Z: %.1f", pos.X, pos.Y, pos.Z)
        CoordsDisplayBottom.Text = text
    end
end)

-- Включение координат
local function ToggleCoords()
    showCoords = not showCoords
    CoordsDisplayBottom.Visible = showCoords
end

-- Инициализация
ToggleCoords() -- Включаем координаты по умолчанию
