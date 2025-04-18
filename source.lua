local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- نظام معالجة الأخطاء
local function SafeExecute(func)
    local success, err = pcall(func)
    if not success then
        warn("ArabHub Error: "..tostring(err))
        return false
    end
    return true
end

-- إنشاء الواجهة الرئيسية (تم إصلاح السطر 479)
local ArabHub = Instance.new("ScreenGui")
ArabHub.Name = "ArabHubVIP"
ArabHub.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0.45, 0, 0.65, 0)  -- هذا هو السطر 479 المصحح
MainFrame.Position = UDim2.new(0.275, 0, 0.175, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ArabHub

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.05, 0)
UICorner.Parent = MainFrame

-- نظام الأوامر الأساسي
local Commands = {
    ["infiniteyield"] = {
        Execute = function()
            SafeExecute(function()
                loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
            end)
        end,
        Description = "أداة Infinite Yield مع أوامر متقدمة"
    },
    ["dex"] = {
        Execute = function()
            SafeExecute(function()
                loadstring(game:HttpGet('https://raw.githubusercontent.com/infyiff/backup/main/dex.lua'))()
            end)
        end,
        Description = "أداة DEX Explorer للفحص المتقدم"
    },
    ["noclip"] = {
        Execute = function()
            local noclip = false
            noclip = not noclip
            
            RunService.Stepped:Connect(function()
                local character = player.Character
                if noclip and character then
                    for _, part in pairs(character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end,
        Description = "تخطي الجدران والعوائق"
    },
    ["speed"] = {
        Execute = function(value)
            local speed = tonumber(value) or 50
            speed = math.clamp(speed, 0, 1000)
            SafeExecute(function()
                player.Character.Humanoid.WalkSpeed = speed
            end)
        end,
        Description = "تغيير سرعة المشي (0-1000)",
        HasInput = true
    },
    ["fly"] = {
        Execute = function()
            SafeExecute(function()
                loadstring(game:HttpGet('https://raw.githubusercontent.com/SuperCuteBunny/Roblox-HAX/main/Fly.lua'))()
            end)
        end,
        Description = "نظام الطيران المتقدم"
    },
    ["daynight"] = {
        Execute = function()
            if Lighting.ClockTime == 14 then
                Lighting.ClockTime = 2
            else
                Lighting.ClockTime = 14
            end
        end,
        Description = "تبديل بين الليل والنهار"
    }
}

-- إنشاء واجهة الأزرار
local ButtonsFrame = Instance.new("ScrollingFrame")
ButtonsFrame.Size = UDim2.new(0.95, 0, 0.88, 0)
ButtonsFrame.Position = UDim2.new(0.025, 0, 0.1, 0)
ButtonsFrame.BackgroundTransparency = 1
ButtonsFrame.ScrollBarThickness = 6
ButtonsFrame.Parent = MainFrame

local ButtonsLayout = Instance.new("UIGridLayout")
ButtonsLayout.CellPadding = UDim2.new(0.02, 0, 0.02, 0)
ButtonsLayout.CellSize = UDim2.new(0.48, 0, 0.15, 0)
ButtonsLayout.Parent = ButtonsFrame

-- الأيقونات (يمكن استبدالها)
local Icons = {
    infiniteyield = "rbxassetid://7072717361",
    dex = "rbxassetid://7072716542",
    noclip = "rbxassetid://7072715432",
    speed = "rbxassetid://7072714321",
    fly = "rbxassetid://7072718123",
    daynight = "rbxassetid://7072710987"
}

-- إنشاء أزرار الأوامر
for cmdName, cmdData in pairs(Commands) do
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 1, 0)
    Button.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    Button.Text = ""
    Button.Parent = ButtonsFrame
    
    local Icon = Instance.new("ImageLabel")
    Icon.Image = Icons[cmdName] or ""
    Icon.Size = UDim2.new(0.2, 0, 0.5, 0)
    Icon.Position = UDim2.new(0.05, 0, 0.25, 0)
    Icon.BackgroundTransparency = 1
    Icon.Parent = Button
    
    local Label = Instance.new("TextLabel")
    Label.Text = cmdName:upper()
    Label.Size = UDim2.new(0.7, 0, 0.5, 0)
    Label.Position = UDim2.new(0.25, 0, 0.1, 0)
    Label.TextColor3 = Color3.fromRGB(220, 220, 255)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Button
    
    local Desc = Instance.new("TextLabel")
    Desc.Text = cmdData.Description
    Desc.Size = UDim2.new(0.7, 0, 0.3, 0)
    Desc.Position = UDim2.new(0.25, 0, 0.5, 0)
    Desc.TextColor3 = Color3.fromRGB(180, 180, 220)
    Desc.BackgroundTransparency = 1
    Desc.Font = Enum.Font.Gotham
    Desc.TextSize = 12
    Desc.TextXAlignment = Enum.TextXAlignment.Left
    Desc.Parent = Button
    
    if cmdData.HasInput then
        local InputBox = Instance.new("TextBox")
        InputBox.Size = UDim2.new(0.25, 0, 0.5, 0)
        InputBox.Position = UDim2.new(0.7, 0, 0.25, 0)
        InputBox.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
        InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        InputBox.PlaceholderText = "القيمة"
        InputBox.Text = ""
        InputBox.Parent = Button
        
        Button.MouseButton1Click:Connect(function()
            cmdData.Execute(InputBox.Text)
        end)
    else
        Button.MouseButton1Click:Connect(function()
            cmdData.Execute()
        end)
    end
end

-- نظام التحريك
local dragging, dragInput, dragStart, startPos

local function UpdateInput(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MainFrame.InputBegan:Connect(function(input)
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

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        UpdateInput(input)
    end
end)

-- إظهار/إخفاء الواجهة بمفتاح F5
local isVisible = true
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.F5 then
        isVisible = not isVisible
        MainFrame.Visible = isVisible
    end
end)

-- التأكد من تحميل الواجهة
warn("ArabHub VIP تم تحميله بنجاح!")