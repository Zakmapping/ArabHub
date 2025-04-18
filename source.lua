--[[
  هذا السكربت يعمل كاملاً من خلال الـExecutor (مثل Synapse/Krnl)
  بدون الحاجة لوضعه في ServerScriptService
  ولكنه يحاكي عمل Server-Side للأوامر المهمة
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- محاكاة Server-Side عبر إعادة تعريف الدوال الأساسية
local function executeServerSide(cmd, ...)
    local args = {...}
    local character = player.Character or player.CharacterAdded:Wait()
    
    if cmd == "killall" then
        for _, target in ipairs(Players:GetPlayers()) do
            if target ~= player and target.Character then
                local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.Health = 0
                end
            end
        end
    elseif cmd == "god" then
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.MaxHealth = math.huge
                humanoid.Health = math.huge
            end
        end
    elseif cmd == "fling" then
        if character then
            local root = character:FindFirstChild("HumanoidRootPart")
            if root then
                root.Velocity = Vector3.new(math.random(-5000,5000), math.random(-5000,5000), math.random(-5000,5000))
            end
        end
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
        loadstring(game:HttpGet("https://raw.githubusercontent.com/SuperCuteBunny/Roblox-HAX/main/Fly.lua", true))()
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
    end
end

-- تصميم الواجهة الفاخرة
local ArabHub = Instance.new("ScreenGui")
ArabHub.Name = "ArabHub"
ArabHub.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0.35, 0, 0.5, 0)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
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

-- زوايا مستديرة متدرجة
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.03, 0)
UICorner.Parent = MainFrame

-- ظل متحرك ديناميكي
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(100, 100, 150)
UIStroke.Thickness = 2
UIStroke.Transparency = 0.7
UIStroke.Parent = MainFrame

-- شريط العنوان المميز
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0.08, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0.03, 0)
TitleCorner.Parent = TitleBar

-- شعار ArabHub
local Logo = Instance.new("ImageLabel")
Logo.Size = UDim2.new(0.08, 0, 0.8, 0)
Logo.Position = UDim2.new(0.01, 0, 0.1, 0)
Logo.Image = "rbxassetid://7072717361" -- يمكن استبدالها بأيقونة خاصة
Logo.BackgroundTransparency = 1
Logo.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Position = UDim2.new(0.1, 0, 0, 0)
Title.Text = "ArabHub VIP"
Title.TextColor3 = Color3.fromRGB(220, 220, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = TitleBar

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0.08, 0, 0.8, 0)
CloseButton.Position = UDim2.new(0.91, 0, 0.1, 0)
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 150, 150)
CloseButton.BackgroundColor3 = Color3.fromRGB(50, 30, 30)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 16
CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0.5, 0)
CloseCorner.Parent = CloseButton

-- منطقة الأزرار المميزة
local ButtonsFrame = Instance.new("ScrollingFrame")
ButtonsFrame.Size = UDim2.new(0.95, 0, 0.88, 0)
ButtonsFrame.Position = UDim2.new(0.025, 0, 0.1, 0)
ButtonsFrame.BackgroundTransparency = 1
ButtonsFrame.ScrollBarThickness = 4
ButtonsFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 150)
ButtonsFrame.Parent = MainFrame

local ButtonsLayout = Instance.new("UIGridLayout")
ButtonsLayout.CellPadding = UDim2.new(0.02, 0, 0.02, 0)
ButtonsLayout.CellSize = UDim2.new(0.3, 0, 0.15, 0)
ButtonsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ButtonsLayout.Parent = ButtonsFrame

-- نظام الأيقونات المخصصة
local Icons = {
    KillAll = "rbxassetid://7072717361",
    God = "rbxassetid://7072720392",
    Fling = "rbxassetid://7072718765",
    Size = "rbxassetid://7072719873",
    Fly = "rbxassetid://7072718123",
    F3X = "rbxassetid://7072716542",
    NoClip = "rbxassetid://7072715432",
    Speed = "rbxassetid://7072714321"
}

-- إنشاء أزرار الأوامر المميزة
local function createCommandButton(cmdName, iconId, description, cmdType)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 1, 0)
    Button.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
    Button.Text = ""
    Button.AutoButtonColor = true
    Button.Parent = ButtonsFrame
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0.15, 0)
    ButtonCorner.Parent = Button
    
    local ButtonGradient = Instance.new("UIGradient")
    ButtonGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 60, 90)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 70))
    }
    ButtonGradient.Rotation = 90
    ButtonGradient.Parent = Button
    
    local ButtonStroke = Instance.new("UIStroke")
    ButtonStroke.Color = Color3.fromRGB(80, 80, 120)
    ButtonStroke.Thickness = 1.5
    ButtonStroke.Parent = Button
    
    local Icon = Instance.new("ImageLabel")
    Icon.Size = UDim2.new(0.5, 0, 0.5, 0)
    Icon.Position = UDim2.new(0.25, 0, 0.1, 0)
    Icon.BackgroundTransparency = 1
    Icon.Image = iconId
    Icon.Parent = Button
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.9, 0, 0.3, 0)
    Label.Position = UDim2.new(0.05, 0, 0.65, 0)
    Label.BackgroundTransparency = 1
    Label.Text = cmdName
    Label.TextColor3 = Color3.fromRGB(220, 220, 255)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 12
    Label.TextWrapped = true
    Label.Parent = Button
    
    local Desc = Instance.new("TextLabel")
    Desc.Size = UDim2.new(0.9, 0, 0.2, 0)
    Desc.Position = UDim2.new(0.05, 0, 0.85, 0)
    Desc.BackgroundTransparency = 1
    Desc.Text = description
    Desc.TextColor3 = Color3.fromRGB(180, 180, 220)
    Desc.Font = Enum.Font.Gotham
    Desc.TextSize = 10
    Desc.TextWrapped = true
    Desc.Parent = Button
    
    -- إضافة مربع إدخال إذا كان الأمر يحتاج قيمة
    if cmdType == "input" then
        local inputBox = Instance.new("TextBox")
        inputBox.Size = UDim2.new(0.8, 0, 0.25, 0)
        inputBox.Position = UDim2.new(0.1, 0, 0.5, 0)
        inputBox.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
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

-- الأوامر المتاحة
local Commands = {
    {Name = "قتل الجميع", Icon = Icons.KillAll, Desc = "يقتل كل اللاعبين", Cmd = "killall"},
    {Name = "عدم الموت", Icon = Icons.God, Desc = "مناعة ضد الضرر", Cmd = "god"},
    {Name = "رمي اللاعب", Icon = Icons.Fling, Desc = "يرمي اللاعب بعيداً", Cmd = "fling"},
    {Name = "تغيير الحجم", Icon = Icons.Size, Desc = "يغير حجم شخصيتك", Cmd = "size", Type = "input"},
    {Name = "أدوات بناء", Icon = Icons.F3X, Desc = "أدوات بناء متقدمة", Cmd = "f3x"},
    {Name = "الطيران", Icon = Icons.Fly, Desc = "يطير في الهواء", Cmd = "fly"},
    {Name = "تخطي الجدران", Icon = Icons.NoClip, Desc = "يمر عبر الجدران", Cmd = "noclip"},
    {Name = "السرعة", Icon = Icons.Speed, Desc = "يغير سرعة المشي", Cmd = "speed", Type = "input"}
}

-- إضافة الأزرار
for _, cmd in ipairs(Commands) do
    local button = createCommandButton(cmd.Name, cmd.Icon, cmd.Desc, cmd.Type)
    
    if cmd.Type == "input" then
        button.FocusLost:Connect(function()
            executeServerSide(cmd.Cmd, button.Text)
        end)
    else
        button.MouseButton1Click:Connect(function()
            executeServerSide(cmd.Cmd)
        end)
    end
end

-- تكييف حجم منطقة الأزرار
ButtonsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ButtonsFrame.CanvasSize = UDim2.new(0, 0, 0, ButtonsLayout.AbsoluteContentSize.Y + 10)
end)

-- نظام التحريك وتغيير الحجم المتطور
local dragging, resizing, dragStart, startPos, startSize

local function updatePosition(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

local function updateSize(input)
    local delta = input.Position - dragStart
    local newSize = UDim2.new(
        startSize.X.Scale, 
        math.clamp(startSize.X.Offset + delta.X, 200, 600),
        startSize.Y.Scale,
        math.clamp(startSize.Y.Offset + delta.Y, 300, 800)
    )
    
    TweenService:Create(MainFrame, TweenInfo.new(0.1), {Size = newSize}):Play()
end

-- مؤشر تغيير الحجم
local ResizeIndicator = Instance.new("Frame")
ResizeIndicator.Size = UDim2.new(0, 10, 0, 10)
ResizeIndicator.Position = UDim2.new(1, -10, 1, -10)
ResizeIndicator.BackgroundColor3 = Color3.fromRGB(100, 100, 150)
ResizeIndicator.BorderSizePixel = 0
ResizeIndicator.Parent = MainFrame

local ResizeCorner = Instance.new("UICorner")
ResizeCorner.CornerRadius = UDim.new(0.5, 0)
ResizeCorner.Parent = ResizeIndicator

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local absolutePosition = input.Position.X - MainFrame.AbsolutePosition.X
        local absoluteSize = MainFrame.AbsoluteSize.X
        
        -- التحقق إذا كان النقر على الزاوية لتغيير الحجم
        if (input.Position - MainFrame.AbsolutePosition).X > MainFrame.AbsoluteSize.X - 20 and
           (input.Position - MainFrame.AbsolutePosition).Y > MainFrame.AbsoluteSize.Y - 20 then
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
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

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

-- إظهار/إخفاء الواجهة بمفتاح (F5)
local isVisible = true

UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.F5 then
        isVisible = not isVisible
        MainFrame.Visible = isVisible
    end
end)

-- تأثيرات إضافية عند التفاعل
mouse.Move:Connect(function()
    ResizeIndicator.BackgroundColor3 = (mouse.X > MainFrame.AbsolutePosition.X + MainFrame.AbsoluteSize.X - 20 and 
                                      mouse.Y > MainFrame.AbsolutePosition.Y + MainFrame.AbsoluteSize.Y - 20) and 
                                      Color3.fromRGB(150, 150, 200) or 
                                      Color3.fromRGB(100, 100, 150)
end)