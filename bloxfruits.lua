--[[
    BLOX FRUITS ULTIMATE - DELTA
    Script otimizado para celular
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

-- ===== FUNÇÕES =====
local function tp(pos)
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(pos)
    end
end

local function atk(target)
    if target and target:FindFirstChild("HumanoidRootPart") then
        tp(target.HumanoidRootPart.Position)
        VirtualInputManager:SendKeyEvent(true, "Z", false, nil)
        wait(0.1)
        VirtualInputManager:SendKeyEvent(false, "Z", false, nil)
        VirtualInputManager:SendKeyEvent(true, "X", false, nil)
        wait(0.1)
        VirtualInputManager:SendKeyEvent(false, "X", false, nil)
    end
end

local function getMob()
    local nearest, dist = nil, math.huge
    for _, v in pairs(Workspace:GetChildren()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
            if v.Humanoid.Health > 0 then
                local d = (v.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude
                if d < dist and d < 150 then
                    nearest, dist = v, d
                end
            end
        end
    end
    return nearest
end

local function getPlayer(targetName)
    for _, v in pairs(Players:GetPlayers()) do
        if v.Name:lower():match(targetName:lower()) then
            return v
        end
    end
    return nil
end

-- ===== VARIÁVEIS =====
local farmOn, raidOn, espOn = false, false, false

-- ===== AUTO FARM =====
local function farm()
    while farmOn and RunService.Heartbeat:Wait() do
        local target = getMob()
        if target then atk(target) end
        wait(0.3)
    end
end

-- ===== AUTO RAID =====
local function raid()
    while raidOn and RunService.Heartbeat:Wait() do
        for _, v in pairs(Workspace:GetChildren()) do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                if v.Name:find("Raid") or v.Name:find("Law") or v.Name:find("Cake") then
                    atk(v)
                end
            end
        end
        wait(0.3)
    end
end

-- ===== CRIAR GUI =====
local gui = Instance.new("ScreenGui")
gui.Name = "BloxUltimate"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local f = Instance.new("Frame")
f.Size = UDim2.new(0, 320, 0, 420)
f.Position = UDim2.new(0.5, -160, 0.5, -210)
f.BackgroundColor3 = Color3.fromRGB(10, 10, 30)
f.BackgroundTransparency = 0.1
f.BorderSizePixel = 0
f.Parent = gui

local glass = Instance.new("Frame")
glass.Size = UDim2.new(1, 0, 1, 0)
glass.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
glass.BackgroundTransparency = 0.95
glass.BorderSizePixel = 0
glass.Parent = f

local border = Instance.new("Frame")
border.Size = UDim2.new(1, 0, 1, 0)
border.Position = UDim2.new(0, 0, 1, 0)
border.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
border.BackgroundTransparency = 0.5
border.BorderSizePixel = 0
border.Parent = f

local t = Instance.new("TextLabel")
t.Size = UDim2.new(1, 0, 0, 45)
t.BackgroundTransparency = 1
t.Text = "⚡ BLOX ULTIMATE"
t.TextColor3 = Color3.fromRGB(0, 200, 255)
t.TextSize = 22
t.Font = Enum.Font.GothamBold
t.Parent = f

-- Botões
local function createBtn(text, y, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BackgroundColor3 = color or Color3.fromRGB(30, 30, 60)
    btn.BackgroundTransparency = 0.5
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 15
    btn.Font = Enum.Font.Gotham
    btn.Parent = f
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local farmBtn = createBtn("⚔️ Auto Farm", 55, Color3.fromRGB(30, 30, 60), function()
    farmOn = not farmOn
    farmBtn.Text = farmOn and "🟢 Auto Farm ON" or "⚔️ Auto Farm"
    if farmOn then coroutine.wrap(farm)() end
end)

local raidBtn = createBtn("🎯 Auto Raid", 105, Color3.fromRGB(30, 30, 60), function()
    raidOn = not raidOn
    raidBtn.Text = raidOn and "🟢 Auto Raid ON" or "🎯 Auto Raid"
    if raidOn then coroutine.wrap(raid)() end
end)

local espBtn = createBtn("👁️ ESP Players", 155, Color3.fromRGB(30, 30, 60), function()
    espOn = not espOn
    espBtn.Text = espOn and "🟢 ESP ON" or "👁️ ESP Players"
    if espOn then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= player and v.Character then
                local h = Instance.new("Highlight")
                h.Parent = v.Character
                h.FillColor = Color3.fromRGB(255, 0, 0)
                h.FillTransparency = 0.3
            end
        end
    end
end)

-- Teleports
local islands = {"Marine", "Jungle", "Sky", "Dragon", "Law", "Cake"}
local posMap = {
    Marine = Vector3.new(-2000, 20, 1500),
    Jungle = Vector3.new(-1500, 10, -2000),
    Sky = Vector3.new(-3000, 500, 3000),
    Dragon = Vector3.new(-4000, 100, -4000),
    Law = Vector3.new(2000, 30, 2000),
    Cake = Vector3.new(-2500, 20, -2500)
}

local y = 205
for i, name in pairs(islands) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.28, 0, 0, 30)
    btn.Position = UDim2.new(0.05 + (i % 3 == 0 and 0.35 or 0) * ((i-1) % 3), 0, 0, y + math.floor((i-1)/3) * 35)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 80)
    btn.BackgroundTransparency = 0.5
    btn.BorderSizePixel = 0
    btn.Text = "🚀 " .. name
    btn.TextColor3 = Color3.fromRGB(200, 200, 255)
    btn.TextSize = 11
    btn.Font = Enum.Font.Gotham
    btn.Parent = f
    btn.MouseButton1Click:Connect(function()
        tp(posMap[name])
        print("🚀 Teleport para " .. name)
    end)
end

-- Teleport Player
local tpInput = Instance.new("TextBox")
tpInput.Size = UDim2.new(0.5, 0, 0, 30)
tpInput.Position = UDim2.new(0.05, 0, 0, 330)
tpInput.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
tpInput.BackgroundTransparency = 0.5
tpInput.BorderSizePixel = 0
tpInput.PlaceholderText = "👤 Nome do Player"
tpInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 200)
tpInput.Text = ""
tpInput.TextColor3 = Color3.fromRGB(255, 255, 255)
tpInput.TextSize = 14
tpInput.Font = Enum.Font.Gotham
tpInput.Parent = f

local tpBtn = Instance.new("TextButton")
tpBtn.Size = UDim2.new(0.3, 0, 0, 30)
tpBtn.Position = UDim2.new(0.6, 0, 0, 330)
tpBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
tpBtn.BackgroundTransparency = 0.3
tpBtn.BorderSizePixel = 0
tpBtn.Text = "Teleport"
tpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
tpBtn.TextSize = 14
tpBtn.Font = Enum.Font.Gotham
tpBtn.Parent = f

tpBtn.MouseButton1Click:Connect(function()
    local target = getPlayer(tpInput.Text)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        tp(target.Character.HumanoidRootPart.Position + Vector3.new(0, 5, 0))
        print("🚀 Teleport para " .. target.Name)
    else
        print("❌ Jogador não encontrado!")
    end
end)

-- Fechar
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0.2, 0, 0, 30)
closeBtn.Position = UDim2.new(0.8, 0, 0, 385)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
closeBtn.BackgroundTransparency = 0.3
closeBtn.BorderSizePixel = 0
closeBtn.Text = "❌ Fechar"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 14
closeBtn.Font = Enum.Font.Gotham
closeBtn.Parent = f

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

print("✅ BLOX ULTIMATE CARREGADO!")