-- ESTADO: ULTRA
-- Maneja la esfera giratoria del modo ultra

local State = require("state")
local UltraState = State:new("ultra")

local H = require("heptagono")
local B = require("pelota")

local machine = nil

-- ESFERA GIRATORIA
local esfera = {
    x = 0,
    y = 0,
    radio = 20,
    angulo = 0,
    velocidadAngular = 3,
    color = {1, 0, 0},
    activa = false,
    timerColor = 0
}

function UltraState:setMachine(sm)
    machine = sm
end

-- ENTRAR AL ESTADO
function UltraState:enter()
    esfera.activa = true
    esfera.angulo = 0
    esfera.timerColor = 0
    esfera.x = cx + 150 * math.cos(esfera.angulo)
    esfera.y = cy + 150 * math.sin(esfera.angulo)
end

-- ACTUALIZAR ESTADO
function UltraState:update(dt)
    if esfera.activa then
        esfera.angulo = esfera.angulo + esfera.velocidadAngular * dt
        esfera.x = cx + 150 * math.cos(esfera.angulo)
        esfera.y = cy + 150 * math.sin(esfera.angulo)
    end

    if B.vx ~= 0 or B.vy ~= 0 then
        if UltraState:colisionar() then
            esfera.activa = false
        end
    end
end

-- SALIR DEL ESTADO
function UltraState:exit()
    esfera.activa = false
end

-- COLISION CON PELOTA
function UltraState:colisionar()
    if not esfera.activa then return false end
    local dx = B.x - esfera.x
    local dy = B.y - esfera.y
    local d = math.sqrt(dx * dx + dy * dy)
    return d < B.r + esfera.radio
end

-- DIBUJAR
function UltraState:draw()
    if esfera.activa then
        love.graphics.setColor(esfera.color)
        love.graphics.circle("fill", esfera.x, esfera.y, esfera.radio)
    end
end

-- VERIFICAR SI LA ESFERA ESTA ACTIVA
function UltraState:estaActiva()
    return esfera.activa
end

return UltraState