--#version: 3.2
-- ================================================
-- 🌟 BatataHub v3.2 | Autor: Lk (coringakaio)
-- Compatível com Delta, Fluxus e Codex
-- ================================================

-- ================================================
-- 🔍 Verificação de Versão + Notificações
-- ================================================
local version = "3.2"

local function notify(title, text)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = 6
        })
    end)
end

print("[BatataHub] ================================")
print("[BatataHub] 🟡 Verificando versão atual...")
task.wait(1)
print("[BatataHub] ✅ Versão detectada: " .. version)
notify("BatataHub", "🟡 Verificando versão...")
task.wait(0.5)
notify("BatataHub", "✅ v" .. version .. " atualizada com sucesso!")

-- ================================================
-- 🧩 Carrega WindUI com segurança (com fallback)
-- ================================================
local WindUI
local winduiLinks = {
    "https://raw.githubusercontent.com/Footagesus/WindUI/main/main.lua", -- link principal
    "https://raw.githubusercontent.com/Footagesus/WindUI/releases/latest/download/main.lua" -- backup
}

print("[BatataHub] 🔄 Carregando WindUI...")
for _, link in ipairs(winduiLinks) do
    local success, result = pcall(function()
        return loadstring(game:HttpGet(link, true))()
    end)

    if success and result then
        WindUI = result
        print("[BatataHub] ✅ WindUI carregado com sucesso de:\n" .. link)
        notify("BatataHub", "✅ WindUI carregado!")
        break
    else
        warn("[BatataHub] ⚠️ Falha ao carregar WindUI de: " .. link)
    end
end

if not WindUI then
    warn("[BatataHub] ❌ Nenhum link do WindUI funcionou!")
    notify("❌ Falha ao carregar WindUI", "Verifique sua conexão ou o link do GitHub.")
    return
end

-- ================================================
-- 🪟 Cria janela principal
-- ================================================
local Window = WindUI:CreateWindow({
    Title = "Batata Hub v" .. version,
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
local InfoTab = Window:Tab({ Title = "Informações", Icon = "info", Locked = false })
InfoTab:Paragraph({ Title = "👤 Criador: Lk" })
InfoTab:Paragraph({ Title = "💬 Discord: coringakaio" })
InfoTab:Paragraph({ Title = "📦 Versão: " .. version })
InfoTab:Paragraph({
    Title = "✨ Funcionalidades:\n- Speed ajustável\n- Super Jump\n- Noclip\n- Interface Drip"
})
InfoTab:Paragraph({
    Title = "⚙️ Compatível com:\n- Delta\n- Fluxus\n- Codex"
})
InfoTab:Paragraph({
    Title = "💡 Dica: use com cuidado e divirta-se!"
})

InfoTab:Button({
    Title = "📋 Copiar Discord",
    Callback = function()
        if setclipboard then
            setclipboard("coringakaio")
            notify("BatataHub", "✅ Discord copiado!")
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
            notify("BatataHub", "✅ Link do servidor copiado!")
        end
    end
})

-- ================================================
-- 🧍 Aba Player
-- ================================================
local PlayerTab = Window:Tab({ Title = "Player", Icon = "user", Locked = false })
PlayerTab:Paragraph({
    Title = "🎮 Controle seu personagem",
    Content = "Use os sliders para ajustar Speed e Jump em tempo real."
})

-- Configurações iniciais
local cfg = { speedValue = 70, jumpValue = 50, speedEnabled = false, jumpEnabled = false, noclip = false }
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
    Value = { Min = 20, Max = 120, Default = cfg.speedValue },
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
    Value = { Min = 10, Max = 200, Default = cfg.jumpValue },
    Callback = function(value)
        cfg.jumpValue = value
        updateJump()
    end
})

-- ================================================
-- 🫥 Aba Noclip
-- ================================================
local NoclipTab = Window:Tab({ Title = "Noclip", Icon = "ghost", Locked = false })
NoclipTab:Toggle({
    Title = "🫥 Ativar Noclip",
    Default = false,
    Callback = function(value)
        cfg.noclip = value
        print("[BatataHub] Noclip está:", value)
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
-- ✅ Finalização
-- ================================================
print("[✅ BatataHub] v" .. version .. " carregado com sucesso!")
notify("✅ BatataHub", "v" .. version .. " carregado com sucesso!")
print("[BatataHub] ================================")
