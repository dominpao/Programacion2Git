-- MODULO: PANTALLAS
local P = {}

-- MENU
function P.dibujarMenu()
    love.graphics.setColor(1, 1, 1)
    local w = love.graphics.getWidth()
    local font = love.graphics.getFont()
    local t1 = "Peque Symphonie"
    local t2 = "ESC: Salir | M: Menu | U: Ultra"
    love.graphics.print(t1, (w - font:getWidth(t1) * 2) / 2, 200, 0, 2, 2)
    love.graphics.print(t2, (w - font:getWidth(t2) * 1.2) / 2, 250, 0, 1.2, 1.2)

    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle("fill", 100, 350, 250, 60, 10, 10)
    love.graphics.setColor(0, 0, 0)
    local tLibre = "JUGA LIBRE"
    love.graphics.print(tLibre, 100 + (250 - font:getWidth(tLibre) * 1.5) / 2, 368, 0, 1.5, 1.5)

    love.graphics.setColor(0, 0, 1)
    love.graphics.rectangle("fill", 450, 350, 250, 60, 10, 10)
    love.graphics.setColor(1, 1, 1)
    local tMelodia = "TOCA LA MELODIA"
    love.graphics.print(tMelodia, 450 + (250 - font:getWidth(tMelodia) * 1.5) / 2, 368, 0, 1.5, 1.5)
end

-- GANASTE
function P.dibujarGanaste()
    love.graphics.setColor(1, 1, 0)
    local w = love.graphics.getWidth()
    local font = love.graphics.getFont()
    love.graphics.print("GANASTE!", (w - font:getWidth("GANASTE!") * 3) / 2, 250, 0, 3, 3)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Hacé click para volver al menú", (w - font:getWidth("Hacé click para volver al menú")) / 2, 350)
end

-- TEXTOS EN JUEGO
function P.dibujarTextos()
    love.graphics.setColor(1, 1, 1)
    local w = love.graphics.getWidth()
    local font = love.graphics.getFont()
    local t1 = "Peque Symphonie"
    local t2 = "ESC: Salir | M: Menu | U: Ultra"
    love.graphics.print(t1, (w - font:getWidth(t1) * 2) / 2, 30, 0, 2, 2)
    love.graphics.print(t2, (w - font:getWidth(t2) * 1.2) / 2, 70, 0, 1.2, 1.2)
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
        love.graphics.print("Nota: " .. notaActual, 20, 500)
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