--// HOEZA UI Library (Rayfield-style modular wrapper)
--// Extracted and refactored for modular use

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")

local Library = {}

--// Palette & Assets
local COLORS = {
    background = Color3.fromRGB(10, 10, 14),
    cardBg = Color3.fromRGB(15, 15, 22),
    cardHover = Color3.fromRGB(22, 26, 38),
    buttonActive = Color3.fromRGB(28, 25, 42),
    border = Color3.fromRGB(50, 45, 65),
    textPrimary = Color3.fromRGB(245, 245, 255),
    textSecondary = Color3.fromRGB(130, 130, 150),
    accentPurple = Color3.fromRGB(168, 85, 247),
    accentGreen = Color3.fromRGB(0, 242, 128),
    dockBg = Color3.fromRGB(8, 8, 12)
}
local UI_IMAGE = "rbxassetid://137048258860955"

--// Utility: Quick Tween
local function tweenQuick(obj, props, duration)
    TweenService:Create(obj, TweenInfo.new(duration or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

--// Main Window Creation
function Library:CreateWindow(options)
    options = options or {}
    local TitleText = options.Name or "HOEZA"
    local SubtitleText = options.Subtitle or "Dashboard"
    local ToggleKey = options.ToggleKey or Enum.KeyCode.RightShift

    -- Cleanup existing
    if CoreGui:FindFirstChild("HoezaUILibrary") then
        CoreGui.HoezaUILibrary:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "HoezaUILibrary"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder = 999
    ScreenGui.Parent = CoreGui

    local MainCard = Instance.new("ImageLabel", ScreenGui)
    MainCard.Name = "MainCard"
    MainCard.Size = UDim2.new(0, 540, 0, 400)
    MainCard.Position = UDim2.new(0.5, -270, 0.5, -200)
    MainCard.BackgroundColor3 = COLORS.background
    MainCard.BackgroundTransparency = 0.1
    MainCard.Image = UI_IMAGE
    MainCard.ScaleType = Enum.ScaleType.Crop
    MainCard.ImageTransparency = 0.1
    MainCard.BorderSizePixel = 0
    MainCard.ZIndex = 2
    Instance.new("UICorner", MainCard).CornerRadius = UDim.new(0, 20)
    
    local MainStroke = Instance.new("UIStroke", MainCard)
    MainStroke.Color = COLORS.border
    MainStroke.Thickness = 1.5

    local MainScale = Instance.new("UIScale", MainCard)
    MainScale.Scale = 1

    -- Ambient Glow
    local AmbientGlow = Instance.new("Frame", MainCard)
    AmbientGlow.Size = UDim2.new(1, 28, 1, 28)
    AmbientGlow.Position = UDim2.new(0, -14, 0, -14)
    AmbientGlow.BackgroundColor3 = COLORS.accentPurple
    AmbientGlow.BackgroundTransparency = 0.85
    AmbientGlow.BorderSizePixel = 0
    AmbientGlow.ZIndex = 1
    Instance.new("UICorner", AmbientGlow).CornerRadius = UDim.new(0, 28)
    local GlowStroke = Instance.new("UIStroke", AmbientGlow)
    GlowStroke.Color = COLORS.accentPurple
    GlowStroke.Transparency = 0.4
    GlowStroke.Thickness = 6

    -- Header
    local Header = Instance.new("Frame", MainCard)
    Header.Size = UDim2.new(1, -28, 0, 40)
    Header.Position = UDim2.new(0, 14, 0, 14)
    Header.BackgroundTransparency = 1
    Header.ZIndex = 3

    local HeaderTitle = Instance.new("TextLabel", Header)
    HeaderTitle.Size = UDim2.new(0.7, 0, 0, 16)
    HeaderTitle.BackgroundTransparency = 1
    HeaderTitle.Text = TitleText
    HeaderTitle.TextColor3 = COLORS.textPrimary
    HeaderTitle.TextSize = 14
    HeaderTitle.Font = Enum.Font.GothamBold
    HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left

    local HeaderSubtitle = Instance.new("TextLabel", Header)
    HeaderSubtitle.Size = UDim2.new(0.7, 0, 0, 12)
    HeaderSubtitle.Position = UDim2.new(0, 0, 0, 18)
    HeaderSubtitle.BackgroundTransparency = 1
    HeaderSubtitle.Text = SubtitleText
    HeaderSubtitle.TextColor3 = COLORS.accentPurple
    HeaderSubtitle.TextSize = 10
    HeaderSubtitle.Font = Enum.Font.GothamMedium
    HeaderSubtitle.TextXAlignment = Enum.TextXAlignment.Left

    -- Dock Container (For Tabs)
    local DockContainer = Instance.new("ImageLabel", MainCard)
    DockContainer.Size = UDim2.new(1, -28, 0, 38)
    DockContainer.Position = UDim2.new(0, 14, 0, 54)
    DockContainer.BackgroundColor3 = COLORS.dockBg
    DockContainer.BackgroundTransparency = 0.15
    DockContainer.Image = UI_IMAGE
    DockContainer.ScaleType = Enum.ScaleType.Crop
    DockContainer.ImageTransparency = 0.8
    DockContainer.BorderSizePixel = 0
    DockContainer.ZIndex = 3
    Instance.new("UICorner", DockContainer).CornerRadius = UDim.new(0, 18)

    local DockLayout = Instance.new("UIListLayout", DockContainer)
    DockLayout.FillDirection = Enum.FillDirection.Horizontal
    DockLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    DockLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    DockLayout.Padding = UDim.new(0, 4)

    -- Body Container (For Content)
    local BodyContainer = Instance.new("Frame", MainCard)
    BodyContainer.Size = UDim2.new(1, -28, 1, -114)
    BodyContainer.Position = UDim2.new(0, 14, 0, 100)
    BodyContainer.BackgroundTransparency = 1
    BodyContainer.ZIndex = 3

    -- Dragging Logic
    local dragging, dragStart, startPos
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainCard.Position
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainCard.Position = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Toggle Logic
    local uiVisible = true
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == ToggleKey then
            uiVisible = not uiVisible
            if uiVisible then
                ScreenGui.Enabled = true
                MainScale.Scale = 0.85
                MainCard.BackgroundTransparency = 1
                MainCard.ImageTransparency = 1
                tweenQuick(MainScale, {Scale = 1}, 0.25)
                tweenQuick(MainCard, {BackgroundTransparency = 0.1, ImageTransparency = 0.1}, 0.25)
            else
                tweenQuick(MainScale, {Scale = 0.85}, 0.2)
                tweenQuick(MainCard, {BackgroundTransparency = 1, ImageTransparency = 1}, 0.2)
                task.wait(0.2)
                ScreenGui.Enabled = false
            end
        end
    end)

    -- Window Object
    local Window = {
        Tabs = {},
        NavButtons = {},
        ActiveTab = nil
    }

    function Window:CreateTab(options)
        local tabName = options.Name or "Tab"
        
        -- Dock Button
        local iconBtn = Instance.new("ImageButton", DockContainer)
        iconBtn.Size = UDim2.new(0, 100, 0.78, 0)
        iconBtn.BackgroundColor3 = COLORS.dockBg
        iconBtn.BackgroundTransparency = 1
        iconBtn.Image = UI_IMAGE
        iconBtn.ScaleType = Enum.ScaleType.Crop
        iconBtn.ImageTransparency = 1
        iconBtn.AutoButtonColor = false
        Instance.new("UICorner", iconBtn).CornerRadius = UDim.new(0, 12)
        
        local iconText = Instance.new("TextLabel", iconBtn)
        iconText.Size = UDim2.new(1, 0, 1, 0)
        iconText.BackgroundTransparency = 1
        iconText.Text = tabName
        iconText.TextSize = 11
        iconText.Font = Enum.Font.GothamBold
        iconText.TextColor3 = COLORS.textSecondary

        -- Tab Content Frame
        local TabScroll = Instance.new("ScrollingFrame", BodyContainer)
        TabScroll.Size = UDim2.new(1, 0, 1, 0)
        TabScroll.BackgroundTransparency = 1
        TabScroll.Visible = false
        TabScroll.ScrollBarThickness = 2
        TabScroll.ScrollBarImageColor3 = COLORS.accentPurple
        TabScroll.BorderSizePixel = 0
        
        local TabList = Instance.new("UIListLayout", TabScroll)
        TabList.SortOrder = Enum.SortOrder.LayoutOrder
        TabList.Padding = UDim.new(0, 8)
        TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center

        -- Auto adjust canvas size
        TabList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabScroll.CanvasSize = UDim2.new(0, 0, 0, TabList.AbsoluteContentSize.Y + 10)
        end)

        Window.Tabs[tabName] = TabScroll
        Window.NavButtons[tabName] = iconBtn

        -- Tab Switching Logic
        iconBtn.MouseButton1Click:Connect(function()
            Window.ActiveTab = tabName
            for key, frame in pairs(Window.Tabs) do frame.Visible = (key == Window.ActiveTab) end
            for key, btn in pairs(Window.NavButtons) do
                local isSel = (key == Window.ActiveTab)
                tweenQuick(btn:FindFirstChildOfClass("TextLabel"), {TextColor3 = isSel and COLORS.accentPurple or COLORS.textSecondary})
                tweenQuick(btn, {
                    BackgroundTransparency = isSel and 0.15 or 1,
                    BackgroundColor3 = isSel and COLORS.buttonActive or COLORS.dockBg,
                    ImageTransparency = isSel and 0.8 or 1
                })
            end
        end)

        -- Select first tab automatically
        if not Window.ActiveTab then
            iconBtn.MouseButton1Click:Fire()
        end

        local TabObject = {}

        --// Create Button
        function TabObject:CreateButton(btnOptions)
            local btnName = btnOptions.Name or "Button"
            local callback = btnOptions.Callback or function() end

            local Button = Instance.new("ImageButton", TabScroll)
            Button.Size = UDim2.new(1, -10, 0, 42)
            Button.BackgroundColor3 = COLORS.cardBg
            Button.BackgroundTransparency = 0.15
            Button.Image = UI_IMAGE
            Button.ScaleType = Enum.ScaleType.Crop
            Button.ImageTransparency = 0.85
            Button.AutoButtonColor = false
            Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 12)
            Instance.new("UIStroke", Button).Color = COLORS.border

            local BtnText = Instance.new("TextLabel", Button)
            BtnText.Size = UDim2.new(1, 0, 1, 0)
            BtnText.BackgroundTransparency = 1
            BtnText.Text = btnName
            BtnText.TextColor3 = COLORS.textPrimary
            BtnText.TextSize = 13
            BtnText.Font = Enum.Font.GothamBold

            Button.MouseEnter:Connect(function() tweenQuick(Button, {BackgroundColor3 = COLORS.cardHover}) end)
            Button.MouseLeave:Connect(function() tweenQuick(Button, {BackgroundColor3 = COLORS.cardBg}) end)
            
            Button.MouseButton1Click:Connect(function()
                tweenQuick(Button, {BackgroundColor3 = COLORS.buttonActive}, 0.1)
                task.wait(0.1)
                tweenQuick(Button, {BackgroundColor3 = COLORS.cardHover}, 0.1)
                callback()
            end)
        end

        --// Create Toggle
        function TabObject:CreateToggle(tglOptions)
            local tglName = tglOptions.Name or "Toggle"
            local currentState = tglOptions.CurrentValue or false
            local callback = tglOptions.Callback or function() end

            local ToggleFrame = Instance.new("ImageButton", TabScroll)
            ToggleFrame.Size = UDim2.new(1, -10, 0, 42)
            ToggleFrame.BackgroundColor3 = COLORS.cardBg
            ToggleFrame.BackgroundTransparency = 0.15
            ToggleFrame.Image = UI_IMAGE
            ToggleFrame.ScaleType = Enum.ScaleType.Crop
            ToggleFrame.ImageTransparency = 0.85
            ToggleFrame.AutoButtonColor = false
            Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 12)
            local Stroke = Instance.new("UIStroke", ToggleFrame)
            Stroke.Color = COLORS.border

            local TglText = Instance.new("TextLabel", ToggleFrame)
            TglText.Size = UDim2.new(1, -50, 1, 0)
            TglText.Position = UDim2.new(0, 16, 0, 0)
            TglText.BackgroundTransparency = 1
            TglText.Text = tglName
            TglText.TextColor3 = COLORS.textPrimary
            TglText.TextSize = 13
            TglText.Font = Enum.Font.GothamBold
            TglText.TextXAlignment = Enum.TextXAlignment.Left

            local StatusText = Instance.new("TextLabel", ToggleFrame)
            StatusText.Size = UDim2.new(0, 40, 1, 0)
            StatusText.Position = UDim2.new(1, -50, 0, 0)
            StatusText.BackgroundTransparency = 1
            StatusText.Text = currentState and "ON" or "OFF"
            StatusText.TextColor3 = currentState and COLORS.accentGreen or COLORS.textSecondary
            StatusText.TextSize = 12
            StatusText.Font = Enum.Font.GothamBlack

            local function updateVisuals()
                StatusText.Text = currentState and "ON" or "OFF"
                tweenQuick(StatusText, {TextColor3 = currentState and COLORS.accentGreen or COLORS.textSecondary})
                tweenQuick(Stroke, {Color = currentState and COLORS.accentPurple or COLORS.border})
            end

            updateVisuals() -- init

            ToggleFrame.MouseEnter:Connect(function() tweenQuick(ToggleFrame, {BackgroundColor3 = COLORS.cardHover}) end)
            ToggleFrame.MouseLeave:Connect(function() tweenQuick(ToggleFrame, {BackgroundColor3 = COLORS.cardBg}) end)

            ToggleFrame.MouseButton1Click:Connect(function()
                currentState = not currentState
                updateVisuals()
                callback(currentState)
            end)
        end

        return TabObject
    end

    return Window
end

return Library
