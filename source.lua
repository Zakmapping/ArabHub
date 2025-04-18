local ScriptHub = Instance.new("ScreenGui")
ScriptHub.Name = "AdvancedScriptHub"
ScriptHub.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 500)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScriptHub

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "Advanced Script Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = MainFrame

local Scroller = Instance.new("ScrollingFrame")
Scroller.Size = UDim2.new(1, -10, 1, -50)
Scroller.Position = UDim2.new(0, 5, 0, 45)
Scroller.BackgroundTransparency = 1
Scroller.ScrollBarThickness = 5
Scroller.Parent = MainFrame

local ButtonLayout = Instance.new("UIListLayout")
ButtonLayout.Padding = UDim.new(0, 10)
ButtonLayout.Parent = Scroller

local ButtonTemplate = Instance.new("TextButton")
ButtonTemplate.Size = UDim2.new(1, 0, 0, 50)
ButtonTemplate.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
ButtonTemplate.TextColor3 = Color3.fromRGB(255, 255, 255)
ButtonTemplate.Font = Enum.Font.Gotham
ButtonTemplate.TextSize = 14
ButtonTemplate.AutoButtonColor = true

local Commands = {
    {
        Name = "Kill All Players",
        Description = "يقتل جميع اللاعبين في السيرفر",
        Execute = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))():Cmd("kill all")
        end
    },
    {
        Name = "F3X Building Tools",
        Description = "يضيف أدوات البناء F3X",
        Execute = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/VisualRoblox/Roblox/main/F3X.lua"))()
        end
    },
    {
        Name = "Fly (طيران)",
        Description = "يمكنك من الطيران في اللعبة",
        Execute = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyScriptV3/main/FlyScriptV3.txt"))()
        end
    },
    {
        Name = "Infinite Yield",
        Description = "أداة متعددة الأغراض مع أوامر كثيرة",
        Execute = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
        end
    },
    {
        Name = "Speed (سرعة)",
        Description = "يزيد سرعة المشي إلى 50",
        Execute = function()
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 50
        end
    }
}

for _, cmd in ipairs(Commands) do
    local button = ButtonTemplate:Clone()
    button.Text = cmd.Name .. "\n" .. cmd.Description
    button.Parent = Scroller
    
    button.MouseButton1Click:Connect(function()
        pcall(function()
            cmd.Execute()
        end)
    end)
end

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

ButtonLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Scroller.CanvasSize = UDim2.new(0, 0, 0, ButtonLayout.AbsoluteContentSize.Y + 10)
end)

local UIS = game:GetService("UserInputService")
local isOpen = true

UIS.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.F5 then
        isOpen = not isOpen
        MainFrame.Visible = isOpen
    end
end)

-- كود التحريك الجديد
local UserInputService = game:GetService("UserInputService")
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)
