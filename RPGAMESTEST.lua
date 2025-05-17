local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Fetch valid keys remotely
local success, validKeys = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/HoodGames/Script/main/Yek.lua"))()
end)

-- If failed to fetch keys
if not success or type(validKeys) ~= "table" then
    LocalPlayer:Kick("Acess Denied: .gg/trenchkid and go join kwarto ni kaii")
    return
end

-- Get key from executor environment
local inputKey = getgenv().kaii

-- Validate key
local function isValidKey(key)
    for _, v in ipairs(validKeys) do
        if key == v then return true end
    end
    return false
end

-- Kick if key is invalid or missing
if not inputKey or not isValidKey(inputKey) then
    LocalPlayer:Kick("Access Denied: .gg/trenchkid and go join kwarto ni kaii")
    return
end

-- ✅ Key is valid, continue to load the hub
local hubSuccess, err = pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/HoodGames/Script/main/GuiEntry.lua"))()
end)

if not hubSuccess then
    warn("Hub script failed to load:", err)
end


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local AimbotEnabled = false
local LockPart = "Head"

local function IsAlive(player)
	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	return humanoid and humanoid.Health > 0
end

local function GetClosestToMouse()
	local closestPlayer, shortestDist = nil, math.huge
	local mousePos = UserInputService:GetMouseLocation()

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and IsAlive(player) then
			local part = player.Character and player.Character:FindFirstChild(LockPart)
			if part then
				local screenPoint, onScreen = Camera:WorldToViewportPoint(part.Position)
				if onScreen then
					local dist = (Vector2.new(screenPoint.X, screenPoint.Y) - mousePos).Magnitude
					if dist < shortestDist then
						shortestDist = dist
						closestPlayer = player
					end
				end
			end
		end
	end

	return closestPlayer
end

RunService.RenderStepped:Connect(function()
	if AimbotEnabled and IsAlive(LocalPlayer) then
		local target = GetClosestToMouse()
		if target and target.Character then
			local targetPart = target.Character:FindFirstChild(LockPart)
			if targetPart then
				Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
			end
		end
	end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.X then
		AimbotEnabled = not AimbotEnabled
	end
end)


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local ESPEnabled = false
local ESPCache = {}

local function createOutlineESP(character, player)
    if ESPCache[player] then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "PlayerESPHighlight"
    highlight.FillTransparency = 1
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = character

    local head = character:FindFirstChild("Head")
    if head then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "PlayerESPName"
        billboard.Size = UDim2.new(0, 200, 0, 30)
        billboard.StudsOffset = Vector3.new(0, 2.5, 0)
        billboard.Adornee = head
        billboard.AlwaysOnTop = true

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 1, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.TextStrokeTransparency = 0.5
        nameLabel.Font = Enum.Font.SourceSansBold
        nameLabel.TextSize = 14
	nameLabel.Text = player.DisplayName .. " (@" .. player.Name .. ")"
        nameLabel.Parent = billboard

        billboard.Parent = head
    end

    ESPCache[player] = true
end

local function removeESP(player)
    if not player.Character then return end

    local highlight = player.Character:FindFirstChild("PlayerESPHighlight")
    if highlight then highlight:Destroy() end

    local head = player.Character:FindFirstChild("Head")
    if head then
        local billboard = head:FindFirstChild("PlayerESPName")
        if billboard then billboard:Destroy() end
    end

    ESPCache[player] = nil
end

local function updateESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            createOutlineESP(player.Character, player)
        end
    end
end

local function clearAllESP()
    for player in pairs(ESPCache) do
        removeESP(player)
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.Tab and not gameProcessed then
        ESPEnabled = true
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.Tab and not gameProcessed then
        ESPEnabled = false
        clearAllESP()
    end
end)

RunService.Heartbeat:Connect(function()
    if ESPEnabled then
        updateESP()
    end
end)

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

local function GNT()
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")
    if not humanoid then return end

    local CT = nil
    local SD = math.huge

    for _, item in ipairs(Workspace:GetChildren()) do
        if item:IsA("BackpackItem") and item:FindFirstChild("Handle") then
            local distance = (character.PrimaryPart.Position - item.Handle.Position).Magnitude
            if distance < SD then
                SD = distance
                CT = item
            end
        end
    end

    if CT then
        humanoid:EquipTool(CT)
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.P then
        GNT()
    end
end)

https://raw.githubusercontent.com/HoodGames/Script/refs/heads/main/PanginoongKaiiPackage
