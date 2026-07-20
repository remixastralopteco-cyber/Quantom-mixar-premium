--[[
    ⚡ SEU SCRIPT PREMIUM - LOADER
    By: SeuNome
    Versão: 1.0
]]

-- Previne carregamento duplicado
if getgenv().MeuScript then
    print("⚠️ Script já está carregado!")
    return
end

-- Verifica se o jogo é o correto
if game.PlaceId ~= 123456789 then -- Coloque o ID do Blox Fruits
    print("❌ Este script só funciona no Blox Fruits!")
    return
end

-- Carrega o script principal
local url = "https://raw.githubusercontent.com/SEU-USUARIO/SEU-REPOSITORIO/main/script.lua"
loadstring(game:HttpGet(url))()

getgenv().MeuScript = true
print("✅ Script Premium Carregado com Sucesso!")