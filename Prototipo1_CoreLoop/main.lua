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

    -- Secuencias de melodias por nivel
    secuencias = {
        {"Do","Re","Mi","Fa","Sol","La","Si","Si","La","Sol","Fa","Mi","Re","Do"},
        {"Do","Do","Do","Re","Mi","Do","Sol","Sol","Sol","La","Sol","Sol","La","Sol","Fa","Mi","Do","Re","Fa","Mi","Re","Do"},
        {"Mi","Mi","Fa","Sol","Sol","Fa","Mi","Re","Do","Do","Re","Mi","Mi","Re","Re","Mi","Mi","Fa","Sol","Sol","Fa","Mi","Re","Do","Do","Re","Mi","Re","Do","Do"}
    }

    -- Estado del juego
    ball = {x=cx, y=cy, r=15, color={1,1,1}, vx=0, vy=0}
    notaActual = ""
    notaColor = {1, 1, 1}
    estado = "menu"
    mx = cx
    my = cy

    -- Estado melodía
    nivelActual = 1
    notaEnCurso = 1
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

            -- Si colisiona
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

                -- Modo melodía: verificar si acertó
                if modo == "melodia" then
                    verificarNota(notas[i])
                end
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
            if modo == "libre" then
                estado = "esperando"
            else
                estado = "melodia"
            end
        else
            ball.x = ball.x + (dx / d) * 450 * dt
            ball.y = ball.y + (dy / d) * 450 * dt
        end
    end
end

-- ========================================
-- MODO MELODIA
-- ========================================
function verificarNota(notaTocada)
    local secuencia = secuencias[nivelActual]
    if notaTocada == secuencia[notaEnCurso] then
        notaEnCurso = notaEnCurso + 1
        if notaEnCurso > #secuencia then
            if nivelActual < 3 then
                nivelActual = nivelActual + 1
                notaEnCurso = 1
            else
                estado = "ganaste"
            end
        end
    else
        notaEnCurso = 1
    end
end

function dibujarMelodia()
    local secuencia = secuencias[nivelActual]

    -- Barra de progreso
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Nivel " .. nivelActual, 20, 530)
    love.graphics.print(notaEnCurso - 1 .. "/" .. #secuencia, 700, 530)

    -- Notas de la secuencia
    for i = 1, #secuencia do
        local nx = 20 + (i - 1) * 25
        local ny = 555
        if i < notaEnCurso then
            love.graphics.setColor(0.5, 0.5, 0.5)
        elseif i == notaEnCurso then
            love.graphics.setColor(1, 1, 0)
        else
            love.graphics.setColor(1, 1, 1)
        end
        love.graphics.print(string.sub(secuencia[i], 1, 2), nx, ny)
    end
end

-- ========================================
-- ENTRADA
-- ========================================
function love.mousepressed(x, y, button)
    if button == 1 then
        -- Menú principal
        if estado == "menu" then
            if x < 400 then
                modo = "libre"
                estado = "esperando"
            else
                modo = "melodia"
                nivelActual = 1
                notaEnCurso = 1
                estado = "melodia"
            end
            return
        end

        -- Pantalla ganaste
        if estado == "ganaste" then
            estado = "menu"
            return
        end

        -- Lanzar pelota
        if estado == "esperando" or estado == "melodia" then
            local d = dist(x, y, cx, cy)
            if d > 0 then
                ball.vx = ((x - cx) / d) * 1500
                ball.vy = ((y - cy) / d) * 1500
                estado = "lanzada"
            end
        end
    end
end

-- ========================================
-- RENDERIZADO
-- ========================================
function love.draw()
    -- Menú
    if estado == "menu" then
        love.graphics.setColor(1, 1, 1)
        local w = love.graphics.getWidth()
        local font = love.graphics.getFont()
        love.graphics.print("Peque Symphonie", (w - font:getWidth("Peque Symphonie") * 2) / 2, 200, 0, 2, 2)
        love.graphics.print("Esc para salir | M: menu", (w - font:getWidth("Esc para salir | M: menu") * 1.2) / 2, 250, 0, 1.2, 1.2)

        love.graphics.setColor(0, 1, 0)
        love.graphics.rectangle("fill", 100, 350, 250, 60, 10, 10)
        love.graphics.setColor(0, 0, 0)
        local t1 = "JUGA LIBRE"
        love.graphics.print(t1, 100 + (250 - font:getWidth(t1) * 1.5) / 2, 368, 0, 1.5, 1.5)

        love.graphics.setColor(0, 0, 1)
        love.graphics.rectangle("fill", 450, 350, 250, 60, 10, 10)
        love.graphics.setColor(1, 1, 1)
        local t2 = "TOCA LA MELODIA"
        love.graphics.print(t2, 450 + (250 - font:getWidth(t2) * 1.5) / 2, 368, 0, 1.5, 1.5)
        return
    end

    -- Pantalla ganaste
    if estado == "ganaste" then
        love.graphics.setColor(1, 1, 0)
        local w = love.graphics.getWidth()
        local font = love.graphics.getFont()
        love.graphics.print("GANASTE!", (w - font:getWidth("GANASTE!") * 3) / 2, 250, 0, 3, 3)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Hacé click para volver al menú", (w - font:getWidth("Hacé click para volver al menú")) / 2, 350)
        return
    end

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
    if estado == "esperando" or estado == "melodia" then
        love.graphics.setColor(1, 1, 1, 0.4)
        love.graphics.setLineWidth(1)
        love.graphics.line(cx, cy, mx, my)
    end

    -- Textos superiores
    love.graphics.setColor(1, 1, 1)
    local w = love.graphics.getWidth()
    local font = love.graphics.getFont()
    local t1 = "Peque Symphonie"
    local t2 = "Esc para salir | M: menu"
    love.graphics.print(t1, (w - font:getWidth(t1) * 2) / 2, 30, 0, 2, 2)
    love.graphics.print(t2, (w - font:getWidth(t2) * 1.2) / 2, 70, 0, 1.2, 1.2)

    -- Nota actual con color
    if notaActual ~= "" then
        love.graphics.setColor(notaColor)
        love.graphics.print("Nota: " .. notaActual, 20, 500)
    end

    -- Barra de progreso (modo melodía)
    if modo == "melodia" then
        dibujarMelodia()
    end
end

-- ========================================
-- CONTROLES
-- ========================================
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
    if key == "m" then
        if estado == "esperando" or estado == "melodia" or estado == "lanzada" or estado == "volviendo" then
            ball.x = cx
            ball.y = cy
            ball.color = {1, 1, 1}
            ball.vx = 0
            ball.vy = 0
            notaActual = ""
            estado = "menu"
        end
    end
end