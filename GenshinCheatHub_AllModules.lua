
-- MainUI.lua（原神风 UI 框架）

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "GenshinCheatHub"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 520, 0, 340)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -170)
MainFrame.BackgroundColor3 = Color3.fromRGB(240, 230, 210)
MainFrame.BorderSizePixel = 0
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 16)

local TopBar = Instance.new("TextLabel", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 36)
TopBar.BackgroundColor3 = Color3.fromRGB(200, 180, 160)
TopBar.Text = "原神风秒赢外挂 Hub"
TopBar.TextColor3 = Color3.fromRGB(50, 30, 10)
TopBar.Font = Enum.Font.SourceSansBold
TopBar.TextSize = 20
TopBar.BorderSizePixel = 0

local HideButton = Instance.new("TextButton", TopBar)
HideButton.Size = UDim2.new(0, 36, 0, 36)
HideButton.Position = UDim2.new(1, -36, 0, 0)
HideButton.Text = "-"
HideButton.Font = Enum.Font.SourceSansBold
HideButton.TextSize = 24
HideButton.TextColor3 = Color3.fromRGB(80, 60, 40)
HideButton.BackgroundTransparency = 1

HideButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = false
end)

local ShowButton = Instance.new("TextButton", ScreenGui)
ShowButton.Size = UDim2.new(0, 80, 0, 30)
ShowButton.Position = UDim2.new(0, 20, 0.5, -15)
ShowButton.Text = "外挂"
ShowButton.Font = Enum.Font.SourceSansBold
ShowButton.TextSize = 20
ShowButton.BackgroundColor3 = Color3.fromRGB(200, 180, 160)
ShowButton.TextColor3 = Color3.fromRGB(50, 30, 10)
local ShowUICorner = Instance.new("UICorner", ShowButton)
ShowUICorner.CornerRadius = UDim.new(0, 12)

ShowButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = true
end)

_G.MainUI = MainFrame
-- Obby.lua（秒赢功能模块 - 跑酷）

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function teleportToWin()
    local winPart = Workspace:FindFirstChild("Win")
    if winPart and winPart:IsA("BasePart") then
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = winPart.CFrame + Vector3.new(0, 5, 0)
        end
    else
        warn("未找到 Win 部件")
    end
end

local function createButton()
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 140, 0, 36)
    btn.Text = "秒赢跑酷"
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 20
    btn.BackgroundColor3 = Color3.fromRGB(220, 180, 120)
    btn.TextColor3 = Color3.fromRGB(40, 20, 0)
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 10)

    btn.MouseButton1Click:Connect(function()
        teleportToWin()
    end)

    return btn
end

-- 挂载到主 UI 中
local MainUI = _G.MainUI
if MainUI then
    local scroll = MainUI:FindFirstChild("Scroll") or Instance.new("Frame", MainUI)
    scroll.Name = "Scroll"
    scroll.Position = UDim2.new(0, 20, 0, 60)
    scroll.Size = UDim2.new(0, 480, 0, 260)
    scroll.BackgroundTransparency = 1

    local btn = createButton()
    btn.Position = UDim2.new(0, 0, 0, 0)
    btn.Parent = scroll
end
-- JumpRope.lua（秒赢功能模块 - 跳绳）
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local flying = false
local bodyVelocity

local function startFlying()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart

    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bodyVelocity.Parent = hrp

    flying = true
end

local function stopFlying()
    if bodyVelocity then bodyVelocity:Destroy() end
    bodyVelocity = nil
    flying = false
end

-- 简单方向控制（适用于手机）
local moveDir = Vector3.zero
RunService.RenderStepped:Connect(function()
    if flying and bodyVelocity then
        bodyVelocity.Velocity = moveDir * 60
    end
end)

local function createControlButtons(parent)
    local dirs = {
        {name = "左", vec = Vector3.new(-1, 0, 0), pos = UDim2.new(0, 10, 0, 40)},
        {name = "右", vec = Vector3.new(1, 0, 0), pos = UDim2.new(0, 120, 0, 40)},
        {name = "前", vec = Vector3.new(0, 0, -1), pos = UDim2.new(0, 65, 0, 0)},
        {name = "后", vec = Vector3.new(0, 0, 1), pos = UDim2.new(0, 65, 0, 80)},
    }

    for _, d in ipairs(dirs) do
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(0, 50, 0, 36)
        btn.Position = d.pos
        btn.Text = d.name
        btn.BackgroundColor3 = Color3.fromRGB(240, 220, 180)
        btn.TextColor3 = Color3.fromRGB(50, 30, 10)
        btn.Font = Enum.Font.SourceSansBold
        btn.TextSize = 18
        local corner = Instance.new("UICorner", btn)
        corner.CornerRadius = UDim.new(0, 8)

        btn.MouseButton1Down:Connect(function() moveDir += d.vec end)
        btn.MouseButton1Up:Connect(function() moveDir -= d.vec end)
    end
end

local function createMainButton()
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 140, 0, 36)
    btn.Text = "跳绳飞行模式"
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    btn.BackgroundColor3 = Color3.fromRGB(220, 190, 150)
    btn.TextColor3 = Color3.fromRGB(40, 20, 0)
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 10)

    btn.MouseButton1Click:Connect(function()
        if flying then
            stopFlying()
            btn.Text = "跳绳飞行模式"
        else
            startFlying()
            btn.Text = "关闭飞行"
        end
    end)

    return btn
end

-- 挂载到 UI
local MainUI = _G.MainUI
if MainUI then
    local scroll = MainUI:FindFirstChild("Scroll")
    if scroll then
        local btn = createMainButton()
        btn.Position = UDim2.new(0, 0, 0, 50)
        btn.Parent = scroll

        local controlFrame = Instance.new("Frame", scroll)
        controlFrame.Size = UDim2.new(0, 180, 0, 120)
        controlFrame.Position = UDim2.new(0, 160, 0, 50)
        controlFrame.BackgroundColor3 = Color3.fromRGB(240, 230, 200)
        local corner = Instance.new("UICorner", controlFrame)
        corner.CornerRadius = UDim.new(0, 12)

        createControlButtons(controlFrame)
    end
end
-- RockPaperScissors.lua（石头剪刀布自动胜利）
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- 自动发送胜利选择：Rock（石头）
local function autoWinRPS()
    local success = false
    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") and v.Name:lower():find("rps") then
            -- 猜测是 RockPaperScissors 相关的远程事件
            pcall(function()
                v:FireServer("Rock")
                success = true
            end)
        end
    end
    return success
end

-- 创建 UI 按钮
local function createRPSButton()
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 140, 0, 36)
    btn.Text = "RPS 自动胜利"
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    btn.BackgroundColor3 = Color3.fromRGB(200, 230, 170)
    btn.TextColor3 = Color3.fromRGB(30, 50, 10)
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 10)

    btn.MouseButton1Click:Connect(function()
        local ok = autoWinRPS()
        if ok then
            btn.Text = "已发送：石头"
        else
            btn.Text = "失败，未找到事件"
        end
        wait(1.5)
        btn.Text = "RPS 自动胜利"
    end)

    return btn
end

-- 挂载到主 UI
local MainUI = _G.MainUI
if MainUI then
    local scroll = MainUI:FindFirstChild("Scroll")
    if scroll then
        local btn = createRPSButton()
        btn.Position = UDim2.new(0, 0, 0, 100)
        btn.Parent = scroll
    end
end
-- TicTacToe.lua（井字棋自动胜利）
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- 自动落子逻辑：循环尝试所有格子
local function autoWinTTT()
    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") and v.Name:lower():find("tictactoe") then
            -- 假设参数为格子编号 1~9
            for i = 1, 9 do
                pcall(function()
                    v:FireServer(i)
                end)
                wait(0.1)
            end
        end
    end
end

-- 创建 UI 按钮
local function createTTTButton()
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 140, 0, 36)
    btn.Text = "井字棋自动落子"
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    btn.BackgroundColor3 = Color3.fromRGB(170, 220, 240)
    btn.TextColor3 = Color3.fromRGB(10, 30, 50)
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 10)

    btn.MouseButton1Click:Connect(function()
        autoWinTTT()
        btn.Text = "已尝试所有格子"
        wait(1.5)
        btn.Text = "井字棋自动落子"
    end)

    return btn
end

-- 挂载到主 UI
local MainUI = _G.MainUI
if MainUI then
    local scroll = MainUI:FindFirstChild("Scroll")
    if scroll then
        local btn = createTTTButton()
        btn.Position = UDim2.new(0, 0, 0, 140)
        btn.Parent = scroll
    end
end
