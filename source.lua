local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")

-- ServerSide Controller
local function CreateRemoteFunction()
    local remote = Instance.new("RemoteFunction")
    remote.Name = "ArabHubRemote"
    
    remote.OnServerInvoke = function(player, cmd, ...)
        local args = {...}
        local character = player.Character
        
        if cmd == "fly" then
            -- نظام الطيران
            local flyEnabled = not character:GetAttribute("FlyEnabled")
            character:SetAttribute("FlyEnabled", flyEnabled)
            
            if flyEnabled then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.PlatformStand = true
                    local bodyGyro = Instance.new("BodyGyro")
                    bodyGyro.P = 10000
                    bodyGyro.MaxTorque = Vector3.new(100000, 100000, 100000)
                    bodyGyro.CFrame = character.HumanoidRootPart.CFrame
                    bodyGyro.Parent = character.HumanoidRootPart
                    
                    local bodyVelocity = Instance.new("BodyVelocity")
                    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                    bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
                    bodyVelocity.Parent = character.HumanoidRootPart
                end
            else
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.PlatformStand = false
                end
                
                for _, v in ipairs(character.HumanoidRootPart:GetChildren()) do
                    if v:IsA("BodyVelocity") or v:IsA("BodyGyro") then
                        v:Destroy()
                    end
                end
            end
            return true
            
        elseif cmd == "noclip" then
            local noclip = not character:GetAttribute("NoclipEnabled")
            character:SetAttribute("NoclipEnabled", noclip)
            return true
            
        elseif cmd == "fling" then
            local target = args[1]
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                target.Character.HumanoidRootPart.Velocity = Vector3.new(
                    math.random(-5000,5000),
                    math.random(-5000,5000),
                    math.random(-5000,5000)
                )
            end
            return true
            
        elseif cmd == "speed" then
            local speed = tonumber(args[1]) or 50
            speed = math.clamp(speed, 0, 1000)
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = speed
            end
            return true
            
        elseif cmd == "daynight" then
            if Lighting.ClockTime == 14 then
                Lighting.ClockTime = 2
            else
                Lighting.ClockTime = 14
            end
            return true
        end
        return false
    end
    
    return remote
end

-- Client UI
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- إنشاء الواجهة الرئيسية
local ArabHub = Instance.new("ScreenGui")
ArabHub.Name = "ArabHub"
ArabHub.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0.55, 0, 0.7, 0) -- حجم أكبر
MainFrame.Position = UDim2.new(0.225, 0, 0.15, 0)
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

-- شريط العنوان مع إمكانية التحريك
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

-- زر الإغلاق
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0.08, 0, 0.7, 0)
CloseButton.Position = UDim2.new(0.91, 0, 0.15, 0)
CloseButton.Text = "X"
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
ButtonsFrame.Size = UDim2.new(0.96, 0, 0.88, 0)
ButtonsFrame.Position = UDim2.new(0.02, 0, 0.09, 0)
ButtonsFrame.BackgroundTransparency = 1
ButtonsFrame.ScrollBarThickness = 6
ButtonsFrame.Parent = MainFrame

local ButtonsLayout = Instance.new("UIGridLayout")
ButtonsLayout.CellPadding = UDim2.new(0.02, 0, 0.02, 0)
ButtonsLayout.CellSize = UDim2.new(0.48, 0, 0.15, 0)
ButtonsLayout.Parent = ButtonsFrame

-- نظام الأوامر
local Commands = {
    ["fly"] = {
        Execute = function()
            local remote = player:FindFirstChild("ArabHubRemote")
            if remote then
                remote:InvokeServer("fly")
            end
        end,
        Description = "تفعيل/إيقاف الطيران",
        Category = "الأكثر شعبية"
    },
    ["noclip"] = {
        Execute = function()
            local remote = player:FindFirstChild("ArabHubRemote")
            if remote then
                remote:InvokeServer("noclip")
            end
        end,
        Description = "تفعيل/إيقاف اختراق الجدران",
        Category = "الأكثر شعبية"
    },
    ["speed"] = {
        Execute = function()
            local speedInput = Instance.new("TextBox")
            speedInput.Size = UDim2.new(0.6, 0, 0.7, 0)
            speedInput.Position = UDim2.new(0.2, 0, 0.15, 0)
            speedInput.PlaceholderText = "أدخل السرعة (0-1000)"
            speedInput.Parent = MainFrame
            
            speedInput.FocusLost:Connect(function()
                local remote = player:FindFirstChild("ArabHubRemote")
                if remote then
                    remote:InvokeServer("speed", speedInput.Text)
                end
                speedInput:Destroy()
            end)
        end,
        Description = "تغيير سرعة المشي",
        Category = "الأوامر الأساسية"
    },
    ["fling"] = {
        Execute = function()
            -- واجهة اختيار اللاعبين
            local SelectionUI = Instance.new("Frame")
            SelectionUI.Size = UDim2.new(0.6, 0, 0.7, 0)
            SelectionUI.Position = UDim2.new(0.2, 0, 0.15, 0)
            SelectionUI.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
            SelectionUI.Parent = ArabHub
            
            local Title = Instance.new("TextLabel")
            Title.Size = UDim2.new(1, 0, 0.1, 0)
            Title.Text = "اختر لاعب للرمي"
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
            Title.Font = Enum.Font.GothamBold
            Title.TextSize = 18
            Title.Parent = SelectionUI
            
            local PlayersFrame = Instance.new("ScrollingFrame")
            PlayersFrame.Size = UDim2.new(1, 0, 0.9, 0)
            PlayersFrame.Position = UDim2.new(0, 0, 0.1, 0)
            PlayersFrame.BackgroundTransparency = 1
            PlayersFrame.Parent = SelectionUI
            
            for _, target in ipairs(Players:GetPlayers()) do
                if target ~= player then
                    local PlayerButton = Instance.new("TextButton")
                    PlayerButton.Size = UDim2.new(0.9, 0, 0, 50)
                    PlayerButton.Position = UDim2.new(0.05, 0, 0, 0)
                    PlayerButton.Text = target.Name
                    PlayerButton.Parent = PlayersFrame
                    
                    PlayerButton.MouseButton1Click:Connect(function()
                        local remote = player:FindFirstChild("ArabHubRemote")
                        if remote then
                            remote:InvokeServer("fling", target)
                        end
                        SelectionUI:Destroy()
                    end)
                end
            end
        end,
        Description = "رمي لاعب معين",
        Category = "الأوامر الأساسية"
    },
    ["daynight"] = {
        Execute = function()
            local remote = player:FindFirstChild("ArabHubRemote")
            if remote then
                remote:InvokeServer("daynight")
            end
        end,
        Description = "تبديل بين الليل والنهار",
        Category = "الأوامر الأساسية"
    },
    ["infiniteyield"] = {
        Execute = function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
        end,
        Description = "أداة Infinite Yield المتقدمة",
        Category = "أدوات المطورين"
    },
    ["dex"] = {
        Execute = function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/infyiff/backup/main/dex.lua'))()
        end,
        Description = "أداة DEX Explorer للفحص",
        Category = "أدوات المطورين"
    }
}

-- تصنيفات الأوامر
local Categories = {
    ["الأكثر شعبية"] = {
        Color = Color3.fromRGB(70, 50, 80)
    },
    ["الأوامر الأساسية"] = {
        Color = Color3.fromRGB(50, 70, 80)
    },
    ["أدوات المطورين"] = {
        Color = Color3.fromRGB(50, 80, 70)
    }
}

-- إنشاء أزرار الأوامر حسب التصنيفات
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
            Button.Text = cmdName:upper()
            Button.TextColor3 = Color3.fromRGB(220, 220, 255)
            Button.Font = Enum.Font.GothamBold
            Button.TextSize = 14
            Button.Parent = ButtonsFrame
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0.1, 0)
            ButtonCorner.Parent = Button
            
            local ButtonStroke = Instance.new("UIStroke")
            ButtonStroke.Color = Color3.fromRGB(80, 80, 100)
            ButtonStroke.Thickness = 2
            ButtonStroke.Parent = Button
            
            local Desc = Instance.new("TextLabel")
            Desc.Text = cmdData.Description
            Desc.Size = UDim2.new(0.9, 0, 0.4, 0)
            Desc.Position = UDim2.new(0.05, 0, 0.6, 0)
            Desc.TextColor3 = Color3.fromRGB(180, 180, 220)
            Desc.BackgroundTransparency = 1
            Desc.Font = Enum.Font.Gotham
            Desc.TextSize = 12
            Desc.TextXAlignment = Enum.TextXAlignment.Left
            Desc.Parent = Button
            
            Button.MouseButton1Click:Connect(function()
                cmdData.Execute()
            end)
        end
    end
end

-- نظام التحريك
local dragging, dragInput, dragStart, startPos

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
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- إغلاق الواجهة
CloseButton.MouseButton1Click:Connect(function()
    ArabHub:Destroy()
end)

-- إظهار/إخفاء الواجهة بمفتاح F5
local isVisible = true
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.F5 then
        isVisible = not isVisible
        MainFrame.Visible = isVisible
    end
end)

-- إنشاء RemoteFunction على السيرفر
if game:GetService("RunService"):IsStudio() then
    -- وضع التطوير (Studio)
    local remote = CreateRemoteFunction()
    remote.Parent = player
else
    -- وضع اللعبة العادي (يجب تنفيذ هذا الجزء من السيرفر)
    warn("يجب وضع جزء السيرفر في ServerScriptService")
end