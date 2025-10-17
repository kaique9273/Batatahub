-- ================================================
-- 🌟 BatataHub Loader v3.2 | Autor: Lk
-- 🔧 Auto Update + Checagem de WindUI + GitHub
-- ================================================

local mainScriptURL = "https://raw.githubusercontent.com/kaique9273/BatataHub/main/BatataHub.lua"
local loaderVersion = "3.2"

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

console("Iniciando BatataHub Loader v"..loaderVersion.."...")
console("Baixando script mais recente...")

-- 1️⃣ Tenta carregar WindUI antes de executar o script
local windSuccess, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua", true))()
end)

if not windSuccess or not WindUI then
    warn("❌ Falha ao carregar WindUI!")
    notify("❌ BatataHub","Erro ao baixar WindUI. Verifique sua internet ou o GitHub da WindUI.",7)
    return
end

-- 2️⃣ Baixa script principal do GitHub
local success,response = pcall(function()
    return game:HttpGet(mainScriptURL.." ?t="..tick(),true)
end)

if success and response then
    -- Procura a versão no script remoto
    local remoteVersion = string.match(response,"%-%-#version:%s*([%d%.]+)") or "desconhecida"

    print("======================================")
    print("✅ BatataHub carregado com sucesso!")
    print("📦 Loader: v"..loaderVersion)
    print("🌐 Script remoto: v"..remoteVersion)
    print("======================================")

    -- Verifica se há nova versão
    if remoteVersion ~= "desconhecida" and remoteVersion ~= loaderVersion then
        warn("⚠️ Nova versão disponível: v"..remoteVersion)
        notify("⚠️ Atualização disponível!","Nova versão do BatataHub detectada: v"..remoteVersion,7)
    else
        console("Você está na versão mais recente.")
    end

    -- 3️⃣ Executa o script principal com segurança
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
    warn("❌ Falha ao baixar script remoto!")
    notify("❌ BatataHub","Erro ao baixar script. Verifique sua conexão ou GitHub.",6)
end