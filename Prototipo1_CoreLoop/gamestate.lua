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

-- ESFERA GIRATORIA (MODO ULTRA)
local esfera = {
    x = 0,
    y = 0,
    radio = 20,
    angulo = 0,
    velocidadAngular = 3,
    color = {1, 0, 0},
    activa = false,
    timerColor = 0,
    ultraOn = false,
    timerSpawn = 0,
    duracionVisible = 4,
    duracionOculta = 1,
    visible = false
}

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
    esfera.ultraOn = false
    esfera.visible = false
end

-- ACTUALIZAR ESTADO
function GameState:update(dt)
    mx, my = love.mouse.getPosition()

    -- Actualizar esfera giratoria (spawner)
    if esfera.ultraOn then
        esfera.timerSpawn = esfera.timerSpawn - dt
        if esfera.timerSpawn <= 0 then
            esfera.visible = not esfera.visible
            if esfera.visible then
                esfera.timerSpawn = esfera.duracionVisible
                esfera.color = {math.random(), math.random(), math.random()}
                esfera.angulo = math.random() * 2 * math.pi
                esfera.timerColor = 0
                esfera.x = cx + 150 * math.cos(esfera.angulo)
                esfera.y = cy + 150 * math.sin(esfera.angulo)
            else
                esfera.timerSpawn = esfera.duracionOculta
            end
        end
        if esfera.visible then
            esfera.angulo = esfera.angulo + esfera.velocidadAngular * dt
            esfera.x = cx + 150 * math.cos(esfera.angulo)
            esfera.y = cy + 150 * math.sin(esfera.angulo)
            esfera.timerColor = esfera.timerColor - dt
            if esfera.timerColor <= 0 then
                esfera.color = {math.random(), math.random(), math.random()}
                esfera.timerColor = 0.5
            end
        end
    end

    if estadoJuego == "lanzada" then
        B.mover(dt)
        if B.verificarLimites(cx, cy, H.radio) then
            estadoJuego = "esperando"
        else
            -- Colision con esfera giratoria
            if esfera.visible then
                local dx = B.x - esfera.x
                local dy = B.y - esfera.y
                local d = math.sqrt(dx * dx + dy * dy)
                if d < B.r + esfera.radio then
                    local nx = dx / d
                    local ny = dy / d
                    B.x = esfera.x + nx * (esfera.radio + B.r + 1)
                    B.y = esfera.y + ny * (esfera.radio + B.r + 1)
                    local dot = B.vx * nx + B.vy * ny
                    B.vx = B.vx - 2 * dot * nx
                    B.vy = B.vy - 2 * dot * ny
                    if modo == "melodia" then
                        M.reiniciarSecuencia()
                        mensajeNivel = "Secuencia reiniciada!"
                        timerMensaje = 2
                    end
                    return
                end
            end

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
                    elseif resultado == "fallo" then
                        mensajeNivel = "Secuencia reiniciada!"
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
    esfera.ultraOn = false
    esfera.visible = false
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

-- TOGGLE MODO ULTRA
function GameState:toggleUltra()
    esfera.ultraOn = not esfera.ultraOn
    if esfera.ultraOn then
        esfera.timerSpawn = esfera.duracionVisible
        esfera.visible = true
        esfera.color = {math.random(), math.random(), math.random()}
        esfera.angulo = 0
        esfera.timerColor = 0
        esfera.x = cx + 150 * math.cos(esfera.angulo)
        esfera.y = cy + 150 * math.sin(esfera.angulo)
    else
        esfera.visible = false
    end
end

-- VERIFICAR SI ULTRA ESTA ACTIVO
function GameState:ultraActivo()
    return esfera.ultraOn
end

-- DIBUJAR
function GameState:draw()
    H.dibujar()
    B.dibujar()

    -- Dibujar esfera giratoria
    if esfera.visible then
        love.graphics.setColor(esfera.color)
        love.graphics.circle("fill", esfera.x, esfera.y, esfera.radio)
    end

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