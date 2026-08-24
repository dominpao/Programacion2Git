-- ========================================
-- PEQUE SYMPHONIE - HEPTAGONO MUSICAL
-- Escape para salir
-- ========================================

-- ========================================
-- UTILIDADES
-- ========================================
function dist(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return math.sqrt(dx * dx + dy * dy)
end

-- ========================================
-- CARGA
-- ========================================
function love.load()
    love.window.setTitle("Peque Symphonie")
    love.window.setMode(800, 600)

    -- Centro y radio del heptagono
    cx = 400
    cy = 340
    radio = 200

    -- Notas musicales y colores de cada lado
    notas = {"Do", "Re", "Mi", "Fa", "Sol", "La", "Si"}
    colores = {
        {1,0,0}, {1,0.5,0}, {1,1,0}, {0,1,0},
        {0,0,1}, {0,1,1}, {0.5,0,1}
    }

    -- Vertices del heptagono
    verts = {}
    for i = 1, 7 do
        local a = (i - 1) * (2 * math.pi / 7) - math.pi / 2
        verts[i] = {x = cx + radio * math.cos(a), y = cy + radio * math.sin(a)}
    end

    -- Carga de sonidos
    sonidos = {}
    for i = 1, 7 do
        sonidos[i] = love.audio.newSource("Resources/" .. notas[i] .. ".wav", "static")
    end

    -- Estado de la pelota
    ball = {x=cx, y=cy, r=15, color={1,1,1}, vx=0, vy=0}
    notaActual = ""
    notaColor = {1, 1, 1}
    estado = "esperando"
    mx = cx
    my = cy
end

-- ========================================
-- ACTUALIZACION
-- ========================================
function love.update(dt)
    mx, my = love.mouse.getPosition()

    -- Movimiento de la pelota hacia el borde
    if estado == "lanzada" then
        ball.x = ball.x + ball.vx * dt
        ball.y = ball.y + ball.vy * dt

        -- Deteccion de colision contra cada lado del heptagono
        for i = 1, 7 do
            local v1 = verts[i]
            local v2 = verts[i % 7 + 1]
            local edx = v2.x - v1.x
            local edy = v2.y - v1.y
            local len = math.sqrt(edx * edx + edy * edy)
            local t = math.max(0, math.min(1, ((ball.x - v1.x) * edx + (ball.y - v1.y) * edy) / (len * len)))
            local cx2 = v1.x + t * edx
            local cy2 = v1.y + t * edy
            local dx2 = ball.x - cx2
            local dy2 = ball.y - cy2
            local d = math.sqrt(dx2 * dx2 + dy2 * dy2)

            -- Si colisiona: cambiar color, reproducir sonido, rebotar
            if d < ball.r then
                ball.color = colores[i]
                notaActual = notas[i]
                notaColor = colores[i]
                sonidos[i]:stop()
                sonidos[i]:play()
                local nx = dx2 / d
                local ny = dy2 / d
                ball.x = cx2 + nx * (ball.r + 1)
                ball.y = cy2 + ny * (ball.r + 1)
                local dot = ball.vx * nx + ball.vy * ny
                ball.vx = ball.vx - 2 * dot * nx
                ball.vy = ball.vy - 2 * dot * ny
                estado = "volviendo"
                break
            end
        end
    end

    -- Retorno de la pelota hacia el centro
    if estado == "volviendo" then
        local dx = cx - ball.x
        local dy = cy - ball.y
        local d = dist(ball.x, ball.y, cx, cy)
        if d < 10 then
            ball.x = cx
            ball.y = cy
            ball.color = {1, 1, 1}
            notaActual = ""
            estado = "esperando"
        else
            ball.x = ball.x + (dx / d) * 450 * dt
            ball.y = ball.y + (dy / d) * 450 * dt
        end
    end
end

-- ========================================
-- ENTRADA
-- ========================================
function love.mousepressed(x, y, button)
    -- Click izquierdo: lanzar pelota desde el centro
    if button == 1 and estado == "esperando" then
        local d = dist(x, y, cx, cy)
        if d > 0 then
            ball.vx = ((x - cx) / d) * 1500
            ball.vy = ((y - cy) / d) * 1500
            estado = "lanzada"
        end
    end
end

-- ========================================
-- RENDERIZADO
-- ========================================
function love.draw()
    -- Dibujar heptagono (7 lados con colores)
    for i = 1, 7 do
        local v1 = verts[i]
        local v2 = verts[i % 7 + 1]
        love.graphics.setColor(colores[i])
        love.graphics.setLineWidth(4)
        love.graphics.line(v1.x, v1.y, v2.x, v2.y)
    end

    -- Dibujar pelota
    love.graphics.setColor(ball.color)
    love.graphics.circle("fill", ball.x, ball.y, ball.r)

    -- Linea de direccion (solo cuando espera click)
    if estado == "esperando" then
        love.graphics.setColor(1, 1, 1, 0.4)
        love.graphics.setLineWidth(1)
        love.graphics.line(cx, cy, mx, my)
    end

    -- Textos superiores
    love.graphics.setColor(1, 1, 1)
    local w = love.graphics.getWidth()
    local font = love.graphics.getFont()
    local t1 = "Peque Symphonie"
    local t2 = "ESC para salir | Mouse para jugar"
    local t3 = "Objetivo: Heptagono musical"
    love.graphics.print(t1, (w - font:getWidth(t1) * 2) / 2, 30, 0, 2, 2)
    love.graphics.print(t2, (w - font:getWidth(t2) * 1.2) / 2, 70, 0, 1.2, 1.2)
    love.graphics.print(t3, (w - font:getWidth(t3) * 1.2) / 2, 100, 0, 1.2, 1.2)

    -- Nota actual con color
    if notaActual ~= "" then
        love.graphics.setColor(notaColor)
        love.graphics.print("Nota: " .. notaActual, 20, 560)
    end
end

-- ========================================
-- CONTROLES
-- ========================================
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end