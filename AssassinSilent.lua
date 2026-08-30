local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

Rayfield:LoadConfiguration()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer

-- ==================== AUTO EXECUTE ON REJOIN / SERVER HOP ====================
local queueteleport = (syn and syn.queue_on_teleport) 
    or queue_on_teleport 
    or (fluxus and fluxus.queue_on_teleport)
    or (getgenv() and getgenv().queue_on_teleport)

local KeepOnTeleport = true

local TeleportCheck = false
LocalPlayer.OnTeleport:Connect(function()
    if KeepOnTeleport and not TeleportCheck and queueteleport then
        TeleportCheck = true
        queueteleport([[
            loadstring(game:HttpGet("https://raw.githubusercontent.com/HoodGames/Script/refs/heads/main/AssassinSilent.lua"))()
        ]])
    end
end)
-- ===========================================================================

local Window = Rayfield:CreateWindow({
    Name = "Silent Assassin by /HOEZA",
    LoadingTitle = "Silent Assassin",
    LoadingSubtitle = "by /HOEZA",
    ToggleUIKeybind = "P",
    ConfigurationSaving = { Enabled = true, FileName = "Big Hub" },
    Discord = { Enabled = true, Invite = "https://discord.gg/invite/kCRuPVxcPD" },
    KeySystem = false,
    KeySettings = { Title = "Join /HOEZA (discord.gg/kCRuPVxcPD)", Note = "Ping @ogwhimpergod in wrld", Key = {"hoezaontop", "HOEZAONTOP", "Hoezaontop"} }
})

local Tab = Window:CreateTab("Main", 4432090463)
Tab:CreateSection("Main Scripts")
Tab:CreateDivider()

local EspEnabled = false
local EspColor = Color3.fromRGB(255, 0, 0)
local EspTransparency = 0.5

local function CleanVisuals(char)
    if not char then return end
    for _, obj in ipairs(char:GetDescendants()) do
        if obj:IsA("BoxHandleAdornment") and obj.Name == "ZeidCham" then
            obj:Destroy()
        end
    end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        local tag = hrp:FindFirstChild("ZeidTag")
        if tag then tag:Destroy() end
    end
end

Tab:CreateToggle({
    Name = "ESP",
    CurrentValue = false,
    Callback = function(v) 
        EspEnabled = v 
        if not v then
            for _, player in ipairs(Players:GetPlayers()) do
                if player.Character then
                    CleanVisuals(player.Character)
                end
            end
        end
        Rayfield:Notify({
            Title = "Visuals",
            Content = v and "ESP Enabled" or "ESP Disabled",
            Duration = 2,
            Image = 4432090463,
        })
    end
})

Tab:CreateColorPicker({
    Name = "ESP Color",
    Color = EspColor,
    Flag = "ESPColor",
    Callback = function(Value)
        EspColor = Value
    end
})

Tab:CreateSlider({
    Name = "ESP Transparency",
    Range = {0, 1},
    Increment = 0.05,
    Suffix = "Transparency",
    CurrentValue = 0.5,
    Flag = "ESPTransparency",
    Callback = function(Value)
        EspTransparency = Value
    end
})

Tab:CreateDivider()

local Label = Tab:CreateLabel("BLATANT MODE", 4483362458, Color3.fromRGB(255, 255, 255), false)

local AutoAttackEnabled = false
local AttackRange = 10
local AttackDelay = 0.05

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local p = Players.LocalPlayer
local Event = RS:WaitForChild("Events"):WaitForChild("GameRemoteFunction")

local Toggle = Tab:CreateToggle({
    Name = "Enable Kill Aura / Auto Attack",
    CurrentValue = false,
    Flag = "KillAuraToggle",
    Callback = function(Value)
        AutoAttackEnabled = Value
    end,
})

local RangeSlider = Tab:CreateSlider({
    Name = "Attack Range",
    Range = {10, 100},
    Increment = 5,
    Suffix = " Studs",
    CurrentValue = 10,
    Flag = "RangeSlider",
    Callback = function(Value)
        AttackRange = Value
    end,
})

local SpeedSlider = Tab:CreateSlider({
    Name = "Attack Speed (Delay)",
    Range = {0.01, 0.5},
    Increment = 0.01,
    Suffix = "s",
    CurrentValue = 0.05,
    Flag = "SpeedSlider",
    Callback = function(Value)
        AttackDelay = Value
    end,
})

Tab:CreateDivider()

-- ==================== SERVER HOP ====================
local AutoServerHopEnabled = false

local function ServerHop()
    local success, err = pcall(function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end)
    if not success then
        Rayfield:Notify({
            Title = "Server Hop",
            Content = "Failed: " .. tostring(err),
            Duration = 3,
            Image = 4432090463,
        })
    end
end

Tab:CreateToggle({
    Name = "Auto Server Hop",
    CurrentValue = false,
    Flag = "AutoServerHop",
    Callback = function(Value)
        AutoServerHopEnabled = Value
        Rayfield:Notify({
            Title = "Server Hop",
            Content = Value and "Auto Server Hop Enabled" or "Auto Server Hop Disabled",
            Duration = 2,
            Image = 4432090463,
        })
    end,
})

Tab:CreateButton({
    Name = "Server Hop",
    Callback = function()
        Rayfield:Notify({
            Title = "Server Hop",
            Content = "Hopping to a new server...",
            Duration = 2,
            Image = 4432090463,
        })
        ServerHop()
    end,
})

Tab:CreateDivider()

Tab:CreateToggle({
    Name = "Keep Script on Teleport / Rejoin",
    CurrentValue = true,
    Flag = "KeepOnTeleport",
    Callback = function(Value)
        KeepOnTeleport = Value
        Rayfield:Notify({
            Title = "Auto Execute",
            Content = Value and "Script will re-execute after teleport/rejoin" or "Script will NOT re-execute after teleport",
            Duration = 3,
            Image = 4432090463,
        })
    end,
})

Tab:CreateButton({
    Name = "Destroy UI",
    Callback = function()
        AutoAttackEnabled = false
        AutoServerHopEnabled = false
        Rayfield:Destroy()
    end,
})

-- Auto Server Hop loop (checks every 5 seconds)
task.spawn(function()
    while true do
        if AutoServerHopEnabled then
            local playerCount = #Players:GetPlayers()
            if playerCount <= 1 then -- only you left / empty server
                Rayfield:Notify({
                    Title = "Auto Server Hop",
                    Content = "No other players detected, hopping...",
                    Duration = 2,
                    Image = 4432090463,
                })
                task.wait(1)
                ServerHop()
            end
        end
        task.wait(5)
    end
end)

RunService.Heartbeat:Connect(function()
    if not EspEnabled then return end

    for _, v in ipairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local char = v.Character
            local hrp = char.HumanoidRootPart

            for _, part in ipairs(char:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    local box = part:FindFirstChild("ZeidCham")
                    if not box then
                        box = Instance.new("BoxHandleAdornment")
                        box.Name = "ZeidCham"
                        box.AlwaysOnTop = true
                        box.ZIndex = 10
                        box.Parent = part
                    end
                    box.Adornee = part
                    box.Size = part.Size
                    box.Color3 = EspColor
                    box.Transparency = EspTransparency
                end
            end

            local tag = hrp:FindFirstChild("ZeidTag")
            if not tag then
                tag = Instance.new("BillboardGui")
                tag.Name = "ZeidTag"
                tag.Size = UDim2.new(0, 200, 0, 50)
                tag.StudsOffset = Vector3.new(0, 3.5, 0)
                tag.AlwaysOnTop = true

                local tl = Instance.new("TextLabel")
                tl.Name = "Label"
                tl.BackgroundTransparency = 1
                tl.Size = UDim2.new(1, 0, 1, 0)
                tl.Font = Enum.Font.SourceSansBold
                tl.TextSize = 16
                tl.TextStrokeTransparency = 0
                tl.Parent = tag
                tag.Parent = hrp
            end

            tag.Label.Text = v.DisplayName .. " (@" .. v.Name .. ")"
            tag.Label.TextColor3 = EspColor
        end
    end
end)

task.spawn(function()
    while true do
        if AutoAttackEnabled then
            local myChar = p.Character
            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
            local tool = myChar and myChar:FindFirstChildOfClass("Tool")
            
            if myRoot and tool then
                local targets = {}
                for _, v in pairs(workspace:GetChildren()) do
                    if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v ~= myChar then
                        local dist = (v.HumanoidRootPart.Position - myRoot.Position).Magnitude
                        if dist <= AttackRange then
                            if dist > 10 then 
                                myRoot.CFrame = CFrame.new(myRoot.Position, v.HumanoidRootPart.Position) 
                            end
                            table.insert(targets, {
                                direction = (v.HumanoidRootPart.Position - myRoot.Position).Unit,
                                isClosestEnemy = false,
                                origin = myRoot.Position,
                                enemyModel = v,
                                distance = dist,
                                knockback = 50
                            })
                        end
                    end
                end
                
                if #targets > 0 then
                    local payload = {
                        attackCycleData = { knockbackMul = 1, slowMult = 0.2, slowTime = 1.5, lungeMul = 1, attackTime = 0.1 },
                        knockback = 50, shouldLock = true, slowTime = 1.5, shouldLunge = true, isCritical = true,
                        weaponDefinition = {
                            attackCycle = {
                                ["1"] = { knockbackMul = 1, slowMult = 0.2, slowTime = 1.5, lungeMul = 1, attackTime = 0.1 },
                                ["2"] = { lungeMult = 1, slowMult = 0.2, slowTime = 1.5, knockbackMult = 1, attackTime = 0.1 },
                                ["3"] = { lungeMult = 0.75, slowMult = 0.2, slowTime = 1.5, knockbackMult = 1.5, attackTime = 0.1 },
                                ["4"] = { lungeMult = 2.25, slowTime = 1.5, slowMult = 0.2, hitboxOffsetAdd = Vector3.new(0, 0, -1.5), hitboxSizeAdd = Vector3.new(0, 0, 3), knockbackMult = 2.25, attackTime = 0.1 }
                            },
                            attackOrder = {"1", "2", "3", "4"}
                        },
                        attackCooldown = 0,
                        shouldSlow = true,
                        lungeKnockback = 55,
                        hitboxSize = Vector3.new(55, 25, 55),
                        slowMult = 0.2,
                        cycleIndex = 1,
                        hitboxOffset = Vector3.new(0, 0, -10),
                        tool = tool,
                        damage = 100
                    }
                    pcall(function() Event:InvokeServer("AttemptWeaponHit", payload, targets) end)
                end
            end
        end
        task.wait(AttackDelay)
    end
end)
