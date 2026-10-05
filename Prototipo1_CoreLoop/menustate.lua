-- ESTADO: MENU
-- Muestra el menu principal con botones de modo libre y melodia

local State = require("state")
local MenuState = State:new("menu")

local UI = require("pantallas")
local M = require("melodia")
local Eventos = require("eventos")

-- REFERENCIA A LA MAQUINA DE ESTADOS
local machine = nil

function MenuState:setMachine(sm)
    machine = sm
end

-- ENTRAR AL ESTADO
function MenuState:enter()
end

-- ACTUALIZAR ESTADO
function MenuState:update(dt)
end

-- SALIR DEL ESTADO
function MenuState:exit()
end

-- CLICK DEL MOUSE
function MenuState:mousepressed(x, y, button)
    if button == 1 then
        local w = love.graphics.getWidth()
        if UI.clickEnBoton(x, y, w/2 - 280, 350, 250, 60) then
            modo = "libre"
            machine:changeState("game")
        elseif UI.clickEnBoton(x, y, w/2 + 30, 350, 250, 60) then
            modo = "melodia"
            M.reiniciar()
            machine:changeState("game")
        else
            -- Click en selector de idioma (area del texto en controles)
            local font = love.graphics.getFont()
            local t2 = (idioma == "es") and "ESC: Salir | M: Menu | U: Ultra" or "ESC: Exit | M: Menu | U: Ultra"
            local langText = (idioma == "es") and "[ES] English" or "Español [EN]"
            local fullControls = t2 .. "  |  " .. langText
            local controlsWidth = font:getWidth(fullControls) * 1.2
            local langTextWidth = font:getWidth(langText) * 1.2
            local langX = (w - controlsWidth) / 2 + controlsWidth - langTextWidth
            local langY = 250
            if x >= langX and x <= langX + langTextWidth and y >= langY and y <= langY + font:getHeight() * 1.2 then
                idioma = (idioma == "es") and "en" or "es"
                Eventos:emit("idioma_cambiado")
            end
        end
    end
end

-- DIBUJAR
function MenuState:draw()
    UI.dibujarMenu()
end

return MenuState