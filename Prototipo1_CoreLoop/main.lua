-- Mínimo Love2D ejecutable
-- Sirve como base para el Prototipo 1: Core Loop
-- Presiona Escape para salir

function love.load()
    -- Configuración inicial 
    ventana_ancho = 800
    ventana_alto = 600
    titulo = "Prototipo 1 - Core Loop - Peque Symphonie"
end

function love.update(dt)
    -- Lógica de actualización cada frame
    -- Aquí iría la física, movimiento, colisiones, etc.
end

function love.draw()
    local font = love.graphics.getFont()
    local w = love.graphics.getWidth()

    local t1 = "Peque Symphonie"
    local t2 = "Selva Paola Dominguez"
    local t3 = "Objetivo: Hectágono musical"

    love.graphics.print(t1, (w - font:getWidth(t1) * 2) / 2, 300, 0, 2, 2)
    love.graphics.print(t2, (w - font:getWidth(t2) * 1.5) / 2, 350, 0, 1.5, 1.5)
    love.graphics.print(t3, (w - font:getWidth(t3) * 1.5) / 2, 400, 0, 1.5, 1.5)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end