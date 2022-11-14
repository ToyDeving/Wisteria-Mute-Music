local mutemusic = Instance.new("ScreenGui")
mutemusic.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
mutemusic.Name = "MuteMusic"
mutemusic.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.BackgroundTransparency = 1
frame.Position = UDim2.new(0.00892219879, 0, 0.804382324, 0)
frame.Size = UDim2.new(0, 35, 0.0329999998, 0)
frame.Parent = mutemusic

local button = Instance.new("ImageButton")
button.Image = "rbxassetid://11559568726"
button.BackgroundColor3 = Color3.new(1, 1, 1)
button.BackgroundTransparency = 0.800000011920929
button.Size = UDim2.new(1, 0, 1, 0)
button.Name = "Button"
button.Parent = frame

local muted_icon = Instance.new("StringValue")
muted_icon.Value = "rbxassetid://11559576076"
muted_icon.Name = "MutedIcon"
muted_icon.Parent = frame

local unmuted_icon = Instance.new("StringValue")
unmuted_icon.Value = "rbxassetid://11559568726"
unmuted_icon.Name = "UnmutedIcon"
unmuted_icon.Parent = frame

local uiaspect_ratio_constraint = Instance.new("UIAspectRatioConstraint")
uiaspect_ratio_constraint.Parent = frame

local Connections = {}
local Disabled = false
local db = false
local DB = false
local Musics = game.ReplicatedStorage:WaitForChild("Music")
button.MouseButton1Click:Connect(function()
	if DB == false then
		DB = true
		task.delay(0.5,function()
			DB = false
		end)
		if Disabled == true then
			Disabled = false
			button.Image = unmuted_icon.Value
			for i, v in pairs(Connections) do
				if i then
					i.Volume = v
				end
			end
		else
			Disabled = true
			button.Image = muted_icon.Value
			for _, v in pairs(Musics:GetChildren()) do
				if v.Playing == true then
					if not table.find(Connections, v) then
						Connections[v] = v.Volume
					end
					v.Volume = 0
				else
					for i, t in pairs(Connections) do
						if i == v then
							Connections[v] = nil
						end
					end
				end
			end
		end
	end
end)
for _, v in pairs(Musics:GetChildren()) do
	v:GetPropertyChangedSignal("Playing"):Connect(function() 
		if not db then
			if v.Playing == true then
				if not table.find(Connections, v) then
					Connections[v] = v.Volume
				end
				if Disabled == true then
					v.Volume = 0
				end			
			else
				if table.find(Connections, v) then
					for i, t in pairs(Connections) do
						if t == v then
							Connections[v] = nil
						end
					end
				end
			end
		end
	end)
end
