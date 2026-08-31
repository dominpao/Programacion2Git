-- PEQUE SYMPHONIE - HEPTAGONO MUSICAL
-- Escape para salir | M para volver al menu

-- Modulos
local H = require("heptagono")
local B = require("pelota")
local M = require("melodia")
local S = require("sonidos")
local UI = require("pantallas")

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

    -- Estados del juego:
    -- menu = pantalla principal
    -- esperando = esperando click del jugador para lanzar
    -- lanzada = pelota en movimiento
    -- volviendo = pelota regresa al centro tras impacto
    -- melodia = esperando siguiente nota (modo melodia)
    -- ganaste = completo los 3 niveles
    estado = "menu"
    modo = ""
    mx = cx
    my = cy
    notaActual = ""
    notaColor = {1, 1, 1}
    mensajeNivel = ""
    timerMensaje = 0
end

-- ACTUALIZACION
function love.update(dt)
    mx, my = love.mouse.getPosition()

    if estado == "lanzada" then
        B.mover(dt)
        if B.verificarLimites(cx, cy, H.radio) then
            estado = "esperando"
        else
            local impacto = B.colisionar(H.verts, H.colores, H.notas, S.sounds)
            if impacto then
                notaActual = H.notas[impacto]
                notaColor = H.colores[impacto]
                estado = "volviendo"
                if modo == "melodia" then
                    local resultado = M.verificar(notaActual)
                    if resultado == "ganaste" then
                        estado = "ganaste"
                    elseif resultado == "avanza" then
                        mensajeNivel = "Nivel " .. M.nivelActual - 1 .. " completado!"
                        timerMensaje = 2
                    end
                end
            end
        end
    end

    if estado == "volviendo" then
        local llego = B.volverCentro(cx, cy, 450, dt)
        if llego then
            notaActual = ""
            if modo == "libre" then
                estado = "esperando"
            else
                estado = "melodia"
            end
        end
    end

    -- Timer del mensaje de nivel completado
    if timerMensaje > 0 then
        timerMensaje = timerMensaje - dt
        if timerMensaje <= 0 then
            timerMensaje = 0
            mensajeNivel = ""
        end
    end
end

-- ENTRADA
function love.mousepressed(x, y, button)
    if button == 1 then
        if estado == "menu" then
            if UI.clickEnBoton(x, y, 100, 350, 250, 60) then
                modo = "libre"
                estado = "esperando"
            elseif UI.clickEnBoton(x, y, 450, 350, 250, 60) then
                modo = "melodia"
                M.reiniciar()
                estado = "melodia"
            end
            return
        end

        if estado == "ganaste" then
            B.resetear(cx, cy)
            notaActual = ""
            estado = "menu"
            return
        end

        if estado == "esperando" or estado == "melodia" then
            B.lanzar(x, y, cx, cy, 1500)
            estado = "lanzada"
        end
    end
end

-- CONTROLES
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
    if key == "m" then
        if estado ~= "menu" and estado ~= "ganaste" then
            B.resetear(cx, cy)
            notaActual = ""
            estado = "menu"
        end
    end
end

-- RENDERIZADO
function love.draw()
    if estado == "menu" then
        UI.dibujarMenu()
        return
    end

    if estado == "ganaste" then
        UI.dibujarGanaste()
        return
    end

    H.dibujar()
    B.dibujar()

    if estado == "esperando" or estado == "melodia" then
        UI.dibujarDireccion(cx, cy, mx, my)
    end

    UI.dibujarTextos()
    UI.dibujarNota(notaActual, notaColor)

    if modo == "melodia" then
        M.dibujar()
    end

    UI.dibujarMensajeNivel(mensajeNivel)
end