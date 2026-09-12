-- ESTADO: MENU
-- Muestra el menu principal con botones de modo libre y melodia

local State = require("state")
local MenuState = State:new("menu")

local UI = require("pantallas")
local M = require("melodia")

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
        if UI.clickEnBoton(x, y, 100, 350, 250, 60) then
            modo = "libre"
            machine:changeState("game")
        elseif UI.clickEnBoton(x, y, 450, 350, 250, 60) then
            modo = "melodia"
            M.reiniciar()
            machine:changeState("game")
        end
    end
end

-- DIBUJAR
function MenuState:draw()
    UI.dibujarMenu()
end

return MenuState