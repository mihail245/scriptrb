-- Ultimate Menu v2.0 Enhanced
-- by github.com/YourUsername

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
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Удаляем старое меню если есть
if CoreGui:FindFirstChild("UltimateGUI") then
    CoreGui.UltimateGUI:Destroy()
end

-- Настройки
local isMinimized = false
local originalSize = UDim2.new(0, 450, 0, 500)
local minimizedSize = UDim2.new(0, 450, 0, 40)
local following = false
local followMode = "Teleport"
local followTarget = nil
local speedHackEnabled = false
local speedValue = 32
local noclipEnabled = false
local noclipConnection = nil
local antiAfkEnabled = false
local afkInterval = 10
local afkConnection = nil
local infiniteJumpEnabled = false
local jumpHeight = 50
local spinbotEnabled = false
local flingEnabled = false
local platformPart = nil
local safeZoneActive = false
local aimbotEnabled = false
local aimbotTarget = nil
local espEnabled = false
local flyEnabled = false
local flySpeed = 50
local nightMode = false
local noFog = false
local fullbright = false
local xrayEnabled = false
local chatSpamEnabled = false
local spamMessages = {"Ultimate Menu v2.0!", "Powered by Lua", "Check out my scripts!"}
local spamInterval = 5
local spamConnection = nil
local spinSpeed = 20
local flingPower = 10000
local spinbotConnection = nil
local aimbotConnection = nil
local espConnections = {}
local flyConnection = nil
local originalFogEnd = Lighting.FogEnd
local originalBrightness = Lighting.Brightness
local originalAmbient = Lighting.Ambient
local originalColor = Lighting.OutdoorAmbient

-- Цветовая схема
local accentColor = Color3.fromRGB(0, 170, 255)
local darkColor = Color3.fromRGB(30, 30, 40)
local darkerColor = Color3.fromRGB(20, 20, 30)
local textColor = Color3.fromRGB(240, 240, 240)
local buttonColor = Color3.fromRGB(50, 50, 60)
local toggleOffColor = Color3.fromRGB(80, 80, 80)
local toggleOnColor = Color3.fromRGB(0, 200, 100)
local warningColor = Color3.fromRGB(255, 80, 80)

-- Создаем GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltimateGUI"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Мини-иконка (перемещаемая)
local MiniIcon = Instance.new("TextButton")
MiniIcon.Name = "MiniIcon"
MiniIcon.Size = UDim2.new(0, 50, 0, 50)
MiniIcon.Position = UDim2.new(0, 10, 0.5, -25)
MiniIcon.BackgroundColor3 = accentColor
MiniIcon.BorderSizePixel = 0
MiniIcon.Text = ">"
MiniIcon.TextColor3 = textColor
MiniIcon.Font = Enum.Font.GothamBold
MiniIcon.TextSize = 24
MiniIcon.Visible = false
MiniIcon.Active = true
MiniIcon.Draggable = true
MiniIcon.Parent = ScreenGui

-- Основное окно
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = originalSize
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -250)
MainFrame.BackgroundColor3 = darkColor
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Тень
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.Size = UDim2.new(1, 10, 1, 10)
Shadow.Position = UDim2.new(0, -5, 0, -5)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://1316045217"
Shadow.ImageColor3 = Color3.new(0, 0, 0)
Shadow.ImageTransparency = 0.8
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
Shadow.Parent = MainFrame

-- Заголовок
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = darkerColor
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ULTIMATE MENU v2.0"
Title.TextColor3 = textColor
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Parent = TitleBar

-- Кнопки управления окном
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 40, 1, 0)
MinimizeButton.Position = UDim2.new(1, -90, 0, 0)
MinimizeButton.BackgroundColor3 = buttonColor
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Text = "_"
MinimizeButton.TextColor3 = textColor
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 18
MinimizeButton.Parent = TitleBar

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 40, 1, 0)
CloseButton.Position = UDim2.new(1, -40, 0, 0)
CloseButton.BackgroundColor3 = warningColor
CloseButton.BorderSizePixel = 0
CloseButton.Text = "X"
CloseButton.TextColor3 = textColor
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 18
CloseButton.Parent = TitleBar

-- Вкладки
local TabButtons = Instance.new("Frame")
TabButtons.Name = "TabButtons"
TabButtons.Size = UDim2.new(1, 0, 0, 40)
TabButtons.Position = UDim2.new(0, 0, 0, 40)
TabButtons.BackgroundTransparency = 1
TabButtons.Parent = MainFrame

local PlayerTabButton = Instance.new("TextButton")
PlayerTabButton.Name = "PlayerTabButton"
PlayerTabButton.Size = UDim2.new(0.25, 0, 1, 0)
PlayerTabButton.Position = UDim2.new(0, 0, 0, 0)
PlayerTabButton.BackgroundColor3 = accentColor
PlayerTabButton.BorderSizePixel = 0
PlayerTabButton.Text = "PLAYER"
PlayerTabButton.TextColor3 = textColor
PlayerTabButton.Font = Enum.Font.GothamBold
PlayerTabButton.TextSize = 14
PlayerTabButton.Parent = TabButtons

local CombatTabButton = Instance.new("TextButton")
CombatTabButton.Name = "CombatTabButton"
CombatTabButton.Size = UDim2.new(0.25, 0, 1, 0)
CombatTabButton.Position = UDim2.new(0.25, 0, 0, 0)
CombatTabButton.BackgroundColor3 = buttonColor
CombatTabButton.BorderSizePixel = 0
CombatTabButton.Text = "COMBAT"
CombatTabButton.TextColor3 = textColor
CombatTabButton.Font = Enum.Font.GothamBold
CombatTabButton.TextSize = 14
CombatTabButton.Parent = TabButtons

local WorldTabButton = Instance.new("TextButton")
WorldTabButton.Name = "WorldTabButton"
WorldTabButton.Size = UDim2.new(0.25, 0, 1, 0)
WorldTabButton.Position = UDim2.new(0.5, 0, 0, 0)
WorldTabButton.BackgroundColor3 = buttonColor
WorldTabButton.BorderSizePixel = 0
WorldTabButton.Text = "WORLD"
WorldTabButton.TextColor3 = textColor
WorldTabButton.Font = Enum.Font.GothamBold
WorldTabButton.TextSize = 14
WorldTabButton.Parent = TabButtons

local MiscTabButton = Instance.new("TextButton")
MiscTabButton.Name = "MiscTabButton"
MiscTabButton.Size = UDim2.new(0.25, 0, 1, 0)
MiscTabButton.Position = UDim2.new(0.75, 0, 0, 0)
MiscTabButton.BackgroundColor3 = buttonColor
MiscTabButton.BorderSizePixel = 0
MiscTabButton.Text = "MISC"
MiscTabButton.TextColor3 = textColor
MiscTabButton.Font = Enum.Font.GothamBold
MiscTabButton.TextSize = 14
MiscTabButton.Parent = TabButtons

-- Основное содержимое
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, 0, 1, -80)
ContentFrame.Position = UDim2.new(0, 0, 0, 80)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Visible = true
ContentFrame.Parent = MainFrame

-- Вкладка Player
local PlayerTab = Instance.new("ScrollingFrame")
PlayerTab.Name = "PlayerTab"
PlayerTab.Size = UDim2.new(1, 0, 1, 0)
PlayerTab.Position = UDim2.new(0, 0, 0, 0)
PlayerTab.BackgroundTransparency = 1
PlayerTab.Visible = true
PlayerTab.ScrollBarThickness = 5
PlayerTab.AutomaticCanvasSize = Enum.AutomaticSize.Y
PlayerTab.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerTab.Parent = ContentFrame

-- Вкладка Combat
local CombatTab = Instance.new("ScrollingFrame")
CombatTab.Name = "CombatTab"
CombatTab.Size = UDim2.new(1, 0, 1, 0)
CombatTab.Position = UDim2.new(0, 0, 0, 0)
CombatTab.BackgroundTransparency = 1
CombatTab.Visible = false
CombatTab.ScrollBarThickness = 5
CombatTab.AutomaticCanvasSize = Enum.AutomaticSize.Y
CombatTab.CanvasSize = UDim2.new(0, 0, 0, 0)
CombatTab.Parent = ContentFrame

-- Вкладка World
local WorldTab = Instance.new("ScrollingFrame")
WorldTab.Name = "WorldTab"
WorldTab.Size = UDim2.new(1, 0, 1, 0)
WorldTab.Position = UDim2.new(0, 0, 0, 0)
WorldTab.BackgroundTransparency = 1
WorldTab.Visible = false
WorldTab.ScrollBarThickness = 5
WorldTab.AutomaticCanvasSize = Enum.AutomaticSize.Y
WorldTab.CanvasSize = UDim2.new(0, 0, 0, 0)
WorldTab.Parent = ContentFrame

-- Вкладка Misc
local MiscTab = Instance.new("ScrollingFrame")
MiscTab.Name = "MiscTab"
MiscTab.Size = UDim2.new(1, 0, 1, 0)
MiscTab.Position = UDim2.new(0, 0, 0, 0)
MiscTab.BackgroundTransparency = 1
MiscTab.Visible = false
MiscTab.ScrollBarThickness = 5
MiscTab.AutomaticCanvasSize = Enum.AutomaticSize.Y
MiscTab.CanvasSize = UDim2.new(0, 0, 0, 0)
MiscTab.Parent = ContentFrame

-- Функция для создания элементов UI
local function CreateButton(name, text, parent, yPos)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(0.9, 0, 0, 35)
    button.Position = UDim2.new(0.05, 0, 0, yPos)
    button.BackgroundColor3 = buttonColor
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = textColor
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = button
    
    return button
end

local function CreateToggle(name, text, parent, yPos)
    local frame = Instance.new("Frame")
    frame.Name = name.."Frame"
    frame.Size = UDim2.new(0.9, 0, 0, 35)
    frame.Position = UDim2.new(0.05, 0, 0, yPos)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Name = name.."Label"
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = textColor
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.Parent = frame
    
    local toggle = Instance.new("TextButton")
    toggle.Name = name.."Toggle"
    toggle.Size = UDim2.new(0.25, 0, 0.8, 0)
    toggle.Position = UDim2.new(0.75, 0, 0.1, 0)
    toggle.BackgroundColor3 = toggleOffColor
    toggle.BorderSizePixel = 0
    toggle.Text = "OFF"
    toggle.TextColor3 = textColor
    toggle.Font = Enum.Font.GothamBold
    toggle.TextSize = 14
    toggle.Parent = frame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = toggle
    
    return toggle
end

local function CreateSlider(name, text, parent, yPos, min, max, default)
    local frame = Instance.new("Frame")
    frame.Name = name.."Frame"
    frame.Size = UDim2.new(0.9, 0, 0, 50)
    frame.Position = UDim2.new(0.05, 0, 0, yPos)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Name = name.."Label"
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = textColor
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.Parent = frame
    
    local slider = Instance.new("Frame")
    slider.Name = name.."Slider"
    slider.Size = UDim2.new(1, 0, 0, 20)
    slider.Position = UDim2.new(0, 0, 0, 25)
    slider.BackgroundColor3 = buttonColor
    slider.BorderSizePixel = 0
    slider.Parent = frame
    
    local fill = Instance.new("Frame")
    fill.Name = name.."Fill"
    fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    fill.Position = UDim2.new(0, 0, 0, 0)
    fill.BackgroundColor3 = accentColor
    fill.BorderSizePixel = 0
    fill.Parent = slider
    
    local value = Instance.new("TextLabel")
    value.Name = name.."Value"
    value.Size = UDim2.new(1, 0, 1, 0)
    value.Position = UDim2.new(0, 0, 0, 0)
    value.BackgroundTransparency = 1
    value.Text = tostring(default)
    value.TextColor3 = textColor
    value.Font = Enum.Font.GothamBold
    value.TextSize = 14
    value.Parent = slider
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = slider
    
    local corner2 = Instance.new("UICorner")
    corner2.CornerRadius = UDim.new(0, 5)
    corner2.Parent = fill
    
    -- Функционал слайдера
    local dragging = false
    
    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    slider.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local xPos = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
            fill.Size = UDim2.new(xPos, 0, 1, 0)
            local currentValue = math.floor(min + (max - min) * xPos)
            value.Text = tostring(currentValue)
            
            -- Обновляем значение
            if name == "Speed" then
                speedValue = currentValue
                if speedHackEnabled then
                    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid.WalkSpeed = speedValue
                    end
                end
            elseif name == "Jump" then
                jumpHeight = currentValue
            elseif name == "SpinSpeed" then
                spinSpeed = currentValue
            elseif name == "FlingPower" then
                flingPower = currentValue
            elseif name == "FlySpeed" then
                flySpeed = currentValue
            end
        end
    end)
    
    return slider
end

-- Создаем элементы для вкладки Player
local SpeedToggle = CreateToggle("Speed", "Speed Hack", PlayerTab, 10)
local SpeedSlider = CreateSlider("Speed", "Speed Value", PlayerTab, 50, 16, 200, speedValue)

local JumpToggle = CreateToggle("Jump", "Infinite Jump", PlayerTab, 110)
local JumpSlider = CreateSlider("Jump", "Jump Height", PlayerTab, 150, 20, 200, jumpHeight)

local NoclipToggle = CreateToggle("Noclip", "Noclip", PlayerTab, 210)
local FlyToggle = CreateToggle("Fly", "Fly Mode", PlayerTab, 260)
local FlySlider = CreateSlider("FlySpeed", "Fly Speed", PlayerTab, 300, 20, 200, flySpeed)

local RespawnButton = CreateButton("Respawn", "Respawn Character", PlayerTab, 360)

-- Создаем элементы для вкладки Combat
local SpinbotToggle = CreateToggle("Spinbot", "Spinbot", CombatTab, 10)
local SpinSpeedSlider = CreateSlider("SpinSpeed", "Spin Speed", CombatTab, 50, 5, 50, spinSpeed)
local FlingPowerSlider = CreateSlider("FlingPower", "Fling Power", CombatTab, 110, 1000, 20000, flingPower)

local AimbotToggle = CreateToggle("Aimbot", "Aimbot", CombatTab, 170)
local ESPToggle = CreateToggle("ESP", "ESP", CombatTab, 220)

-- Создаем элементы для вкладки World
local SafeZoneButton = CreateButton("SafeZone", "Create Safe Zone", WorldTab, 10)
local NightToggle = CreateToggle("Night", "Night Mode", WorldTab, 60)
local NoFogToggle = CreateToggle("NoFog", "No Fog", WorldTab, 110)
local FullbrightToggle = CreateToggle("Fullbright", "Fullbright", WorldTab, 160)
local XrayToggle = CreateToggle("Xray", "X-Ray", WorldTab, 210)

-- Создаем элементы для вкладки Misc
local AntiAFKToggle = CreateToggle("AntiAFK", "Anti-AFK", MiscTab, 10)
local ChatSpamToggle = CreateToggle("ChatSpam", "Chat Spam", MiscTab, 60)

-- Функции
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

local function SwitchTab(tab)
    PlayerTab.Visible = (tab == "Player")
    CombatTab.Visible = (tab == "Combat")
    WorldTab.Visible = (tab == "World")
    MiscTab.Visible = (tab == "Misc")
    
    PlayerTabButton.BackgroundColor3 = (tab == "Player") and accentColor or buttonColor
    CombatTabButton.BackgroundColor3 = (tab == "Combat") and accentColor or buttonColor
    WorldTabButton.BackgroundColor3 = (tab == "World") and accentColor or buttonColor
    MiscTabButton.BackgroundColor3 = (tab == "Misc") and accentColor or buttonColor
end

local function ToggleSpeedHack()
    speedHackEnabled = not speedHackEnabled
    
    if speedHackEnabled then
        SpeedToggle.BackgroundColor3 = toggleOnColor
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
        SpeedToggle.BackgroundColor3 = toggleOffColor
        SpeedToggle.Text = "OFF"
        
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 16
        end
    end
end

local function ToggleInfiniteJump()
    infiniteJumpEnabled = not infiniteJumpEnabled
    
    if infiniteJumpEnabled then
        JumpToggle.BackgroundColor3 = toggleOnColor
        JumpToggle.Text = "ON"
        
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
        JumpToggle.BackgroundColor3 = toggleOffColor
        JumpToggle.Text = "OFF"
    end
end

local function ToggleNoclip()
    noclipEnabled = not noclipEnabled
    
    if noclipEnabled then
        NoclipToggle.BackgroundColor3 = toggleOnColor
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
        NoclipToggle.BackgroundColor3 = toggleOffColor
        NoclipToggle.Text = "OFF"
        
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
    end
end

local function ToggleFly()
    flyEnabled = not flyEnabled
    
    if flyEnabled then
        FlyToggle.BackgroundColor3 = toggleOnColor
        FlyToggle.Text = "ON"
        
        if flyConnection then
            flyConnection:Disconnect()
        end
        
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(0, 0, 0)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        
        if LocalPlayer.Character then
            bodyVelocity.Parent = LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or LocalPlayer.Character:WaitForChild("HumanoidRootPart")
        end
        
        LocalPlayer.CharacterAdded:Connect(function(character)
            bodyVelocity.Parent = character:WaitForChild("HumanoidRootPart")
        end)
        
        flyConnection = RunService.Heartbeat:Connect(function()
            if not flyEnabled or not LocalPlayer.Character then
                return
            end
            
            local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not root then return end
            
            local cam = workspace.CurrentCamera.CFrame
            local moveVec = Vector3.new()
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveVec = moveVec + (cam.LookVector * flySpeed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveVec = moveVec - (cam.LookVector * flySpeed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveVec = moveVec - (cam.RightVector * flySpeed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveVec = moveVec + (cam.RightVector * flySpeed)
            end
            
            if bodyVelocity then
                bodyVelocity.Velocity = moveVec
                bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            end
        end)
    else
        FlyToggle.BackgroundColor3 = toggleOffColor
        FlyToggle.Text = "OFF"
        
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
        
        if LocalPlayer.Character then
            local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local bodyVelocity = root:FindFirstChild("BodyVelocity")
                if bodyVelocity then
                    bodyVelocity:Destroy()
                end
            end
        end
    end
end

local function RespawnCharacter()
    if LocalPlayer.Character then
        LocalPlayer.Character:BreakJoints()
    end
end

local function ToggleSpinbot()
    spinbotEnabled = not spinbotEnabled
    
    if spinbotEnabled then
        SpinbotToggle.BackgroundColor3 = toggleOnColor
        SpinbotToggle.Text = "ON"
        
        if spinbotConnection then
            spinbotConnection:Disconnect()
        end
        
        spinbotConnection = RunService.Heartbeat:Connect(function()
            if not spinbotEnabled or not LocalPlayer.Character then
                return
            end
            
            local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                -- Вращение
                root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, tick() * spinSpeed % (2 * math.pi), 0)
                
                -- Флинг всех игроков в радиусе
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
                        if targetRoot then
                            -- Отправляем игрока в космос
                            targetRoot.Velocity = Vector3.new(0, flingPower, 0)
                            targetRoot.RotVelocity = Vector3.new(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100))
                            
                            -- Убиваем игрока через 3 секунды
                            delay(3, function()
                                if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                                    player.Character:BreakJoints()
                                end
                            end)
                        end
                    end
                end
            end
        end)
    else
        SpinbotToggle.BackgroundColor3 = toggleOffColor
        SpinbotToggle.Text = "OFF"
        
        if spinbotConnection then
            spinbotConnection:Disconnect()
            spinbotConnection = nil
        end
    end
end

local function ToggleAimbot()
    aimbotEnabled = not aimbotEnabled
    
    if aimbotEnabled then
        AimbotToggle.BackgroundColor3 = toggleOnColor
        AimbotToggle.Text = "ON"
        
        if aimbotConnection then
            aimbotConnection:Disconnect()
        end
        
        aimbotConnection = RunService.RenderStepped:Connect(function()
            if not aimbotEnabled or not LocalPlayer.Character then return end
            
            local closestPlayer = nil
            local closestDistance = math.huge
            local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            
            if not localRoot then return end
            
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
                    if targetRoot then
                        local distance = (targetRoot.Position - localRoot.Position).Magnitude
                        if distance < closestDistance then
                            closestDistance = distance
                            closestPlayer = player
                        end
                    end
                end
            end
            
            if closestPlayer and closestPlayer.Character then
                local targetRoot = closestPlayer.Character:FindFirstChild("HumanoidRootPart")
                if targetRoot then
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetRoot.Position)
                end
            end
        end)
    else
        AimbotToggle.BackgroundColor3 = toggleOffColor
        AimbotToggle.Text = "OFF"
        
        if aimbotConnection then
            aimbotConnection:Disconnect()
            aimbotConnection = nil
        end
    end
end

local function CreateESP(player)
    if not player.Character then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_"..player.Name
    highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.FillTransparency = 0.8
    highlight.OutlineTransparency = 0
    highlight.Parent = player.Character
    
    espConnections[player] = player.CharacterAdded:Connect(function(char)
        highlight:Destroy()
        task.wait(1)
        local newHighlight = Instance.new("Highlight")
        newHighlight.Name = "ESP_"..player.Name
        newHighlight.OutlineColor = Color3.fromRGB(255, 0, 0)
        newHighlight.FillColor = Color3.fromRGB(255, 0, 0)
        newHighlight.FillTransparency = 0.8
        newHighlight.OutlineTransparency = 0
        newHighlight.Parent = char
    end)
end

local function RemoveESP(player)
    if espConnections[player] then
        espConnections[player]:Disconnect()
        espConnections[player] = nil
    end
    
    if player.Character then
        local highlight = player.Character:FindFirstChild("ESP_"..player.Name)
        if highlight then
            highlight:Destroy()
        end
    end
end

local function ToggleESP()
    espEnabled = not espEnabled
    
    if espEnabled then
        ESPToggle.BackgroundColor3 = toggleOnColor
        ESPToggle.Text = "ON"
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                CreateESP(player)
            end
        end
        
        Players.PlayerAdded:Connect(function(player)
            CreateESP(player)
        end)
        
        Players.PlayerRemoving:Connect(function(player)
            RemoveESP(player)
        end)
    else
        ESPToggle.BackgroundColor3 = toggleOffColor
        ESPToggle.Text = "OFF"
        
        for _, player in ipairs(Players:GetPlayers()) do
            RemoveESP(player)
        end
        
        table.clear(espConnections)
    end
end

local function ToggleSafeZone()
    safeZoneActive = not safeZoneActive
    
    if safeZoneActive then
        SafeZoneButton.BackgroundColor3 = toggleOnColor
        SafeZoneButton.Text = "Safe Zone (ON)"
        
        if not LocalPlayer.Character then return end
        
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        -- Телепорт вверх на 500 блоков
        root.CFrame = root.CFrame + Vector3.new(0, 500, 0)
        
        -- Создание большой платформы (50x50)
        if platformPart then
            platformPart:Destroy()
        end
        
        platformPart = Instance.new("Part")
        platformPart.Name = "SafePlatform"
        platformPart.Size = Vector3.new(50, 1, 50)
        platformPart.Anchored = true
        platformPart.Transparency = 0.7
        platformPart.Material = Enum.Material.Neon
        platformPart.Color = Color3.fromRGB(0, 255, 0)
        platformPart.CFrame = root.CFrame - Vector3.new(0, 3, 0)
        platformPart.Parent = workspace
    else
        SafeZoneButton.BackgroundColor3 = accentColor
        SafeZoneButton.Text = "Create Safe Zone"
        
        if platformPart then
            platformPart:Destroy()
            platformPart = nil
        end
    end
end

local function ToggleNightMode()
    nightMode = not nightMode
    
    if nightMode then
        NightToggle.BackgroundColor3 = toggleOnColor
        NightToggle.Text = "ON"
        Lighting.ClockTime = 0
        Lighting.Brightness = 0.1
        Lighting.Ambient = Color3.fromRGB(50, 50, 50)
        Lighting.OutdoorAmbient = Color3.fromRGB(50, 50, 50)
    else
        NightToggle.BackgroundColor3 = toggleOffColor
        NightToggle.Text = "OFF"
        Lighting.ClockTime = 14
        Lighting.Brightness = originalBrightness
        Lighting.Ambient = originalAmbient
        Lighting.OutdoorAmbient = originalColor
    end
end

local function ToggleNoFog()
    noFog = not noFog
    
    if noFog then
        NoFogToggle.BackgroundColor3 = toggleOnColor
        NoFogToggle.Text = "ON"
        originalFogEnd = Lighting.FogEnd
        Lighting.FogEnd = 1000000
    else
        NoFogToggle.BackgroundColor3 = toggleOffColor
        NoFogToggle.Text = "OFF"
        Lighting.FogEnd = originalFogEnd
    end
end

local function ToggleFullbright()
    fullbright = not fullbright
    
    if fullbright then
        FullbrightToggle.BackgroundColor3 = toggleOnColor
        FullbrightToggle.Text = "ON"
        Lighting.Brightness = 2
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    else
        FullbrightToggle.BackgroundColor3 = toggleOffColor
        FullbrightToggle.Text = "OFF"
        Lighting.Brightness = originalBrightness
        Lighting.Ambient = originalAmbient
        Lighting.OutdoorAmbient = originalColor
    end
end

local function ToggleXray()
    xrayEnabled = not xrayEnabled
    
    if xrayEnabled then
        XrayToggle.BackgroundColor3 = toggleOnColor
        XrayToggle.Text = "ON"
        
        for _, part in ipairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and not part:IsA("Terrain") and part.Transparency < 0.95 then
                part.LocalTransparencyModifier = 0.5
            end
        end
        
        workspace.DescendantAdded:Connect(function(part)
            if part:IsA("BasePart") and not part:IsA("Terrain") then
                part.LocalTransparencyModifier = 0.5
            end
        end)
    else
        XrayToggle.BackgroundColor3 = toggleOffColor
        XrayToggle.Text = "OFF"
        
        for _, part in ipairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") then
                part.LocalTransparencyModifier = 0
            end
        end
    end
end

local function ToggleAntiAFK()
    antiAfkEnabled = not antiAfkEnabled
    
    if antiAfkEnabled then
        AntiAFKToggle.BackgroundColor3 = toggleOnColor
        AntiAFKToggle.Text = "ON"
        
        if afkConnection then
            afkConnection:Disconnect()
        end
        
        afkConnection = RunService.Heartbeat:Connect(function()
            if not antiAfkEnabled then return end
            local VirtualUser = game:GetService("VirtualUser")
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    else
        AntiAFKToggle.BackgroundColor3 = toggleOffColor
        AntiAFKToggle.Text = "OFF"
        
        if afkConnection then
            afkConnection:Disconnect()
            afkConnection = nil
        end
    end
end

local function ToggleChatSpam()
    chatSpamEnabled = not chatSpamEnabled
    
    if chatSpamEnabled then
        ChatSpamToggle.BackgroundColor3 = toggleOnColor
        ChatSpamToggle.Text = "ON"
        
        if spamConnection then
            spamConnection:Disconnect()
        end
        
        local function SendMessage(message)
            local args = {
                [1] = message,
                [2] = "All"
            }
            
            local success, err = pcall(function()
                game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack(args))
            end)
            
            if not success then
                warn("Chat spam error:", err)
            end
        end
        
        spamConnection = RunService.Heartbeat:Connect(function()
            if not chatSpamEnabled then return end
            SendMessage(spamMessages[math.random(1, #spamMessages)])
            wait(spamInterval)
        end)
    else
        ChatSpamToggle.BackgroundColor3 = toggleOffColor
        ChatSpamToggle.Text = "OFF"
        
        if spamConnection then
            spamConnection:Disconnect()
            spamConnection = nil
        end
    end
end

-- Подключение событий
MiniIcon.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    MiniIcon.Visible = false
end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

MinimizeButton.MouseButton1Click:Connect(ToggleMinimize)

PlayerTabButton.MouseButton1Click:Connect(function() SwitchTab("Player") end)
CombatTabButton.MouseButton1Click:Connect(function() SwitchTab("Combat") end)
WorldTabButton.MouseButton1Click:Connect(function() SwitchTab("World") end)
MiscTabButton.MouseButton1Click:Connect(function() SwitchTab("Misc") end)

SpeedToggle.MouseButton1Click:Connect(ToggleSpeedHack)
JumpToggle.MouseButton1Click:Connect(ToggleInfiniteJump)
NoclipToggle.MouseButton1Click:Connect(ToggleNoclip)
FlyToggle.MouseButton1Click:Connect(ToggleFly)
RespawnButton.MouseButton1Click:Connect(RespawnCharacter)

SpinbotToggle.MouseButton1Click:Connect(ToggleSpinbot)
AimbotToggle.MouseButton1Click:Connect(ToggleAimbot)
ESPToggle.MouseButton1Click:Connect(ToggleESP)

SafeZoneButton.MouseButton1Click:Connect(ToggleSafeZone)
NightToggle.MouseButton1Click:Connect(ToggleNightMode)
NoFogToggle.MouseButton1Click:Connect(ToggleNoFog)
FullbrightToggle.MouseButton1Click:Connect(ToggleFullbright)
XrayToggle.MouseButton1Click:Connect(ToggleXray)

AntiAFKToggle.MouseButton1Click:Connect(ToggleAntiAFK)
ChatSpamToggle.MouseButton1Click:Connect(ToggleChatSpam)

-- Инициализация
SwitchTab("Player")

-- Обработка выхода игрока
LocalPlayer.CharacterAdded:Connect(function(character)
    if speedHackEnabled then
        task.wait(0.5)
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = speedValue
        end
    end
    
    if flyEnabled then
        task.wait(0.5)
        ToggleFly()
        ToggleFly() -- Переключаем дважды для повторной активации
    end
end)

-- Сохраняем оригинальные настройки освещения
originalBrightness = Lighting.Brightness
originalAmbient = Lighting.Ambient
originalColor = Lighting.OutdoorAmbient
originalFogEnd = Lighting.FogEnd

-- Уведомление о загрузке
print("Ultimate Menu v2.0 Enhanced loaded successfully!")
