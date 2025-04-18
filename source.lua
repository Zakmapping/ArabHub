-- ServerSide Controller (يجب وضعه في Script في ServerScriptService)
local ServerController = [[
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")

local function executeCommand(player, cmd, ...)
    local args = {...}
    
    if cmd == "killall" then
        for _, target in ipairs(Players:GetPlayers()) do
            if target.Character then
                local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.Health = 0
                end
            end
        end
    elseif cmd == "god" then
        if player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.MaxHealth = math.huge
                humanoid.Health = math.huge
            end
        end
    elseif cmd == "fling" then
        if player.Character then
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            if root then
                root.Velocity = Vector3.new(math.random(-5000,5000), math.random(-5000,5000), math.random(-5000,5000))
            end
        end
    elseif cmd == "size" then
        local scale = tonumber(args[1]) or 1
        if player.Character then
            for _, part in ipairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Size = part.Size * scale
                end
            end
        end
    end
end

local function onClientInvoke(player, cmd, ...)
    pcall(executeCommand, player, cmd, ...)
    return true
end

local function initPlayer(player)
    local remote = Instance.new("RemoteFunction")
    remote.Name = "ArabHubRemote"
    remote.Parent = player
    
    remote.OnServerInvoke = onClientInvoke
end

Players.PlayerAdded:Connect(initPlayer)
for _, player in ipairs(Players:GetPlayers()) do
    initPlayer(player)
end
]]

-- Client UI (يتم حقنه من خلال executor)
local ArabHubUI = [[
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local arabHubRemote = player:WaitForChild("ArabHubRemote", 10)

if not arabHubRemote then
    warn("ArabHub: ServerSide غير نشط!")
    return
end

-- تصميم الواجهة المتميز
local ArabHub = Instance.new("ScreenGui")
ArabHub.Name = "ArabHub"
ArabHub.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0.35, 0, 0.5, 0)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ArabHub

-- تأثير زجاجي
local GlassEffect = Instance.new("Frame")
GlassEffect.Size = UDim2.new(1, 0, 1, 0)
GlassEffect.BackgroundTransparency = 0.95
GlassEffect.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
GlassEffect.BorderSizePixel = 0
GlassEffect.ZIndex = -1
GlassEffect.Parent = MainFrame

-- زوايا مستديرة
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.03, 0)
UICorner.Parent = MainFrame

-- ظل أنيق
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(100, 100, 150)
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

-- شريط العنوان
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0.08, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0.03, 0)
TitleCorner.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.8, 0, 1, 0)
Title.Position = UDim2.new(0.1, 0, 0, 0)
Title.Text = "ArabHub - Premium"
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

-- منطقة الأزرار
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

-- الأيقونات المخصصة
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

-- إنشاء أزرار الأوامر
local function createCommandButton(cmdName, iconId, description)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 1, 0)
    Button.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
    Button.Text = ""
    Button.AutoButtonColor = true
    Button.Parent = ButtonsFrame
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0.15, 0)
    ButtonCorner.Parent = Button
    
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
    
    return Button
end

-- الأوامر المتاحة
local Commands = {
    {Name = "قتل الجميع", Icon = Icons.KillAll, Desc = "يقتل كل اللاعبين", Cmd = "killall"},
    {Name = "عدم الموت", Icon = Icons.God, Desc = "مناعة ضد الضرر", Cmd = "god"},
    {Name = "رمي اللاعب", Icon = Icons.Fling, Desc = "يرمي اللاعب بعيداً", Cmd = "fling"},
    {Name = "تغيير الحجم", Icon = Icons.Size, Desc = "يغير حجم شخصيتك", Cmd = "size", HasInput = true},
    {Name = "أدوات بناء", Icon = Icons.F3X, Desc = "أدوات بناء متقدمة", Cmd = "f3x"},
    {Name = "الطيران", Icon = Icons.Fly, Desc = "يطير في الهواء", Cmd = "fly"},
    {Name = "تخطي الجدران", Icon = Icons.NoClip, Desc = "يمر عبر الجدران", Cmd = "noclip"},
    {Name = "السرعة", Icon = Icons.Speed, Desc = "يغير سرعة المشي", Cmd = "speed", HasInput = true}
}

-- إضافة الأزرار
for _, cmd in ipairs(Commands) do
    local button = createCommandButton(cmd.Name, cmd.Icon, cmd.Desc)
    
    if cmd.HasInput then
        local inputBox = Instance.new("TextBox")
        inputBox.Size = UDim2.new(0.8, 0, 0.25, 0)
        inputBox.Position = UDim2.new(0.1, 0, 0.5, 0)
        inputBox.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        inputBox.PlaceholderText = "القيمة"
        inputBox.Text = ""
        inputBox.Font = Enum.Font.Gotham
        inputBox.TextSize = 12
        inputBox.Parent = button
        
        button.MouseButton1Click:Connect(function()
            local value = inputBox.Text
            arabHubRemote:InvokeServer(cmd.Cmd, value)
        end)
    else
        button.MouseButton1Click:Connect(function()
            arabHubRemote:InvokeServer(cmd.Cmd)
        end)
    end
end

-- تكييف حجم منطقة الأزرار
ButtonsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ButtonsFrame.CanvasSize = UDim2.new(0, 0, 0, ButtonsLayout.AbsoluteContentSize.Y + 10)
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
        math.clamp(startSize.X.Offset + delta.X, 200, 600),
        startSize.Y.Scale,
        math.clamp(startSize.Y.Offset + delta.Y, 300, 800)
    )
    
    TweenService:Create(MainFrame, TweenInfo.new(0.1), {Size = newSize}):Play()
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local absolutePosition = input.Position.X - MainFrame.AbsolutePosition.X
        local absoluteSize = MainFrame.AbsoluteSize.X
        
        -- التحقق إذا كان النقر على الزاوية لتغيير الحجم
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
]]

-- كيفية الاستخدام:
-- 1. ضع الجزء الأول (ServerController) في Script داخل ServerScriptService
-- 2. استخدم الجزء الثاني (ArabHubUI) في executor مثل Synapse أو Krnl