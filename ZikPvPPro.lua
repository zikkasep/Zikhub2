-- Zik PvP GUI Pro (Auto Bounty + No CD + Auto Skill)
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local plr = Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "ZikPvPGui"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 60)
frame.Position = UDim2.new(0, 50, 0, 200)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 20)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "Zik Auto Bounty PvP"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 14

local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(1, -20, 0, 30)
toggle.Position = UDim2.new(0, 10, 0, 25)
toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
toggle.Text = "Auto Bounty: OFF"
toggle.Font = Enum.Font.Gotham
toggle.TextSize = 14

-- Status Toggle
local active = false

-- Auto No Cooldown Function
local function NoCooldown()
    for i,v in pairs(getgc(true)) do
        if typeof(v) == "function" and getfenv(v).script == plr.Character:FindFirstChildOfClass("Tool") then
            for _,k in pairs(debug.getupvalues(v)) do
                if typeof(k) == "table" and k["CD"] then
                    k["CD"] = 0
                    k["Cooldown"] = 0
                    k["HitCooldown"] = 0
                    k["LastUse"] = 0
                end
            end
        end
    end
end

-- PvP Logic
local function AutoBounty()
    local hrp = plr.Character:WaitForChild("HumanoidRootPart")
    spawn(function()
        while active do
            pcall(function()
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EnablePvp")
            end)
            wait(10)
        end
    end)

    while active do
        NoCooldown()
        local closest, dist = nil, math.huge
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= plr and v.Team ~= plr.Team and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local d = (v.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                if d < dist and v.Character:FindFirstChild("Humanoid").Health > 0 then
                    dist = d
                    closest = v.Character
                end
            end
        end

        if closest then
            repeat
                wait()
                hrp.CFrame = closest.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
                for _, key in ipairs({"Z","X","C","V","F"}) do
                    keypress(Enum.KeyCode[key])
                    wait(0.05)
                    keyrelease(Enum.KeyCode[key])
                end
                mouse1click()
            until not active or closest:FindFirstChild("Humanoid").Health <= 0
        end
        wait(1)
    end
end

toggle.MouseButton1Click:Connect(function()
    active = not active
    toggle.Text = "Auto Bounty: " .. (active and "ON" or "OFF")
    if active then
        AutoBounty()
    end
end)
