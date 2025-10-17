-- ================================================
-- 🌟 BatataHub Loader v3.3 | Autor: Lk
-- 🔧 Auto Update + Checagem de WindUI + Versão automática
-- ================================================

local mainScriptURL = "https://raw.githubusercontent.com/kaique9273/Batatahub/main/BatataHubv3.2"

-- Função de notificação
local function notify(title,text,duration)
    print("[🔹 "..title.."] "..text)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification",{Title=title,Text=text,Duration=duration or 6})
    end)
end

-- Função auxiliar de console
local function console(msg)
    print("🔹 [BatataHub Loader] "..msg)
end

console("Iniciando BatataHub Loader v3.3...")
console("Baixando script mais recente...")

-- 1️⃣ Carrega WindUI
local windSuccess, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/kaique9273/Batatahub/refs/heads/main/BatataHubv3.2", true))()
end)

if not windSuccess or not WindUI then
    warn("❌ Falha ao carregar WindUI!")
    notify("❌ BatataHub","Erro ao baixar WindUI. Verifique sua internet ou GitHub.",7)
    return
end

-- 2️⃣ Baixa script principal do GitHub
local success,response = pcall(function()
    return game:HttpGet(mainScriptURL .. "?t=" .. tick(), true)
end)

if success and response then
    -- Procura a versão no script remoto
    local remoteVersion = string.match(response,"%-%-#version:%s*([%d%.]+)") or "desconhecida"

    print("======================================")
    print("✅ BatataHub carregado com sucesso!")
    print("📅 Data: "..os.date("%d/%m/%Y"))
    print("⏰ Hora: "..os.date("%H:%M:%S"))
    print("🌐 Script remoto: v"..remoteVersion)
    print("======================================")

    -- 3️⃣ Executa o script remoto com proteção
    local ok,err = pcall(function()
        loadstring(response)()
    end)

    if ok then
        notify("✅ BatataHub","Script carregado com sucesso!\nVersão: v"..remoteVersion,6)
    else
        warn("❌ Erro ao executar script remoto: "..err)
        notify("❌ BatataHub","Erro ao executar script remoto.",6)
    end
else
    warn("❌ Falha ao baixar o script remoto!")
    notify("❌ BatataHub","Erro ao baixar script. Verifique sua conexão ou GitHub.",6)
end

