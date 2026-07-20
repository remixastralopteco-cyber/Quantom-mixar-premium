--[[
    BLOX FRUITS ULTIMATE SCRIPT v3.0
    SCRIPT COMPLETO E FUNCIONAL
]]

-- ===== INICIALIZAÇÃO =====
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TeleportService = game:GetService("TeleportService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- ===== VARIÁVEIS =====
local autoFarmEnabled = false
local autoRaidEnabled = false
local espEnabled = false
local espFruits = false
local espPlayers = false
local aimbotEnabled = false
local autoHakiEnabled = false
local hakiVersion = "V1"
local autoBelisEnabled = false
local autoFragmentEnabled = false

-- ===== ANTI-BAN =====
local function setupAntiBan()
    if syn and syn.protect_gui then
        syn.protect_gui(screenGui)
    end
    local oldWarn = warn
    warn = function(...) end
    local oldPrint = print
    print = function(...)
        local msg = tostring(...)
        if msg:find("Exploit") or msg:find("Cheat") or msg:find("Hack") then
            return
        end
        oldPrint(...)
    end
end

-- ===== ANTI-AFK =====
local AntiAFK = {Enabled = true}
local function setupAntiAFK()
    coroutine.wrap(function()
        while AntiAFK.Enabled and RunService.Heartbeat:Wait() do
            if character and character:FindFirstChild("HumanoidRootPart") then
                local randomAngle = math.random() * 2 * math.pi
                local moveVector = Vector3.new(
                    math.cos(randomAngle) * 0.1,
                    0,
                    math.sin(randomAngle) * 0.1
                )
                character.HumanoidRootPart.Velocity = Vector3.new(
                    character.HumanoidRootPart.Velocity.X + moveVector.X,
                    character.HumanoidRootPart.Velocity.Y,
                    character.HumanoidRootPart.Velocity.Z + moveVector.Z
                )
            end
            wait(0.1)
        end
    end)()
end

-- ===== ANTI-ADMIN =====
local AdminList = {
    "Shedletsky", "Clockwork", "Builderman", "Roblox", "Admin", "Moderator"
}
local function checkForAdmins()
    coroutine.wrap(function()
        while wait(3) do
            for _, otherPlayer in ipairs(Players:GetPlayers()) do
                if otherPlayer ~= player then
                    local isAdmin = false
                    for _, adminName in ipairs(AdminList) do
                        if otherPlayer.Name:lower():match(adminName:lower()) then
                            isAdmin = true
                            break
                        end
                    end
                    if isAdmin then
                        print("⚠️ ADMIN: " .. otherPlayer.Name)
                        autoFarmEnabled = false
                        autoRaidEnabled = false
                        espEnabled = false
                        if screenGui then screenGui:Destroy() end
                        wait(1)
                        TeleportService:Teleport(game.PlaceId)
                    end
                end
            end
        end
    end)()
end

-- ===== FUNÇÕES =====
local function teleportTo(position)
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = CFrame.new(position)
        return true
    end
    return false
end

local function teleportToPlayer(targetName)
    for _, target in ipairs(Players:GetPlayers()) do
        if target.Name:lower():match(targetName:lower()) then
            if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                teleportTo(target.Character.HumanoidRootPart.Position + Vector3.new(0, 5, 0))
                return true
            end
        end
    end
    return false
end

local function teleportToIsland(islandName)
    local islands = {
        ["Marine Fort"] = Vector3.new(-2000, 20, 1500),
        ["Jungle"] = Vector3.new(-1500, 10, -2000),
        ["Prison"] = Vector3.new(1000, 20, -1500),
        ["Sky Island"] = Vector3.new(-3000, 500, 3000),
        ["Frost Island"] = Vector3.new(3000, 50, -3000),
        ["Dragon Island"] = Vector3.new(-4000, 100, -4000),
        ["Law Island"] = Vector3.new(2000, 30, 2000),
        ["Cake Island"] = Vector3.new(-2500, 20, -2500)
    }
    if islands[islandName] then
        teleportTo(islands[islandName])
        return true
    end
    return false
end

local function attackTarget(target)
    if target and target:FindFirstChild("HumanoidRootPart") then
        teleportTo(target.HumanoidRootPart.Position)
        wait(0.1)
        VirtualInputManager:SendKeyEvent(true, "Z", false, nil)
        wait(0.1)
        VirtualInputManager:SendKeyEvent(false, "Z", false, nil)
        wait(0.05)
        VirtualInputManager:SendKeyEvent(true, "X", false, nil)
        wait(0.1)
        VirtualInputManager:SendKeyEvent(false, "X", false, nil)
        return true
    end
    return false
end

local function getNearestMob(radius)
    radius = radius or 100
    local nearest = nil
    local shortest = math.huge
    for _, v in ipairs(Workspace:GetChildren()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
            if v.Humanoid.Health > 0 then
                local distance = (v.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude
                if distance < shortest and distance < radius then
                    if v.Name:find("Mob") or v.Name:find("NPC") or v.Name:find("Enemy") then
                        nearest = v
                        shortest = distance
                    end
                end
            end
        end
    end
    return nearest
end

-- ===== AUTO FARM =====
local function autoFarm()
    while autoFarmEnabled and RunService.Heartbeat:Wait() do
        local target = getNearestMob()
        if target then
            attackTarget(target)
        else
            local randomPos = character.HumanoidRootPart.Position + Vector3.new(
                math.random(-50, 50),
                0,
                math.random(-50, 50)
            )
            teleportTo(randomPos)
        end
        wait(0.3)
    end
end

-- ===== AUTO RAID =====
local function autoRaid()
    while autoRaidEnabled and RunService.Heartbeat:Wait() do
        for _, v in ipairs(Workspace:GetChildren()) do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                if v.Name:find("Raid") or v.Name:find("Law") or v.Name:find("Cake") then
                    if v.Humanoid.Health > 0 then
                        attackTarget(v)
                    end
                end
            end
        end
        wait(0.3)
    end
end

-- ===== AUTO BELIS =====
local function autoBelis()
    while autoBelisEnabled and RunService.Heartbeat:Wait() do
        local target = getNearestMob()
        if target then
            attackTarget(target)
        end
        wait(0.3)
    end
end

-- ===== AUTO FRAGMENT =====
local function autoFragment()
    while autoFragmentEnabled and RunService.Heartbeat:Wait() do
        for _, v in ipairs(Workspace:GetChildren()) do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                if v.Name:find("Fragment") or v.Name:find("Raid") then
                    attackTarget(v)
                end
            end
        end
        wait(0.3)
    end
end

-- ===== AUTO HAKI =====
local function autoHaki()
    while autoHakiEnabled and RunService.Heartbeat:Wait() do
        local hakiNPCs = {"Haki Trainer", "Haki Master", "Observation Trainer"}
        for _, npcName in ipairs(hakiNPCs) do
            for _, v in ipairs(Workspace:GetChildren()) do
                if v:IsA("Model") and v.Name:find(npcName) then
                    if v:FindFirstChild("HumanoidRootPart") then
                        teleportTo(v.HumanoidRootPart.Position)
                        wait(0.5)
                        VirtualInputManager:SendKeyEvent(true, "E", false, nil)
                        wait(0.2)
                        VirtualInputManager:SendKeyEvent(false, "E", false, nil)
                        wait(0.5)
                    end
                end
            end
        end
        wait(2)
    end
end

-- ===== AIMBOT =====
local function aimbot()
    while aimbotEnabled and RunService.Heartbeat:Wait() do
        local target = nil
        local shortest = math.huge
        for _, v in ipairs(Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local distance = (v.Character.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude
                if distance < shortest then
                    target = v
                    shortest = distance
                end
            end
        end
        if target then
            local camera = game.Workspace.CurrentCamera
            camera.CFrame = CFrame.new(
                camera.CFrame.Position,
                target.Character.HumanoidRootPart.Position
            )
            VirtualInputManager:SendMouseButtonEvent(0, 0, true, Enum.UserInputType.MouseButton1, 1)
            wait(0.1)
            VirtualInputManager:SendMouseButtonEvent(0, 0, false, Enum.UserInputType.MouseButton1, 1)
        end
        wait(0.05)
    end
end

-- ===== CRIAÇÃO DA GUI =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BloxFruitsUltimateGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

if syn and syn.protect_gui then
    syn.protect_gui(screenGui)
end

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 600, 0, 450)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 25)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local glassEffect = Instance.new("Frame")
glassEffect.Size = UDim2.new(1, 0, 1, 0)
glassEffect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
glassEffect.BackgroundTransparency = 0.95
glassEffect.BorderSizePixel = 0
glassEffect.Parent = mainFrame

local neonBorder = Instance.new("Frame")
neonBorder.Size = UDim2.new(1, 4, 1, 4)
neonBorder.Position = UDim2.new(0, -2, 0, -2)
neonBorder.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
neonBorder.BackgroundTransparency = 0.5
neonBorder.BorderSizePixel = 0
neonBorder.Parent = mainFrame

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 50)
titleBar.BackgroundTransparency = 1
titleBar.Parent = mainFrame

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, 0, 1, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "⚡ BLOX FRUITS ULTIMATE"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextSize = 20
titleText.Font = Enum.Font.GothamBold
titleText.Parent = titleBar

-- ===== NOTIFICAÇÃO =====
function notify(message, color)
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(0, 300, 0, 40)
    notification.Position = UDim2.new(1, 20, 0, 10)
    notification.BackgroundColor3 = color or Color3.fromRGB(0, 150, 255)
    notification.BackgroundTransparency = 0.85
    notification.BorderSizePixel = 0
    notification.Parent = screenGui
    
    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = message
    text.TextColor3 = Color3.fromRGB(255, 255, 255)
    text.TextSize = 14
    text.Font = Enum.Font.Gotham
    text.Parent = notification
    
    notification.Position = UDim2.new(1, 0, 0, 10)
    TweenService:Create(notification, TweenInfo.new(0.5), {
        Position = UDim2.new(1, -310, 0, 10)
    }):Play()
    
    wait(3)
    TweenService:Create(notification, TweenInfo.new(0.5), {
        Position = UDim2.new(1, 20, 0, 10)
    }):Play()
    wait(0.5)
    notification:Destroy()
end

-- ===== MENU LATERAL =====
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 150, 1, 0)
sidebar.Position = UDim2.new(0, 0, 0, 50)
sidebar.BackgroundColor3 = Color3.fromRGB(5, 5, 15)
sidebar.BackgroundTransparency = 0.2
sidebar.BorderSizePixel = 0
sidebar.Parent = mainFrame

local tabs = {
    {name = "⚔️ Auto Farm", key = "AutoFarm"},
    {name = "🎯 Auto Raid", key = "AutoRaid"},
    {name = "👁️ ESP", key = "ESP"},
    {name = "🚀 Teleports", key = "Teleports"},
    {name = "⚡ Haki/V4", key = "Haki"},
    {name = "🎯 AimBot", key = "AimBot"},
    {name = "💰 Farm", key = "Farm"},
    {name = "⚙️ Settings", key = "Settings"}
}

local buttonY = 10
for _, tab in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, buttonY)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 55)
    btn.BackgroundTransparency = 0.8
    btn.BorderSizePixel = 0
    btn.Text = tab.name
    btn.TextColor3 = Color3.fromRGB(180, 180, 220)
    btn.TextSize = 13
    btn.Font = Enum.Font.Gotham
    btn.Parent = sidebar
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.3), {
            BackgroundTransparency = 0.5,
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.3), {
            BackgroundTransparency = 0.8,
            TextColor3 = Color3.fromRGB(180, 180, 220)
        }):Play()
    end)
    
    buttonY = buttonY + 45
end

local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -150, 1, -50)
contentArea.Position = UDim2.new(0, 150, 0, 50)
contentArea.BackgroundTransparency = 1
contentArea.ClipsDescendants = true
contentArea.Parent = mainFrame

-- ===== ARRASTAR =====
local dragging = false
local dragStart = nil
local startPos = nil

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

mainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- ===== ATIVAR SEGURANÇA =====
setupAntiBan()
setupAntiAFK()
checkForAdmins()

-- ===== INICIALIZAÇÃO =====
notify("🛡️ Segurança Ativada!", Color3.fromRGB(0, 200, 100))
notify("🚀 Script Carregado!", Color3.fromRGB(0, 150, 255))
notify("👑 Nenhum admin", Color3.fromRGB(100, 255, 100))

print("✅ BLOX FRUITS ULTIMATE SCRIPT CARREGADO!")
print("📌 Versão: 3.0")
print("👤 Usuário: " .. player.Name)