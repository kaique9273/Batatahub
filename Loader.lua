-- ================================================
-- 🌟 BatataHub Loader v3.7 | Autor: Lk (coringakaio)
-- 🔧 Auto Update + WindUI Check + GitHub Support
-- ================================================

local loaderVersion = "3.7"
local mainScriptURL = "https://raw.githubusercontent.com/kaique9273/Batatahub/main/BatataHub_v3.4.lua"
local winduiURL = "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"

-- ================================================
-- 🧩 Funções utilitárias
-- ================================================
local function notify(title, text, duration)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 6
        })
    end)
    print("🔹 [" .. title .. "] " .. text)
end

local function console(msg, color)
    color = color or "cyan"
    local c = {
        red = "\27[31m", green = "\27[32m", yellow = "\27[33m",
        blue = "\27[34m", magenta = "\27[35m", cyan = "\27[36m", reset = "\27[0m"
    }
    print((c[color] or "") .. "[BatataHub Loader] " .. msg .. c.reset)
end

console("Iniciando BatataHub Loader v" .. loaderVersion .. "...", "cyan")

-- ================================================
-- 1️⃣ Carrega WindUI com segurança
-- ================================================
console("Baixando WindUI...", "yellow")

local windSuccess, WindUI = pcall(function()
    return loadstring(game:HttpGet(winduiURL, true))()
end)

if not windSuccess or not WindUI then
    warn("[❌] Falha ao carregar WindUI!")
    notify("❌ BatataHub", "Erro ao baixar WindUI. Verifique sua internet ou GitHub.", 8)
    return
else
    console("✅ WindUI carregado com sucesso!", "green")
end

-- 🔧 Corrige WindUI invisível (caso precise)
task.wait(0.5)
if WindUI and WindUI.Init then
    pcall(WindUI.Init)
end

-- ================================================
-- 2️⃣ Baixa script principal (BatataHub)
-- ================================================
console("Baixando o script principal...", "yellow")

local success, response = pcall(function()
    return game:HttpGet(mainScriptURL .. "?v=" .. tick(), true)
end)

if not success or not response or #response < 50 then
    warn("[❌] Falha ao baixar o script remoto!")
    notify("❌ BatataHub", "Erro ao baixar script principal. Verifique sua conexão.", 6)
    return
end

-- ================================================
-- 3️⃣ Executa script remoto com proteção
-- ================================================
local remoteVersion = string.match(response, "%-%-#version:%s*([%d%.]+)") or "desconhecida"

print("======================================")
print("✅ BatataHub carregado com sucesso!")
print("📦 Loader: v" .. loaderVersion)
print("🌐 Script remoto: v" .. remoteVersion)
print("📅 Data: " .. os.date("%d/%m/%Y"))
print("⏰ Hora: " .. os.date("%H:%M:%S"))
print("======================================")

local ok, err = pcall(function()
    loadstring(response)()
end)

if ok then
    notify("✅ BatataHub", "Painel carregado com sucesso!\nVersão: v" .. remoteVersion, 6)
    console("Execução concluída com sucesso.", "green")
else
    warn("[❌] Erro ao executar script remoto: " .. tostring(err))
    notify("❌ BatataHub", "Erro ao executar script remoto.", 6)
end

-- ================================================
-- 4️⃣ Mensagem final de sucesso
-- ================================================
console("✅ Loader finalizado. Tudo pronto!", "green")
