-- ================================================
-- 🌟 BatataHub Loader v3.6 | Autor: Lk
-- 🔧 Auto Update + Checagem de WindUI + GitHub
-- ================================================

local loaderVersion = "3.6"
local mainScriptURL = "https://raw.githubusercontent.com/kaique9273/Batatahub/main/BatataHub_v3.2.lua"
local winduiURL = "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"

-- ================================================
-- 🔔 Notificação + Console
-- ================================================
local function notify(title, text, duration)
    print("[🔹 " .. title .. "] " .. text)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 6
        })
    end)
end

local function console(msg)
    print("🔹 [BatataHub Loader] " .. msg)
end

console("Iniciando BatataHub Loader v" .. loaderVersion .. "...")
console("Baixando WindUI...")

-- ================================================
-- 1️⃣ Carrega WindUI com proteção
-- ================================================
local windSuccess, WindUI = pcall(function()
    return loadstring(game:HttpGet(winduiURL, true))()
end)

if not windSuccess or not WindUI then
    warn("❌ Falha ao carregar WindUI!")
    notify("❌ BatataHub", "Erro ao baixar WindUI. Verifique sua internet ou GitHub.", 8)
    return
else
    console("✅ WindUI carregado com sucesso!")
end

-- ================================================
-- 2️⃣ Baixa script principal (BatataHub)
-- ================================================
console("Baixando o script principal...")

local success, response = pcall(function()
    return game:HttpGet(mainScriptURL .. "?t=" .. tick(), true)
end)

if success and response and #response > 50 then
    -- Extrai versão do script remoto
    local remoteVersion = string.match(response, "%-%-#version:%s*([%d%.]+)") or "desconhecida"

    print("======================================")
    print("✅ BatataHub carregado com sucesso!")
    print("📅 Data: " .. os.date("%d/%m/%Y"))
    print("⏰ Hora: " .. os.date("%H:%M:%S"))
    print("📦 Loader: v" .. loaderVersion)
    print("🌐 Script remoto: v" .. remoteVersion)
    print("======================================")

    -- Executa o script remoto com segurança
    local ok, err = pcall(function()
        loadstring(response)()
    end)

    if ok then
        notify("✅ BatataHub", "Script carregado com sucesso!\nVersão: v" .. remoteVersion, 6)
        console("Execução do script concluída com sucesso.")
    else
        warn("❌ Erro ao executar script remoto: " .. tostring(err))
        notify("❌ BatataHub", "Erro ao executar script remoto.", 6)
    end
else
    warn("❌ Falha ao baixar o script remoto!")
    notify("❌ BatataHub", "Erro ao baixar script. Verifique sua conexão ou GitHub.", 6)
end
