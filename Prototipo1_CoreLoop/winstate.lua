-- ESTADO: WIN
-- Muestra la pantalla de ganaste

local State = require("state")
local WinState = State:new("win")

local UI = require("pantallas")
local B = require("pelota")

local machine = nil

function WinState:setMachine(sm)
    machine = sm
end

-- ENTRAR AL ESTADO
function WinState:enter()
end

-- ACTUALIZAR ESTADO
function WinState:update(dt)
end

-- SALIR DEL ESTADO
function WinState:exit()
end

-- CLICK DEL MOUSE
function WinState:mousepressed(x, y, button)
    if button == 1 then
        B.resetear(cx, cy)
        notaActual = ""
        machine:changeState("menu")
    end
end

-- DIBUJAR
function WinState:draw()
    UI.dibujarGanaste()
end

return WinState