-- MODULO: PELOTA
local P = {}

-- CREACION
function P.crear(cx, cy)
    P.x = cx
    P.y = cy
    P.r = 15
    P.color = {1, 1, 1}
    P.vx = 0
    P.vy = 0
end

-- MOVIMIENTO
function P.mover(dt)
    P.x = P.x + P.vx * dt
    P.y = P.y + P.vy * dt
end

-- VERIFICAR LIMITES
function P.verificarLimites(cx, cy, radio)
    local dx = P.x - cx
    local dy = P.y - cy
    local d = math.sqrt(dx * dx + dy * dy)
    if d > radio + 50 then
        P.x = cx
        P.y = cy
        P.color = {1, 1, 1}
        P.vx = 0
        P.vy = 0
        return true
    end
    return false
end

-- LANZAMIENTO
function P.lanzar(x, y, cx, cy, velocidad)
    local dx = x - cx
    local dy = y - cy
    local d = math.sqrt(dx * dx + dy * dy)
    if d > 0 then
        P.vx = (dx / d) * velocidad
        P.vy = (dy / d) * velocidad
    end
end

-- COLISION
function P.colisionar(verts, colores, notas, sonidos)
    for i = 1, 7 do
        local v1 = verts[i]
        local v2 = verts[i % 7 + 1]
        local edx = v2.x - v1.x
        local edy = v2.y - v1.y
        local len = math.sqrt(edx * edx + edy * edy)
        local t = math.max(0, math.min(1, ((P.x - v1.x) * edx + (P.y - v1.y) * edy) / (len * len)))
        local cx2 = v1.x + t * edx
        local cy2 = v1.y + t * edy
        local dx2 = P.x - cx2
        local dy2 = P.y - cy2
        local d = math.sqrt(dx2 * dx2 + dy2 * dy2)

        if d < P.r then
            P.color = colores[i]
            sonidos[i]:stop()
            sonidos[i]:play()
            local nx = dx2 / d
            local ny = dy2 / d
            P.x = cx2 + nx * (P.r + 1)
            P.y = cy2 + ny * (P.r + 1)
            local dot = P.vx * nx + P.vy * ny
            P.vx = P.vx - 2 * dot * nx
            P.vy = P.vy - 2 * dot * ny
            return i
        end
    end
    return nil
end

-- RETORNO AL CENTRO
function P.volverCentro(cx, cy, velocidad, dt)
    local dx = cx - P.x
    local dy = cy - P.y
    local d = math.sqrt(dx * dx + dy * dy)
    if d < 10 then
        P.x = cx
        P.y = cy
        P.color = {1, 1, 1}
        P.vx = 0
        P.vy = 0
        return true
    else
        P.x = P.x + (dx / d) * velocidad * dt
        P.y = P.y + (dy / d) * velocidad * dt
        return false
    end
end

-- RESETEAR
function P.resetear(cx, cy)
    P.x = cx
    P.y = cy
    P.color = {1, 1, 1}
    P.vx = 0
    P.vy = 0
end

-- RENDERIZADO
function P.dibujar()
    love.graphics.setColor(P.color)
    love.graphics.circle("fill", P.x, P.y, P.r)
end

return P