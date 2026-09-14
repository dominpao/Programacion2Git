-- MAQUINA DE ESTADOS: CLASE BASE
-- Clase base para todos los estados del juego
-- Cada estado debe implementar entrar(), actualizar() y salir()

local State = {}
State.__index = State

-- CREAR ESTADO
function State:new(name)
    local self = setmetatable({}, State)
    self.name = name
    return self
    end

function State:enter()

-- ENTRAR AL ESTADO (se ejecuta al cambiar a este esta
end

-- ACTUALIZAR ESTADO (se ejecuta cada frame)
function State:update(dt)
end

-- SALIR DEL ESTADO (se ejecuta al cambiar a otro estado)
function State:exit()
end

return State