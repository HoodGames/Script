-- Toggle this to true or false to enable/disable the UI
local toggleUI = true

-- DESTROY & EXIT IF OFF
if not toggleUI then
    if getgenv().AntiAfkExecuted then
        getgenv().AntiAfkExecuted = false
        local gui = game.CoreGui:FindFirstChild("zeidontop")
        if gui then gui:Destroy() end
    end
    return
end

-- Prevent multiple executions
if getgenv().AntiAfkExecuted then
    local gui = game.CoreGui:FindFirstChild("zeidontop")
    if gui then gui:Destroy() end
end
getgenv().AntiAfkExecuted = true

-- Wait until fully loaded
repeat task.wait() until game:IsLoaded() and game.Players and game.Players.LocalPlayer and game.Players.LocalPlayer.Character

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

local AntiAfkConn -- Forward declaration for cleanup

-- UI Setup
local zeidontop = Instance.new("ScreenGui", game.CoreGui)
zeidontop.Name = "zeidontop"
zeidontop.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local mainFrame = Instance.new("Frame", zeidontop)
mainFrame.Name = "mainFrame"
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.Position = UDim2.new(0.423, 0, 0.1, 0)
mainFrame.Size = UDim2.new(0, 225, 0, 96)
Instance.new("UICorner", mainFrame)

local closeButton = Instance.new("TextButton", mainFrame)
closeButton.Position = UDim2.new(0.9, 0, 0.042, 0)
closeButton.Size = UDim2.new(0, 15, 0, 15)
closeButton.BackgroundTransparency = 1
closeButton.Font = Enum.Font.GothamBold
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 0, 0)
closeButton.TextSize = 20
closeButton.MouseButton1Click:Connect(function()
    getgenv().AntiAfkExecuted = false
    if AntiAfkConn then AntiAfkConn:Disconnect() end -- Clean up connection!
    zeidontop:Destroy()
end)

local titleLabel = Instance.new("TextLabel", mainFrame)
titleLabel.Position = UDim2.new(0.05, 0, 0, 0)
titleLabel.Size = UDim2.new(0, 190, 0, 30)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.Merriweather
titleLabel.Text = "ANTI AFK BY ZEID | (@gf0e)"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 13.75

-- Divider Line
local divider = Instance.new("Frame", mainFrame)
divider.Position = UDim2.new(0.05, 0, 0.32, 0)
divider.Size = UDim2.new(0, 200, 0, 2)
divider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
divider.BorderSizePixel = 0

local pingLabel = Instance.new("TextLabel", mainFrame)
pingLabel.Position = UDim2.new(0.13, 0, 0.36, 0)
pingLabel.Size = UDim2.new(0, 55, 0, 24)
pingLabel.BackgroundTransparency = 1
pingLabel.Font = Enum.Font.GothamBold
pingLabel.Text = "Ping: 0"
pingLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
pingLabel.TextSize = 14

local fpsLabel = Instance.new("TextLabel", mainFrame)
fpsLabel.Position = UDim2.new(0.605, 0, 0.36, 0)
fpsLabel.Size = UDim2.new(0, 55, 0, 24)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.Text = "FPS: 0"
fpsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
fpsLabel.TextSize = 14

local statusLabel = Instance.new("TextLabel", mainFrame)
statusLabel.Position = UDim2.new(0.285, 0, 0.7, 0)
statusLabel.Size = UDim2.new(0, 95, 0, 12)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.Creepster
statusLabel.Text = "ANTI AFK ENABLED"
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.TextSize = 35

-- Draggable
local dragging, dragInput, dragStart, startPos
mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Fixed Anti-AFK Mechanism
AntiAfkConn = Players.LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    task.wait(0.5)
    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

-- FPS Counter
local frames, lastTime = 0, os.clock()
RunService.RenderStepped:Connect(function()
    frames += 1
    if os.clock() - lastTime >= 1 then
        fpsLabel.Text = "FPS: " .. frames
        frames = 0
        lastTime = os.clock()
    end
end)

-- Ping Counter
task.spawn(function()
    while getgenv().AntiAfkExecuted and zeidontop.Parent do
        local pingStat = game:GetService("Stats"):FindFirstChild("PerformanceStats") and game.Stats.PerformanceStats:FindFirstChild("Ping")
        if pingStat then pingLabel.Text = "Ping: " .. math.floor(pingStat:GetValue()) end
        task.wait(1)
    end
end)
