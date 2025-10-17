--#version: 3.2
-- ================================================
-- 🌟 BatataHub v3.2 | Autor: Lk (coringakaio)
-- Compatível com Delta, Fluxus e Codex
-- ================================================

-- 🔹 Carrega WindUI com segurança (link corrigido)
local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)

if not success or not WindUI then
    warn("[BatataHub] ❌ Falha ao carregar WindUI! Verifique o link ou a conexão.")
    return
end

-- ================================================
-- 🪟 Cria janela principal
-- ================================================
local Window = WindUI:CreateWindow({
    Title = "Batata Hub v3.2",
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

-- ================================================
-- 📘 Aba de Informações
-- ================================================
local InfoTab = Window:Tab({Title = "Informações", Icon = "info", Locked = false})
InfoTab:Paragraph({Title = "👤 Criador: Lk"})
InfoTab:Paragraph({Title = "💬 Discord: coringakaio"})
InfoTab:Paragraph({Title = "📦 Versão: 3.2"})
InfoTab:Paragraph({Title = "✨ Funcionalidades:\n- Speed ajustável\n- Super Jump\n- Noclip\n- Estilo Moderno (Drip)"})
InfoTab:Paragraph({Title = "⚙️ Compatível com:\n- Delta\n- Fluxus\n- Codex"})
InfoTab:Paragraph({Title = "💡 Dica: use com cuidado e divirta-se!"})

InfoTab:Button({
    Title = "📋 Copiar Discord",
    Callback = function()
        if setclipboard then
            setclipboard("coringakaio")
            print("[BatataHub] Discord copiado!")
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
            print("[BatataHub] Link copiado!")
        end
    end
})

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
local TrollTab = Window:Tab({Title = "Troll", Icon = "skull", Locked = false})

TrollTab:Paragraph({Title = "Atravessar Paredes",})

TrollTab:Toggle({
    Title = "🫥 Ativar Noclip",
    Default = false,
    Callback = function(value)
        cfg.noclip = value
        print("[BatataHub] Noclip está:", value)

        -- Notify estilo BatataHub
        if value then
            WindUI:Notify({
                Title = "Noclip Ativado",
                Content = "Você agora atravessa paredes!",
                Duration = 3,
                Icon = "ghost" -- ícone do notify
            })
        else
            WindUI:Notify({
                Title = "Noclip Desativado",
                Content = "Você voltou a colidir normalmente.",
                Duration = 3,
                Icon = "ghost"
            })
        end
    end
})

game:GetService("RunService").Stepped:Connect(function()
    if player.Character then
        for _, part in ipairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                if cfg.noclip then
                    part.CanCollide = false
                else
                    part.CanCollide = true
                end
            end
        end
    end
end)

-- ================================================
-- ✅ Log final
-- ================================================
print("[✅ BatataHub] v3.2 carregado com sucesso! Última atualização: " .. os.date("%d/%m/%Y %H:%M:%S"))






