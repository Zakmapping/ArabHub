local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- نظام الطيران المحسن
local function enableAdvancedFly()
    local flyEnabled = false
    local flySpeed = 50
    local flyKeys = {Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D}
    local flyVelocity = Vector3.new(0, 0, 0)
    
    return {
        toggle = function()
            flyEnabled = not flyEnabled
            if flyEnabled then
                local character = player.Character or player.CharacterAdded:Wait()
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.PlatformStand = true
                    
                    local bodyGyro = Instance.new("BodyGyro")
                    bodyGyro.P = 10000
                    bodyGyro.MaxTorque = Vector3.new(100000, 100000, 100000)
                    bodyGyro.CFrame = character:FindFirstChild("HumanoidRootPart").CFrame
                    bodyGyro.Parent = character:FindFirstChild("HumanoidRootPart")
                    
                    local bodyVelocity = Instance.new("BodyVelocity")
                    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                    bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
                    bodyVelocity.Parent = character:FindFirstChild("HumanoidRootPart")
                    
                    local connection
                    connection = RunService.Stepped:Connect(function()
                        if not flyEnabled then
                            connection:Disconnect()
                            return
                        end
                        
                        local root = character:FindFirstChild("HumanoidRootPart")
                        if root and bodyGyro and bodyVelocity then
                            -- التحكم بالطيران
                            local forward = UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or UserInputService:IsKeyDown(Enum.KeyCode.S) and -1 or 0
                            local right = UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or UserInputService:IsKeyDown(Enum.KeyCode.A) and -1 or 0
                            local up = UserInputService:IsKeyDown(Enum.KeyCode.Space) and 1 or UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and -1 or 0
                            
                            flyVelocity = Vector3.new(right * flySpeed, up * flySpeed, forward * flySpeed)
                            
                            -- تحديث السرعة
                            bodyVelocity.Velocity = root.CFrame:VectorToWorldSpace(flyVelocity)
                            bodyGyro.CFrame = CFrame.new(root.Position, root.Position + mouse.UnitRay.Direction * 100)
                        end
                    end)
                end
            else
                local character = player.Character
                if character then
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid.PlatformStand = false
                    end
                    
                    local root = character:FindFirstChild("HumanoidRootPart")
                    if root then
                        for _, v in ipairs(root:GetChildren()) do
                            if v:IsA("BodyVelocity") or v:IsA("BodyGyro") then
                                v:Destroy()
                            end
                        end
                    end
                end
            end
            return flyEnabled
        end,
        setSpeed = function(speed)
            flySpeed = tonumber(speed) or 50
        end
    }
end

local advancedFly = enableAdvancedFly()

-- نظام الأوامر الأساسي
local function executeCommand(cmd, ...)
    local args = {...}
    local character = player.Character or player.CharacterAdded:Wait()
    
    if cmd == "god" then
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.MaxHealth = math.huge
                humanoid.Health = math.huge
            end
        end
    elseif cmd == "fling" then
        -- سيتم التعامل معها في الواجهة الخاصة
    elseif cmd == "size" then
        local scale = tonumber(args[1]) or 1
        if character then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Size = part.Size * scale
                end
            end
        end
    elseif cmd == "f3x" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/VisualRoblox/Roblox/main/F3X.lua", true))()
    elseif cmd == "fly" then
        advancedFly.toggle()
    elseif cmd == "noclip" then
        local noclip = false
        noclip = not noclip
        
        RunService.Stepped:Connect(function()
            if noclip and character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    elseif cmd == "speed" then
        local speed = tonumber(args[1]) or 50
        speed = math.clamp(speed, 0, 1000)
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = speed
            end
        end
    elseif cmd == "dex" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua", true))()
    elseif cmd == "bring" then
        local target = args[1]
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            target.Character.HumanoidRootPart.CFrame = character.HumanoidRootPart.CFrame
        end
    elseif cmd == "teleport" then
        local target = args[1]
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
        end
    elseif cmd == "daynight" then
        if Lighting.ClockTime == 14 then
            Lighting.ClockTime = 2
        else
            Lighting.ClockTime = 14
        end
    end
end

-- تصميم الواجهة الرئيسية
local ArabHub = Instance.new("ScreenGui")
ArabHub.Name = "ArabHubVIP"
ArabHub.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0.4, 0, 0.6, 0)
MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ArabHub

-- تأثير زجاجي متطور
local GlassEffect = Instance.new("ImageLabel")
GlassEffect.Size = UDim2.new(1, 0, 1, 0)
GlassEffect.Image = "rbxassetid://8992230431"
GlassEffect.ScaleType = Enum.ScaleType.Slice
GlassEffect.SliceScale = 0.02
GlassEffect.ImageTransparency = 0.1
GlassEffect.ImageColor3 = Color3.fromRGB(30, 30, 50)
GlassEffect.BackgroundTransparency = 1
GlassEffect.ZIndex = -1
GlassEffect.Parent = MainFrame

-- زوايا مستديرة
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.03, 0)
UICorner.Parent = MainFrame

-- شريط العنوان
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0.07, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0.03, 0)
TitleCorner.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.8, 0, 1, 0)
Title.Position = UDim2.new(0.1, 0, 0, 0)
Title.Text = "ArabHub VIP"
Title.TextColor3 = Color3.fromRGB(220, 220, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = TitleBar

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0.07, 0, 0.7, 0)
CloseButton.Position = UDim2.new(0.92, 0, 0.15, 0)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 150, 150)
CloseButton.BackgroundColor3 = Color3.fromRGB(50, 30, 30)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 16
CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0.5, 0)
CloseCorner.Parent = CloseButton

-- إعدادات التحجيم
local ScaleSlider = Instance.new("TextButton")
ScaleSlider.Size = UDim2.new(0.07, 0, 0.7, 0)
ScaleSlider.Position = UDim2.new(0.84, 0, 0.15, 0)
ScaleSlider.Text = "⚙️"
ScaleSlider.TextColor3 = Color3.fromRGB(200, 200, 255)
ScaleSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
ScaleSlider.Font = Enum.Font.GothamBold
ScaleSlider.TextSize = 16
ScaleSlider.Parent = TitleBar

local ScaleCorner = Instance.new("UICorner")
ScaleCorner.CornerRadius = UDim.new(0.5, 0)
ScaleCorner.Parent = ScaleSlider

-- منطقة الأزرار
local ButtonsFrame = Instance.new("ScrollingFrame")
ButtonsFrame.Size = UDim2.new(0.96, 0, 0.9, 0)
ButtonsFrame.Position = UDim2.new(0.02, 0, 0.08, 0)
ButtonsFrame.BackgroundTransparency = 1
ButtonsFrame.ScrollBarThickness = 6
ButtonsFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 150)
ButtonsFrame.Parent = MainFrame

local ButtonsLayout = Instance.new("UIGridLayout")
ButtonsLayout.CellPadding = UDim2.new(0.02, 0, 0.02, 0)
ButtonsLayout.CellSize = UDim2.new(0.48, 0, 0.15, 0)
ButtonsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ButtonsLayout.Parent = ButtonsFrame

-- نظام الأيقونات
local Icons = {
    God = "rbxassetid://7072720392",
    Fling = "rbxassetid://7072718765",
    Size = "rbxassetid://7072719873",
    Fly = "rbxassetid://7072718123",
    F3X = "rbxassetid://7072716542",
    NoClip = "rbxassetid://7072715432",
    Speed = "rbxassetid://7072714321",
    Dex = "rbxassetid://7072713210",
    Bring = "rbxassetid://7072712109",
    Teleport = "rbxassetid://7072711098",
    DayNight = "rbxassetid://7072710987"
}

-- إنشاء زر أمر
local function createCommandButton(cmdName, iconId, description, hasInput)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 1, 0)
    Button.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    Button.Text = ""
    Button.AutoButtonColor = true
    Button.Parent = ButtonsFrame
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0.1, 0)
    ButtonCorner.Parent = Button
    
    local Icon = Instance.new("ImageLabel")
    Icon.Size = UDim2.new(0.2, 0, 0.5, 0)
    Icon.Position = UDim2.new(0.05, 0, 0.25, 0)
    Icon.BackgroundTransparency = 1
    Icon.Image = iconId
    Icon.Parent = Button
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 0.5, 0)
    Label.Position = UDim2.new(0.25, 0, 0.1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = cmdName
    Label.TextColor3 = Color3.fromRGB(220, 220, 255)
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Button
    
    local Desc = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 0.3, 0)
    Label.Position = UDim2.new(0.25, 0, 0.5, 0)
    Label.BackgroundTransparency = 1
    Label.Text = description
    Label.TextColor3 = Color3.fromRGB(180, 180, 220)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Button
    
    if hasInput then
        local inputBox = Instance.new("TextBox")
        inputBox.Size = UDim2.new(0.25, 0, 0.5, 0)
        inputBox.Position = UDim2.new(0.7, 0, 0.25, 0)
        inputBox.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
        inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        inputBox.PlaceholderText = "القيمة"
        inputBox.Text = ""
        inputBox.Font = Enum.Font.Gotham
        inputBox.TextSize = 12
        inputBox.Parent = Button
        
        return inputBox
    end
    
    return Button
end

-- إنشاء واجهة اختيار اللاعبين للـFling
local function createPlayerSelectionUI(callback)
    local SelectionUI = Instance.new("Frame")
    SelectionUI.Size = UDim2.new(0.6, 0, 0.8, 0)
    SelectionUI.Position = UDim2.new(0.2, 0, 0.1, 0)
    SelectionUI.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    SelectionUI.Parent = ArabHub
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0.03, 0)
    UICorner.Parent = SelectionUI
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0.1, 0)
    Title.Text = "اختر لاعب للرمي"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.Parent = SelectionUI
    
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0.1, 0, 0.1, 0)
    CloseButton.Position = UDim2.new(0.9, 0, 0, 0)
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 150, 150)
    CloseButton.BackgroundColor3 = Color3.fromRGB(60, 30, 30)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 18
    CloseButton.Parent = SelectionUI
    
    local PlayersFrame = Instance.new("ScrollingFrame")
    PlayersFrame.Size = UDim2.new(1, 0, 0.9, 0)
    PlayersFrame.Position = UDim2.new(0, 0, 0.1, 0)
    PlayersFrame.BackgroundTransparency = 1
    PlayersFrame.ScrollBarThickness = 6
    PlayersFrame.Parent = SelectionUI
    
    local PlayersLayout = Instance.new("UIListLayout")
    PlayersLayout.Padding = UDim.new(0, 10)
    PlayersLayout.Parent = PlayersFrame
    
    -- إضافة اللاعبين
    for _, target in ipairs(Players:GetPlayers()) do
        if target ~= player then
            local PlayerButton = Instance.new("TextButton")
            PlayerButton.Size = UDim2.new(0.9, 0, 0.15, 0)
            PlayerButton.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
            PlayerButton.Text = target.Name
            PlayerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            PlayerButton.Font = Enum.Font.Gotham
            PlayerButton.TextSize = 14
            PlayerButton.Parent = PlayersFrame
            
            local PlayerCorner = Instance.new("UICorner")
            PlayerCorner.CornerRadius = UDim.new(0.1, 0)
            PlayerCorner.Parent = PlayerButton
            
            PlayerButton.MouseButton1Click:Connect(function()
                callback(target)
                SelectionUI:Destroy()
            end)
        end
    end
    
    CloseButton.MouseButton1Click:Connect(function()
        SelectionUI:Destroy()
    end)
    
    PlayersLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        PlayersFrame.CanvasSize = UDim2.new(0, 0, 0, PlayersLayout.AbsoluteContentSize.Y + 20)
    end)
end

-- الأوامر المتاحة
local Commands = {
    {Name = "عدم الموت", Icon = Icons.God, Desc = "مناعة ضد الضرر", Cmd = "god"},
    {Name = "رمي اللاعب", Icon = Icons.Fling, Desc = "يرمي لاعب معين", Cmd = "fling"},
    {Name = "تغيير الحجم", Icon = Icons.Size, Desc = "يغير حجم شخصيتك", Cmd = "size", Input = true},
    {Name = "الطيران", Icon = Icons.Fly, Desc = "يطير في الهواء", Cmd = "fly"},
    {Name = "أدوات بناء", Icon = Icons.F3X, Desc = "أدوات بناء متقدمة", Cmd = "f3x"},
    {Name = "تخطي الجدران", Icon = Icons.NoClip, Desc = "يمر عبر الجدران", Cmd = "noclip"},
    {Name = "السرعة", Icon = Icons.Speed, Desc = "يغير سرعة المشي", Cmd = "speed", Input = true},
    {Name = "DEX Explorer", Icon = Icons.Dex, Desc = "أداة استكشاف متقدمة", Cmd = "dex"},
    {Name = "جلب لاعب", Icon = Icons.Bring, Desc = "يجلب لاعب معين", Cmd = "bring"},
    {Name = "انتقال إلى", Icon = Icons.Teleport, Desc = "ينتقل إلى لاعب", Cmd = "teleport"},
    {Name = "ليل/نهار", Icon = Icons.DayNight, Desc = "يغير وقت اليوم", Cmd = "daynight"}
}

-- إضافة الأزرار
for _, cmd in ipairs(Commands) do
    local button = createCommandButton(cmd.Name, cmd.Icon, cmd.Desc, cmd.Input)
    
    if cmd.Cmd == "fling" then
        button.MouseButton1Click:Connect(function()
            createPlayerSelectionUI(function(target)
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local root = player.Character.HumanoidRootPart
                    root.Velocity = Vector3.new(math.random(-5000,5000), math.random(-5000,5000), math.random(-5000,5000))
                end
            end)
        end)
    elseif cmd.Cmd == "bring" then
        button.MouseButton1Click:Connect(function()
            createPlayerSelectionUI(function(target)
                executeCommand("bring", target)
            end)
        end)
    elseif cmd.Cmd == "teleport" then
        button.MouseButton1Click:Connect(function()
            createPlayerSelectionUI(function(target)
                executeCommand("teleport", target)
            end)
        end)
    elseif cmd.Input then
        local input = button:FindFirstChildOfClass("TextBox")
        button.MouseButton1Click:Connect(function()
            executeCommand(cmd.Cmd, input.Text)
        end)
    else
        button.MouseButton1Click:Connect(function()
            executeCommand(cmd.Cmd)
        end)
    end
end

-- تكييف حجم منطقة الأزرار
ButtonsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ButtonsFrame.CanvasSize = UDim2.new(0, 0, 0, ButtonsLayout.AbsoluteContentSize.Y + 20)
end)

-- نظام التحريك وتغيير الحجم
local dragging, resizing, dragStart, startPos, startSize

local function updatePosition(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

local function updateSize(input)
    local delta = input.Position - dragStart
    local newSize = UDim2.new(
        startSize.X.Scale, 
        math.clamp(startSize.X.Offset + delta.X, 300, 800),
        startSize.Y.Scale,
        math.clamp(startSize.Y.Offset + delta.Y, 400, 1000)
    )
    
    MainFrame.Size = newSize
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local absolutePosition = input.Position.X - MainFrame.AbsolutePosition.X
        local absoluteSize = MainFrame.AbsoluteSize.X
        
        if absolutePosition > absoluteSize - 20 then
            resizing = true
            dragStart = input.Position
            startSize = MainFrame.Size
        else
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                resizing = false
            end
        end)
    end
end

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput then
        if dragging then
            updatePosition(input)
        elseif resizing then
            updateSize(input)
        end
    end
end)

-- إغلاق الواجهة
CloseButton.MouseButton1Click:Connect(function()
    ArabHub:Destroy()
end)

-- إعدادات التحجيم
local scaleSettings = {
    currentScale = 100,
    minScale = 50,
    maxScale = 150
}

ScaleSlider.MouseButton1Click:Connect(function()
    local ScaleUI = Instance.new("Frame")
    ScaleUI.Size = UDim2.new(0.3, 0, 0.2, 0)
    ScaleUI.Position = UDim2.new(0.35, 0, 0.4, 0)
    ScaleUI.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    ScaleUI.Parent = ArabHub
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0.05, 0)
    UICorner.Parent = ScaleUI
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0.3, 0)
    Title.Text = "تغيير حجم الواجهة"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.Parent = ScaleUI
    
    local Slider = Instance.new("TextButton")
    Slider.Size = UDim2.new(0.8, 0, 0.2, 0)
    Slider.Position = UDim2.new(0.1, 0, 0.4, 0)
    Slider.Text = ""
    Slider.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
    Slider.Parent = ScaleUI
    
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0.5, 0)
    SliderCorner.Parent = Slider
    
    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new(scaleSettings.currentScale/100, 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    Fill.Parent = Slider
    
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(0.5, 0)
    FillCorner.Parent = Fill
    
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(1, 0, 0.3, 0)
    ValueLabel.Position = UDim2.new(0, 0, 0.7, 0)
    ValueLabel.Text = scaleSettings.currentScale .. "%"
    ValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Font = Enum.Font.Gotham
    ValueLabel.TextSize = 14
    ValueLabel.Parent = ScaleUI
    
    local function updateScale(value)
        value = math.clamp(value, scaleSettings.minScale, scaleSettings.maxScale)
        scaleSettings.currentScale = value
        ValueLabel.Text = value .. "%"
        Fill.Size = UDim2.new(value/100, 0, 1, 0)
        
        local scaleFactor = value/100
        MainFrame.Size = UDim2.new(0.4 * scaleFactor, 0, 0.6 * scaleFactor, 0)
    end
    
    Slider.MouseButton1Down:Connect(function()
        local connection
        connection = RunService.RenderStepped:Connect(function()
            local mouseX = UserInputService:GetMouseLocation().X
            local sliderStart = Slider.AbsolutePosition.X
            local sliderEnd = sliderStart + Slider.AbsoluteSize.X
            local percent = (mouseX - sliderStart) / (sliderEnd - sliderStart)
            updateScale(math.floor(percent * (scaleSettings.maxScale - scaleSettings.minScale) + scaleSettings.minScale)
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                connection:Disconnect()
            end
        end)
    end)
    
    ScaleUI.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    ScaleUI:Destroy()
                end
            end)
        end
    end)
end)

-- إظهار/إخفاء الواجهة بمفتاح (F5)
local isVisible = true

UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.F5 then
        isVisible = not isVisible
        MainFrame.Visible = isVisible
    end
end)