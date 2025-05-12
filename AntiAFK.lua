repeat wait() until game:IsLoaded() and game.Players and game.Players.LocalPlayer and game.Players.LocalPlayer.Character

if getgenv().AntiAfkExecuted and kaiiontop then 
    getgenv().AntiAfkExecuted = false
	getgenv().Kaii = false
	game.CoreGui.kaiiontop:Destroy()
end

getgenv().AntiAfkExecuted = true

local kaiiontop = Instance.new("ScreenGui")
local madebykaii = Instance.new("Frame")
local UICornerw = Instance.new("UICorner")
local DestroyButton = Instance.new("TextButton")
local trenchkid = Instance.new("TextLabel")
local xtazy = Instance.new("TextLabel")
local fpslabel = Instance.new("TextLabel")
local enkai = Instance.new("TextLabel")
local pinglabel = Instance.new("TextLabel")
local kaiieee = Instance.new("Frame")
local UICornerww = Instance.new("UICorner")
local blizware = Instance.new("TextLabel")

kaiiontop.Name = "kaiiontop"
kaiiontop.Parent = game.CoreGui
kaiiontop.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

madebykaii.Name = "madebykaii"
madebykaii.Parent = kaiiontop
madebykaii.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
madebykaii.Position = UDim2.new(0.423, 0, 0.1, 0)
madebykaii.Size = UDim2.new(0, 225, 0, 96)

UICornerw.Name = "UICornerw"
UICornerw.Parent = madebykaii

DestroyButton.Name = "DestroyButton"
DestroyButton.Parent = madebykaii
DestroyButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
DestroyButton.BackgroundTransparency = 1
DestroyButton.Position = UDim2.new(0.9, 0, 0.042, 0)
DestroyButton.Size = UDim2.new(0, 15, 0, 15)
DestroyButton.Font = Enum.Font.GothamBold
DestroyButton.Text = "X"
DestroyButton.TextColor3 = Color3.fromRGB(255, 0, 0)
DestroyButton.TextSize = 20

DestroyButton.MouseButton1Click:connect(function()
	getgenv().AntiAfkExecuted = false
	
	wait(0.1)
	kaiiontop:Destroy()
end)

trenchkid.Name = "trenchkid"
trenchkid.Parent = madebykaii
trenchkid.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
trenchkid.BackgroundTransparency = 1.000
trenchkid.Position = UDim2.new(0.25, 0, 0, 0)
trenchkid.Size = UDim2.new(0, 95, 0, 24)
trenchkid.Font = Enum.Font.Merriweather
trenchkid.Text = "ANTI AFK BY KAII | (@binggrae_.)"
trenchkid.TextColor3 = Color3.fromRGB(255, 255, 255)
trenchkid.TextSize = 13.75

xtazy.Name = "xtazy"
xtazy.Parent = madebykaii
xtazy.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
xtazy.BackgroundTransparency = 1.000
xtazy.Position = UDim2.new(0.13, 0, 0.36, 0)
xtazy.Size = UDim2.new(0, 29, 0, 24)
xtazy.Font = Enum.Font.GothamBold
xtazy.Text = "Ping: "
xtazy.TextColor3 = Color3.fromRGB(255, 255, 255)
xtazy.TextSize = 14.000

fpslabel.Name = "fpslabel"
fpslabel.Parent = madebykaii
fpslabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
fpslabel.BackgroundTransparency = 1.000
fpslabel.Position = UDim2.new(0.725, 0, 0.36, 0)
fpslabel.Size = UDim2.new(0, 55, 0, 24)
fpslabel.Font = Enum.Font.GothamBold
fpslabel.Text = "SAM"
fpslabel.TextColor3 = Color3.fromRGB(255, 255, 255)
fpslabel.TextSize = 14.000

enkai.Name = "enkai"
enkai.Parent = madebykaii
enkai.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
enkai.BackgroundTransparency = 1.000
enkai.Position = UDim2.new(0.605, 0, 0.36, 0)
enkai.Size = UDim2.new(0, 26, 0, 24)
enkai.Font = Enum.Font.GothamBold
enkai.Text = "Fps: "
enkai.TextColor3 = Color3.fromRGB(255, 255, 255)
enkai.TextSize = 14.000

pinglabel.Name = "pinglabel"
pinglabel.Parent = madebykaii
pinglabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
pinglabel.BackgroundTransparency = 1.000
pinglabel.Position = UDim2.new(0.25, 0, 0.36, 0)
pinglabel.Size = UDim2.new(0, 55, 0, 24)
pinglabel.Font = Enum.Font.GothamBold
pinglabel.Text = "KAII"
pinglabel.TextColor3 = Color3.fromRGB(255, 255, 255)
pinglabel.TextSize = 14.000
pinglabel.TextWrapped = true

kaiieee.Name = "kaiieee"
kaiieee.Parent = madebykaii
kaiieee.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
kaiieee.Position = UDim2.new(0.00444444455, 0, 0.243312627, 0)
kaiieee.Size = UDim2.new(0, 224, 0, 5)

UICornerww.CornerRadius = UDim.new(0, 50)
UICornerww.Name = "UICornerww"
UICornerww.Parent = kaiieee

blizware.Name = "blizware"
blizware.Parent = madebykaii
blizware.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
blizware.BackgroundTransparency = 1.000
blizware.Position = UDim2.new(0.285, 0, 0.7, 0)
blizware.Size = UDim2.new(0, 95, 0, 12)
blizware.Font = Enum.Font.Creepster
blizware.Text = "ANTI AFK ENABLED"
blizware.TextColor3 = Color3.fromRGB(255, 255, 255)
blizware.TextSize = 35



local Drag = game.CoreGui.kaiiontop.madebykaii
gsCoreGui = game:GetService("CoreGui")
gsTween = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local dragging
local dragInput
local dragStart
local startPos
local function update(input)
	local delta = input.Position - dragStart
	local dragTime = 0.04
	local SmoothDrag = {}
	SmoothDrag.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	local dragSmoothFunction = gsTween:Create(Drag, TweenInfo.new(dragTime, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), SmoothDrag)
	dragSmoothFunction:Play()
end
Drag.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = Drag.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)
Drag.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging and Drag.Size then
		update(input)
	end
end)



local Kai = game:service'VirtualUser'

game:service'Players'.LocalPlayer.Idled:connect(function()
	Kai:CaptureController()
	Kai:ClickButton2(Vector2.new())
end)




local FPSsLabel = fpslabel
local RunService = game:GetService("RunService")
local RenderStepped = RunService.RenderStepped
local sec = nil
local FPS = {}

local function fre()
	local fr = tick()
	for index = #FPS,1,-1 do
		FPS[index + 1] = (FPS[index] >= fr - 1) and FPS[index] or nil
	end
	FPS[1] = fr
	local fps = (tick() - sec >= 1 and #FPS) or (#FPS / (tick() - sec))
	fps = math.floor(fps)
	fpslabel.Text = fps
end


sec = tick()
RenderStepped:Connect(fre)




spawn(function()
	repeat
		wait(1)
		local ping = tonumber(game:GetService("Stats"):FindFirstChild("PerformanceStats").Ping:GetValue())
		ping = math.floor(ping)
		pinglabel.Text = ping



	until pinglabel == nil
end)

local saniye = 0



local dakika = 0



local saat = 0




getgenv().Kaii = true

while true do


		if getgenv().Kaii then

			saniye = saniye + 1

			wait(1)

		end


		if saniye >= 60 then
			saniye = 0
			dakika = dakika + 1

		end


		if dakika >= 60 then
			dakika = 0
			saat = saat + 1

		end
	end

    game:GetService("Players").LocalPlayer.Idled:Connect(function()
    local VirtualUser = game:GetService("VirtualUser")
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)
