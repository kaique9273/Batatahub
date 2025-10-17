--#version: 3.3
-- ================================================
-- 🌟 BatataHub v3.3 | Autor: Lk (coringakaio)
-- Compatível com Delta, Fluxus e Codex
-- ================================================

-- 🔹 Carrega WindUI com segurança
local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/source.lua"))()
end)

if not success or not WindUI then
    warn("[BatataHub] Falha ao carregar WindUI!")
    return
end

-- Cria janela principal
local Window = WindUI:CreateWindow({
    Title = "Batata Hub v3.3",
    Icon = "door-open",
    Author = "Owner Lk",
    Folder = "BatataHub",
    Size = UDim2.fromOffset(580, 520),
    MinSize = Vector2.new(560, 400),
    MaxSize = Vector2.new(850, 600),
    Transparent = true,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 200,
    BackgroundImageTransparency = 0.42,
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

-- ✅ Notify ao iniciar
WindUI:Notify({
    Title = "✅ BatataHub Iniciado!",
    Content = "Versão 3.3 carregada com sucesso.",
    Duration = 4,
    Icon = "check-circle"
})

-- ================================================
-- 📘 Aba de Informações
-- ================================================
local InfoTab = Window:Tab({Title = "Informações", Icon = "info", Locked = false})
InfoTab:Paragraph({Title = "👤 Criador: Lk"})
InfoTab:Paragraph({Title = "💬 Discord: coringakaio"})
InfoTab:Paragraph({Title = "📦 Versão: 3.3"})
InfoTab:Paragraph({Title = "✨ Funcionalidades:\n- Speed ajustável\n- Super Jump\n- Noclip\n- Notificação Global do Owner"})
InfoTab:Paragraph({Title = "⚙️ Compatível com:\n- Delta\n- Fluxus\n- Codex"})
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
        else
            print("[BatataHub] Seu executor não suporta copiar texto.")
        end
    end
})

InfoTab:Button({
    Title = "🔗 Copiar Link do Servidor",
    Callback = function()
        local link = "https://discord.gg/seuservidor"
        if setclipboard then
            setclipboard(link)
            WindUI:Notify({
                Title = "🔗 Link Copiado",
                Content = "Convite copiado para a área de transferência.",
                Duration = 3,
                Icon = "link"
            })
        end
    end
})

-- ================================================
-- 👑 Notify Global do Owner
-- ================================================
local ownerUserId = 7607971236 -- coloque o UserId real do dono
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local ownerPlayer = nil
local ownerOnline = false

local function broadcast(message, icon)
    WindUI:Notify({
        Title = "👑 BatataHub Global",
        Content = message,
        Duration = 5,
        Icon = icon or "megaphone"
    })
end

local function ownerJoined(pl)
    ownerPlayer = pl
    ownerOnline = true
    broadcast(pl.Name .. " (Owner) entrou no servidor! 👑", "user-check")
end

local function ownerLeft()
    local prevName = ownerPlayer and ownerPlayer.Name or "Owner"
    ownerPlayer = nil
    ownerOnline = false
    broadcast(prevName .. " (Owner) saiu do servidor. 🚪", "user-x")
end

local function findOwnerPlayer()
    for _, pl in pairs(Players:GetPlayers()) do
        if pl.UserId == ownerUserId then
            return pl
        end
    end
    return nil
end

local function initOwnerPresence()
    local found = findOwnerPlayer()
    if found then
        ownerJoined(found)
    else
        ownerOnline = false
    end
end

Players.PlayerAdded:Connect(function(pl)
    if pl.UserId == ownerUserId then
        ownerJoined(pl)
    end
end)

Players.PlayerRemoving:Connect(function(pl)
    if pl.UserId == ownerUserId then
        ownerLeft()
    end
end)

-- Loop de verificação a cada 2 segundos
local securityCheckInterval = 2
local accumulatedTime = 0

RunService.Heartbeat:Connect(function(dt)
    accumulatedTime = accumulatedTime + dt
    if accumulatedTime >= securityCheckInterval then
        accumulatedTime = 0
        local found = findOwnerPlayer()
        if found and not ownerOnline then
            ownerJoined(found)
        elseif not found and ownerOnline then
            ownerLeft()
        end
    end
end)

initOwnerPresence()

-- ================================================
-- 🧍 Aba Player
-- ================================================
local PlayerTab = Window:Tab({Title = "Player", Icon = "user", Locked = false})
PlayerTab:Paragraph({Title = "🎮 Controle seu personagem", Content = "Use os sliders para ajustar Speed e Jump em tempo real."})

-- Configurações iniciais
local cfg = {speedValue=70, jumpValue=50, speedEnabled=false, jumpEnabled=false, noclip=false}
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid")

local function updateSpeed()
    if humanoid then
        humanoid.WalkSpeed = cfg.speedEnabled and cfg.speedValue or 16
    end
end

local function updateJump()
    if humanoid then
        humanoid.JumpPower = cfg.jumpEnabled and cfg.jumpValue or 50
    end
end

PlayerTab:Toggle({
    Title = "⚡ Ativar Speed",
    Default = false,
    Callback = function(state)
        cfg.speedEnabled = state
        updateSpeed()
        WindUI:Notify({
            Title = state and "🚀 Speed Ativado" or "🐢 Speed Desativado",
            Content = "Velocidade ajustada para " .. cfg.speedValue,
            Duration = 3,
            Icon = "zap"
        })
    end
})

PlayerTab:Slider({
    Title = "Velocidade",
    Step = 1,
    Value = {Min=20, Max=120, Default=cfg.speedValue},
    Callback = function(value)
        cfg.speedValue = value
        updateSpeed()
    end
})

PlayerTab:Toggle({
    Title = "🦘 Ativar Super Jump",
    Default = false,
    Callback = function(state)
        cfg.jumpEnabled = state
        updateJump()
        WindUI:Notify({
            Title = state and "🦘 Super Jump Ativado" or "🪶 Super Jump Desativado",
            Content = "Força do pulo: " .. cfg.jumpValue,
            Duration = 3,
            Icon = "chevrons-up"
        })
    end
})

PlayerTab:Slider({
    Title = "Força do Pulo",
    Step = 1,
    Value = {Min=10, Max=200, Default=cfg.jumpValue},
    Callback = function(value)
        cfg.jumpValue = value
        updateJump()
    end
})

-- ================================================
-- 🫥 Aba Noclip
-- ================================================
local TrollTab = Window:Tab({Title = "Noclip", Icon = "ghost", Locked = false})
TrollTab:Toggle({
    Title = "🫥 Ativar Noclip",
    Default = false,
    Callback = function(value)
        cfg.noclip = value
        WindUI:Notify({
            Title = value and "🫥 Noclip Ativado" or "🚫 Noclip Desativado",
            Content = value and "Você pode atravessar paredes." or "As colisões foram restauradas.",
            Duration = 3,
            Icon = "ghost"
        })
    end
})

game:GetService("RunService").Stepped:Connect(function()
    if cfg.noclip and player.Character then
        for _, part in ipairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- ================================================
-- Exibe versão carregada no console
print("[✅ BatataHub] v3.3 carregado com sucesso! Última atualização: " .. os.date("%d/%m/%Y %H:%M:%S"))
