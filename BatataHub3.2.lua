-- Carrega WindUI
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua", true))()

-- Cria janela principal
local Window = WindUI:CreateWindow({
    Title = "Batata Hub v1.0",
    Icon = "door-open",
    Author = "Owner Lk",
    Folder = "EM BREVE",
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
            print("User button clicked")
        end,
    },
})

--==========================================
-- 🌟 ABA DE INFORMAÇÕES - BATATA HUB
--==========================================
local InfoTab = Window:Tab({
    Title = "Informações",
    Icon = "info",
    Locked = false,
})

-- Criador
InfoTab:Paragraph({Title = "👤 Criador 💻 Nome: Lk"})
InfoTab:Paragraph({Title = "Discord 💬 coringakaio"})

-- Script
InfoTab:Paragraph({Title = "📌 Script Batata Hub v1.0"})

-- Funcionalidades
InfoTab:Paragraph({Title = "✨ Funcionalidades"})
InfoTab:Paragraph({Title = "Fly Gui Em Construção..."})
InfoTab:Paragraph({Title = "Speed ajustável"})
InfoTab:Paragraph({Title = "Super Jump"})
InfoTab:Paragraph({Title = "Trolls (EM DESENVOLVIMENTO 💻)"})

-- Compatibilidade
InfoTab:Paragraph({Title = "⚙️ Compatibilidade Delta\n- Fluxus\n- Codex"})

-- Estilo e aviso
InfoTab:Paragraph({Title = "📌 Estilo Moderno (Drip Style)"})
InfoTab:Paragraph({Title = "💡 Aviso Use com cuidado e divirta-se!"})

-- Botões
InfoTab:Button({
    Title = "📋 Copiar Discord",
    Callback = function()
        if setclipboard then
            setclipboard("coringakaio")
            print("Discord copiado!")
        else
            print("Seu executor não suporta copiar texto.")
        end
    end
})

InfoTab:Button({
    Title = "🔗 Ver Atualizações",
    Callback = function()
        local url = "https://discord.gg/seuservidor"
        if setclipboard then setclipboard(url) end
        print("Link de atualizações copiado!")
    end
})

--==========================================
-- 🧍 ABA PLAYER
--==========================================
local PlayerTab = Window:Tab({
    Title = "Player",
    Icon = "user",
    Locked = false,
})

PlayerTab:Paragraph({
    Title = "Controle seu personagem",
    Content = "Use os toggles e sliders para controlar Speed e Jump."
})

--====================
-- PLAYER CONFIG
--====================
local speedValue = 70
local jumpValue = 50
local speedEnabled = false
local jumpEnabled = false
local cfg = {}
cfg.noclip = false

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid")

-- Funções para atualizar
local function updateSpeed()
    if humanoid then
        humanoid.WalkSpeed = speedEnabled and speedValue or 16 -- valor padrão 16
    end
end

local function updateJump()
    if humanoid then
        humanoid.JumpPower = jumpEnabled and jumpValue or 50 -- valor padrão 50
    end
end

--====================
-- SPEED TOGGLE
--====================
PlayerTab:Toggle({
    Title = "Ativar Speed",
    Default = false,
    Callback = function(state)
        speedEnabled = state
        updateSpeed()
    end
})

PlayerTab:Slider({
    Title = "Speed",
    Step = 1,
    Value = {
        Min = 20,
        Max = 120,
        Default = speedValue,
    },
    Callback = function(value)
        speedValue = value
        updateSpeed()
    end
})

--====================
-- JUMP TOGGLE
--====================
PlayerTab:Toggle({
    Title = "Ativar Super Jump",
    Default = false,
    Callback = function(state)
        jumpEnabled = state
        updateJump()
    end
})

PlayerTab:Slider({
    Title = "Super Jump",
    Step = 1,
    Value = {
        Min = 10,
        Max = 200,
        Default = jumpValue,
    },
    Callback = function(value)
        jumpValue = value
        updateJump()
    end
})

local TabTroll = Window:Tab({
	Title = "Noclip",
	icon = "cog",
	locked = false
})

TabTroll:Toggle({
	Title = "🫥Ativa Noclip",
	Default = false,
	Callback = function(value)
	      cfg.noclip = value
	       print("Noclip Agr Esta", value)
	end
})

game:GetService("RunService").Stepped:Connect(function()
    if cfg.noclip and game.Players.LocalPlayer.Character then
        for _, part in ipairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end) 