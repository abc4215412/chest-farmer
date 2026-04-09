-- Chạy từ executor

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- ===================== CHỐNG CHẠY 2 LẦN =====================
if _G.TeleportLoaded then return end
_G.TeleportLoaded = true

-- ===================== KEEP ALIVE =====================
local queueteleport = queue_on_teleport
    or (syn and syn.queue_on_teleport)
    or (fluxus and fluxus.queue_on_teleport)

local TeleportCheck = false
Players.LocalPlayer.OnTeleport:Connect(function(State)
    if not TeleportCheck and queueteleport then
        TeleportCheck = true
        _G.TeleportLoaded = nil
        queueteleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/abc4215412/chest-farmer/refs/heads/main/chestfarm.lua'))()")
    end
end)

-- ===================== GUI PARENT =====================
local COREGUI = game:GetService("CoreGui")
local MAX_DISPLAY_ORDER = 2147483647
local PARENT = nil

local function randomString()
    local length = math.random(10, 20)
    local array = {}
    for i = 1, length do
        array[i] = string.char(math.random(32, 126))
    end
    return table.concat(array)
end

if get_hidden_gui or gethui then
    local Main = Instance.new("ScreenGui")
    Main.Name = randomString()
    Main.ResetOnSpawn = false
    Main.DisplayOrder = MAX_DISPLAY_ORDER
    Main.Parent = (get_hidden_gui or gethui)()
    PARENT = Main
elseif syn and syn.protect_gui then
    local Main = Instance.new("ScreenGui")
    Main.Name = randomString()
    Main.ResetOnSpawn = false
    Main.DisplayOrder = MAX_DISPLAY_ORDER
    syn.protect_gui(Main)
    Main.Parent = COREGUI
    PARENT = Main
elseif COREGUI:FindFirstChild("RobloxGui") then
    PARENT = COREGUI.RobloxGui
else
    local Main = Instance.new("ScreenGui")
    Main.Name = randomString()
    Main.ResetOnSpawn = false
    Main.DisplayOrder = MAX_DISPLAY_ORDER
    Main.Parent = COREGUI
    PARENT = Main
end

-- ===================== GUI =====================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportGui"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = MAX_DISPLAY_ORDER
screenGui.Parent = PARENT

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 270, 0, 160)
mainFrame.Position = UDim2.new(0, 16, 0.5, -80)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 38)
titleBar.BackgroundColor3 = Color3.fromRGB(72, 44, 160)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12)

local patch = Instance.new("Frame")
patch.Size = UDim2.new(1, 0, 0, 10)
patch.Position = UDim2.new(0, 0, 1, -10)
patch.BackgroundColor3 = Color3.fromRGB(72, 44, 160)
patch.BorderSizePixel = 0
patch.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, 0, 1, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "Auto Teleport"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextSize = 15
titleText.Font = Enum.Font.GothamBold
titleText.Parent = titleBar

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -16, 0, 30)
statusLabel.Position = UDim2.new(0, 8, 0, 44)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Đang chờ..."
statusLabel.TextColor3 = Color3.fromRGB(150, 255, 180)
statusLabel.TextSize = 13
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = mainFrame

local logLabel = Instance.new("TextLabel")
logLabel.Size = UDim2.new(1, -16, 0, 60)
logLabel.Position = UDim2.new(0, 8, 0, 88)
logLabel.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
logLabel.BorderSizePixel = 0
logLabel.Text = ""
logLabel.TextColor3 = Color3.fromRGB(140, 200, 140)
logLabel.TextSize = 11
logLabel.Font = Enum.Font.Code
logLabel.TextXAlignment = Enum.TextXAlignment.Left
logLabel.TextYAlignment = Enum.TextYAlignment.Top
logLabel.TextWrapped = true
logLabel.Parent = mainFrame
Instance.new("UICorner", logLabel).CornerRadius = UDim.new(0, 6)

-- ===================== HELPERS =====================
local logLines = {}

local function addLog(msg)
    table.insert(logLines, msg)
    if #logLines > 4 then table.remove(logLines, 1) end
    logLabel.Text = table.concat(logLines, "\n")
end

local function setStatus(text, color)
    statusLabel.Text = "Status: " .. text
    statusLabel.TextColor3 = color or Color3.fromRGB(150, 255, 180)
end

-- ===================== MAIN =====================
task.spawn(function()
    -- Đếm ngược 5 giây
    for i = 5, 1, -1 do
        setStatus("Teleport sau " .. i .. "s...", Color3.fromRGB(180, 180, 255))
        task.wait(1)
    end

    -- Chờ character sẵn sàng
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart", 10)

    if not root then
        setStatus("✗ Không tìm thấy character!", Color3.fromRGB(255, 80, 80))
        addLog("✗ HumanoidRootPart không tồn tại")
        return
    end

    -- Teleport
    root.CFrame = CFrame.new(
        -8.29012299, 20.4728603, -19.6051674,
        1, 0, 0,
        0, 1, 0,
        0, 0, 1
    )

    setStatus("✅ Đã teleport!", Color3.fromRGB(80, 255, 120))
    addLog("✅ Teleport thành công")
    addLog("📍 " .. math.floor(-8.29) .. ", " .. math.floor(20.47) .. ", " .. math.floor(-19.60))
end)
