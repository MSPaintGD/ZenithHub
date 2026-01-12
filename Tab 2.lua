local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- GUI Setup
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "ZenithHub_Doors"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 480)
frame.Position = UDim2.new(0.5, -150, 0.5, -240)
frame.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
frame.Active = true
frame.Draggable = true

-- Title Bar
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
title.Text = "ZenithHub Doors"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.new(1, 1, 1)
title.TextScaled = true

-- Content Frame
local contentFrame = Instance.new("Frame", frame)
contentFrame.Size = UDim2.new(1, -20, 1, -40)
contentFrame.Position = UDim2.new(0, 10, 0, 40)
contentFrame.BackgroundTransparency = 1

-- Button Maker
local function makeButton(text, posY, callback)
	local btn = Instance.new("TextButton", contentFrame)
	btn.Size = UDim2.new(1, 0, 0, 35)
	btn.Position = UDim2.new(0, 0, 0, posY)
	btn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.Gotham
	btn.TextScaled = true
	btn.Text = text

	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 200, 0)}):Play()
	end)

	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 255, 0)}):Play()
	end)

	btn.MouseButton1Click:Connect(callback)
end

-- Features
local espEnabled = false
local function toggleESP()
	espEnabled = not espEnabled
	while espEnabled do
		for _, v in pairs(Workspace:GetDescendants()) do
			if v:IsA("Model") and v:FindFirstChild("Main") and not v:FindFirstChild("ZenithESP") then
				local highlight = Instance.new("Highlight", v)
				highlight.Name = "ZenithESP"
				highlight.FillColor = Color3.fromRGB(0, 255, 0)
				highlight.OutlineColor = Color3.new(1, 1, 1)
			end
		end
		task.wait(1)
	end
	for _, v in pairs(Workspace:GetDescendants()) do
		if v:FindFirstChild("ZenithESP") then
			v.ZenithESP:Destroy()
		end
	end
end

local function autoHide()
	local char = LocalPlayer.Character
	if char then
		local closet = Workspace:FindFirstChild("Closets")
		if closet then
			for _, obj in pairs(closet:GetDescendants()) do
				if obj.Name == "Prompt" and obj:IsA("ProximityPrompt") then
					fireproximityprompt(obj)
					break
				end
			end
		end
	end
end

local function noScreech()
	local screech = Workspace:FindFirstChild("Screech")
	if screech then screech:Destroy() end
end

local function instantInteract()
	for _, prompt in ipairs(Workspace:GetDescendants()) do
		if prompt:IsA("ProximityPrompt") then
			pcall(function() fireproximityprompt(prompt) end)
		end
	end
end

local function boostSpeed()
	local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if humanoid then humanoid.WalkSpeed = 60 end
end

local function seekESP()
	for _, part in pairs(Workspace:GetDescendants()) do
		if part:IsA("BasePart") and string.find(part.Name, "Path") then
			local highlight = Instance.new("Highlight", part)
			highlight.FillColor = Color3.fromRGB(255, 255, 0)
			highlight.OutlineColor = Color3.new(0, 0, 0)
			highlight.Name = "SeekESP"
		end
	end
end

local function disableJumpscares()
	for _, sound in ipairs(Workspace:GetDescendants()) do
		if sound:IsA("Sound") and string.find(sound.Name:lower(), "jumpscare") then
			sound:Destroy()
		end
	end
end

local noclip = false
RunService.Stepped:Connect(function()
	if noclip and LocalPlayer.Character then
		for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
			if part:IsA("BasePart") then part.CanCollide = false end
		end
	end
end)

local infiniteJump = false
UserInputService.JumpRequest:Connect(function()
	if infiniteJump and LocalPlayer.Character then
		LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

-- Add Buttons
local features = {
	{"ESP Entities/Items", toggleESP},
	{"Auto Hide", autoHide},
	{"No Screech", noScreech},
	{"Instant Interact", instantInteract},
	{"Speed Boost", boostSpeed},
	{"Seek Path ESP", seekESP},
	{"Disable Jumpscares", disableJumpscares},
	{"Toggle Noclip", function() noclip = not noclip end},
	{"Toggle Infinite Jump", function() infiniteJump = not infiniteJump end}
}

for i, feat in ipairs(features) do
	makeButton(feat[1], (i - 1) * 40, feat[2])
end