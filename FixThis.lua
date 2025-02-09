_G.CheatEnabled = false
wait(0.5)
_G.CheatEnabled = true

_G.Lockeded = true  -- Set to false to disable the cheat

getgenv().JILCFConfig = {
    PredictionMultiplier = 0.0984,  -- Set your Prediction
    AimAssistStrength = 1,        -- Set AimAssist Strength
    ToggleKey = Enum.KeyCode.Q,      -- Default toggle key
    LockPart = "Head"               -- Default lock part
}

local Camera = Workspace.CurrentCamera
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local connection
local LockedTarget
local camLockActive = false

local function FindNearestEnemy()
    local ClosestDistance, ClosestPlayer = math.huge, nil
    local CenterPosition = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    for _, Player in ipairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer then
            local Character = Player.Character
            if Character and Character:FindFirstChild(getgenv().JILCFConfig.LockPart) and Character:FindFirstChildOfClass("Humanoid").Health > 0 then
                local Position, IsVisibleOnViewport = Camera:WorldToViewportPoint(Character[getgenv().JILCFConfig.LockPart].Position)
                if IsVisibleOnViewport then
                    local Distance = (CenterPosition - Vector2.new(Position.X, Position.Y)).Magnitude
                    if Distance < ClosestDistance then
                        ClosestPlayer = Character[getgenv().JILCFConfig.LockPart]
                        LockedTarget = Player
                        ClosestDistance = Distance
                    end
                end
            end
        end
    end
    return ClosestPlayer
end

local function enableCamLock()
    if not camLockActive and _G.Lockeded then
        local targetPart = FindNearestEnemy()
        if targetPart then
            camLockActive = true
            connection = RunService.RenderStepped:Connect(function()
                if camLockActive and targetPart and targetPart.Parent and targetPart.Parent:FindFirstChild("Humanoid") then
                    local targetPosition = targetPart.Position
                    local targetVelocity = targetPart.Velocity
                    local predictedPosition = targetPosition + (targetVelocity * getgenv().JILCFConfig.PredictionMultiplier)
                    local aimAssistPosition = predictedPosition + (LocalPlayer:GetMouse().Hit.p - Camera.CFrame.Position) * getgenv().JILCFConfig.AimAssistStrength
                    Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, aimAssistPosition), 10)
                else
                    if connection then connection:Disconnect() end
                end
            end)
        end
    end
end

local function disableCamLock()
    if camLockActive then
        camLockActive = false
        if connection then connection:Disconnect() end
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == getgenv().JILCFConfig.ToggleKey then
        if camLockActive then
            disableCamLock()
        else
            enableCamLock()
        end
    end
end)

spawn(function()
    while true do
        wait(0.5)
        if not _G.Lockeded then
            disableCamLock()
            break
        end
    end
end)

local CHairs = {
    ["Star"] = "rbxassetid://18921737577",
    ["X"] = "rbxassetid://18908945667"
}

local Defaults = {
    CrossHair = CHairs.X,
    Color = Color3.fromRGB(255, 0, 0),
    CrossEnabled = false
}

-- Values
local W, A, S, D
local CurrentCrossHair = Defaults.CrossHair
local LockedTarget
local AimCheck1
local AimCheck2

-- Bool Values
local NoFog = false
local FullBright = false
ApplyVisualChanges = false
ResetVisualChanges = false
local Flying = false
local ShowNames = false
local ChamsEnabled = false
local AimEnabled = false
local SmoothAim = false
local CheatExited = false
local FreeCam = false
local ChamsTeamCheck = false

-- Strings
local LockPart = { "Head", "Torso", "HumanoidRootPart" }
local AimType = { "Toggle", "Hold", }

-- Number Values
local namesize = 10
local FlySpeed = 0
local nameoffset = 0
local smoothness = 1
local HighlightTransparency = 0
local NametextTransparency = 0
local ChamsDist = 600
local ColorDiff = 0.4

-- Colors
local ChosenColor = Defaults.Color
local UnivColors = Color3.new(0, 0, 0)
local ChamsType = "Both"

-- Positions
local CurrentCF
local StartPosition

-- Keys
local AimKey = Enum.KeyCode.T

-- UIS
-- instances
local Crosshair = Instance.new("ScreenGui")
local Img = Instance.new("ImageLabel", Crosshair)
local Ratio = Instance.new("UIAspectRatioConstraint", Img)
local Text = Instance.new("TextLabel", Crosshair)
local con
-- properties
Crosshair.Name = "CH"
Crosshair.Parent = game:GetService("CoreGui")
Crosshair.IgnoreGuiInset = true
Img.AnchorPoint = Vector2.new(0.5, 0.5)
Img.BackgroundTransparency = 1
Img.Position = UDim2.new(0.5, 0, 0.5, 0)
Img.Size = UDim2.new(0, 20, 0, 20)
Img.Image = CurrentCrossHair
Img.Visible = Defaults.CrossEnabled
Ratio.AspectRatio = 1
Text.Size = UDim2.fromScale(1, .1)
Text.AnchorPoint = Vector2.new(0, 0.5)
Text.Position = UDim2.new(0.52, 0, 0.5, 0)
Text.BackgroundTransparency = 1
Text.Text = ""
Text.TextSize = 12
Text.TextXAlignment = Enum.TextXAlignment.Left
Text.Visible = false

-- Functions
GetUDim2Dist = function(UD1, UD2)
    local deltaXScale = UD1.X.Scale - UD2.X.Scale
    local deltaXOffset = UD1.X.Offset - UD2.X.Offset
    local deltaYScale = UD1.Y.Scale - UD2.Y.Scale
    local deltaYOffset = UD1.Y.Offset - UD2.Y.Offset

    local distance = math.sqrt(deltaXScale ^ 2 + deltaXOffset ^ 2 + deltaYScale ^ 2 + deltaYOffset ^ 2)
    return distance
end
HighLight = function(charmodel)
    if not charmodel:FindFirstChildOfClass("Highlight") then
        local hl = Instance.new("Highlight", charmodel)
        hl.FillColor = UnivColors
        hl.DepthMode = "AlwaysOnTop"

        if ChamsType == "Outline" then
            hl.OutlineColor = UnivColors
            hl.OutlineTransparency = HighlightTransparency / 10
            hl.FillTransparency = 1
        elseif ChamsType == "Body" then
            hl.FillTransparency = HighlightTransparency / 10
            hl.OutlineTransparency = 1
        elseif ChamsType == "Both" then
            hl.OutlineColor = Color3.new(UnivColors.R - ColorDiff, UnivColors.G - ColorDiff, UnivColors.B - ColorDiff)
            hl.FillTransparency = HighlightTransparency / 10
            hl.OutlineTransparency = HighlightTransparency / 10
        end
        game:GetService("Debris"):AddItem(hl, 0.05)
    end
end
Msg = function(title, text)
    task.spawn(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = 4
        })
    end)
end
ShowName = function(charmodel)
    if charmodel and charmodel.Head then
        if charmodel.Head:FindFirstChildOfClass("BillboardGui") then
            return
        end
        local bg = Instance.new("BillboardGui", charmodel.Head)
        local tb = Instance.new("TextBox", bg)
        bg.AlwaysOnTop = true
        bg.StudsOffsetWorldSpace = Vector3.new(0, 1 + nameoffset * 2, 0)
        bg.Size = UDim2.fromOffset(100, 50)
        tb.Size = UDim2.fromScale(1, 1)
        tb.BackgroundTransparency = 1
        tb.TextSize = namesize
        tb.TextTransparency = NametextTransparency / 10
        tb.ClipsDescendants = false
        tb.TextColor3 = UnivColors
        tb.Text = charmodel.Name .. " [" ..
                      tostring(math.floor((charmodel.Head.Position - workspace.CurrentCamera.CFrame.Position).Magnitude)) ..
                      " S]"
        game:GetService("Debris"):AddItem(bg, 0.05)
    end
end
ShowNameItem = function(Item)
    if Item then
        if Item:FindFirstChildOfClass("BillboardGui") then
            return
        end
        local bg = Instance.new("BillboardGui", Item)
        local tb = Instance.new("TextBox", bg)
        bg.AlwaysOnTop = true
        bg.StudsOffsetWorldSpace = Vector3.new(0, 1 + nameoffset * 2, 0)
        bg.Size = UDim2.fromOffset(100, 50)
        tb.Size = UDim2.fromScale(1, 1)
        tb.BackgroundTransparency = 1
        tb.TextSize = namesize
        tb.ClipsDescendants = false
        tb.TextColor3 = UnivColors
        tb.Text = Item.Name .. " [" ..
                      tostring(math.floor((Item.Position - workspace.CurrentCamera.CFrame.Position).Magnitude)) .. " S]"
        game:GetService("Debris"):AddItem(bg, 0.05)
    end
end
RemoveAllNames = function()
    for _, v in pairs(game:GetService("Players"):GetPlayers()) do
        if v ~= game:GetService("Players").LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and
            v.Character.Head:FindFirstChildOfClass("BillboardGui") then
            v.Character.Head:FindFirstChildOfClass("BillboardGui"):Destroy()
        end
    end
end
RemoveAllHL = function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Highlight") then
            v:Destroy()
        end
    end
end
Teleport = function(Position)
    if game:GetService("Players").LocalPlayer and game:GetService("Players").LocalPlayer.Character then
        CurrentCF = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
        for _, v in pairs(game:GetService("Players"):GetPlayers()) do
            if v ~= game:GetService("Players").LocalPlayer and v.Character and v.Character.HumanoidRootPart then
                local PlayerPosition = v.Character.HumanoidRootPart.Position
                if (Position - PlayerPosition).Magnitude <= 150 then
                    Msg("Failed", "Detected Player Too Close To Area")
                    return
                end
            end
        end
        CurrentCF.CFrame = CFrame.new(Position)
        Msg("Success", "Teleported Successfully")
    else
        Msg("Error", "No Character/Player")
    end
end
TeleportUnrestricted = function(Position)
    CurrentCF.CFrame = CFrame.new(Position)
end
AddBind = function(Key, Func)
    c = game:GetService("UserInputService").InputBegan:Connect(function(input, gs)
        if CheatExited then
            return c:Disconnect()
        end
        if input.KeyCode == Key or input.UserInputType == Key then
            if not gs then
                Func()
            end
        end
    end)
end
AddBindDouble = function(Key, Func)
    local pressed = 0
    local dbtime = 0.3
    c = game:GetService("UserInputService").InputBegan:Connect(function(input, gs)
        if CheatExited then
            return c:Disconnect()
        end
        if input.KeyCode == Key and not gs then
            pressed = pressed + 1
            if pressed == 2 then
                Func()
                pressed = 0
            end
            task.spawn(function()
                wait(dbtime)
                pressed = 0
            end)
        end
    end)
end
AddBindHold = function(Key, Func, Func2)
    local c = game:GetService("UserInputService").InputBegan:Connect(function(input, gs)
        if CheatExited then
            return c:Disconnect()
        end
        if input.KeyCode == Key and not gs then
            Func()
        end
    end)
    local c = game:GetService("UserInputService").InputEnded:Connect(function(input)
        if CheatExited then
            return c:Disconnect()
        end
        if input.KeyCode == Key then
            Func2()
        end
    end)
end
ToggleFlight = function()
    if not FreeCam then
        CurrentCF = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
        local Fly = Flying
        Fly = not Fly

        if Fly then
            Msg("Note", "You Are Invisible when flying")
            local StartPosition = CurrentCF.Position
            TeleportUnrestricted(Vector3.new(0, 100000, 0))
            wait(.1)
            CurrentCF.Anchored = true
            TeleportUnrestricted(StartPosition)
        else
            Msg("Stopped Flying", "Yes")
            CurrentCF.Anchored = false
        end
        Flying = Fly
    else
        Msg("Error", "You Are Already Fake Flying.")
    end
end
ToggleFlightFake = function()
    if not Flying then
        CurrentCF = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
        FreeCam = not FreeCam
        if FreeCam then
            StartPosition = CurrentCF.Position
            Msg("Note", "You Are now fake flying")
            CurrentCF.Anchored = true
        else
            Msg("Stopped Flying", "Yes")
            CurrentCF.Anchored = false
            TeleportUnrestricted(StartPosition)
        end
    else
        Msg("Error", "You Are Already Flying.")
    end
end
UpdatePosition = function()
    CurrentCF = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
    FreeCam = false
    Flying = false
    CurrentCF.Anchored = false
    Msg("Success", "Updated Successfully")
end

-- Library
local colors = {
    SchemeColor = Color3.fromRGB(54, 81, 125),
    Background = Color3.fromRGB(45, 63, 106),
    Header = Color3.fromRGB(46, 86, 106),
    TextColor = Color3.fromRGB(255, 255, 255),
    ElementColor = Color3.fromRGB(52, 104, 117)
}

local function ApplyVisualChanges()
    local lighting = game:GetService("Lighting")
    lighting.FogEnd = math.huge
    lighting.FogStart = math.huge
    lighting.GlobalShadows = false
    lighting.Ambient = Color3.new(1, 1, 1)
    lighting.OutdoorAmbient = Color3.new(1, 1, 1)
    lighting.Brightness = 2
end

-- Function to reset visuals
local function ResetVisualChanges()
    local lighting = game:GetService("Lighting")
    lighting.FogEnd = 100000
    lighting.FogStart = 0
    lighting.GlobalShadows = true
    lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
    lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
    lighting.Brightness = 1
end

local lib = loadstring(game:HttpGet"https://raw.githubusercontent.com/dawid-scripts/UI-Libs/main/Vape.txt")()

local win = lib:Window("BLIZ WARE (RightControl Close/Open)",Color3.fromRGB(0, 0, 0), Enum.KeyCode.RightControl)

local tab = win:Tab("Aimbot")


tab:Toggle("AimLock", false, function(t) _G.Lockeded = t end)
tab:Dropdown("Lock Part", {"Head", "HumanoidRootPart"}, function(currentOption) getgenv().JILCFConfig.LockPart = currentOption end)
tab:Textbox("KeyBind (Big Letter)", true, function(t) getgenv().JILCFConfig.ToggleKey = Enum.KeyCode[t] or Enum.KeyCode.Q end)
tab:Textbox("Prediction", true, function(t) getgenv().JILCFConfig.PredictionMultiplier = tonumber(t) or 0.0984 end)
tab:Toggle("Smooth AimLock", false, function(t) getgenv().JILCFConfig.AimAssistStrength = t and 1 or 0 end)
tab:Slider("AimLock Smoothness", 0, 10, 0, function(t) getgenv().JILCFConfig.AimAssistStrength = t / 1 end)

local tab = win:Tab("Visuals")

tab:Button("Toggle Chams [K]", function()
    ChamsEnabled = not ChamsEnabled
end)

tab:Toggle("Team Check",false, function(state)
    ChamsTeamCheck = state
end)

tab:Slider("Chams Distance",1,100,0, function(value)
    ChamsDist = value * 100
end)

tab:Dropdown("Chams Type",{"Outline","Body","Both"}, function(currentOption)
    ChamsType = currentOption
end)

tab:Toggle("Show Names",false, function(state)
    ShowNames = state
end)

tab:Slider("Name Size",5,15,0, function(value)
    namesize = value
end)

tab:Slider("Name Height",0,10,0, function(value)
    nameoffset = value
end)

tab:Slider("Chams Opacity",0,10,0, function(value)
    HighlightTransparency = value
end)

tab:Slider("Name Opacity",0,10,0, function(value)
    NametextTransparency = value
end)


tab:Colorpicker("Colorpicker",Color3.fromRGB(0,0,0), function(color)
    ChosenColor = color
end)


tab:Toggle("Crosshair",false, function(state)
    Img.Visible = state
end)

tab:Toggle("Closest Player",false, function(state)
    Text.Visible = state
end)

local tab = win:Tab("Character")

tab:Button("Invis Fly [2x Tab]", function()
    ToggleFlight()
end)

tab:Button("FreeCam [2x Equals Sign (=)]", function()
    ToggleFlightFake()
end)

tab:Button("Update Position [2x Backquote (`)[Above Tab]]", function()
    UpdatePosition()
end)

tab:Slider("Fly Speed",0,100,0, function(value)
    FlySpeed = value / 10
end)

local tab = win:Tab("World")

tab:Button("Remove Fog (Won't be able to be back)", function()
    NoFog = not NoFog
end)

tab:Button("Full Bright", function()
    FullBright = not FullBright
end)

tab:Button("Enable Clear Visuals", ApplyVisualChanges)
tab:Button("Reset Visuals", ResetVisualChanges)

local tab = win:Tab("Misc")

tab:Button("Stop Cheat (Will be useless, Execute it again)", function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Highlight") then
            v:Destroy()
			end
		end
	    for _, v in pairs(game:GetService("Players"):GetPlayers()) do
        if v ~= game:GetService("Players").LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and
            v.Character.Head:FindFirstChildOfClass("BillboardGui") then
            v.Character.Head:FindFirstChildOfClass("BillboardGui"):Destroy()
        end
    end
	    local lighting = game:GetService("Lighting")

    lighting.ColorShift_Bottom = Color3.new(0, 0, 0)  -- Reset to default
    lighting.ColorShift_Top = Color3.new(0, 0, 0)  -- Reset to default
    lighting.GlobalShadows = true  -- Enable shadows back
    lighting.Ambient = Color3.new(0.5, 0.5, 0.5)  -- Default ambient
    lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)  -- Default outdoor ambient
    lighting.Brightness = 2  -- Default brightness
    lighting.ClockTime = 12  -- Default time
    UpdatePosition()
	local ChamsEnabled = false
    _G.CheatEnabled = false
end)

tab:Button("Copy Discord", function()
    setclipboard("https://discord.gg/FVZusaezUh")
end)

-- Binds

AddBind(Enum.KeyCode.K, function()
    ChamsEnabled = not ChamsEnabled
end)
AddBindDouble(Enum.KeyCode.Equals, function()
    ToggleFlightFake()
end)
AddBindDouble(Enum.KeyCode.Tab, function()
    ToggleFlight()
end)
AddBindDouble(Enum.KeyCode.Backquote, function()
    UpdatePosition()
end)
AddBindHold(Enum.KeyCode.W, function()
    W = true
end, function()
    W = false
end)
AddBindHold(Enum.KeyCode.A, function()
    A = true
end, function()
    A = false
end)
AddBindHold(Enum.KeyCode.S, function()
    S = true
end, function()
    S = false
end)
AddBindHold(Enum.KeyCode.D, function()
    D = true
end, function()
    D = false
end)

spawn(function()
    con = game:GetService("RunService").RenderStepped:Connect(function()
        if not _G.CheatEnabled then
            ChamsEnabled = false
            ShowNames = false
            CheatExited = true
            Flying = false
            NoFog = false
			ApplyVisualChanges = false
			ResetVisualChanges = false
            FullBright = false
            Crosshair:Destroy()
            RemoveAllNames()
            RemoveAllHL()
            return con:Disconnect()
        end

        if FullBright then
            game:GetService("Lighting").ColorShift_Bottom = Color3.new(.6, .6, .6)
            game:GetService("Lighting").ColorShift_Top = Color3.new(.6, .6, .6)
            game:GetService("Lighting").GlobalShadows = false
            game:GetService("Lighting").Ambient = Color3.new(.6, .6, .6)
            game:GetService("Lighting").OutdoorAmbient = Color3.new(.6, .6, .6)
            game:GetService("Lighting").Brightness = 1.2
            game:GetService("Lighting").ClockTime = 2
        end
        if NoFog then
            game:GetService("Lighting").FogEnd = math.huge
            game:GetService("Lighting").FogStart = math.huge
            if game:GetService("Lighting"):FindFirstChildOfClass("Atmosphere") then
                game:GetService("Lighting"):FindFirstChildOfClass("Atmosphere"):Destroy()
            end
        end
        if ChamsEnabled then
            for _, v in pairs(game:GetService("Players"):GetPlayers()) do
                if v ~= game:GetService("Players").LocalPlayer then
                    if v.Character and v.Character:FindFirstChild("Head") and
                        (v.Character.Head.Position - workspace.CurrentCamera.CFrame.Position).Magnitude < ChamsDist then
                        if ChamsTeamCheck then
                            if v.Team ~= game:GetService("Players").LocalPlayer.Team then
                                HighLight(v.Character)
                            end
                        else
                            HighLight(v.Character)
                        end
                    end
                end
            end
        end
        if ShowNames then
            for _, v in pairs(game:GetService("Players"):GetPlayers()) do
                if v ~= game:GetService("Players").LocalPlayer then
                    if v.Character and v.Character:FindFirstChild("Head") then
                        ShowName(v.Character)
                    end
                end
            end
        end

        local Dist = math.huge
        local ChosenPlayer = nil
        local Magnitude2
        for _, v in pairs(game:GetService("Players"):GetPlayers()) do
            if v and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v ~=
                game:GetService("Players").LocalPlayer then
                local PlayerPos = v.Character.HumanoidRootPart.Position
                local MyPos = workspace.CurrentCamera.CFrame.Position
                local Magnitude = (PlayerPos - MyPos).Magnitude
                if Magnitude < Dist then
                    Dist = Magnitude
                    ChosenPlayer = v
                    Magnitude2 = Magnitude
                end
            end
        end
        if ChosenPlayer then
            Text.Text = "closest: " .. ChosenPlayer.Name .. " [" .. tostring(math.floor(Magnitude2)) .. "]"
        else
            Text.Text = ""
        end

        if FreeCam and not Flying then
            local FlySpd = 1 + FlySpeed
            CurrentCF = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
            local lv = workspace.CurrentCamera.CFrame.LookVector
            local rv = workspace.CurrentCamera.CFrame.RightVector
            local uv = workspace.CurrentCamera.CFrame.UpVector

            if W then
                CurrentCF.CFrame = CurrentCF.CFrame + (lv * FlySpd) + uv / 10
            end
            if A then
                CurrentCF.CFrame = CurrentCF.CFrame - (rv * FlySpd)
            end
            if S then
                CurrentCF.CFrame = CurrentCF.CFrame - (lv * FlySpd) + uv / 10
            end
            if D then
                CurrentCF.CFrame = CurrentCF.CFrame + (rv * FlySpd)
            end
        end
        if Flying and not FreeCam then
            local FlySpd = 1 + FlySpeed
            CurrentCF = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
            local lv = workspace.CurrentCamera.CFrame.LookVector
            local rv = workspace.CurrentCamera.CFrame.RightVector
            local uv = workspace.CurrentCamera.CFrame.UpVector

            if W then
                CurrentCF.CFrame = CurrentCF.CFrame + (lv * FlySpd) + uv / 10
            end
            if A then
                CurrentCF.CFrame = CurrentCF.CFrame - (rv * FlySpd)
            end
            if S then
                CurrentCF.CFrame = CurrentCF.CFrame - (lv * FlySpd)
            end
            if D then
                CurrentCF.CFrame = CurrentCF.CFrame + (rv * FlySpd)
            end
        end
        UnivColors = ChosenColor
        Img.ImageColor3 = ChosenColor
        Text.TextColor3 = ChosenColor
        if AimEnabled then
            if not LockedTarget then
                local function GetClosestPlayerToMouse()
                    local mouse = game:GetService("Players").LocalPlayer:GetMouse()
                    local dist = math.huge
                    for _, v in pairs(game:GetService("Players"):GetChildren()) do
                        if v:IsA("Player") and v ~= game:GetService("Players").LocalPlayer and v.Character and
                            v.Character:FindFirstChildOfClass("Humanoid") and
                            v.Character:FindFirstChildOfClass("Humanoid").Health > 0 then

                            local char = v.Character
                            local Hum = char:FindFirstChild("HumanoidRootPart")
                            if not Hum then
                                return
                            end

                            local posv3 = workspace.CurrentCamera:WorldToViewportPoint(Hum.Position)
                            local screenpos = UDim2.fromOffset(posv3.X, posv3.Y)
                            if posv3.Z > 0.5 and posv3.Z < maxdist2 then
                                local calculated = GetUDim2Dist(screenpos, UDim2.fromOffset(mouse.X, mouse.Y))
                                if calculated < dist then
                                    LockedTarget = v
                                    dist = calculated
                                end
                            end
                        end
                    end
                    if LockedTarget and dist < maxdist then
                        return LockedTarget
                    end
                    return nil
                end
local locked = GetClosestPlayerToMouse()
if locked and locked.Character then
    local character = locked.Character
    local humanoid = character:FindFirstChildOfClass("Humanoid")

    -- Check if the character and humanoid exist
    if humanoid then
        -- Prioritize which part to aim at (R6 = "Torso", R15 = "HumanoidRootPart")
        local targetPart = character:FindFirstChild("Head") 
		    or character:FindFirstChild("Torso") 
            or character:FindFirstChild("HumanoidRootPart")

        if targetPart then
            humanoid.Died:Connect(function()
                locked = nil
            end)

            local cam = workspace.CurrentCamera

            if SmoothAim then
                cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, targetPart.Position), smoothness)
            else
                cam.CFrame = CFrame.new(cam.CFrame.Position, targetPart.Position)
            end
        end
    end
end
            elseif LockedTarget then
                -- check choosen dudes distance to not accidently lock him when he dies, and not change mid lock
                local mouse = game:GetService("Players").LocalPlayer:GetMouse()
                if LockedTarget.Character then
                    local humm = LockedTarget.Character:FindFirstChildOfClass("Humanoid")
                    if humm and humm.health > 0 then
                        local char = LockedTarget.Character
                        local Hum = char:FindFirstChild(LockPart)
                        if not Hum then
                            LockedTarget = nil
                            return
                        end

                        local posv3 = workspace.CurrentCamera:WorldToViewportPoint(Hum.Position)
                        local screenpos = UDim2.fromOffset(posv3.X, posv3.Y)
                        if posv3.Z > 0.5 then
                            local calculated = GetUDim2Dist(screenpos, UDim2.fromOffset(mouse.X, mouse.Y))
                            if calculated > maxdist then
                                LockedTarget = nil
                            else
                                local cam = workspace.CurrentCamera
                                if SmoothAim then
                                    cam.CFrame = cam.CFrame:Lerp(
                                        CFrame.new(cam.CFrame.Position, LockedTarget.Character[LockPart].Position),
                                        smoothness)
                                else
                                    cam.CFrame = CFrame.new(cam.CFrame.Position,
                                        LockedTarget.Character[LockPart].Position)
                                end
                            end
                        else
                            LockedTarget = nil
                        end
                    else
                        LockedTarget = nil
                    end
                else
                    LockedTarget = nil
                end
            end
        else
            LockedTarget = nil
        end
    end)
    while _G.CheatEnabled do
        wait(.2)
        RemoveAllNames()
        RemoveAllHL()
    end
end)
