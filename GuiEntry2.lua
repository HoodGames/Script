local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = PlayerGui

local Notification = Instance.new("Frame")
Notification.Parent = ScreenGui
Notification.Size = UDim2.new(0.4, 0, 0.2, 0)
Notification.Position = UDim2.new(0.3, 0, 0.74, 0)  -- Slightly higher position
Notification.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Notification.BackgroundTransparency = 0.2
Notification.BorderSizePixel = 0

local MainText = Instance.new("TextLabel")
MainText.Parent = Notification
MainText.Size = UDim2.new(1, 0, 0.5, 0)
MainText.Position = UDim2.new(-0.13, 0, 0.1, 0)
MainText.BackgroundTransparency = 1
MainText.TextColor3 = Color3.fromRGB(255, 255, 255)
MainText.Font = Enum.Font.GothamBold
MainText.TextSize = 50
MainText.Text = "Access Granted!"
MainText.TextXAlignment = Enum.TextXAlignment.Center
MainText.TextWrapped = true

local SubText = Instance.new("TextLabel")
SubText.Parent = Notification
SubText.Size = UDim2.new(1, 0, 0.5, 0)
SubText.Position = UDim2.new(-0.13, 0, 0.5, 0)
SubText.BackgroundTransparency = 1
SubText.TextColor3 = Color3.fromRGB(255, 255, 255)
SubText.Font = Enum.Font.Gotham
SubText.TextSize = 35
SubText.Text = "Welcome, " .. LocalPlayer.Name
SubText.TextXAlignment = Enum.TextXAlignment.Center
SubText.TextWrapped = true

local Title = Instance.new("TextLabel")
Title.Parent = Notification
Title.Size = UDim2.new(1, 0, 0.3, 0)
Title.Position = UDim2.new(0, 0, -0.35, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.Fantasy
Title.TextSize = 45
Title.Text = "BLIZ WARE"
Title.TextScaled = true
Title.TextTransparency = 1 

local TitleGlow = Instance.new("UIStroke")
TitleGlow.Parent = Title
TitleGlow.Thickness = 3
TitleGlow.Color = Color3.fromRGB(255, 255, 255)
TitleGlow.Transparency = 1 

local Avatar = Instance.new("ImageLabel")
Avatar.Parent = Notification
Avatar.Size = UDim2.new(0.25, 0, 0.8, 0)
Avatar.Position = UDim2.new(0.72, 0, 0.1, 0)
Avatar.BackgroundTransparency = 1
Avatar.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=420&height=420&format=png"
Avatar.ImageTransparency = 1 

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.1, 0)
UICorner.Parent = Notification

Notification.BackgroundTransparency = 1
MainText.TextTransparency = 1
SubText.TextTransparency = 1
Title.TextTransparency = 1

local fadeInTween1 = TweenService:Create(Notification, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
    BackgroundTransparency = 0.2
})
local fadeInTween2 = TweenService:Create(MainText, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
    TextTransparency = 0
})
local fadeInTween3 = TweenService:Create(SubText, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
    TextTransparency = 0
})
local fadeInTween4 = TweenService:Create(Title, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
    TextTransparency = 0
})
local fadeInTween5 = TweenService:Create(TitleGlow, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
    Transparency = 0.2
})
local fadeInTween6 = TweenService:Create(Avatar, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
    ImageTransparency = 0
})

fadeInTween1:Play()
fadeInTween2:Play()
fadeInTween3:Play()
fadeInTween4:Play()
fadeInTween5:Play()
fadeInTween6:Play()

task.wait(3)

local moveUpTween = TweenService:Create(Notification, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
    Position = UDim2.new(0.3, 0, 0.1, 0)  -- Move it further up by reducing the Y value more
})

moveUpTween:Play()

task.wait(1) -- Wait for the movement to complete

local fadeOutTween1 = TweenService:Create(Notification, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
    BackgroundTransparency = 1
})
local fadeOutTween2 = TweenService:Create(MainText, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
    TextTransparency = 1
})
local fadeOutTween3 = TweenService:Create(SubText, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
    TextTransparency = 1
})
local fadeOutTween4 = TweenService:Create(Title, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
    TextTransparency = 1
})
local fadeOutTween5 = TweenService:Create(TitleGlow, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
    Transparency = 1
})
local fadeOutTween6 = TweenService:Create(Avatar, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
    ImageTransparency = 1
})

fadeOutTween1:Play()
fadeOutTween2:Play()
fadeOutTween3:Play()
fadeOutTween4:Play()
fadeOutTween5:Play()
fadeOutTween6:Play()

fadeOutTween1.Completed:Connect(function()
    ScreenGui:Destroy()
end)
