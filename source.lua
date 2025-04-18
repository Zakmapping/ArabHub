local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- إنشاء الواجهة الرئيسية
local ArabHub = Instance.new("ScreenGui")
ArabHub.Name = "ArabHub"
ArabHub.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0.5, 0, 0.45, 0) -- واجهة عريضة وليست طويلة
MainFrame.Position = UDim2.new(0.25, 0, 0.275, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ArabHub

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.03, 0)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(60, 60, 80)
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

-- شريط العنوان
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0.08, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
TitleBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.8, 0, 1, 0)
Title.Position = UDim2.new(0.1, 0, 0, 0)
Title.Text = "ArabHub"
Title.TextColor3 = Color3.fromRGB(220, 220, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = TitleBar

-- نظام الأوامر الأساسي
local Commands = {
    ["infiniteyield"] = {
        Execute = function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
        end,
        Description = "أداة Infinite Yield مع أوامر متقدمة",
        Category = "أدوات الهاكات"
    },
    ["dex"] = {
        Execute = function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/infyiff/backup/main/dex.lua'))()
        end,
        Description = "أداة DEX Explorer للفحص المتقدم",
        Category = "أدوات الهاكات"
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
        Description = "تخطي الجدران والعوائق",
        Category = "الأكثر شعبية"
    },
    ["speed"] = {
        Execute = function(value)
            local speed = tonumber(value) or 50
            speed = math.clamp(speed, 0, 1000)
            player.Character.Humanoid.WalkSpeed = speed
        end,
        Description = "تغيير سرعة المشي (0-1000)",
        HasInput = true,
        Category = "الأوامر الأساسية"
    },
    ["fly"] = {
        Execute = function()
            -- نظام طيران بدون loadstring
            local flyEnabled = false
            local flySpeed = 50
            local bodyVelocity, bodyGyro
            
            local function enableFly()
                local character = player.Character
                if not character then return end
                
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                
                if not humanoid or not rootPart then return end
                
                humanoid.PlatformStand = true
                
                bodyGyro = Instance.new("BodyGyro")
                bodyGyro.P = 10000
                bodyGyro.MaxTorque = Vector3.new(100000, 100000, 100000)
                bodyGyro.CFrame = rootPart.CFrame
                bodyGyro.Parent = rootPart
                
                bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
                bodyVelocity.Parent = rootPart
                
                return true
            end

            local function disableFly()
                local character = player.Character
                if not character then return end
                
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.PlatformStand = false
                end
                
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    for _, obj in ipairs(rootPart:GetChildren()) do
                        if obj:IsA("BodyVelocity") or obj:IsA("BodyGyro") then
                            obj:Destroy()
                        end
                    end
                end
            end

            flyEnabled = not flyEnabled
            if flyEnabled then
                enableFly()
            else
                disableFly()
            end
        end,
        Description = "نظام الطيران المتقدم",
        Category = "الأكثر شعبية"
    },
    ["daynight"] = {
        Execute = function()
            if Lighting.ClockTime == 14 then
                Lighting.ClockTime = 2
            else
                Lighting.ClockTime = 14
            end
        end,
        Description = "تبديل بين الليل والنهار",
        Category = "الأوامر الأساسية"
    },
    ["fling"] = {
        Execute = function(target)
            if target and target.Character then
                local root = target.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    root.Velocity = Vector3.new(math.random(-5000,5000), math.random(-5000,5000), math.random(-5000,5000))
                end
            end
        end,
        Description = "رمي اللاعبين",
        Category = "الأوامر الأساسية"
    }
}

-- إنشاء واجهة الأزرار
local Categories = {
    ["الأكثر شعبية"] = {
        Color = Color3.fromRGB(70, 50, 80)
    },
    ["أدوات الهاكات"] = {
        Color = Color3.fromRGB(50, 70, 80)
    },
    ["الأوامر الأساسية"] = {
        Color = Color3.fromRGB(50, 80, 70)
    }
}

local ButtonsFrame = Instance.new("ScrollingFrame")
ButtonsFrame.Size = UDim2.new(0.96, 0, 0.88, 0)
ButtonsFrame.Position = UDim2.new(0.02, 0, 0.09, 0)
ButtonsFrame.BackgroundTransparency = 1
ButtonsFrame.ScrollBarThickness = 6
ButtonsFrame.Parent = MainFrame

local ButtonsLayout = Instance.new("UIListLayout")
ButtonsLayout.Padding = UDim.new(0, 10)
ButtonsLayout.Parent = ButtonsFrame

-- إنشاء أزرار الأوامر
for categoryName, categoryData in pairs(Categories) do
    -- عنوان التصنيف
    local CategoryLabel = Instance.new("TextLabel")
    CategoryLabel.Size = UDim2.new(1, 0, 0, 30)
    CategoryLabel.Text = "  " .. categoryName
    CategoryLabel.TextColor3 = Color3.fromRGB(220, 220, 255)
    CategoryLabel.BackgroundColor3 = categoryData.Color
    CategoryLabel.Font = Enum.Font.GothamBold
    CategoryLabel.TextSize = 14
    CategoryLabel.TextXAlignment = Enum.TextXAlignment.Left
    CategoryLabel.Parent = ButtonsFrame
    
    local CategoryCorner = Instance.new("UICorner")
    CategoryCorner.CornerRadius = UDim.new(0.1, 0)
    CategoryCorner.Parent = CategoryLabel
    
    -- إضافة الأزرار لكل تصنيف
    for cmdName, cmdData in pairs(Commands) do
        if cmdData.Category == categoryName then
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, -20, 0, 50)
            Button.Position = UDim2.new(0, 10, 0, 0)
            Button.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
            Button.Text = ""
            Button.AutoButtonColor = true
            Button.Parent = ButtonsFrame
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0.1, 0)
            ButtonCorner.Parent = Button
            
            local ButtonStroke = Instance.new("UIStroke")
            ButtonStroke.Color = Color3.fromRGB(80, 80, 100)
            ButtonStroke.Thickness = 2
            ButtonStroke.Parent = Button
            
            local Label = Instance.new("TextLabel")
            Label.Text = cmdName:upper()
            Label.Size = UDim2.new(0.7, 0, 0.6, 0)
            Label.Position = UDim2.new(0.1, 0, 0.1, 0)
            Label.TextColor3 = Color3.fromRGB(220, 220, 255)
            Label.BackgroundTransparency = 1
            Label.Font = Enum.Font.GothamBold
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Button
            
            local Desc = Instance.new("TextLabel")
            Desc.Text = cmdData.Description
            Desc.Size = UDim2.new(0.7, 0, 0.3, 0)
            Desc.Position = UDim2.new(0.1, 0, 0.6, 0)
            Desc.TextColor3 = Color3.fromRGB(180, 180, 220)
            Desc.BackgroundTransparency = 1
            Desc.Font = Enum.Font.Gotham
            Desc.TextSize = 12
            Desc.TextXAlignment = Enum.TextXAlignment.Left
            Desc.Parent = Button
            
            if cmdData.HasInput then
                local InputBox = Instance.new("TextBox")
                InputBox.Size = UDim2.new(0.25, 0, 0.6, 0)
                InputBox.Position = UDim2.new(0.7, 0, 0.2, 0)
                InputBox.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
                InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
                InputBox.PlaceholderText = "القيمة"
                InputBox.Text = ""
                InputBox.Font = Enum.Font.Gotham
                InputBox.TextSize = 12
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
    end
end

-- نظام التحريك
local dragging, dragInput, dragStart, startPos

local function UpdateInput(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

TitleBar.InputBegan:Connect(function(input)
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

TitleBar.InputChanged:Connect(function(input)
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