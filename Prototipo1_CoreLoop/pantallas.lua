-- MODULO: PANTALLAS
local P = {}
local I = require("idioma")

-- MENU
function P.dibujarMenu()
    love.graphics.setColor(1, 1, 1)
    local w = love.graphics.getWidth()
    local font = love.graphics.getFont()

    local t1 = I.getTexto("titulo", idioma)
    local t2 = I.getTexto("controles", idioma)
    love.graphics.print(t1, (w - font:getWidth(t1) * 2) / 2, 200, 0, 2, 2)

    -- Controles + selector idioma
    local langText = (idioma == "es") and "[ES] English" or "Español [EN]"
    local fullControls = t2 .. "  |  " .. langText
    local controlsX = (w - font:getWidth(fullControls) * 1.2) / 2
    local controlsY = 250
    love.graphics.print(fullControls, controlsX, controlsY, 0, 1.2, 1.2)

    -- Subrayado en parte clickeable
    local clickableX = controlsX + font:getWidth(t2 .. "  |  ") * 1.2
    local clickableW = font:getWidth(langText) * 1.2
    love.graphics.setLineWidth(1)
    love.graphics.line(clickableX, controlsY + font:getHeight() * 1.2 + 2, clickableX + clickableW, controlsY + font:getHeight() * 1.2 + 2)

    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle("fill", w/2 - 280, 350, 250, 60, 10, 10)
    love.graphics.setColor(0, 0, 0)
    local tLibre = I.getTexto("botonLibre", idioma)
    love.graphics.print(tLibre, w/2 - 280 + (250 - font:getWidth(tLibre) * 1.5) / 2, 368, 0, 1.5, 1.5)

    love.graphics.setColor(0, 0, 1)
    love.graphics.rectangle("fill", w/2 + 30, 350, 250, 60, 10, 10)
    love.graphics.setColor(1, 1, 1)
    local tMelodia = I.getTexto("botonMelodia", idioma)
    love.graphics.print(tMelodia, w/2 + 30 + (250 - font:getWidth(tMelodia) * 1.5) / 2, 368, 0, 1.5, 1.5)
end

-- GANASTE
function P.dibujarGanaste()
    love.graphics.setColor(1, 1, 0)
    local w = love.graphics.getWidth()
    local font = love.graphics.getFont()
    local msg = I.getTexto("mensajeGanaste", idioma)
    love.graphics.print(msg, (w - font:getWidth(msg) * 3) / 2, 250, 0, 3, 3)
    love.graphics.setColor(1, 1, 1)
    local clickMsg = I.getTexto("clickVolver", idioma)
    love.graphics.print(clickMsg, (w - font:getWidth(clickMsg)) / 2, 350)
end

-- TEXTOS EN JUEGO
function P.dibujarTextos()
    love.graphics.setColor(1, 1, 1)
    local w = love.graphics.getWidth()
    local font = love.graphics.getFont()
    local t1 = I.getTexto("titulo", idioma)
    local t2 = I.getTexto("controles", idioma)

    -- Controles + selector idioma
    local langText = (idioma == "es") and "[ES] English" or "Español [EN]"
    local fullControls = t2 .. "  |  " .. langText
    local controlsX = (w - font:getWidth(fullControls) * 1.2) / 2
    local controlsY = 70
    love.graphics.print(t1, (w - font:getWidth(t1) * 2) / 2, 30, 0, 2, 2)
    love.graphics.print(fullControls, controlsX, controlsY, 0, 1.2, 1.2)

    -- Subrayado en parte clickeable
    local clickableX = controlsX + font:getWidth(t2 .. "  |  ") * 1.2
    local clickableW = font:getWidth(langText) * 1.2
    love.graphics.setLineWidth(1)
    love.graphics.line(clickableX, controlsY + font:getHeight() * 1.2 + 2, clickableX + clickableW, controlsY + font:getHeight() * 1.2 + 2)
end

-- LINEA DE DIRECCION
function P.dibujarDireccion(cx, cy, mx, my)
    love.graphics.setColor(1, 1, 1, 0.4)
    love.graphics.setLineWidth(1)
    love.graphics.line(cx, cy, mx, my)
end

-- NOTA ACTUAL
function P.dibujarNota(notaActual, notaColor)
    if notaActual ~= "" then
        love.graphics.setColor(notaColor)
        local prefijo = I.getTexto("nota", idioma)
        love.graphics.print(prefijo .. notaActual, 20, 500)
    end
end

-- CLICK EN BOTON
function P.clickEnBoton(x, y, bx, by, bw, bh)
    return x >= bx and x <= bx + bw and y >= by and y <= by + bh
end

-- MENSAJE DE NIVEL
function P.dibujarMensajeNivel(texto)
    if texto ~= "" then
        love.graphics.setColor(1, 1, 0)
        local w = love.graphics.getWidth()
        love.graphics.print(texto, (w - love.graphics.getFont():getWidth(texto) * 1.5) / 2, 300, 0, 1.5, 1.5)
    end
end

return P