-- Wait until the game is fully loaded
repeat wait() until game:IsLoaded() and game.Players and game.Players.LocalPlayer and game.Players.LocalPlayer.Character

-- Prevent multiple executions
if getgenv().AntiAfkExecuted then
    getgenv().AntiAfkExecuted = false
    if game.CoreGui:FindFirstChild("kaiiontop") then
        game.CoreGui.kaiiontop:Destroy()
    end
end

getgenv().AntiAfkExecuted = true

-- Create ScreenGui
local kaiiontop = Instance.new("ScreenGui")
kaiiontop.Name = "kaiiontop"
kaiiontop.Parent = game.CoreGui
kaiiontop.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "mainFrame"
mainFrame.Parent = kaiiontop
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.Position = UDim2.new(0.423, 0, 0.1, 0)
mainFrame.Size = UDim2.new(0, 225, 0, 96)

local UICorner = Instance.new("UICorner")
UICorner.Parent = mainFrame

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Name = "closeButton"
closeButton.Parent = mainFrame
closeButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
closeButton.BackgroundTransparency = 1
closeButton.Position = UDim2.new(0.9, 0, 0.042, 0)
closeButton.Size = UDim2.new(0, 15, 0, 15)
closeButton.Font = Enum.Font.GothamBold
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 0, 0)
closeButton.TextSize = 20

closeButton.MouseButton1Click:Connect(function()
    getgenv().AntiAfkExecuted = false
    kaiiontop:Destroy()
end)

-- Title Label
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "titleLabel"
titleLabel.Parent = mainFrame
titleLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.BackgroundTransparency = 1
titleLabel.Position = UDim2.new(0.25, 0, 0, 0)
titleLabel.Size = UDim2.new(0, 95, 0, 24)
titleLabel.Font = Enum.Font.Merriweather
titleLabel.Text = "ANTI AFK BY KAII | (@binggrae_.)"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 13.75

-- Ping Label
local pingLabel = Instance.new("TextLabel")
pingLabel.Name = "pingLabel"
pingLabel.Parent = mainFrame
pingLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
pingLabel.BackgroundTransparency = 1
pingLabel.Position = UDim2.new(0.13, 0, 0.36, 0)
pingLabel.Size = UDim2.new(0, 55, 0, 24)
pingLabel.Font = Enum.Font.GothamBold
pingLabel.Text = "Ping: 0"
pingLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
pingLabel.TextSize = 14

-- FPS Label
local fpsLabel = Instance.new("TextLabel")
fpsLabel.Name = "fpsLabel"
fpsLabel.Parent = mainFrame
fpsLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Position = UDim2.new(0.605, 0, 0.36, 0)
fpsLabel.Size = UDim2.new(0, 55, 0, 24)
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.Text = "FPS: 0"
fpsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
fpsLabel.TextSize = 14

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "statusLabel"
statusLabel.Parent = mainFrame
statusLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.BackgroundTransparency = 1
statusLabel.Position = UDim2.new(0.285, 0, 0.7, 0)
statusLabel.Size = UDim2.new(0, 95, 0, 12)
statusLabel.Font = Enum.Font.Creepster
statusLabel.Text = "ANTI AFK ENABLED"
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.TextSize = 35

-- Draggable Functionality
local UserInputService = game:GetService("UserInputService")
local dragging = false
local dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Anti-AFK Functionality
local VirtualUser = game:service'VirtualUser'
game:service'Players'.LocalPlayer.Idled:connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- FPS Counter
local RunService = game:GetService("RunService")
local fps = 0
local lastTime = tick()
local frames = 0

RunService.RenderStepped:Connect(function()
    frames = frames + 1
    if tick() - lastTime >= 1 then
        fps = frames
        frames = 0
        lastTime = tick()
        fpsLabel.Text = "FPS: " .. fps
    end
end)

-- Ping Counter
spawn(function()
    while true do
        wait(1)
        local stats = game:GetService("Stats")
        local pingStat = stats:FindFirstChild("PerformanceStats") and stats.PerformanceStats:FindFirstChild("Ping")
        if pingStat then
            local ping = math.floor(pingStat:GetValue())
            pingLabel.Text = "Ping: " .. ping
        end
    end
end)
