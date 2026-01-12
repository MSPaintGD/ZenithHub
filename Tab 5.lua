local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

-- GUI Setup
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "ZenithHub_Troll"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 450)  -- Adjusted GUI size for dropdown and textbox
frame.Position = UDim2.new(0.5, -150, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
frame.Draggable = true
frame.Active = true

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
title.Text = "ZenithHub Troll"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.new(1, 1, 1)
title.TextScaled = true

-- Content Area
local contentFrame = Instance.new("Frame", frame)
contentFrame.Size = UDim2.new(1, -20, 1, -30)
contentFrame.Position = UDim2.new(0, 10, 0, 40)
contentFrame.BackgroundTransparency = 1

-- Dropdown Menu for Player Selection
local PlayerDropdown = Instance.new("Frame", contentFrame)
PlayerDropdown.Size = UDim2.new(1, 0, 0, 100)
PlayerDropdown.BackgroundColor3 = Color3.fromRGB(34, 139, 34)
PlayerDropdown.Position = UDim2.new(0, 0, 0, 0)

local PlayerDropdownList = Instance.new("UIListLayout", PlayerDropdown)
PlayerDropdownList.SortOrder = Enum.SortOrder.LayoutOrder

local PlayerTextBox = Instance.new("TextBox", contentFrame)
PlayerTextBox.Size = UDim2.new(1, 0, 0, 30)
PlayerTextBox.Position = UDim2.new(0, 0, 0, 100)
PlayerTextBox.PlaceholderText = "Enter Player Name"
PlayerTextBox.BackgroundColor3 = Color3.fromRGB(34, 139, 34)
PlayerTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerTextBox.Font = Enum.Font.SourceSans
PlayerTextBox.TextSize = 18

local function updatePlayerDropdown()
    -- Clear previous entries in dropdown
    for _, child in ipairs(PlayerDropdownList:GetChildren()) do
        child:Destroy()
    end

    -- Add player names to dropdown
    for _, player in pairs(Players:GetPlayers()) do
        local playerButton = Instance.new("TextButton")
        playerButton.Size = UDim2.new(1, 0, 0, 30)
        playerButton.Text = player.Name
        playerButton.BackgroundColor3 = Color3.fromRGB(24, 109, 24)
        playerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        playerButton.Font = Enum.Font.SourceSans
        playerButton.TextSize = 18
        playerButton.MouseButton1Click:Connect(function()
            PlayerTextBox.Text = player.Name
        end)
        playerButton.Parent = PlayerDropdownList
    end
end

updatePlayerDropdown()  -- Call initially to populate the dropdown

Players.PlayerAdded:Connect(updatePlayerDropdown)  -- Update dropdown when a player joins

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

-- Example Action: Kick Player (using the dropdown or text box)
local function kickSelectedPlayer()
    local targetName = PlayerTextBox.Text
    local target = Players:FindFirstChild(targetName)
    if target then
        local messages = {
            "ZenithHub says bye 👋",
            "nah you idk get troll 💀",
            "you're not that guy pal 😤",
            "game over, clown 🤡",
            "deleted by green justice 💚"
        }
        local randomMessage = messages[math.random(1, #messages)]
        target:Kick(randomMessage)
    else
        warn("Player not found!")
    end
end

-- New Function: Fling All
local function flingAllPlayers()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local humanoidRootPart = player.Character.HumanoidRootPart

            -- Create a BodyVelocity to fling the player
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
            bodyVelocity.Velocity = Vector3.new(math.random(-100, 100), 200, math.random(-100, 100)) -- Apply a random fling direction
            bodyVelocity.Parent = humanoidRootPart

            -- Remove the BodyVelocity after 0.5 seconds to stop the fling
            game:GetService("Debris"):AddItem(bodyVelocity, 0.5)
        end
    end
end

-- New Function: Max Volume and Play "Why So Serious"
local function playWhySoSerious()
    local targetName = PlayerTextBox.Text
    local target = Players:FindFirstChild(targetName)
    
    if target then
        -- Max volume for the target player
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://186775374"  -- Replace with the correct "Why So Serious" asset ID
        sound.Volume = 10  -- Roblox max volume
        sound.Parent = target.Character or target:WaitForChild("HumanoidRootPart")
        sound:Play()

        -- Optional: Display a message
        local messageLabel = Instance.new("TextLabel")
        messageLabel.Text = "Why so serious? 😈"
        messageLabel.Size = UDim2.new(0, 300, 0, 50)
        messageLabel.Position = UDim2.new(0.5, -150, 0.5, -25)
        messageLabel.BackgroundTransparency = 1
        messageLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        messageLabel.TextScaled = true
        messageLabel.Font = Enum.Font.GothamBold
        messageLabel.Parent = gui
        
        -- Wait a few seconds before removing the message
        wait(3)
        messageLabel:Destroy()
    else
        warn("Player not found!")
    end
end

-- Buttons
local buttons = {
    {"Kick Selected Player", kickSelectedPlayer},
    {"Play 'Why So Serious' & Max Volume", playWhySoSerious},
    {"Fling All", flingAllPlayers},  -- Fling all button
    {"Nuke", function()
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character then
                local explosion = Instance.new("Explosion")
                explosion.Position = player.Character:GetPivot().Position
                explosion.BlastRadius = 10
                explosion.BlastPressure = 500000
                explosion.Parent = Workspace
            end
        end
    end},
    {"Kill All", function()
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.Health = 0
            end
        end
    end},
    {"Freeze All", function()
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.Anchored = true
            end
        end
    end},
    {"Unfreeze All", function()
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.Anchored = false
            end
        end
    end}
}

for i, b in ipairs(buttons) do
    makeButton(b[1], (i - 1) * 40 + 130, b[2])  -- Adjusted button positions
end
