local ScriptHub = Instance.new("ScreenGui")
ScriptHub.Name = "MobileScriptHub"
ScriptHub.Parent = game:GetService("CoreGui")

-- إعدادات الواجهة للهاتف
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0.8, 0, 0.7, 0)
MainFrame.Position = UDim2.new(0.1, 0, 0.15, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.BackgroundTransparency = 0.2
MainFrame.Parent = ScriptHub

-- جعل الزوايا مستديرة
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "📱 Mobile Script Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Parent = MainFrame

-- زوايا مستديرة لعنوان النافذة
local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = Title

local Scroller = Instance.new("ScrollingFrame")
Scroller.Size = UDim2.new(1, -10, 1, -50)
Scroller.Position = UDim2.new(0, 5, 0, 45)
Scroller.BackgroundTransparency = 1
Scroller.ScrollBarThickness = 5
Scroller.Parent = MainFrame

local ButtonLayout = Instance.new("UIListLayout")
ButtonLayout.Padding = UDim.new(0, 8)
ButtonLayout.Parent = Scroller

-- تصميم زر أنيق
local ButtonTemplate = Instance.new("TextButton")
ButtonTemplate.Size = UDim2.new(1, 0, 0, 60)
ButtonTemplate.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
ButtonTemplate.TextColor3 = Color3.fromRGB(255, 255, 255)
ButtonTemplate.Font = Enum.Font.Gotham
ButtonTemplate.TextSize = 14
ButtonTemplate.AutoButtonColor = true
ButtonTemplate.TextXAlignment = Enum.TextXAlignment.Left

-- زوايا مستديرة للأزرار
local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 8)
ButtonCorner.Parent = ButtonTemplate

-- الأوامر المحدثة والمصلحة
local Commands = {
    {
        Name = "⚔️ Kill All Players",
        Description = "يقتل جميع اللاعبين في السيرفر",
        Execute = function()
            for _, player in ipairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer then
                    local character = player.Character
                    if character then
                        local humanoid = character:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                            humanoid.Health = 0
                        end
                    end
                end
            end
        end
    },
    {
        Name = "🛠️ F3X Building Tools",
        Description = "أدوات بناء متقدمة",
        Execute = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/VisualRoblox/Roblox/main/F3X.lua", true))()
        end
    },
    {
        Name = "🦅 Fly (طيران)",
        Description = "تمكنك من الطيران في اللعبة",
        Execute = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/SuperCuteBunny/Roblox-HAX/main/Fly.lua", true))()
        end
    },
    {
        Name = "🚀 Speed (سرعة)",
        Description = "تغيير سرعة المشي",
        HasTextBox = true,
        Execute = function(speed)
            speed = tonumber(speed) or 50
            speed = math.clamp(speed, 0, 1000)
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = speed
        end
    },
    {
        Name = "👻 NoClip (تخطي الجدران)",
        Description = "يمر عبر الجدران والأجسام",
        Execute = function()
            local noclip = false
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            
            game:GetService("RunService").Stepped:Connect(function()
                if noclip and character then
                    for _, part in pairs(character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
            
            noclip = not noclip
            return noclip
        end
    }
}

-- إنشاء الأزرار مع تحسينات
for _, cmd in ipairs(Commands) do
    local button = ButtonTemplate:Clone()
    button.Text = "   " .. cmd.Name .. "\n   " .. cmd.Description
    button.Parent = Scroller
    
    if cmd.HasTextBox then
        local textBox = Instance.new("TextBox")
        textBox.Size = UDim2.new(0.3, 0, 0.6, 0)
        textBox.Position = UDim2.new(0.65, 0, 0.2, 0)
        textBox.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        textBox.Text = "50"
        textBox.PlaceholderText = "السرعة"
        textBox.Parent = button
        
        button.MouseButton1Click:Connect(function()
            pcall(function()
                cmd.Execute(textBox.Text)
            end)
        end)
    else
        button.MouseButton1Click:Connect(function()
            pcall(function()
                cmd.Execute()
            end)
        end)
    end
end

-- زر الإغلاق
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.Parent = MainFrame

CloseButton.MouseButton1Click:Connect(function()
    ScriptHub:Destroy()
end)

-- تكييف حجم السكرولر تلقائياً
ButtonLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Scroller.CanvasSize = UDim2.new(0, 0, 0, ButtonLayout.AbsoluteContentSize.Y + 10)
end)

-- نظام التحريك
local UserInputService = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Title.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)