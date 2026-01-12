local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

-- GUI Setup
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "ZenithHub_UNIVERSAL"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 400)  -- Adjusted GUI size
frame.Position = UDim2.new(0.5, -150, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
frame.Draggable = true
frame.Active = true

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
title.Text = "ZenithHub v2.4"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.new(1, 1, 1)
title.TextScaled = true

-- Content Area
local contentFrame = Instance.new("Frame", frame)
contentFrame.Size = UDim2.new(1, -20, 1, -30)
contentFrame.Position = UDim2.new(0, 10, 0, 40)
contentFrame.BackgroundTransparency = 1

-- Button Generator with Active State
local function makeButton(text, positionY, callback)
    local btn = Instance.new("TextButton", contentFrame)
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.Position = UDim2.new(0, 0, 0, positionY)
    btn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextScaled = true
    btn.Text = text
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- ESP (Lines)
local espEnabled = false
local lines = {}

local function createLine(player)
    local line = Drawing.new("Line")
    line.Color = Color3.fromRGB(255, 0, 0)
    line.Thickness = 2
    line.Transparency = 1
    line.Visible = true
    return line
end

local function updateLine(line, player)
    local cam = Workspace.CurrentCamera
    local head = player.Character and player.Character:FindFirstChild("Head")
    local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if head and myHRP then
        local pos1 = cam:WorldToViewportPoint(myHRP.Position)
        local pos2 = cam:WorldToViewportPoint(head.Position)
        line.From = Vector2.new(pos1.X, pos1.Y)
        line.To = Vector2.new(pos2.X, pos2.Y)
        line.Visible = true
    else
        line.Visible = false
    end
end

RunService.RenderStepped:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if espEnabled then
                if not lines[player] then lines[player] = createLine(player) end
                updateLine(lines[player], player)
            elseif lines[player] then
                lines[player].Visible = false
            end
        end
    end
end)

-- Fly
local flying = false
local bv, bg

local function getGroundY(pos)
    local ray = Ray.new(pos, Vector3.new(0, -1000, 0))
    local _, hit = Workspace:FindPartOnRay(ray, LocalPlayer.Character)
    return hit.Y
end

local function startFly()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:WaitForChild("HumanoidRootPart")
    if not hrp then return end
    bv = Instance.new("BodyVelocity", hrp)
    bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
    bv.Velocity = Vector3.zero
    bg = Instance.new("BodyGyro", hrp)
    bg.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
    bg.CFrame = hrp.CFrame
end

local function stopFly()
    if bv then bv:Destroy() bv = nil end
    if bg then bg:Destroy() bg = nil end
end

RunService.RenderStepped:Connect(function()
    if flying and LocalPlayer.Character then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp and bv and bg then
            local targetY = getGroundY(hrp.Position) + 20
            bv.Velocity = Vector3.new(0, (targetY - hrp.Position.Y) * 5, 0)
            bg.CFrame = Workspace.CurrentCamera.CFrame
        end
    end
end)

-- Speed, Jump, and Attack Power
local speedEnabled = false
local jumpPowerEnabled = false
local attackPowerEnabled = false

local function setSpeed()
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = speedEnabled and 100 or 16
    end
end

local function setJumpPower()
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.JumpPower = jumpPowerEnabled and 200 or 50
    end
end

local function setAttackPower()
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.Health = attackPowerEnabled and 5000 or 100
    end
end

-- Kill Touch
local killTouchEnabled = false
local killTouchConnections = {}
local function toggleKillTouch()
    killTouchEnabled = not killTouchEnabled
    for _, conn in ipairs(killTouchConnections) do conn:Disconnect() end
    table.clear(killTouchConnections)
    if killTouchEnabled then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                table.insert(killTouchConnections, part.Touched:Connect(function(hit)
                    local hum = hit.Parent and hit.Parent:FindFirstChildOfClass("Humanoid")
                    if hum and hit.Parent ~= LocalPlayer.Character then hum.Health = 0 end
                end))
            end
        end
    end
end

-- Teleport
local function teleportToNearest()
    local closest, dist = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local d = (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if d < dist then closest = player dist = d end
        end
    end
    if closest then
        LocalPlayer.Character.HumanoidRootPart.CFrame = closest.Character.HumanoidRootPart.CFrame + Vector3.new(3, 0, 0)
    end
end

-- Fun Mode
local funModeEnabled = false
local function toggleFunMode()
    funModeEnabled = not funModeEnabled
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") then
            local hum = p.Character.Humanoid
            hum.WalkSpeed = funModeEnabled and math.random(40, 120) or 16
            hum.JumpPower = funModeEnabled and math.random(70, 150) or 50
        end
    end
end

-- Infinite Jump
local infJump = false
UserInputService.JumpRequest:Connect(function()
    if infJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState("Jumping")
    end
end)

-- NoClip
local noClip = false
RunService.Stepped:Connect(function()
    if noClip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- Buttons
local buttons = {
    {"ESP (Lines)", function() espEnabled = not espEnabled end},
    {"Fly (20 studs)", function() flying = not flying if flying then startFly() else stopFly() end end},
    {"Speed (100)", function() speedEnabled = not speedEnabled setSpeed() end},
    {"Jump Power (200)", function() jumpPowerEnabled = not jumpPowerEnabled setJumpPower() end},
    {"Attack Power (5000)", function() attackPowerEnabled = not attackPowerEnabled setAttackPower() end},
    {"Kill Touch", toggleKillTouch},
    {"Teleport to Nearest", teleportToNearest},
    {"Fun Mode", toggleFunMode},
    {"Infinite Jump", function() infJump = not infJump end},
    {"NoClip", function() noClip = not noClip end},
}

for i, b in ipairs(buttons) do
    makeButton(b[1], (i - 1) * 40, b[2])
end
