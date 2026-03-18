-- HASE MODS LITE - Versión Final Corregida
local NOMBRE_MENU = "H  A  S  E    M  O  D  S"
local lp = game.Players.LocalPlayer
local Noclip, InfJump, HologramaEnemigos, Aimbot, FOVVisible = false, false, false, false, false
local PosicionGuardada = nil
local VisualMarcador = nil
local FOVRadius = 50

-- 1. MENSAJE DE BIENVENIDA
local msgGui = Instance.new("ScreenGui", game.CoreGui)
local msgFrame = Instance.new("Frame", msgGui)
msgFrame.Size = UDim2.new(0, 250, 0, 45)
msgFrame.Position = UDim2.new(0.5, -125, 0, 60)
msgFrame.BackgroundColor3 = Color3.new(0,0,0)
msgFrame.BackgroundTransparency = 0.4
Instance.new("UICorner", msgFrame)
local msgLabel = Instance.new("TextLabel", msgFrame)
msgLabel.Size = UDim2.new(1, 0, 1, 0)
msgLabel.BackgroundTransparency = 1
msgLabel.TextColor3 = Color3.new(1,1,1)
msgLabel.TextSize = 16
msgLabel.Text = "BIENVENIDO AL PANEL V1 HASE_444"

-- 2. INTERFAZ
local MainGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", MainGui)
Frame.Size = UDim2.new(0, 260, 0, 350)
Frame.Position = UDim2.new(0.5, -130, 0.5, -175)
Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Frame.Visible = false
Instance.new("UICorner", Frame)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = NOMBRE_MENU
Title.TextColor3 = Color3.new(1,1,1)
Title.TextSize = 18
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UICorner", Title)

local Scroll = Instance.new("ScrollingFrame", Frame)
Scroll.Size = UDim2.new(1, 0, 1, -50)
Scroll.Position = UDim2.new(0, 0, 0, 50)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 4
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y -- FIX: Se detiene donde terminan las funciones
local UIList = Instance.new("UIListLayout", Scroll)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.Padding = UDim.new(0, 8)

-- BOTONES FLOTANTES
local MenuBtn = Instance.new("TextButton", MainGui)
MenuBtn.Size = UDim2.new(0, 70, 0, 70)
MenuBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
MenuBtn.Text = "🌟\nMENÚ AQUÍ"
MenuBtn.TextSize = 10
MenuBtn.Visible = false
MenuBtn.Draggable, MenuBtn.Active = true, true
Instance.new("UICorner", MenuBtn).CornerRadius = UDim.new(1, 0)

local FastTP = Instance.new("TextButton", MainGui)
FastTP.Size = UDim2.new(0, 70, 0, 70)
FastTP.Position = UDim2.new(0.05, 0, 0.53, 0)
FastTP.Text = "⚡\nTP AQUÍ"
FastTP.TextSize = 10
FastTP.BackgroundColor3 = Color3.new(1,0,0)
FastTP.TextColor3 = Color3.new(1,1,1)
FastTP.Visible = false 
FastTP.Draggable, FastTP.Active = true, true
Instance.new("UICorner", FastTP).CornerRadius = UDim.new(1, 0)

task.delay(8, function() msgGui:Destroy(); MenuBtn.Visible = true end)

MenuBtn.MouseButton1Click:Connect(function() Frame.Visible = not Frame.Visible end)
FastTP.MouseButton1Click:Connect(function()
    if PosicionGuardada and lp.Character then lp.Character.HumanoidRootPart.CFrame = PosicionGuardada end
end)

-- 3. CREADORES
local function AddMod(txt, callback, isToggle)
    local btn = Instance.new("TextButton", Scroll)
    btn.Size = UDim2.new(0, 220, 0, 35)
    btn.Text = txt .. (isToggle and " [OFF]" or "")
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", btn)
    local state = false
    btn.MouseButton1Click:Connect(function()
        if isToggle then
            state = not state
            btn.Text = txt .. (state and " [ON]" or " [OFF]")
            btn.BackgroundColor3 = state and Color3.new(0.8,0,0) or Color3.fromRGB(45, 45, 45)
            callback(state)
        else callback() end
    end)
end

local function AddSlider(txt, min, max, callback)
    local sFrame = Instance.new("Frame", Scroll)
    sFrame.Size = UDim2.new(0, 220, 0, 50); sFrame.BackgroundTransparency = 1
    local label = Instance.new("TextLabel", sFrame)
    label.Size = UDim2.new(1, 0, 0, 20); label.Text = txt .. ": " .. min; label.TextColor3 = Color3.new(1,1,1); label.BackgroundTransparency = 1
    local bar = Instance.new("TextButton", sFrame)
    bar.Size = UDim2.new(1, 0, 0, 10); bar.Position = UDim2.new(0,0,0,25); bar.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2); bar.Text = ""
    local slider = Instance.new("Frame", bar)
    slider.Size = UDim2.new(0, 10, 1, 0); slider.BackgroundColor3 = Color3.new(1,0,0)
    bar.MouseButton1Down:Connect(function()
        local move; move = game:GetService("UserInputService").InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                local percent = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                slider.Position = UDim2.new(percent, -5, 0, 0)
                local val = math.floor(min + (max - min) * percent)
                label.Text = txt .. ": " .. val; callback(val)
            end
        end)
        game:GetService("UserInputService").InputEnded:Connect(function(i) if i.UserInputType == Enum.MouseButton1 then move:Disconnect() end end)
    end)
end

-- 4. FUNCIONES
AddMod("MARCAR UBICACIÓN", function(v) 
    FastTP.Visible = v
    if v and lp.Character then
        PosicionGuardada = lp.Character.HumanoidRootPart.CFrame
        if VisualMarcador then VisualMarcador:Destroy() end
        VisualMarcador = Instance.new("Part", workspace)
        VisualMarcador.Anchored, VisualMarcador.CanCollide = true, false
        VisualMarcador.Size = Vector3.new(2, 0.1, 2); VisualMarcador.Color = Color3.new(1,0,0)
        VisualMarcador.CFrame = PosicionGuardada * CFrame.new(0, -3.2, 0)
        local bg = Instance.new("BillboardGui", VisualMarcador)
        bg.Size = UDim2.new(0, 100, 0, 40); bg.AlwaysOnTop = true
        local tl = Instance.new("TextLabel", bg)
        tl.Size = UDim2.new(1,0,1,0); tl.BackgroundTransparency = 1; tl.TextColor3 = Color3.new(1,0,0); tl.TextSize = 14; tl.Name = "Dist"
    else if VisualMarcador then VisualMarcador:Destroy() end end
end, true)

AddMod("SPEED X10", function(v) lp.Character.Humanoid.WalkSpeed = v and 160 or 16 end, true)
AddMod("SPEED X15", function(v) lp.Character.Humanoid.WalkSpeed = v and 240 or 16 end, true)
AddMod("SPEED X20", function(v) lp.Character.Humanoid.WalkSpeed = v and 320 or 16 end, true)
AddMod("SPEED X25", function(v) lp.Character.Humanoid.WalkSpeed = v and 400 or 16 end, true)
AddMod("SALTOS INFINITOS", function(v) InfJump = v end, true)
AddMod("NOCLIP", function(v) Noclip = v end, true)
AddMod("HOLOGRAMA ENEMIGOS", function(v) HologramaEnemigos = v end, true)
AddMod("AIBOM", function(v) Aimbot = v end, true)
AddMod("CIRCULO FOV", function(v) FOVVisible = v end, true)
AddSlider("RADIO FOV", 10, 300, function(v) FOVRadius = v end)

-- 5. LÓGICA
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness, FOVCircle.Color, FOVCircle.Filled = 1, Color3.new(1,0,0), false

game:GetService("RunService").RenderStepped:Connect(function()
    FOVCircle.Visible = FOVVisible
    FOVCircle.Radius = FOVRadius
    FOVCircle.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X/2, workspace.CurrentCamera.ViewportSize.Y/2)
    
    if VisualMarcador and lp.Character then
        local d = math.floor((lp.Character.HumanoidRootPart.Position - VisualMarcador.Position).Magnitude)
        VisualMarcador.BillboardGui.Dist.Text = "📍 ESTÁS AQUÍ\n[" .. d .. "m]"
    end

    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= lp and p.Character then
            local h = p.Character:FindFirstChild("HaseHighlight")
            if HologramaEnemigos then
                if not h then
                    h = Instance.new("Highlight", p.Character)
                    h.Name = "HaseHighlight"; h.FillColor = Color3.new(1,0,0)
                end
                h.Enabled = true
            elseif h then h.Enabled = false end
        end
    end
end)

game:GetService("RunService").Stepped:Connect(function()
    if Noclip and lp.Character then
        for _, v in pairs(lp.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
end)

game:GetService("UserInputService").JumpRequest:Connect(function() if InfJump then lp.Character.Humanoid:ChangeState("Jumping") end end)

spawn(function() while true do MenuBtn.BackgroundColor3 = Color3.fromHSV(tick()%5/5, 1, 1); task.wait(0.1) end end)
