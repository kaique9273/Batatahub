--#version: 3.4
-- ================================================
-- 🌟 BatataHub v3.4 | Autor: Lk (coringakaio)
-- Compatível com Delta, Fluxus e Codex
-- ================================================

-- 🧩 Carrega WindUI com segurança e inicializa
local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/source.lua"))()
end)

if not success or not WindUI then
    warn("[BatataHub] ❌ Falha ao carregar WindUI!")
    return
end

-- Alguns forks precisam de inicialização explícita
if WindUI.Init then
    pcall(WindUI.Init)
end

-- Pequeno delay para garantir que a GUI esteja pronta
task.wait(0.5)

-- ✅ Cria janela principal
local Window = WindUI:CreateWindow({
    Title = "Batata Hub v3.4",
    Icon = "door-open",
    Author = "Owner Lk",
    Folder = "BatataHub",
    Size = UDim2.fromOffset(580, 520),
    MinSize = Vector2.new(560, 400),
    MaxSize = Vector2.new(850, 600),
    Transparent = false, -- ⚠️ Deixamos visível
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 200,
    BackgroundImageTransparency = 0.15, -- leve transparência
    HideSearchBar = true,
    ScrollBarEnabled = false,
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            print("[BatataHub] Botão do usuário clicado!")
        end,
    },
})

if not Window then
    warn("[BatataHub] ⚠️ Falha ao criar janela WindUI!")
    return
end

-- 🎉 Notify de inicialização
WindUI:Notify({
    Title = "✅ BatataHub Iniciado!",
    Content = "Versão 3.4 carregada com sucesso.",
    Duration = 4,
    Icon = "check-circle"
})

-- ================================================
-- 📘 Aba de Informações
-- ================================================
local InfoTab = Window:Tab({Title = "Informações", Icon = "info", Locked = false})
InfoTab:Paragraph({Title = "👤 Criador: Lk"})
InfoTab:Paragraph({Title = "💬 Discord: coringakaio"})
InfoTab:Paragraph({Title = "📦 Versão: 3.4"})
InfoTab:Paragraph({Title = "✨ Funcionalidades:\n- Speed ajustável\n- Super Jump\n- Noclip\n- Notify Global do Owner"})
InfoTab:Paragraph({Title = "💡 Dica: use com cuidado e divirta-se!"})

InfoTab:Button({
    Title = "📋 Copiar Discord",
    Callback = function()
        if setclipboard then
            setclipboard("coringakaio")
            WindUI:Notify({
                Title = "📎 Discord Copiado",
                Content = "Usuário: coringakaio",
                Duration = 3,
                Icon = "clipboard"
            })
        end
    end
})

-- ================================================
-- 👑 Notify Global do Owner
-- ================================================
local ownerUserId = 7607971236
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ownerOnline = false

local function broadcast(msg, icon)
    WindUI:Notify({
        Title = "👑 BatataHub Global",
        Content = msg,
        Duration = 5,
        Icon = icon or "megaphone"
    })
end

local function ownerJoined(pl)
    ownerOnline = true
    broadcast("🔥 " .. pl.Name .. " (Owner) entrou no servidor!", "user-check")
end

local function ownerLeft()
    ownerOnline = false
    broadcast("🚪 O Owner saiu do servidor.", "user-x")
end

Players.PlayerAdded:Connect(function(pl)
    if pl.UserId == ownerUserId then ownerJoined(pl) end
end)

Players.PlayerRemoving:Connect(function(pl)
    if pl.UserId == ownerUserId then ownerLeft() end
end)

-- ================================================
-- 🧍 Aba Player
-- ================================================
local PlayerTab = Window:Tab({Title = "Player", Icon = "user"})
local cfg = {speedValue=70, jumpValue=50, speedEnabled=false, jumpEnabled=false, noclip=false}
local player = game.Players.LocalPlayer

local function updateChar()
    local char = player.Character or player.CharacterAdded:Wait()
    local humanoid = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid")
    return humanoid
end

local function updateSpeed()
    local h = updateChar()
    h.WalkSpeed = cfg.speedEnabled and cfg.speedValue or 16
end

local function updateJump()
    local h = updateChar()
    h.JumpPower = cfg.jumpEnabled and cfg.jumpValue or 50
end

PlayerTab:Toggle({
    Title = "⚡ Ativar Speed",
    Default = false,
    Callback = function(state)
        cfg.speedEnabled = state
        updateSpeed()
        WindUI:Notify({
            Title = state and "🚀 Speed Ativado" or "🐢 Speed Desativado",
            Content = "Velocidade: " .. cfg.speedValue,
            Duration = 3,
            Icon = "zap"
        })
    end
})

PlayerTab:Slider({
    Title = "Velocidade",
    Step = 1,
    Value = {Min=20, Max=120, Default=cfg.speedValue},
    Callback = function(v)
        cfg.speedValue = v
        updateSpeed()
    end
})

PlayerTab:Toggle({
    Title = "🦘 Super Jump",
    Default = false,
    Callback = function(s)
        cfg.jumpEnabled = s
        updateJump()
        WindUI:Notify({
            Title = s and "🦘 Super Jump Ativado" or "🪶 Super Jump Desativado",
            Content = "Força: " .. cfg.jumpValue,
            Duration = 3,
            Icon = "chevrons-up"
        })
    end
})

PlayerTab:Slider({
    Title = "Força do Pulo",
    Step = 1,
    Value = {Min=10, Max=200, Default=cfg.jumpValue},
    Callback = function(v)
        cfg.jumpValue = v
        updateJump()
    end
})

-- ================================================
-- 🫥 Aba Noclip
-- ================================================
local TrollTab = Window:Tab({Title = "Noclip", Icon = "ghost"})
TrollTab:Toggle({
    Title = "🫥 Ativar Noclip",
    Default = false,
    Callback = function(v)
        cfg.noclip = v
        WindUI:Notify({
            Title = v and "🫥 Noclip Ativado" or "🚫 Noclip Desativado",
            Content = v and "Você pode atravessar paredes." or "As colisões foram restauradas.",
            Duration = 3,
            Icon = "ghost"
        })
    end
})

game:GetService("RunService").Stepped:Connect(function()
    if cfg.noclip and player.Character then
        for _, part in ipairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- ================================================
print("[✅ BatataHub] v3.4 carregado com sucesso! " .. os.date("%d/%m/%Y %H:%M:%S"))
