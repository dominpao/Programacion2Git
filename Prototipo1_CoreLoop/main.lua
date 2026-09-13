-- PEQUE SYMPHONIE - HEPTAGONO MUSICAL
-- Escape para salir | M para volver al menu

-- Modulos
local H = require("heptagono")
local B = require("pelota")
local M = require("melodia")
local S = require("sonidos")
local StateMachine = require("statemachine")
local MenuState = require("menustate")
local GameState = require("gamestate")
local WinState = require("winstate")

-- CARGA
function love.load()
    love.window.setTitle("Peque Symphonie")
    love.window.setMode(800, 600)

    cx = 400
    cy = 340

    H.crear(cx, cy, 200)
    B.crear(cx, cy)
    M.crear()
    S.crear(H.notas)

    -- Variables globales del juego
    modo = ""
    mx = cx
    my = cy
    notaActual = ""
    notaColor = {1, 1, 1}
    mensajeNivel = ""
    timerMensaje = 0
    estadoJuego = "esperando"

    -- Maquina de estados
    sm = StateMachine:new()
    MenuState:setMachine(sm)
    GameState:setMachine(sm)
    WinState:setMachine(sm)
    sm:addState(MenuState)
    sm:addState(GameState)
    sm:addState(WinState)
    sm:changeState("menu")
end

-- ACTUALIZACION
function love.update(dt)
    sm:update(dt)
end

-- ENTRADA
function love.mousepressed(x, y, button)
    if sm.currentState then
        sm.currentState:mousepressed(x, y, button)
    end
end

-- CONTROLES
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
    if key == "m" then
        if sm:getState() ~= "menu" and sm:getState() ~= "win" then
            B.resetear(cx, cy)
            notaActual = ""
            sm:changeState("menu")
        end
    end
end

-- RENDERIZADO
function love.draw()
    if sm.currentState then
        sm.currentState:draw()
    end
end