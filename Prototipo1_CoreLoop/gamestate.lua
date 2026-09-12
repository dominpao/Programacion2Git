-- ESTADO: GAME
-- Maneja la jugada principal (modo libre y modo melodia)

local State = require("state")
local GameState = State:new("game")

local H = require("heptagono")
local B = require("pelota")
local M = require("melodia")
local S = require("sonidos")
local UI = require("pantallas")

local machine = nil

function GameState:setMachine(sm)
    machine = sm
end

-- ENTRAR AL ESTADO
function GameState:enter()
    B.resetear(cx, cy)
    estadoJuego = "esperando"
    notaActual = ""
    notaColor = {1, 1, 1}
    mx = cx
    my = cy
end

-- ACTUALIZAR ESTADO
function GameState:update(dt)
    mx, my = love.mouse.getPosition()

    if estadoJuego == "lanzada" then
        B.mover(dt)
        if B.verificarLimites(cx, cy, H.radio) then
            estadoJuego = "esperando"
        else
            local impacto = B.colisionar(H.verts, H.colores, H.notas, S.sounds)
            if impacto then
                notaActual = H.notas[impacto]
                notaColor = H.colores[impacto]
                estadoJuego = "volviendo"
                if modo == "melodia" then
                    local resultado = M.verificar(notaActual)
                    if resultado == "ganaste" then
                        machine:changeState("win")
                    elseif resultado == "avanza" then
                        mensajeNivel = "Nivel " .. M.nivelActual - 1 .. " completado!"
                        timerMensaje = 2
                    end
                end
            end
        end
    end

    if estadoJuego == "volviendo" then
        local llego = B.volverCentro(cx, cy, 450, dt)
        if llego then
            notaActual = ""
            if modo == "libre" then
                estadoJuego = "esperando"
            else
                estadoJuego = "melodia"
            end
        end
    end

    if timerMensaje > 0 then
        timerMensaje = timerMensaje - dt
        if timerMensaje <= 0 then
            timerMensaje = 0
            mensajeNivel = ""
        end
    end
end

-- SALIR DEL ESTADO
function GameState:exit()
end

-- CLICK DEL MOUSE
function GameState:mousepressed(x, y, button)
    if button == 1 then
        if estadoJuego == "esperando" or estadoJuego == "melodia" then
            B.lanzar(x, y, cx, cy, 1500)
            estadoJuego = "lanzada"
        end
    end
end

-- DIBUJAR
function GameState:draw()
    H.dibujar()
    B.dibujar()

    if estadoJuego == "esperando" or estadoJuego == "melodia" then
        UI.dibujarDireccion(cx, cy, mx, my)
    end

    UI.dibujarTextos()
    UI.dibujarNota(notaActual, notaColor)

    if modo == "melodia" then
        M.dibujar()
    end

    UI.dibujarMensajeNivel(mensajeNivel)
end

return GameState